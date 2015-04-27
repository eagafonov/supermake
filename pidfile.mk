ifndef V
	V2:=@
endif

pidfile_status:
	$(V2)(test -f $(PIDFILE) && kill -0 `cat $(PIDFILE)` && echo "Running (PID=`cat $(PIDFILE)`)") || (echo "Stopped"; exit 0)

pidfile_stop:
	$(V2)(test -f $(PIDFILE) && kill `cat $(PIDFILE)`) || (echo "Failed to stop"; exit 0)
