.help:
	@echo "Available commands:"
	@grep -h '^# COMMAND: ' Makefile .supermake.mk 2> /dev/null | sed 's|# COMMAND: |  - |'


# COMMAND: targets - list available targets of this supermakefile
targets:
	@echo "Available targets:"
	@make --dry-run  --no-builtin-rules --no-builtin-variables --print-data-base --question __BASH_MAKE_COMPLETION__=1 -C . | grep -v -E '^# |=|^\.|^Makefile|^all'| grep '^[a-zA-Z]' | sed 's/:.*$$//; s/^/  - /' | sort
