smf-check::

RUNSERVER_HTTP_BIND?='127.0.0.1:8000'

runserver:
	$(SANDBOX) $(PYTHON) manage.py runserver $(RUNSERVER_HTTP_BIND)

collectstatic:
	$(SANDBOX) ./manage.py collectstatic --noinput --clear
