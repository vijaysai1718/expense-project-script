#!/bin/bash

user=$( id -u )
scriptName=$( echo $0 | cut -d "." -f1 )
timeStamp=$( date +%F-%H-%M-%S)
fileName=/tmp/$scriptName-$timeStamp.log

echo "please enter the password for the mysql root user"

read -s mysql_root_password

red="\e[31m"
green="\e[32m"
normal="\e[0m"
yellow="\e[33m"
if [ $user -ne 0 ]
then
echo "hey man you are not having access to run this script please get the root access or try with super access"
exit 1
else
echo "User is having super access"
fi

validate()

if [ $1 -ne 0 ]
then
echo -e "$2  got $red failed $normal please check the logs for more details"
exit 1
else
echo -e " $2  $green success $normal"
fi

dnf install mysql-server -y &>>$fileName

validate $? "mysql-server installation is"

systemctl enable mysqld &>>$fileName
validate $? "mysqld server got enabled "

systemctl start mysqld
validate $? "mysqld server started"

# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
# VALIDATE $? "Setting up root password"

#Below code will be useful for idempotent nature
#below command will be checking whether we are able to get the list of db or not 
#If we are getting then already password already been set so no need of setting password again which will cause for an issue
mysql -h 34.226.190.65 -uroot -p${mysql_root_password} -e 'show databases;' &>>$fileName
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$fileName
    validate $? "MySQL Root password Setup"
else
    echo -e "MySQL Root password is already setup...$yellow SKIPPING $normal"
fi



