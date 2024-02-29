# MockbaMod

### Modded Firmware for the Akai Force
(Note: MockbaMod is **NOT a Custom Firmware**. It still runs the Factory Firmware)<br>
This repository contains information about MockbaMod and the basic contents of the SD card.<br>
With the information contained here people should be able to install/uninstall MockbaMod and create their own customized SD card.<br>
<br>
It is **VERY IMPORTANT** that you read this entire readme file before attempting to install MockbaMod.
<hr>

### Repository Folders
* **Documentation** - All the document files go here.
* **SD** - This is the SD card skeleton template for those willing to build a custom one.
* **AddOns** - All the MockbaMod add-ons available are listed in the .psv file stored here.
* **Apps** - Apps which can be called from the load menu.
<hr>

### Latest Version
The MockbaMod is composed of two parts, which we call "images". There's the firmware part, which replaces Akai's firmware on your Force, and the SD Card part, which is read by the firmware to enable the additional functionality of MockbaMod.<br>

This is the firmware image, which is applied to your Force via USB upgrade:<br>
* **MockbaMod**: 3.2.5.1 - https://mega.nz/file/cfAnUIjK#NaJBnRQxlm4sS3Io5_A2atHvrP_Abir19mLXoInpSo0 <br>
* **MockbaMod**: 3.2.6.14 - https://mega.nz/file/UPBhCZRD#SoMPNZsnpJ8z25BnTTpCqBeKtd3BlwsJCAV1fU6ao4g <br>
* **MockbaMod**: 3.3.0.0 - https://mega.nz/file/oTBkhYSR#MbPTaJyNVqHnqsYH9PsMpUww1vfJUYS7qR3AfPwzJ9s <br>
(The Difference Between the Above MockbaMod and the Factory Firmware is very minute. The Above Modded Firmware Just checks for Presence For an Inserted MockbaMod SD Card (Below)
and loads extra scripts from there... It still Runs the **Stock Factory** Firmware Either Way, But with some extra "Bells and Whistles" From the SD card..

This is the card contents zip archive, which is extracted to the root folder of your SD card:<br>
* **SD Card**: 4.08 - https://mega.nz/file/FexABKgI#dOyL4QwdUje8JhBXk0Tezx7BJAr_QFjv1ETrB6D91aA <br>
### Emmc Repair Only
This is the card contents zip archive for Emmc Repair Tool Only, which is extracted to the root folder of your SD card (This does not install any mods to your Force):<br>
Instructions are included in the SD Card Zip File.. <br>
* **Emmc Repair SD Card**: https://mega.nz/file/s5YhmKiB#WXYkVaiHW2b4UFHFqThiTskd1sJLj3_NXuaArE6f1TQ

For additinal information join our Discord at: <br>
* https://discord.gg/HvNBpArSSa
<hr>

### Installation / Utilization

To install the modded firmware, follow the same procedure as the regular firmware. Copy the .img file to the root of an SD card, USB key, or SSD, and execute the USB firmware update from the Settings menu. If prompted during installation, accept the reinstallation.
The install procedure is EXACTLY the same as Akai's for USB upgrade. Just use the modded image instead of Akai's.

To create the required SD card, download the SD card zip archive and extract it to the root of an ExFat-formatted SD card named 662522. Renaming the card after formatting may not work (needs confirmation). The SD card must have the MockbaMod folders and the boot.sh file in its root folder.

When booting the Force with the SD card inserted, MockbaMod will load the modifications. Without the SD card, the Force will execute the original Akai firmware without changes.

When installing this latest v4 over previous versions of MockbaMod, it will remove the previous version to avoid conflicts. This is normal and should occur only the first time an SD card is created/used.

NOTE: Prior to installation, your internal emmc (/media/az01-internal) will be checked for corruption and will be repaired using standard linux tools that come pre-installed on Force (fsck.ext4)<br>We have decided to add this step as we have found that some uses were experiencing strange behaviors, like crashes and loss of wifi configuration due to a corrupt filesystem.<br>This is true for both modded and unmodded firmwares, the only difference with modded is that we can repair it during our boot process.

IMPORTANT: MockbaMod consists of two parts: the modded firmware and the SD card contents. There may be updated SD card contents without a new Akai firmware release, and vice versa. It is not mandatory to reinstall the firmware image when a new SD card image is available, nor the SD image when a new firmware is released.
<hr>

### Features

MockbaMod implements the following (always evolving) list of features:

* **Scene automation (follow actions)** - Allows the implementation of an automation track which launches scenes automatically, so the Force can be used as a hands-off accompaniment device.
* **Foot controller support** - The Automation feature also allows external midi controllers to automatically trigger buttons in the padboard. Perfect for guitarists.
* **Hidden screen access** - Allows access to some screens of the MPC KEY 61 which are hidden in the Force firmeware. Added functionality.
* **Multi boot** - Allows the selection of older (to some extent) firmware upon starting a project. This helps test things in older versions of the firmware without reflashing the unit.
* **SSH/SFTP Access** - This adds remote filesystem access to the Force, which is great for copying files to and from the unit without having to move USB devices or SD cards back and forth.
* **Custom Arpeggios** - Filesystem access allows modification/addition of arpeggio files.
* **Tempo Automation** - Both Absolute and Relative Tempo Automation Support (Beta).
* **AddOn manager** - Allows managing addons installed on the device. Run the command **addon-manager** in Mac/Linux Terminal or [Putty (windows)](https://www.putty.org/)
* **Multiple AddOns** - MockbaMod supports multiple addons, listed below:

  - **PushLua** - Implements native support to the Push 1 as an additional padboard for the Force for playing notes, drums, etc. with no computer needed.
  - **DropSeq** - Implements a Special Drop Weight-based 4 Track Midi Sequencer.
  - **Euclidier** - Implements a headless 8 Track Euclidean sequencer for Akai Force.
  - **RiffMaker4T** - 4 Track Monophonic Midi Generator/Sequencer with Realtime Transpose,Accents/Slides (303). Great for Basslines/Arps/Acid and Melodic Percussion.  
  - **SoX** - SoX (Sound eXchange) is the Swiss Army knife of sound processing tools.
  - **dxSEX** - CC to Sysex Converter for DX7, VolcaFM, Dexed for Akai Force.
  - **NodeServer** - Implements a Web Application Server for Akai Force Hosting many Apps.
  - **CustomBufferSize** - ALSA Api Middleware To Allow Custom Period/Buffer Sizes.
  - **CustomArpPatterns** - This AddOn allows you to easily add your own midi files as arp patterns.
  - **emmcRepair** - A Tool to Repair corruption of internal emmc that does happen from time to time.
  - **VNCServer** - Stream Force Screen to your Desktop/Phone Vnc Client (touch/mouse supported).
  - **SoundBrowserUI** - Custom UI Skin For Sound Browser (Dark / Better Contrast).
  - **MidiLoop** - Implements the automation functionality plus command macros, key combos, screenshots, video capture, midi interface blocklist. (MidiLoop is always installed by default)
  - **MPC FX Racks** - MPC Fx Rack Presets For Akai Force (Not Supplied with Force) 
