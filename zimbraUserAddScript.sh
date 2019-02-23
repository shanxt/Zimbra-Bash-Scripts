#!/bin/bash
#
# -----------------------------------------------------------------------------
#  Script to add users in Zimbra 6,7,8 using a csv file
#   
#  written by Shashank Shekhar Tewari
#
# ------------------------------------------------------------------------------
# This script takes a csv file, called '/tmp/newusers.csv', and converts it as an input
# file (called /tmp/zmprovinput) for 'zmprov' command. The users can then be added
# by simply running 'zmprov < /tmp/zmprovinput'
# 
# So basically, follow these steps:
# 1) Create a csv file in the following format, with the separator being a semi-colon:
# 
# "Email ID";"Name";"Company";"Description";"Mobile Number";"Phone Number";"Address";"State";"Country"
# Example:
# "keyur.shah@example.com";"Keyur Shah";"Acme Inc";"This guy works in engineering";996323418;4216857841;"Valley road, random colony";"New Delhi";"India"
# 
# ENSURE THAT THE SEPARATOR IS A SEMI-COLON, AND NOT A COMMA. This is necessary 
# because addresses usually have a comma, and that screws with the script.
#
# 2) Upload the csv on the server, and save it as '/tmp/newusers.csv'
#
# 3) Run the script. Change the password if you want, which is currently set as 'very_secure_password_1831'. 
#    A file '/tmp/zmprovinput' will be created
#
# 4) Go through the file, and ensure everything is OK. 
#
# 5) Run as the zimbra user, 'zmprov < /tmp/zmprovinput'
####################################################################################

USERLIST='/tmp/newusers.csv'
ZMPROVINPUT='/tmp/zmprovinput'

# Empties the 'zmprov' file
> $ZMPROVINPUT

while read i; do
field1=`echo $i | awk -F\; '{print $1}' | sed 's/"//g'`
field2=`echo $i | awk -F\; '{print $2}' | sed 's/"//g'`
field3=`echo $i | awk -F\; '{print $3}' | sed 's/"//g'`
field4=`echo $i | awk -F\; '{print $4}' | sed 's/"//g'`
field5=`echo $i | awk -F\; '{print $5}' | sed 's/"//g'`
field6=`echo $i | awk -F\; '{print $6}' | sed 's/"//g'`
field7=`echo $i | awk -F\; '{print $7}' | sed 's/"//g'`
field8=`echo $i | awk -F\; '{print $8}' | sed 's/"//g'`
field9=`echo $i | awk -F\; '{print $9}' | sed 's/"//g'`
echo "Added $i"
echo createAccount \"$field1\" 'very_secure_password_1831' displayName \"$field2\" cn \"$field2\" company \"$field3\" description \"$field4\" mobile \"$field5\" telephoneNumber \"$field6\" street \"$field7\" l \"$field8\" co \"$field9\" >> $ZMPROVINPUT

done < $USERLIST

