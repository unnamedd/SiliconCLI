#!/bin/bash

MONITORED_FOLDER="$PWD/Sources"
EXCLUDED_FOLDERS_REGEX="(.git|.build|.swiftpm|.zed)"
BUILDING_FILE=$1
EXECUTABLE_FILE=$2

function run_command {
  if [ ! -f "$BUILDING_FILE" ]; then
    swift build > "/tmp/$EXECUTABLE_FILE-building-output.log" 2>&1
  fi

  "./$EXECUTABLE_FILE" 2> /dev/null &
}

function processes_for {
  # shellcheck disable=SC2009
  ps aux | grep -w "$1" | grep -v grep | awk -v file="$1" '$11==file'
}

function count_processes_for {
  processes_for "$1" | wc -l
}

function list_processes_identifiers_for {
  processes_for "$1" | awk '{print $2}'
}

function stop_command {
  # a smarter way of killing all possible processes
  # running that wasn't killed before running new ones
  processes_identifiers=$(list_processes_identifiers_for "$1")
  for identifier in $processes_identifiers; do
    kill -9 "$identifier" > /dev/null 2>&1
  done
}

# shellcheck disable=SC2162
fswatch -0 "$MONITORED_FOLDER" --exclude "$EXCLUDED_FOLDERS_REGEX" --event Renamed --event MovedTo --event Removed --event Updated --event Created | while read -d "" _; do
  if [ -f "$BUILDING_FILE" ]; then
    continue
  fi

  # Count the amount of processes running and
  # kill 'em all before run any other instance
  processes_count=$(count_processes_for "./$EXECUTABLE_FILE")
  if [ "$processes_count" -gt 0 ]; then
    stop_command "./$EXECUTABLE_FILE"
  fi

  run_command
done
