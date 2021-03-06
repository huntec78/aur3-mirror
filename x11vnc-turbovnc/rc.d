#!/bin/bash

. /etc/rc.conf
. /etc/rc.d/functions
. /etc/conf.d/x11vnc

PID=$(pidof -o %PPID /usr/bin/x11vnc)
case "$1" in
  start)
    stat_busy "Starting x11vnc"
    [[ -z "$PID" ]] && /usr/bin/x11vnc $X11VNC_ARGS &> /dev/null &
    if [[ $? -gt 0 ]]; then
      stat_fail
    else
      add_daemon x11vnc
      stat_done
    fi
    ;;
  stop)
    stat_busy "Stopping x11vnc"
    [[ ! -z "$PID" ]]  && kill $PID &> /dev/null
    if [[ $? -gt 0 ]]; then
      stat_fail
    else
      rm_daemon x11vnc
      stat_done
    fi
    ;;
  restart)
    $0 stop
    sleep 1
    $0 start
    ;;
  *)
    echo "usage: $0 {start|stop|restart}"
esac
exit 0
