
SANDBOX_DIR?=$(shell pwd)/sandbox

SANDBOX ?=. $(SANDBOX_DIR)/bin/activate &&
PYTHON?=python

PIP:=$(SANDBOX) pip

VIRTUALENV?= $(PYTHON) -m virtualenv --no-site-packages

PYLINT:=$(SANDBOX) PYTHONPATH=$(PYTHON_PATH) pylint --max-line-length=140 --indent-string='    '  $(PYLINT_ARGS)

smf-check::
	$(call SMF_CHECK_VAR,SANDBOX_DIR)

sandbox: $(SANDBOX_DIR)


$(SANDBOX_DIR):
	$(VIRTUALENV) $(SANDBOX_DIR)

distclean::
	-rm -Rf $(SANDBOX_DIR)


shell: sandbox
	$(SANDBOX) export debian_chroot='SBOX' && export PYTHONPATH=$(PYTHON_PATH) && /bin/bash -i

install-requirements: requirements.txt sandbox
	$(PIP) install -r requirements.txt

requirements.txt:
	@echo $@ must present in root folder
	exit 1

freeze: sandbox
	$(PIP) freeze | tee requirements-freezed.txt

install-requirements-freezed: sandbox requirements-freezed.txt
	$(PIP) install -r requirements-freezed.txt

requirements-freezed.txt:
	@echo $@ must present in root folder. Run \'make freeze\' to update it.
	exit 1


pylint::
	$(PYLINT) $(PYLINT_PACKAGES)

check-sandbox:
#	echo $(shell dirname "$(shell which python)")
#	echo $(SANDBOX_DIR)/bin
ifneq ($(shell dirname $(shell which python)), $(SANDBOX_DIR)/bin)
	@echo "Not a sandbox. Aborting"
	@exit 1
endif
