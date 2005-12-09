#!/bin/sh

case $# in
0) exit 0
esac

CMD=$1
shift

exec 3>&-
exec 4>&-
exec 5>&-
exec 6>&-
exec 7>&-
exec 8>&-
exec 9>&-

exec "$CMD" "$@"
