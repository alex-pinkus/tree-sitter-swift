import os
import subprocess
from platform import system

from setuptools import setup, Extension, find_packages
from setuptools.command.build_ext import build_ext
from wheel.bdist_wheel import bdist_wheel


class CustomBuildExt(build_ext):
    def run(self):
        # Ensure directories exist before build
        if not os.path.exists("tree_sitter_swift"):
            os.makedirs("tree_sitter_swift")

        check_tree_sitter_cli_installed()
        run_tree_sitter_generate()
        super().run()


def check_tree_sitter_cli_installed():
    try:
        subprocess.check_call(["tree-sitter", "--version"])
    except (subprocess.CalledProcessError, FileNotFoundError):
        raise RuntimeError(
            "Tree-sitter CLI is not installed. Please install it using `npm install -g tree-sitter-cli`."
        )


def run_tree_sitter_generate():
    if not os.path.exists("src/parser.c") and not os.path.exists("src/tree_sitter/"):
        subprocess.check_call(["tree-sitter", "generate"])


class BdistWheel(bdist_wheel):
    def get_tag(self):
        python, abi, platform = super().get_tag()
        if python.startswith("cp"):
            python, abi = "cp38", "abi3"
        return python, abi, platform


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
                "src/scanner.c",
            ],
            extra_compile_args=["-std=c11"] if system() != "Windows" else [],
            define_macros=[
                ("Py_LIMITED_API", "0x03080000"),
                ("PY_SSIZE_T_CLEAN", None),
            ],
            include_dirs=["src"],
            py_limited_api=True,
        )
    ],
    cmdclass={
        "build_ext": CustomBuildExt,
        "bdist_wheel": BdistWheel,
    },
    license="MIT",
    python_requires=">=3.8",
    install_requires=["tree-sitter~=0.21"],
    zip_safe=False,
)
