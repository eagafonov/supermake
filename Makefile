SANDBOX_DIR:=$(shell pwd)/sandbox

SANDBOX ?=. $(SANDBOX_DIR)/bin/activate &&

ROOT:=$(shell pwd)

PYTHON_PATH:=$(shell pwd)/lib

PYLINT:=$(SANDBOX) PYTHONPATH=$(PYTHON_PATH) pylint --max-line-length=140 --indent-string='    '

PYTHON:=$(SANDBOX) PYTHONPATH=$(PYTHON_PATH) python

PIP:=$(SANDBOX) pip

TWISTD:=$(SANDBOX) PYTHONPATH=$(PYTHON_PATH)  twistd

all: pylint

# TODO update to check specific folders
pylint:
	$(PYLINT) $(PACKAGES) *.py

distclean:
	-rm -Rf $(SANDBOX_DIR)

sandbox:
	virtualenv --no-site-packages sandbox

install-requirements: sandbox requirements.txt
	$(PIP) install -r requirements.txt

requirements.txt:
	@echo $@ must present in root folder
	exit 1

$(subst .py,-py-run,$(wildcard *.py)):
	@echo 'Running ' $@
	$(PYTHON) $(subst -py-run,.py,$@)

$(addprefix run-,$(wildcard *.py)):
	@echo 'Running ' $@
	$(PYTHON) $(subst run-,,$@)

run-twisted:
	$(TWISTD) -n iqubot -P test123

shell:
	$(SANDBOX) export debian_chroot='SBOX' && export PYTHONPATH=$(PYTHON_PATH) && /bin/bash -i

check:
	export PYTHONPATH=$(PYTHON_PATH) && ./runtrial.sh

pydoc:
	$(PYTHON) `which pydoc` -p 8081