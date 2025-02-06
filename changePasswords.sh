#!/bin/bash
#Script to take a list of users defined in the script and change the password
#Deletes the old password list and creates a new file
rm newpasswords.csv
touch newpasswords.csv

#List of the users on the system
users=("jeremy.rover" "maxwell.starling" "jack.harris" "emily.chen" "william.wilson" "melissa.chen" "john.taylor" "laura.harris" "alan.chen" "anna.wilson" "matthew.taylor" "emily.lee" "chris.harris" "danielle.wilson" "heather.chen" "james.taylor" "ashley.lee" "mark.wilson" "rachel.harris" "alan.taylor" "amy.wilson" "kathleen.chen" "dave.harris" "jeff.taylor" "julie.wilson" "tom.harris" "sarah.taylor" "michael.chen" "christine.wilson" "alan.harris" "emily.lee" "tony.taylor" "tiffany.wilson" "sharon.harris" "amy.wilson" "terry.chen" "rachel.wilson" "tiffany.harris" "amy.taylor" "terry.wilson")

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

#Loops through the list of users and changse their password
for user in ${users[@]}; do
  # Skip users with the prefix "seccdc"
  if [ $user == seccdc* ]; then
    echo "Skipping seccdc user"
    continue
  fi

  #Skips blackteam user
  if [ $user == blackteam_adm* ]; then
    echo "Skipping blackteam_adm user"
    continue
  fi

  #Generates a random password for the user
  newPassword=$(generatePassword)
  #Changes the user's password
  echo "$user:$newPassword" | sudo chpasswd
  #Echos the password and the username to a .csv file
  echo "\"$user\",\"$newPassword\"" >> newpasswords.csv

done