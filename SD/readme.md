This folder contains the skeleton of the latest SD card image.

boot.sh contain a copy of remove.sh, which will clear the previous version upon first boot.
bool_old.sh is the regular boot.sh, which upon first boot will install tehe latest version.

This is the default behavior for now.

To create a card which just install upon first boot, remove boot.sh and rename boot_old.sh to boot.sh.

