VERSION := 0.1.1

# Repository
SRC_DIR := src

PARSER_REPO_URL   ?= $(shell git -C $(SRC_DIR) remote get-url origin)
$(eval PARSER_NAME=$(shell basename $(PARSER_REPO_URL) | cut -d '-' -f3 | sed 's#.git##' ))
UPPER_PARSER_NAME := $(shell echo $(PARSER_NAME) | tr a-z A-Z)

# install directory layout
PREFIX ?= /usr/local
INCLUDEDIR ?= $(PREFIX)/include
LIBDIR ?= $(PREFIX)/lib
PCLIBDIR ?= $(LIBDIR)/pkgconfig

# collect C++ sources, and link if necessary
CPPSRC := $(wildcard $(SRC_DIR)/*.cc)

ifeq (, $(CPPSRC))
	ADDITIONALLIBS := 
else
	ADDITIONALLIBS := -lc++
endif

# collect sources
SRC := $(wildcard $(SRC_DIR)/*.c)
SRC += $(CPPSRC)
OBJ := $(addsuffix .o,$(basename $(SRC)))

# ABI versioning
SONAME_MAJOR := 0
SONAME_MINOR := 0

CFLAGS ?= -O3 -Wall -Wextra -I$(SRC_DIR)
CXXFLAGS ?= -O3 -Wall -Wextra -I$(SRC_DIR)
override CFLAGS += -std=gnu99 -fPIC
override CXXFLAGS += -fPIC

# OS-specific bits
ifeq ($(shell uname),Darwin)
	SOEXT = dylib
	SOEXTVER_MAJOR = $(SONAME_MAJOR).dylib
	SOEXTVER = $(SONAME_MAJOR).$(SONAME_MINOR).dylib
	LINKSHARED += -dynamiclib -Wl,$(ADDITIONALLIBS),-install_name,$(LIBDIR)/libtree-sitter-$(PARSER_NAME).$(SONAME_MAJOR).dylib,-rpath,@executable_path/../Frameworks
else
	SOEXT = so
	SOEXTVER_MAJOR = so.$(SONAME_MAJOR)
	SOEXTVER = so.$(SONAME_MAJOR).$(SONAME_MINOR)
	LINKSHARED += -shared -Wl,$(ADDITIONALLIBS),-soname,libtree-sitter-$(PARSER_NAME).so.$(SONAME_MAJOR)
endif
ifneq (,$(filter $(shell uname),FreeBSD NetBSD DragonFly))
	PCLIBDIR := $(PREFIX)/libdata/pkgconfig
endif
				
all: libtree-sitter-$(PARSER_NAME).a libtree-sitter-$(PARSER_NAME).$(SOEXTVER) bindings/c/tree-sitter.h

libtree-sitter-$(PARSER_NAME).a: $(OBJ)
	$(AR) rcs $@ $^

libtree-sitter-$(PARSER_NAME).$(SOEXTVER): $(OBJ)
	$(CC) $(LDFLAGS) $(LINKSHARED) $^ $(LDLIBS) -o $@
	ln -sf $@ libtree-sitter-$(PARSER_NAME).$(SOEXT)
	ln -sf $@ libtree-sitter-$(PARSER_NAME).$(SOEXTVER_MAJOR)

 bindings/c/tree-sitter.h:
	sed -e 's|@UPPER_PARSERNAME@|$(UPPER_PARSER_NAME)|' \
		-e 's|@PARSERNAME@|$(PARSER_NAME)|' \
		$@.in > $@

install: all
	install -d '$(DESTDIR)$(LIBDIR)'
	install -m755 libtree-sitter-$(PARSER_NAME).a '$(DESTDIR)$(LIBDIR)'/libtree-sitter-$(PARSER_NAME).a
	install -m755 libtree-sitter-$(PARSER_NAME).$(SOEXTVER) '$(DESTDIR)$(LIBDIR)'/libtree-sitter-$(PARSER_NAME).$(SOEXTVER)
	ln -sf libtree-sitter-$(PARSER_NAME).$(SOEXTVER) '$(DESTDIR)$(LIBDIR)'/libtree-sitter-$(PARSER_NAME).$(SOEXTVER_MAJOR)
	ln -sf libtree-sitter-$(PARSER_NAME).$(SOEXTVER) '$(DESTDIR)$(LIBDIR)'/libtree-sitter-$(PARSER_NAME).$(SOEXT)
	install -d '$(DESTDIR)$(INCLUDEDIR)'/tree_sitter
	install -m644 bindings/c/tree-sitter.h '$(DESTDIR)$(INCLUDEDIR)'/tree_sitter/
	install -d '$(DESTDIR)$(PCLIBDIR)'
	sed -e 's|@LIBDIR@|$(LIBDIR)|;s|@INCLUDEDIR@|$(INCLUDEDIR)|;s|@VERSION@|$(VERSION)|' \
	    -e 's|=$(PREFIX)|=$${prefix}|' \
	    -e 's|@PREFIX@|$(PREFIX)|' \
	    -e 's|@ADDITIONALLIBS@|$(ADDITIONALLIBS)|' \
		-e 's|@PARSERNAME@|$(PARSER_NAME)|' \
		-e 's|@PARSERREPOURL@|$(PARSER_REPO_URL)|' \
	    bindings/c/tree-sitter.pc.in > '$(DESTDIR)$(PCLIBDIR)'/tree-sitter-$(PARSER_NAME).pc

clean:
	rm -f $(OBJ) libtree-sitter-$(PARSER_NAME).a libtree-sitter-$(PARSER_NAME).$(SOEXT) libtree-sitter-$(PARSER_NAME).$(SOEXTVER_MAJOR) libtree-sitter-$(PARSER_NAME).$(SOEXTVER) bindings/c/tree-sitter.h

.PHONY: all install clean