#!/bin/sh

set -e

PIDFILE=/home/jobberuser/snapdump.pid

function clearPid() {
  # Kill snapdump process if there is one
  kill ${PID} || true
  rm -rf "${PIDFILE}"
}

if [ ! -f "${PIDFILE}" ] || [ -z "$(cat ${PIDFILE})" -o ! -e /proc/$(cat ${PIDFILE}) ]; then

  /home/jobberuser/.local/bin/snapdump -c /home/jobberuser/snapdump.yml backup &
  PID=${!}

  trap clearPid EXIT SIGHUP SIGINT SIGQUIT SIGTERM

  echo ${PID} > "${PIDFILE}"

  echo "Snapdump started."

  wait

else

  PID=$(cat "${PIDFILE}")

  echo "Skipping snapdump start due to existing snapdump process in progress with PID=${PID}"

fi
