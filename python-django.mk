smf-check::

sandbox: $(SANDBOX_DIR)

runserver:
	$(PYTHON) manage.py runserver

collectstatic:
	$(SANDBOX) ./manage.py collectstatic --noinput
