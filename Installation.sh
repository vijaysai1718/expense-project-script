#!/bin/bash

user=$( id -u )
scriptName=$( echo $0 | cut -d "." -f1 )
timeStamp=$( date +%F-%H-%M-%S)

echo "user is --> $user  scriptname is $scriptName time is $timeStamp"