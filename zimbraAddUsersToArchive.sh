#!/bin/bash
# ENSURE ALL THE SERVERS HAVE PASSWORDLESS SSH AUTHENTICATON (Login using keys), 
# OR THE SCRIPT WILL FAIL
# -----------------------------------------------------------------------------
#  Zimbra Archiving
#   
#  written by Shashank Shekhar Tewari
# 
#
#  Feb 22, 2012
#
#  This script will add users that are present on the main Zimbra server, but not
#  on the archival server. It will also make the appropriate changes in postfix.
# ------------------------------------------------------------------------------
#	
#
#
# IP of the archive server (arhchive.example.com)
ARCHIP=192.168.1.18

# File names of example.com and archive.example.com users
# MAINLST is the userlist from the main server (example.com)
# ARLST is the userlist from the archive server (archive.example.com)
MAINLST=mainserverlist
ARLST=archiveuserlist

# Emptying out the input file for zmprov
echo "" > /tmp/zmprovarchiv

# Getting userlist from the archive server
ssh $ARCHIP 'su -c "zmprov -l gaa | cut -d\@ -f1 > /tmp/archiveuserlist" -l zimbra'
rsync -Pa $ARCHIP:/tmp/archiveuserlist /tmp/$ARLIST

# Getting userlist from local (main) server
su -c "zmprov -l gaa | cut -d\@ -f1 > /tmp/$MAINLST" -l zimbra

# Sorting the files for comparison
sort /tmp/$MAINLST > /tmp/sorted$MAINLST
sort /tmp/$ARLST > /tmp/sorted$ARLST  

# Comparing the files, and getting the unique users of the example.com domain
# This will get the new users created on example.com, but not present on the archive server
comm -23 /tmp/sorted$MAINLST /tmp/sorted$ARLST > /tmp/newusers


# Checking if there are new users
if [ -s /tmp/newusers ]; then
   # Loop to read users one by one
   for newuser in `cat /tmp/newusers`; do
	# Creating a file that will be the input for zmprov.
	# This will create the new user accounts on the archive server.
	# The user's passwords have been set to 'very_secure_PW_31812'
	echo "ca $newuser@archive.example.com very_secure_PW_31812" >> /tmp/zmprovarchiv
    done	
    # Creates the file for postfix mapping. This file contains users in the form of 'from' and 'to' 
    awk '{print $1"@example.com","\t",$1"@archive.example.com"}' /tmp/newusers  >> /opt/zimbra/postfix/conf/archivelist
    
    # rsync the zmprov file to the archive server
    rsync -Pa /tmp/zmprovarchiv $ARCHIP:/tmp

    # Runs the zmprov command to add users on the archive server
    ssh $ARCHIP 'su -l zimbra -c zmprov < /tmp/zmprovarchiv'

    # Postmapping on  the servers
    su -c "postmap /opt/zimbra/postfix/conf/archivelist" -l zimbra
    su -c "postfix reload" -l zimbra
    
else
   exit 
fi
