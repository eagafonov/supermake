SANDBOX_DIR:=$(shell pwd)/sandbox

SANDBOX ?=. $(SANDBOX_DIR)/bin/activate &&

ROOT:=$(shell pwd)

PYTHON_PATH:=$(shell pwd)/lib:$(shell pwd)

PYLINT:=$(SANDBOX) PYTHONPATH=$(PYTHON_PATH) pylint --max-line-length=140 --indent-string='    ' --disable W0232,W0212

PYTHON:=$(SANDBOX) PYTHONPATH=$(PYTHON_PATH) python2

COVERAGE:=$(SANDBOX) PYTHONPATH=$(PYTHON_PATH) coverage

PIP:=$(SANDBOX) pip

TWISTD:=$(SANDBOX) PYTHONPATH=$(PYTHON_PATH)  twistd

all: pylint check

# TODO update to check specific folders
pylint:
	cd iqube && $(PYLINT) $(PACKAGES) *.py

distclean:
	-rm -Rf $(SANDBOX_DIR)

sandbox:
	python2 -m virtualenv --no-site-packages sandbox

install-requirements: sandbox requirements.txt
	$(PIP) install -r requirements.txt

freeze: sandbox
	$(PIP) freeze | tee requirements-freezed.txt

install-requirements-freezed: sandbox requirements-freezed.txt
	$(PIP) install -r requirements-freezed.txt


requirements.txt:
	@echo $@ must present in root folder
	exit 1

$(subst .py,-py-run,$(wildcard *.py)):
	@echo 'Running ' $@
	$(PYTHON) $(subst -py-run,.py,$@)

$(addprefix run-,$(wildcard *.py)):
	@echo 'Running ' $@
	$(PYTHON) $(subst run-,,$@)

shell:
	$(SANDBOX) export debian_chroot='SBOX' && export PYTHONPATH=$(PYTHON_PATH) && /bin/bash -i

check:
	for f in $(shell find tests -name '*.py'); do \
		$(PYTHON) $$f; \
	done

pydoc:
	$(PYTHON) `which pydoc` -p 8081

run-server:
	$(PYTHON) iqube/manage.py runserver

test: test_api test_node
	$(COVERAGE) html
	$(COVERAGE) report

test_node:
	$(COVERAGE) run --source='iqube' iqube/manage.py test node

test_api:
	$(COVERAGE) run --source='iqube' iqube/manage.py test api
