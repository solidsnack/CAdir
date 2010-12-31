#!/bin/bash

function msg {
  echo "e: $1" 1>&2
  echo "o: $1"
}

exec 3>&1
( for x in a b c
  do
    msg "$x"
  done | sed -r 's|^|o/|' ) 2>&1 1>&3 | sed -r 's|^|e/|' 3>&1 1>&2

( while read x
  do
    msg "$x"
  done | sed -r 's|^|o/|' ) 2>&1 1>&3 | sed -r 's|^|e/|' 3>&1 1>&2
exec 3>&-

