define SMF_CHECK_VAR
    @if [ -z "$($1)" ]; then \
        echo "Variable '$1' must be defined"; \
        exit 1; \
    fi
    @echo "$1=$($1)"
endef

smf-check::
	@echo "Check supermakefile"
