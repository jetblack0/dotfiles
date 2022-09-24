#! /bin/sh

# check if there already an instance of program
run() {
  if ! pgrep -f "$1" ;
  then
    "$@"&
  fi
}

# run some nice programs when start awesomewm (use .xinitrc instead)
