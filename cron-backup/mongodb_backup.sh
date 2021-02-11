#!/bin/bash
#The Shell script will be used for taking backup and send it to Amazon s3 bucket.

# TO list all Databases in mongodb databases
DATE1=$(date +%Y%m%d%H%M)
DATE=`date +%d-%m-%y_%H-%M`
showdb(){
mongo --quiet --host mongodb:27017 --eval  "printjson(db.adminCommand('listDatabases'))" -u $MONGO_INITDB_ROOT_USERNAME -p $MONGO_INITDB_ROOT_PASSWORD | grep -i name | awk -F'"' '{print $4}'
}


showdb > /mongo_dbs.txt

#Backing up the databases listed.
while read db
do
  echo "Creating backup for $db"
  mongodump --host mongodb:27017 --db $db --authenticationDatabase admin -u $MONGO_INITDB_ROOT_USERNAME -p $MONGO_INITDB_ROOT_PASSWORD -o /var/lib/mongodb-backup/$db
done < "/mongo_dbs.txt"

# Moving the backup to Amazon Cloud
if [ $? -eq 0 ]; then

        tar czf /var/lib/mongodb-S3-bucket/${SOURCE_NAME}_db_backup_${DATE1}.tgz /var/lib/mongodb-backup/.
        rsync -avr /var/lib/mongodb/ /root/mongodb_data/ && tar czf /var/lib/mongodb-S3-bucket/${SOURCE_NAME}_data_directory_backup_${DATE1}.tgz /root/mongodb_data/.
        aws s3  sync /var/lib/mongodb-S3-bucket/ s3://${S3_BUCKET_MONGODB}/
	echo "DATE:" $DATE > /mongodbbackup.txt
	echo " " >> /mongodbbackup.txt
	echo "DESCRIPTION: ${SOURCE_NAME}_Mongodb backup" >> /mongodbbackup.txt
	echo " " >> /mongodbbackup.txt
	echo "STATUS: mongodb backup is Successful." >> /mongodbbackup.txt
	echo " " >> /mongodbbackup.txt
	echo "******* Mongodb Database Backup ****************" >> /mongodbbackup.txt
	echo " " >> /mongodbbackup.txt
	aws s3 ls s3://${S3_BUCKET_MONGODB}/  --human-readable | grep -i ${SOURCE_NAME}_db | cut -d' ' -f3- | tac | head -10 &>> /mongodbbackup.txt
	echo " " >> /mongodbbackup.txt
	echo "************** Mongodb data Backup *************" >> /mongodbbackup.txt
	echo " " >> /mongodbbackup.txt
	aws s3 ls s3://${S3_BUCKET_MONGODB}/  --human-readable | grep -i ${SOURCE_NAME}_data | cut -d' ' -f3- | tac | head -10 &>> /mongodbbackup.txt
	echo " " >> /mongodbbackup.txt
	echo "********************** END *********************" >> /mongodbbackup.txt

else
	echo "DATE:" $DATE > /mongodbbackup.txt
	echo " " >> /mongodbbackup.txt
	echo "DESCRIPTION: ${SOURCE_NAME}_Mongodb backup" >> /mongodbbackup.txt
	echo " " >> /mongodbbackup.txt
	echo "STATUS: mongodb backup is Failed." >> /mongodbbackup.txt
	echo " " >> /mongodbbackup.txt
	echo "Something went wrong, Please check it"  >> /mongodbbackup.txt
        cat /mongodbbackup.txt | mail -s "${SOURCE_NAME}: mongodb backup" ${CRON_BACKUP_MAIL} 
fi

# Remove the old backup data in local directory to avoid excessive storage use
find /var/lib/mongodb-S3-bucket/ -type f -exec rm {} \;
find /root/mongodb_data/ -type f -exec rm {} \;
find /var/lib/mongodb-backup/ -type f -exec rm {} \;

cat /mongodbbackup.txt | mail -s "${SOURCE_NAME}: mongodb backup" ${CRON_BACKUP_MAIL} 
