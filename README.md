# MockbaMod
### Akai Force Modded Firmware
This repository contains information about MockbaMod and the basic contents of a SD card.<br>
With the information contained here people should be able to install/uninstall MockbaMod and create their own customized SD card.<br>
<hr>

### Folders
* Documentation - All the document files go here
* SD - This is a SD card skeleton template
* AddOns - All the MockbaMod add-ons
* Apps - Apps which can be called from the load menu
<hr>

### Latest Version
MockbaMod: 3.2.5.1 - https://mega.nz/file/cfAnUIjK#NaJBnRQxlm4sS3Io5_A2atHvrP_Abir19mLXoInpSo0 <br>
SD Card: 4.06 - https://mega.nz/file/RKhmRLJa#LoMyEHZBr4ivJf5y0HJHfZoMz_isHXQbN8ZGAA7eS2g <br>

Discord: https://discord.gg/HvNBpArSSa
<hr>

### Installation / Utilization

To install the modded firmware, follow the same procedure as the regular firmware. Write the .img file to the root of an SD card, USB key, or SSD, and execute the USB firmware update from the Settings menu. If prompted during installation, accept the reinstallation.

To create the required SD card, download the SD card image and extract it to the root of an ExFat-formatted SD card named 662522. Renaming the card after formatting may not work (needs confirmation). The SD card must have the MockbaMod folders and the boot.sh file in its root folder.

When booting the Force with the SD card inserted, MockbaMod will load the modifications. Without the SD card, the Force will execute the original Akai firmware without changes.

When installing this latest v4 over previous versions of MockbaMod, it will remove the previous version to avoid conflicts. This is normal and should occur only the first time an SD card is created/used.

IMPORTANT: MockbaMod consists of two parts: the modded firmware and the SD card contents. There may be updated SD card contents without a new Akai firmware release, and vice versa. It is not mandatory to reinstall the firmware image when a new SD card image is available, nor the SD image when a new firmware is released.
