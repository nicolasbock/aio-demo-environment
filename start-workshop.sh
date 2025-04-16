#!/bin/bash

set -u -e

set -x

sshopts="-o StrictHostKeyChecking=no"

short_name() {
  local container=$1
  echo ${container} | sed -e 's/^[^_]*_\(.*\)_container.*$/\1/'
}

containers=(
  $(sudo lxc-ls --fancy-format NAME --running --line)
)

show_containers=(
  "utility"
  "rsyslog"
  "galera"
  "neutron"
  "cinder"
  "repo"
)

create_window() {
  local window_index=$(( $1 ))
  local window_name=$2

  shift; shift

  local cmd="$@"

  if ! (tmux select-window -t ${window_index} 2> /dev/null); then
    tmux new-window -t ${window_index} -n "${window_name}"
    tmux send-keys -t ${window_index} "${cmd}" Enter
    echo created
  else
    tmux rename-window -t ${window_index} "${window_name}"
  fi
}

initialize_workshop() {
  # . clean-logs.sh
  for c in ${show_containers[@]}; do
    if [[ ${c} =~ designate ]]; then
      sudo ssh ${sshopts} ${designate} "systemctl restart named"
    fi
  done
}

while true; do
  if [[ $(sudo lxc-ls --stopped | wc -l) == 0 ]]; then
    break
  fi
  echo "Containers are still booting..."
  sleep 2
done

if ! tmux list-sessions -F '#{session_name}' 2>&1 | grep --quiet workshop; then
  initialize_workshop
  tmux start-server
  tmux new-session -d -s workshop -n host
  tmux set-option -t workshop -g -w allow-rename off
  tmux set-option -t workshop -g history-limit 100000
fi

create_window 0 host

for window_index in ${!show_containers[@]}; do
  window_name=${show_containers[${window_index}]}
  for container_name in ${containers[@]}; do
    if [[ ${container_name} =~ ${window_name} ]]; then
      create_window $(( ${window_index} + 1 )) ${window_name} "sudo -i lxc-attach --name ${container_name}"
    fi
  done
done

tmux select-window -t utility
tmux attach-session -t workshop
