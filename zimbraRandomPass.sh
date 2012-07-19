#!/bin/bash
# -----------------------------------------------------------------------------
#  Script to randomize passwords in Zimbra 6,7
#   
#  written by Shashank Shekhar Tewari
#
# ------------------------------------------------------------------------------
# This script generates a random password for all users, stores it in a file,
# and forces users to change their passwords once they successfully login.
#
# The initial user list can be generated with a simple 'zmprov -l gaa > /tmp/allaccounts'
#
# To use it, simply run the script. Two files are then generated:
#
# a) /tmp/newpasswords.csv -> this contains the username and passwords, and is csv file
# b) /tmp/zmprovNew -> this needs to be run as zmprov input to actually apply the changes, ie, 
#	'zmprov < /tmp/zmprovPwChange'

# Initial user list with all accounts
USERLIST='/tmp/allaccounts'

# User list with the random passwords
PASSLIST='/tmp/newpasswords.csv'

# zmprov input file
ZMINPUT='/tmp/zmprovPwChange'

# Empties the two files
echo "" > $PASSLIST
echo "" > $ZMINPUT

while read USERNAME; do


MATRIX="23456789ABCDEFGHIJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz"
LENGTH="8"


while [ "${n:=1}" -le "$LENGTH" ]
do
        PASSW="$PASSW${MATRIX:$(($RANDOM%${#MATRIX})):1}"
                let n+=1
done

# Reset 'n'
n=""

echo "$USERNAME , $PASSW" >> $PASSLIST
echo "ma \"$USERNAME\" userPASSWORD \"$PASSW\" zimbraPasswordMustChange TRUE" >> $ZMINPUT

PASSW=""
done < $USERLIST

