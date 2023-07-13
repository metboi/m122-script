#!/bin/bash

# ------------------------------------------------
# Contributors: Muhamet Krasniqi, Luka Joksimovic
# ------------------------------------------------

# Name of necessary files
CONFIGFILE="config.cfg"
LOGFILE="logfile.log"

# This function will read the configuration file, containing the information about the source server and destination server
read_config() {
	if [[ -f "$CONFIGFILE" ]]; then
		. $PWD/config.cfg
	else
		log "Configuration file not found."
	fi
}

# This function will check if a logfile exists
check_if_logfile_exists() {
	if [[ ! -f "$LOGFILE" ]]; then
 		touch "$LOGFILE"
    		log "Logfile has been created."
	fi
}

# Log messages to the log file
log() {
	local message="$1"
	echo "$(date '+%Y-%m-%d +%H:%M:%S') - Message: $message" >> "$LOGFILE"
}

# This function will check a folder for the source server has been created or not
check_dest() {

log "Checking if a folder of the source server on the destination server exists ..."

# Connect to FTP server and check if the folder already exists
folder_exists=$(ftp -n $destination_server <<EOF
user $destination_user $destination_password
cd $destination_directory
cd $source_server
quit
EOF
2>&1)

# If the message contains "Can't", then that means, that there is no such directory and one should be created
if [[ $folder_exists == *"Can't"* ]]; then
  # If the folder doesn't exist create it
  ftp -n $destination_server <<EOF
  user $destination_user $destination_password
  cd $destination_directory
  mkdir $source_server
  quit
EOF
  log "Folder has been created on destination server for source server."
else
  log "Folder on destination server already exists for source server."
fi

}

# This function will do the backup of the files on the source server to the destination server
do_backup() {

# Destination zip file name
zip_file_name="Backup_$(date '+%Y%m%d_%H:%M%S').zip"

# Local temporary folder
temp_folder="./temp"


# Download the files from the FTP server
mkdir -p "$temp_folder"
cd "$temp_folder"

# Do a listing of the files on the source server and save it into the file "file_list.txt"
curl -u "$source_user:$source_password" -R "ftp://$source_server/$source_directory" | while IFS= read -r string; do echo "$string" | awk -F':[0-9]* ' '/:/{print $2}'; done > file_list.txt

# Download each file and folder locallyy, so afterward it can be zipped and uploaded to the destination server
while IFS= read -r line
do
    # Checks if the line entry in the file "file_list.txt" is a folder
    if [[ "$line" != *.* ]]; then
        dirname="${line%/}"
	mkdir -p "$dirname"
        curl -u "$source_user:$source_password" -o "$dirname" "ftp://$source_server/$source_directory/$dirname"
    fi

    # Checks if the line entry in the file "file_list.txt" is a file
    if [[ "$line" == *.* ]]; then
        #File - download
        filename="${line##*/}"
        curl -u "$source_user:$source_password" -o "$filename" "ftp://$source_server/$source_directory/$filename"
    fi
done < file_list.txt

# Compress the downloaded files into a zip archive
zip -r "$zip_file_name" .

# Upload the zip file back to the FTP server
ftp -n $destination_server <<EOF
user $destination_user $destination_password
cd $destination_directory/$source_server
put "$zip_file_name"
quit
EOF

# Remove/Delete temporary files
rm "file_list.txt"
cd "../"
rm -rf "temp"

}

# Check if logfile exists
check_if_logfile_exists

# Read config file
read_config

# Check if folder on destination server exists
check_dest

# do the backup of files
do_backup

exit 1

# This will copy one file from the source to destination

FILE_NAME="index.html"

curl -sS --disable-epsv --ftp-skip-pasv-ip "ftp://$source_user:$source_password@$source_server/$source_directory/$FILE_NAME" -o "$FILE_NAME"

curl -sS --disable-epsv --ftp-skip-pasv-ip -T "$FILE_NAME" "ftp://$destination_user:$destination_password@$destination_server/$destination_directory/$FILE_NAME"
