#!/bin/sh

#----------------------------------------------------------
# a simple mysql database backup script.
# version 2, updated March 26, 2011.
# copyright 2011 alvin alexander, http://alvinalexander.com
#----------------------------------------------------------
# This work is licensed under a Creative Commons 
# Attribution-ShareAlike 3.0 Unported License;
# see http://creativecommons.org/licenses/by-sa/3.0/ 
# for more information.
#----------------------------------------------------------

if [ -f .env ]
then
  export $(cat .env | xargs)
fi


# (1) set up all the mysqldump variables

DATE=`date +"%m-%d-%y-%H%M"`
FILE=dump.sql
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT_FOLDER="${DIR}/"
DUMP_FOLDER="${DIR}/mysql-dump/"

# (2) in case you run this more than once a day, remove the previous version of the file
unalias rm     2> /dev/null
rm ${FILE}     2> /dev/null
rm ${FILE}.gz  2> /dev/null

# (3) do the mysql database backup (dump)

# use this command for a database server on a separate host:
mysqldump --opt --port=3306 --protocol=TCP --user=${DB_USER} --password=${DB_PASSWORD} --host=${DB_SERVER_URL} ${DB_NAME} > ${DUMP_FOLDER}/${FILE}

# use this command for a database server on localhost. add other options if need be.
#mysqldump --opt --user=${USER} --password=${PASS} ${DATABASE} > ${FILE}

# (4) gzip the mysql database dump file
gzip ${DUMP_FOLDER}/${FILE}
rm ${DUMP_FOLDER}/${FILE}

# (5) show the user the result
git add --all
git commit -m "save ${DATE}"
git pull --ff
git tag ${DATE}
git push
git push --tags
