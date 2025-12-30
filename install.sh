#!/bin/bash

###################################################################################################################################

# Ensure the script is run without sudo privileges
if [ "$EUID" -eq 0 ]; then
  echo "❌ You cannot run this script with sudo privileges."
  exit 1
fi

###################################################################################################################################

# Create TEMP directory for intermediate files
TEMP_DIR="$HOME/Downloads/temp"
mkdir -p "$TEMP_DIR"
export TEMP_DIR

###################################################################################################################################

# Define the order of scripts to execute
SCRIPTS=(
  "src/terminal-config.sh"
  "src/gnome-config.sh"
  "src/install-package-manager-apps.sh"
  "src/install-flatpack-apps.sh"
)

###################################################################################################################################

# Execute each script in the defined order
for SCRIPT in "${SCRIPTS[@]}"; do
  if [ -f "$SCRIPT" ]; then
    echo "🚀 Executing $SCRIPT..."
    bash "$SCRIPT" || {
      echo "❌ Error occurred while executing $SCRIPT. Exiting.";
      exit 1;
    }
  else
    echo "⚠️  Script $SCRIPT not found. Skipping."
  fi

done

###################################################################################################################################

# Delete TEMP directory
rm -rf "$TEMP_DIR"

###################################################################################################################################

echo "✅ All scripts executed successfully!"