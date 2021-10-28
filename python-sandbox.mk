
SANDBOX_DIR?=$(shell pwd)/sandbox

SANDBOX ?=. $(SANDBOX_DIR)/bin/activate &&
PYTHON ?= python3

PIP:=$(SANDBOX) pip

PROMPT?=SBOX

VIRTUALENV?= $(PYTHON) -m virtualenv --prompt="(${PROMPT})" --python=$(PYTHON)


PYLINT:=$(SANDBOX) PYTHONPATH=$(PYTHON_PATH) pylint --output-format=msvs --max-line-length=140 --indent-string='    '  $(PYLINT_ARGS)


SORT_CMD:=python -c "import sys; print('\n'.join(sorted(sys.stdin.read().split('\n'))))"

smf-check::
	$(call SMF_CHECK_VAR,SANDBOX_DIR)

sandbox: $(SANDBOX_DIR)/bin/activate


$(SANDBOX_DIR)/bin/activate:
	$(VIRTUALENV) $(SANDBOX_DIR)
	
upgrade-pip:
	$(SANDBOX) pip install -U pip

distclean::
	-rm -Rf $(SANDBOX_DIR)


shell: sandbox $(SANDBOX_DIR)/.requirements-dev-installed.stamp
	$(SANDBOX) export debian_chroot="${PROMPT}" && export PYTHONPATH=$(PYTHON_PATH) && /bin/bash -i

install-requirements: requirements-dev.txt sandbox
	$(PIP) install --requirement=requirements-dev.txt  $(PIP_EXTRA)

$(SANDBOX_DIR)/.requirements-dev-installed.stamp:
	@test -f requirements-dev.txt && ( $(PIP) install --requirement=requirements-dev.txt $(PIP_EXTRA) && touch $@) \
		|| (echo W: requirements-dev.txt is not found. Nothing is installed)

.force-install-dev:
	-rm $(SANDBOX_DIR)/.requirements-dev-installed.stamp

# shortcut for install-requirements
install-dev: .force-install-dev $(SANDBOX_DIR)/.requirements-dev-installed.stamp


upgrade-requirements: requirements-dev.txt sandbox
	$(PIP) install --upgrade --requirement=requirements-dev.txt  $(PIP_EXTRA)

# shortcut for install-requirements
upgrade-dev: upgrade-requirements

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
	(echo "#    !!!! DO NOT EDIT - DO NOT EDIT - DO NOT EDIT \n#    Generated with  'pip freeze'\n#    Updated requirements-dev.txt and launch 'make freeze'\n" ; $(PIP) freeze | $(SORT_CMD)) | tee requirements.txt

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
#	echo $(shell dirname "$(shell which $(PYTHON))")
#	echo $(SANDBOX_DIR)/bin
ifneq ($(shell dirname $(shell which $(PYTHON))), $(SANDBOX_DIR)/bin)
	@echo "Not a sandbox. Aborting"
	@exit 1
endif

pip-install-%:
	$(PIP) install $(subst pip-install-,,$@)
