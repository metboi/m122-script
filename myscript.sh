#!/bin/bash

# ------------------------------------------------
# Contributors: Muhamet Krasniqi, Luka Joksimovic
# ------------------------------------------------

CONFIGFILE="config.cfg" 
LOGFILE="logfile.log"

# Read the configuration file
read_config() {
	if [[ -f "$CONFIGFILE" ]]; then
		. $PWD/config.cfg
	else
		log "Configuration file not found."
	}
	fi
}

check_if_logfile_exists() {
	if [[ ! -f "$LOGFILE" ]]; then
 		touch "$LOGFILE"
    		log "Logfile created."
	fi
}

#Log messages to the log file
log() {
	local message="$1"
	echo "$(date + '%Y-%m-%d %H:%M:%S') - Error: $message" >> "$LOGFILE"
}

check_if_logfile_exists

# Main execution
read_config

# -----------------------------------
# FROM HERE FTP WORK STARTS !!!
# -----------------------------------

# Connect to the source server and list all files
ftp -inv "$source_server" <<EOF
user "$source_user" "$source_password"
cd "$source_directory"
ls -1
quit
EOF

# Save the listing of files to a temporary file
FILE_LIST=$(mktemp)
ftp -inv "$source_server" <<EOF | tee "$FILE_LIST"
user "$source_user" "$source_password"
cd "$source_directory"
ls -1
quit
EOF

# Check if the file listing was successful
if [[ $? -eq 0 ]]; then
    echo "File listing retrieved successfully."

    # Read the file listing and transfer each file
    while IFS= read -r file; do
        # Skip directories and parent directory entries
        if [[ "$file" != "." && "$file" != ".." && ! -d "$file" ]]; then
            # Connect to the destination server and upload the file
            ftp -inv "$destination_server" <<EOFF
            user "$destination_user" "$destination_password"
            cd "$destination_directory"
            put "$file"
            quit
EOFF

            # Check if the file transfer was successful
            if [[ $? -eq 0 ]]; then
                echo "File '$file' transferred successfully."
            else
                echo "File '$file' transfer failed."
            fi
        fi
    done < "$FILE_LIST"

    # Clean up the temporary file
    rm "$FILE_LIST"
else
    echo "File listing retrieval failed."
fi

