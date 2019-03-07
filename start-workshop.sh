#!/bin/bash

set -x

sshopts="-o StrictHostKeyChecking=no"

short_name() {
  local container=$1
  echo ${container} | sed -e 's/^[^_]*_\(.*\)_container.*$/\1/'
}

containers=(
  $(sudo lxc-ls -f | tail -n +2 | cut -d ' ' -f 1)
)

show_containers=(
  "galera"
  "neutron"
  "repo"
  "rsyslog"
  "utility"
)

if ! tmux list-sessions -F '#{session_name}' 2>&1 | grep --quiet workshop; then
  tmux start-server
  tmux new-session -d -s workshop -n host sudo su -
  tmux set-option -t workshop -g -w allow-rename off
  tmux set-option -t workshop -g history-limit 100000
  for c in ${containers[@]}; do
    for s in ${show_containers[@]}; do
      if [[ ${c} =~ ${s} ]]; then
        tmux new-window -n $(short_name ${c}) "sudo lxc-attach --name ${c}"
      fi
    done
  done
  tmux select-window -t utility
fi
tmux attach-session -t workshop
