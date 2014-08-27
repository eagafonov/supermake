
SANDBOX_DIR?=$(shell pwd)/sandbox

SANDBOX ?=. $(SANDBOX_DIR)/bin/activate &&

PIP:=$(SANDBOX) pip

VIRTUALENV?=virtualenv

PYLINT:=$(SANDBOX) PYTHONPATH=$(PYTHON_PATH) pylint --max-line-length=140 --indent-string='    '  $(PYLINT_ARGS)

smf-check::
	$(call SMF_CHECK_VAR,SANDBOX_DIR)

sandbox: $(SANDBOX_DIR)


$(SANDBOX_DIR):
	$(VIRTUALENV) --no-site-packages $(SANDBOX_DIR)

distclean::
	-rm -Rf $(SANDBOX_DIR)


shell: sandbox
	$(SANDBOX) export debian_chroot='SBOX' && export PYTHONPATH=$(PYTHON_PATH) && /bin/bash -i

install-requirements: sandbox requirements.txt
	$(PIP) install -r requirements.txt

requirements.txt:
	@echo $@ must present in root folder
	exit 1

pylint::
	$(PYLINT) $(PYLINT_PACKAGES)
