
SANDBOX_DIR?=$(shell pwd)/sandbox

SANDBOX ?=. $(SANDBOX_DIR)/bin/activate &&
PYTHON?=python

PIP:=$(SANDBOX) pip

VIRTUALENV?= $(PYTHON) -m virtualenv --no-site-packages

PYLINT:=$(SANDBOX) PYTHONPATH=$(PYTHON_PATH) pylint --output-format=msvs --max-line-length=140 --indent-string='    '  $(PYLINT_ARGS)

smf-check::
	$(call SMF_CHECK_VAR,SANDBOX_DIR)

sandbox: $(SANDBOX_DIR)


$(SANDBOX_DIR):
	$(VIRTUALENV) $(SANDBOX_DIR)

distclean::
	-rm -Rf $(SANDBOX_DIR)


shell: sandbox
	$(SANDBOX) export debian_chroot='SBOX' && export PYTHONPATH=$(PYTHON_PATH) && /bin/bash -i

install-requirements: requirements-dev.txt sandbox
	$(PIP) install --requirement=requirements-dev.txt  $(PIP_EXTRA)

upgrade-requirements: requirements-dev.txt sandbox
	$(PIP) install --upgrade --requirement=requirements-dev.txt  $(PIP_EXTRA)

requirements-dev.txt:
	@echo $@ must present in root folder
	exit 1

install-requirements-test: requirements-test.txt requirements-dev.txt sandbox
	$(PIP) install --requirement=requirements-dev.txt  \
		--requirement=requirements-test.txt \
		$(PIP_EXTRA)

requirements-test.txt:
	@echo $@ must present in root folder
	exit 1



freeze: sandbox
	(echo "#    !!!! DO NOT EDIT - DO NOT EDIT - DO NOT EDIT \n#    Generated with  'pip freeze'\n#    Updated requirements-dev.txt and launch 'make freeze'\n" ; $(PIP) freeze | sort) | tee requirements.txt

install-requirements-freezed: sandbox requirements.txt
	$(PIP) install -r requirements.txt

requirements.txt:
	@echo $@ must present in root folder. Run \'make freeze\' to update it.
	exit 1


pylint:: pip-check-install-pylint
	$(PYLINT) $(PYLINT_PACKAGES)

pip-check-install-pylint:
	test -f $(SANDBOX_DIR)/bin/pylint || make pip-install-pylint

check-sandbox:
#	echo $(shell dirname "$(shell which python)")
#	echo $(SANDBOX_DIR)/bin
ifneq ($(shell dirname $(shell which python)), $(SANDBOX_DIR)/bin)
	@echo "Not a sandbox. Aborting"
	@exit 1
endif

pip-install-%:
	$(PIP) install $(subst pip-install-,,$@)
