# Main makefile for the project
# will call the makefile in the subdirectories
# with the same target

MAKEFILES = $(wildcard */Makefile)

main: build

build:
	@for makefile in $(MAKEFILES); do \
		$(MAKE) -C $$(dirname $$makefile) $@; \
	done

clean:
	@for makefile in $(MAKEFILES); do \
		$(MAKE) -C $$(dirname $$makefile) $@; \
	done

run:
	@for makefile in $(MAKEFILES); do \
		$(MAKE) -C $$(dirname $$makefile) $@; \
	done

.PHONY: main build clean run
