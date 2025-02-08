#!/bin/bash
#Script to generate a random password. Designed for use on the Jump machine

#Defines the characters that a password can contain
possibleChars="A-Za-z0-9.@#$%&+!?*,:-_<>;=}{^)(/~"

#Function to generate a random password of 32 characters
generatePassword() {
  #Sets the length of the password to 32 characters
  length=32
  #Generates a password using /dev/urandom and restricts the possible characters to those in possibleChars
  password=$(tr -dc "$possibleChars" < /dev/urandom | head -c $length)
  #Echos the password so it can be captured by the calling script
  echo "$password"
}

#Echos the random password back to the user
echo $(generatePassword)