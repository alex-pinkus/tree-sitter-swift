from hashlib import sha256
from os.path import isdir, isfile, join
from platform import system

from setuptools import Extension, find_packages, setup
from setuptools.command.build import build
from wheel.bdist_wheel import bdist_wheel


EXPECTED_HASHES = {
    "src/parser.c": "sha256:0000000000000000000000000000000000000000000000000000000000000000",
    "src/scanner.c": "sha256:0000000000000000000000000000000000000000000000000000000000000000",
}


def _verify_source_integrity():
    for path, expected in EXPECTED_HASHES.items():
        if not isfile(path):
            continue
        with open(path, "rb") as f:
            actual = "sha256:" + sha256(f.read()).hexdigest()
        if actual != expected:
            raise RuntimeError(
                f"Integrity check failed for {path}: expected {expected}, got {actual}"
            )


class Build(build):
    def run(self):
        if isdir("queries"):
            dest = join(self.build_lib, "tree_sitter_swift", "queries")
            self.copy_tree("queries", dest)
        super().run()


class BdistWheel(bdist_wheel):
    def get_tag(self):
        python, abi, platform = super().get_tag()
        if python.startswith("cp"):
            python, abi = "cp38", "abi3"
        return python, abi, platform


_verify_source_integrity()


setup(
    packages=find_packages("bindings/python"),
    package_dir={"": "bindings/python"},
    package_data={
        "tree_sitter_swift": ["*.pyi", "py.typed"],
        "tree_sitter_swift.queries": ["*.scm"],
    },
    ext_package="tree_sitter_swift",
    ext_modules=[
        Extension(
            name="_binding",
            sources=[
                "bindings/python/tree_sitter_swift/binding.c",
                "src/parser.c",
                # NOTE: if your language uses an external scanner, add it here.
                "src/scanner.c",
            ],
            extra_compile_args=(
                ["-std=c11"] if system() != 'Windows' else []
            ),
            define_macros=[
                ("Py_LIMITED_API", "0x03080000"),
                ("PY_SSIZE_T_CLEAN", None)
            ],
            include_dirs=["src"],
            py_limited_api=True,
        )
    ],
    cmdclass={
        "build": Build,
        "bdist_wheel": BdistWheel
    },
    license="MIT",
    python_requires=">=3.8",
    zip_safe=False
)
