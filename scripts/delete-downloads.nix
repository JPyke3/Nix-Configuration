{pkgs, ...}:
pkgs.writeShellScriptBin "clean-downloads-folder" ''
   #!/usr/bin/env bash

   # This script will clean the downloads folder by removing all files that are older than 30 days.
   # Set the downloads folder path
   DOWNLOADS_FOLDER="''${HOME}/Downloads"

   # Check if the downloads folder exists
   if [ ! -d "''${DOWNLOADS_FOLDER}" ]; then
  echo "The downloads folder does not exist."
  exit 1
   fi

   # Change to the downloads folder
   cd "''${DOWNLOADS_FOLDER}" || exit 1

   # Remove all files that are older than 30 days
   find . -type f -mtime +30 -exec rm -f {} \;

   # Remove all empty directories
   find . -type d -empty -delete

   echo "The downloads folder has been cleaned."
   exit 0
''
