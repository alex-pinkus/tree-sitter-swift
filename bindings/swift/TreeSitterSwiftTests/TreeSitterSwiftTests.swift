import XCTest
import SwiftTreeSitter
import TreeSitterSwift

final class TreeSitterSwiftTests: XCTestCase {
    func testCanLoadGrammar() throws {
        let parser = Parser()
        let language = Language(language: tree_sitter_swift())
        XCTAssertNoThrow(try parser.setLanguage(language),
                         "Error loading Swift grammar")
    }
}
