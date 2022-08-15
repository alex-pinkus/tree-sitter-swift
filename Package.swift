// swift-tools-version: 5.6
import PackageDescription

let package = Package(
  name: "TreeSitterSwift",
  platforms: [.macOS(.v10_13), .iOS(.v11)],
  products: [.library(name: "TreeSitterSwift", targets: ["TreeSitterSwift"])],
  targets: [
    .target(
      name: "TreeSitterSwift",
      path: ".",
      exclude: [
        "bindings",
        "corpus",
        "LICENSE",
        "package.json",
        "README.md",
      ],
      sources: [
        "src/parser.c",
        "src/scanner.c",
      ],
      resources: [
        .copy("queries")
      ],
      publicHeadersPath: "bindings/swift",
      cSettings: [.headerSearchPath("src")]
    ),
  ]
)
