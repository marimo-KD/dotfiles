#!/bin/bash

ponymix --sink is-muted #check sources muted

if [ $? = 0 ]; then
  ponymix --sink unmute > /dev/null #If sources are muted,unmute them
else
  ponymix --sink mute > /dev/null #If sources are not muted,mute them
fi
