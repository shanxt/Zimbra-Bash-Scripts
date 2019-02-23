# Zimbra bash scripts

Bash scripts written to do specific tasks in Zimbra

## Getting Started

Download these on the Zimbra Collaboration Suite (ZCS) server that you're running.
Example:
```
wget https://raw.githubusercontent.com/shanxt/Zimbra-Scripts/master/zimbraAddUsersToArchive.sh
```


## Descriptions of each script

### zimbraAddUsersToArchive.sh
This script will add users that are present on the main Zimbra server, but not
on the archival server. It will also make the appropriate changes in postfix.

The only pre-requisite is to ensure all the servers have passwordless ssh authenticaton 
(login using keys), or the script will fail.
This should be the default on all ZCS servers.
#
### zimbraRandomPass.sh
This generates a random password for all users, stores it in a file,
and forces users to change their passwords once they successfully login.

The initial user list can be generated with a simple 'zmprov -l gaa > /tmp/allaccounts'

To use it, simply run the script. Two files are then generated:
1. /tmp/newpasswords.csv -> this contains the username and passwords, and is csv file
2. /tmp/zmprovNew -> this needs to be run as zmprov input to actually apply the changes, ie, 
```
zmprov < /tmp/zmprovPwChange
```
#
### zimbraUserAddScript.sh
This script takes a csv file, called '/tmp/newusers.csv', and converts it as an input
file (called /tmp/zmprovinput) for 'zmprov' command. The users can then be added
by simply running 'zmprov < /tmp/zmprovinput'
 
Follow these steps:
1. Create a csv file in the following format, with the separator being a semi-colon:
``` 
"Email ID";"Name";"Company";"Description";"Mobile Number";"Phone Number";"Address";"State";"Country"
```

Example:
```
"keyur.shah@example.com";"Keyur Shah";"Acme Inc";"This guy works in engineering";996323418;4216857841;"Valley road, random colony";"New Delhi";"India"
```
 
ENSURE THAT THE SEPARATOR IS A SEMI-COLON, AND NOT A COMMA. This is necessary 
because addresses usually have a comma, and that screws with the script.

2. Upload the csv on the server, and save it as '/tmp/newusers.csv'

3. Run the script. Change the password if you want, which is currently set as 'very_secure_password_1831'. 
    A file '/tmp/zmprovinput' will be created

4. Go through the file, and ensure everything is OK. 

5. Run as the zimbra user
```
zmprov < /tmp/zmprovinput
```
