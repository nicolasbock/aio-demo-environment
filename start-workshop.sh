#!/bin/bash

set -x

sshopts="-o StrictHostKeyChecking=no"

designate=$(grep designate /etc/hosts | awk '{print $3}')
galera=$(grep galera /etc/hosts | awk '{print $3}')
neutron_server=$(grep neutron-server /etc/hosts | awk '{print $3}')
nova_api=$(grep nova-api /etc/hosts | awk '{print $3}')
octavia=$(grep octavia /etc/hosts | awk '{print $3}')
rsyslog=$(grep rsyslog /etc/hosts | awk '{print $3}')
utility=$(grep utility /etc/hosts | awk '{print $3}')

if ! tmux list-sessions -F '#{session_name}' 2>&1 | grep --quiet workshop; then
  tmux start-server
  tmux new-session -d -s workshop -n host
  tmux set-option -t workshop -g -w allow-rename off
  tmux set-option -t workshop -g history-limit 100000
  [[ -n ${designate} ]] && tmux new-window -n designate "sudo ssh ${sshopts} ${designate}"
  [[ -n ${galera} ]] && tmux new-window -n galera "sudo ssh ${sshopts} ${galera}"
  [[ -n ${neutron_server} ]] && tmux new-window -n neutron-server "sudo ssh ${sshopts} ${neutron_server}"
  [[ -n ${nova_api} ]] && tmux new-window -n nova-api "sudo ssh ${sshopts} ${nova_api}"
  [[ -n ${octavia} ]] && tmux new-window -n octavia "sudo ssh ${sshopts} ${octavia}"
  [[ -n ${rsyslog} ]] && tmux new-window -n rsyslog "sudo ssh ${sshopts} -t ${rsyslog} '/root/clean-logs.sh ; lnav /var/log/log-storage/*/'"
  [[ -n ${utility} ]] && tmux new-window -n utility "sudo ssh ${sshopts} ${utility}"
  tmux select-window -t utility
fi
tmux attach-session -t workshop
