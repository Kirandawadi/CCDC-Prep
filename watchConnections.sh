#!/bin/bash
#This script is designed for incident response in cyber competitions to watch for users connecting or interacting with the system.
#This script uses the 'who -u' command to output 7 fields:
#1) The username of the logged-in user.
#2) Terminal: The terminal the user is logged into (e.g., tty1, pts/0).
#3) Login Time: The date and time the user logged in (e.g., 2025-02-02 08:15).
#4) Idle Time: The idle time/duration since the user last interacted with the system.
#5) PID (Process ID): The process ID of the user's login shell or session.
#6) From (IP or Host): The source of the user’s session—this can be an IP address or hostname. For local console logins (e.g., tty1), this field is usually blank or (:0).

#The script also writes each set of text  to an output file as the output changes.


#Function to fetch and print current users information
getUsersInfo()
{
    #Gets the current users connected
    currentOutputWho=$(who -u)
    currentOutputss=$(ss -punt | awk '{print $1, $2, $5, $6, $7}')

    #Compares the current output with the previous output
    if [ "$currentOutputWho" != "$previousOutputWho" ] || [ "$currentOutputss" != "$previousOutputss" ]; then
        #Only prints if the output has changed
        clear
        echo "New users or sessions detected:"
        echo "$currentOutputWho"
        echo ""
        echo ""
        echo "$currentOutputss"
        echo ""

        #Writes the new output from both commands to the end of the log file
        echo "$currentOutputWho" >> usertimes.txt
        echo "" >> usertimes.txt
        echo "$currentOutputss" >> usertimes.txt
        echo "" >> usertimes.txt
        echo "" >> usertimes.txt

        #Update the previous output with the current output
        previousOutputWho="$currentOutputWho"
        previousOutputss="$currentOutputss"
    fi
}

#Initialize previous_output variable as empty
previousOutputWho=""
previousOutputss=""


#Infinite loop to continuously print users connected
while true; do
    getUsersInfo
    #Refreshes every 0.001 seconds
    sleep 0.001
done