# Miscellaneous Configuration Script
# Swap memory: 16 GB

#!/bin/bash

set -e

###################################################################################################################################

# Create Swap file (disk partitioning alternative)
# Fedora uses /dev/zram0 by default for swap, which uses compressed RAM, but if you want a disk swap file instead, uncomment below:
# Fedora uses btrfs by default, so we create a swap file accordingly.
mkdir -p /swap
sudo btrfs filesystem mkswapfile --size 16G /swap/swapfile
sudo chmod 600 /swap/swapfile
sudo swapon --priority -2 /swap/swapfile
echo '/swap/swapfile none swap sw,pri=-2 0 0' | sudo tee -a /etc/fstab
# Swap mount needs to have this configuration: subvol=swap,nodatacow,noatime 0 0
sudo systemctl daemon-reload

###################################################################################################################################

echo "🚀 Done!"