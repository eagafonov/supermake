smf-check::

runserver:
	$(SANDBOX) $(PYTHON) manage.py runserver

collectstatic:
	$(SANDBOX) ./manage.py collectstatic --noinput --clear
