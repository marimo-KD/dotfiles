#!/bin/bash

declare -A list=(
  ['Suspend']='systemctl suspend'
  ['Poweroff']='systemctl poweroff'
  ['Reboot']='systemctl reboot'
#  ['Hibernate']='systemctl hibernate'
  ['Logout']='i3-msg exit'
)

if [[ ${1##* } == 'yes' ]]; then
  eval ${list[${1%% *}]}
elif [[ ${1##* } == 'no' ]]; then
  echo ${!list[@]} | sed 's/ /\n/g'
elif [[ -n $1 ]]; then
  echo "$1 / no"
  echo "$1 / yes"
else
  echo ${!list[@]} | sed 's/ /\n/g'
fi
