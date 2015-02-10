daemon-status:
	@if ! test -f $(DAEMON_PID_FILE); then echo "Servis not started (no pid file)"; exit 1; fi
	@if ! kill -0 `cat $(DAEMON_PID_FILE)`; then echo "Servis not started (stailed pid file)"; exit 1; fi
	@echo "Started (PID=`cat $(DAEMON_PID_FILE)`)"

daemon-stop:
	test -f $(DAEMON_PID_FILE)
	kill `cat $(DAEMON_PID_FILE)`
