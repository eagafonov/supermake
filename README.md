Supermake
=========

A set of makefiles to create supermakefile.

Install
-------

Simplest way is to use `git submodule` to checkout `supermake` in subfolder folder.

    #> git submodule add https://github.com/eagafonov/supermake
    #> git commit -m "Add supermake submodule"

Minimal supermake file
----------------------

Here is an example of minimal supermakefile to use sandbox

    all:

    include supermake/python-sandbox.mk
    
Note that default target `all` is placed before any include

Modules
=======

python-sandbox
--------------

This module contains variouse stuff con setup local sandobox evironment

### How to enable

	include supermake/python-sandbox.py

### targets

#### sandbox

Setup fresh sandbox in `$(SANDBOX_DIR)` if not exists. It need not to be invoked directly but must be mentioned here

#### shell

Run interactive shell in sandbox

#### install-requirements

Install dependencies from `requirements.txt` with `pip install -r requirements.txt`. 
requirements.txt must exists otherwize the tartget fails.

#### freeze

Save currently installed packages into `requirements-freezed.txt` with `pip freeze` (https://pip.pypa.io/en/latest/reference/pip_freeze.html)

#### install-requirements-freezed

Install freezed requirements from `requirements-freezed.txt`

#### check-sandbox

Helper target to make sure sandbox is active.
Fails if invoked not in sandbox

Usage example:

	must_run_in_sandbox: check-sandbox
		echo "Sandbox is OK"

#### pip-install-%

template target to install package

For example, we need to install pytest to run tests but need not to install it in production environement so 
lets install it before tests is invoked 

	check: pip-install-pytest
		$(SANDBOX) pytest --ignore=sandbox

### Configuration variables

* PYTHON - python binary to use. Defaul is `python`. Set to `python3` to enforce fresh  Python3 or `python2.6` to stick on old crap.
* SANDBOX_DIR - Path where sandbox will be installed. Default is `$(shell pwd)/sandbox`

### Other useful variable s
* SANDBOX - command prefix to run it the command on sandbox. Default is `source $(SANDBOX_DIR)/bin/activate &&`. 
            I.e. `$(SANDBOX) python runme.py` is expanded into `source $(SANDBOX_DIR)/bin/activate && python runme.py`
* VIRTUALENV - command to setup sandbox. Default is `$(PYTHON) -m virtualenv --no-site-packages`



