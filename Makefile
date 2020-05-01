
PROJECT_NAME = restic-tools
PROJECT_VERSION = 1
FULLNAME = $(PROJECT_NAME)-$(PROJECT_VERSION)

MKDIR = mkdir -p
RSYNC = rsync --exclude CVS --exclude '*~'
RM = rm -f

BREW_HOME=$(shell brew --repository)
BREW=$(BREW_HOME)/bin/brew
BREW_CELLAR=$(BREW_HOME)/Cellar
BREW_PROJECT_DIR="$(BREW_CELLAR)/$(PROJECT_NAME)/$(PROJECT_VERSION)"

.PHONY: build dist install install-encap install-brew clean

# Default
all: help

build: FORCE
	$(MKDIR) build/$(FULLNAME)/bin
	$(MKDIR) build/$(FULLNAME)/share
	$(RSYNC) -a --delete bin/ build/$(FULLNAME)/bin

install: build
	@if [ -e "$(BREW_PROJECT_DIR)" ]; then \
		$(BREW) unlink $(PROJECT_NAME); \
	fi
	$(MKDIR) "$(BREW_PROJECT_DIR)"
	$(RSYNC) -rl --delete "build/$(FULLNAME)/" "$(BREW_PROJECT_DIR)"
	$(BREW) link $(PROJECT_NAME)

dist: build FORCE
	$(MKDIR) dist
	tar -zc -C build -f dist/$(FULLNAME).tar.gz $(FULLNAME)

clean:
	$(RM) -r build dist

help:
	@echo "Run 'make install' to install into brew"
	@echo "Run 'make dist' to build a tar archive"
	@echo "Run 'make build' to create the staging directory for build and dist"
	@echo "Run 'make clean' to cleanup generated files"

FORCE: