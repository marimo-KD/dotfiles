#!/bin/bash

ponymix --source is-muted #check sources muted

if [ $? = 0 ]; then
  ponymix --source unmute > /dev/null #If sources are muted,unmute them
else
  ponymix --source mute > /dev/null #If sources are not muted,mute them
fi
