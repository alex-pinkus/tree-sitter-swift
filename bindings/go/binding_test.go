package tree_sitter_swift_test

import (
	"testing"

	tree_sitter "github.com/tree-sitter/go-tree-sitter"
	tree_sitter_swift "github.com/alex-pinkus/tree-sitter-swift/bindings/go"
)

func TestCanLoadGrammar(t *testing.T) {
	language := tree_sitter.NewLanguage(tree_sitter_swift.Language())
	if language == nil {
		t.Errorf("Error loading Swift grammar")
	}
}
