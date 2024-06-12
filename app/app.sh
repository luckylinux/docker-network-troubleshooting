#!/bin/bash

# Change to app folder
cd "/opt/app" || exit

# Infinite loop to Troubleshoot
# Also needed if the Main Script/App doesn't have a looping itself, preventing the Container from Stopping
#if [[ -v ENABLE_INFINITE_LOOP ]]
#then
   if [[ "${ENABLE_INFINITE_LOOP}" == "true" ]]
   then
       echo "Starting Infinite Loop"
       while true
       do
          sleep 5
       done
   fi
#fi
