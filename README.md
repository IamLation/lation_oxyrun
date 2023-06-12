# Lation's Oxy Run

A unique take on oxy runs for FiveM. Start simply by visiting a sketchy blank prescription dealer (configurable to require an item, etc) and pay for a blank prescription you can fill in yourself. Take this script, fill it in with the proper information (yes, the information input matters), find a local pharmacy that is open (there is a list of pharmacy locations that come by default, the script selects one of those locations upon each restart, so that pharmacy locations are not the same everytime) and hand in your prescription paperwork for your prescribed bottle of oxy you totally need. Be careful though, on every restart the doctor name that will by accepted by the pharmacy is different each time (randomly selected from what you have in the DoctorNames list in the config). 

The pharmacy checks over your illegally written script when handing it in to make sure the patients name matches the one handing it in, that acute pain exception is checked & that the doctor's signature on the script matches the doctor "on duty" for that day. If just one of those are wrong, the pharmacy will accuse you of fraud and shred your prescription and you'll need a new one to try again. 

There is a list of available doctor names you can configure in the config, as well as where it can be found for players to discover and play with available names until they get it right. Next time the server restarts, the pharmacy location moves and the doctor "on duty" changes. 

You can open the bottle of oxy and in turn receive individual pills. With those you can configure them to apply specific amounts of health, armor or do nothing at all. The idea behind this is as an additional drug process to then integrate into your drug selling system, and/or offer a new way for players to get useful health or armor (or both in one) items.

## Features
- Set as many (or as little) Pharmacy locations you want
- Create a list of as many (or as little) Doctor names 
- Enable/disable Discord webhook logs
- Enable/disable health or armor effects upon use
- Set random pricing when purchasing a blank script, or a fixed price
- Optimized 0.00 on use & idle
- Only supports ESX / easy to convert
- Highly detailed config file

## Dependencies
- [ox_inventory](https://github.com/overextended/ox_inventory/releases)
- [ox_lib](https://github.com/overextended/ox_lib/releases)
- [ox_target](https://github.com/overextended/ox_target/releases)

## Installation
- Ensure you have all dependencies installed
- Open "install" folder, add the items.lua to ox_inventory/data/items.lua
- Drag and drop images from "images" folder into ox_inventory/web/images folder
- Add lation_oxyrun to your 'resources' directory
- Add 'ensure lation_oxyrun' in your 'server.cgf'

## Preview
[Streamable - Lation's Oxy Run](https://streamable.com/o4t7bz)

## Join Discord
[Click here to join our Discord](https://discord.gg/9EbY4nM5uu)
