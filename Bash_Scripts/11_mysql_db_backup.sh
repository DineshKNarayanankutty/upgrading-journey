#!/bin/bash
# Tells the system to run this script using the Bash shell.


DATE=$(date +%F)
# Gets today's date in YYYY-MM-DD format.
# Example: 2026-09-10
# $(...) runs the command inside it and stores its output in DATE.


DUMP_FILE="db_${DATE}.sql"
# Creates the backup filename using today's date.
# Example: db_2026-09-10.sql


ssh <app-user>@stapp01 \
  "mysqldump -u kodekloud_roy -pasdfgdsd kodekloud_db01" \
  > "/tmp/${DUMP_FILE}"
# SSH connects to the application server "stapp01"
# using the user "<app-user>".
#
# The "\" means the command continues onto the next line.
#
# Once connected, it runs:
# mysqldump -u kodekloud_roy -pasdfgdsd kodekloud_db01
#
# mysqldump       -> Creates a backup of the MySQL database.
# -u              -> Specifies the MySQL username.
# kodekloud_roy   -> MySQL username.
# -p              -> Specifies the MySQL password.
# asdfgdsd        -> MySQL password.
# kodekloud_db01  -> Name of the database to back up.
#
# The ">" redirects the mysqldump output into a file.
#
# The backup is temporarily saved as:
# /tmp/db_2026-09-10.sql


scp "/tmp/${DUMP_FILE}" \
  natasha@ststor01:/home/natasha/db_backups/
# scp means Secure Copy.
#
# Copies the temporary backup file:
# /tmp/db_2026-09-10.sql
#
# To the storage server:
# ststor01
#
# Using the user:
# natasha
#
# And saves it in:
# /home/natasha/db_backups/
#
# The "\" means the command continues onto the next line.


rm -f "/tmp/${DUMP_FILE}"
# Removes the temporary backup file from /tmp.
#
# -f means "force" removal and prevents an error
# if the file does not exist.
#
# The backup on ststor01 is NOT deleted.
# Only the temporary local copy is removed.
