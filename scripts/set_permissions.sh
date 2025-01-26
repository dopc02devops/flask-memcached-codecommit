#!/bin/bash

# Directory where the .sh files are located
SCRIPT_DIR="/home/kube_user/scripts"

# Check if the directory exists
if [ -d "$SCRIPT_DIR" ]; then
  echo "Directory $SCRIPT_DIR exists. Checking for .sh files..."

  # Check if any .sh files exist in the directory, excluding the current script
  for script_file in $SCRIPT_DIR/*.sh; do
    # Skip the current script (set_permissions.sh)
    if [ "$(basename "$script_file")" != "set_permissions.sh" ]; then
      # Check if the file exists (important for glob patterns)
      if [ -e "$script_file" ]; then
        echo "Found $script_file, setting execute permissions..."
        chmod +x "$script_file"
      fi
    fi
  done
  
  echo "Permissions successfully applied to .sh files (excluding set_permissions.sh)."
else
  echo "Directory $SCRIPT_DIR does not exist."
fi
