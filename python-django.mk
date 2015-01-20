smf-check::

runserver:
	$(PYTHON) manage.py runserver

collectstatic:
	$(SANDBOX) ./manage.py collectstatic --noinput --clear
