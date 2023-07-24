Config = {}

--[[ Doctor Names Configs ]]
Config.DoctorNames = { -- List of all possible Doctor names that can be used when trying to fill a script (one is randomly selected at every server/script restart)
    'Dr. Khantgetard',
    'Dr. Sirpeeslot',
    'Dr. Seuss',
    'Dr. Doalot',
    'Dr. Likspeen',
    'Dr. Docraak',
    'Dr. Harrysak',
    'Dr. Pepper'
}

--[[ Pharmacy Locations Configs ]]
Config.PharmacyLocations = { -- List of coordinates of Pharmacy locations (one is randomly selected at every server/script restart)
    vec3(1142.1522, -451.8326, 66.9843), -- Mirror park
    vec3(69.2566, -1570.2457, 29.5978), -- Strawyberry ave
    vec3(98.4244, -226.2621, 54.6374), -- Hawick ave
    vec3(114.2634, -4.5923, 67.8195), -- Spanish and Alta ave
    vec3(237.7168, -26.7896, 69.8964), -- Spanish and Power ave
    vec3(213.6084, -1835.6198, 27.5606) -- Carson ave
}

--[[ General Configs ]]
Config.startOxyRunPedModel = 'g_m_y_ballaeast_01' -- The ped model for the starting mission
Config.StartOxyRunLocation = vec3(246.7493, 370.7164, 104.7381) -- The location of the starting mission ped
Config.StartOxyRunPedHeading = 120.6238 -- The heading (facing direction) of the starting mission ped
Config.StartOxyRunPedRadius = 45 -- The radius at which a player must be within for the ped to spawn
Config.BlankPrescription = 'blank_prescription' -- The name of the item that is rewarded upon a mission start
Config.SignedPerscription = 'signed_prescription' -- The name of the item that is given after filling in the information
Config.BlankPrescriptionRewardAmount = 1 -- How many of the above item is rewarded upon a mission start
Config.BlankPrescriptionPrice = 2000 -- How much it costs to start the mission
Config.Money = 'money' -- The currency to start the mission ('money' or 'black_money')
Config.RandomBlankPrescriptionPricing = true -- If true it makes the price of starting the mission random (within parameters below)
Config.MinBlankPrescriptionPrice = 1500 -- The minimum price for a Blank Prescription if above is true (otherwise, ignore)
Config.MaxBlankPrescriptionPrice = 3500 -- The maximum price for a Blank Prescription if above is true (otherwise, ignore)
Config.RequireItem = false -- If you'd like to require an item to start the mission, set this to true
Config.RequireItemName = 'water' -- If RequireItem = true, this is the required item name
Config.RequireItemAmount = 5 -- If RequireItem = true, this is the quantity required of the item name above
Config.OxyBottleItem = 'oxy_bottle' -- The name of the item that serves as an Oxy Bottle
Config.OxyBottleQuantity = 1 -- How many you want to reward when the precription is filled out correctly
Config.OxyPillItem = 'oxycontin' -- The item name of the oxy pills when you open the bottle
Config.OxyPillQuantity = 15 -- The number of pills player is given upon opening the bottle
Config.AvailableDoctorListLocation = vec3(343.1629, -1399.8206, 32.5092) -- The location at which a player can view possible Doctor names to fill the script
Config.EnableEffects = { -- When using an oxycontin, do you want effects enabled?
    enable = true, -- If so, make sure this is true. If you don't want any effects, set this to false
    health = {
        enable = true, -- Do you want to apply health to the player when this drug is used? (True if yes, false if no)
        amount = 200 -- If enable = true, how much health do you want to apply? (200 is full health)
    },
    armor = {
        enable = true, -- Do you want to apply armor to the player when this drug is used? (True if yes, false if no)
        amount = 100 -- If enable = true, how much armor do you want to apply? (100 is full armor)
    },
    speed = {
        enable = true, -- Do you want to apply a speed "boost" to the player when this drug is used? (True if yes, false if no)
        multiplier = 1.49, -- 1.49 is the maximum speed multiplier that works on FiveM, anything over 1.49 will not work and be set to normal speed
        duration = 10 -- How long in seconds the speed multiplier should work for
    },
    screenEffect = {
        enable = true, -- Do you want to apply a screen effect when this drug is used? (True if yes, false if no)
        effect = 'glasses_pink', -- If enableScreenEffect is true, what effect do you want? (Huge list of options: https://forum.cfx.re/t/timecyclemodifier-index-and-name-list/1419389)
        duration = 10000 -- If enable is true, how long in seconds do you want the effect to last?
    }
}

--[[ Webhook Configs ]]
Config.EnableWebhook = true -- If you want Discord webhook logs, enable this with true. If not, disable it with false.
Config.WebhookLink = '' -- The webhook link for logs
Config.WebhookName = 'Oxy' -- The Discord bot name for the webhook
Config.WebhookAvatarIcon = '' -- The webhook avatar image
Config.WebhookFooterIcon = '' -- The webhook footer image

--[[ String Configs ]]
Notifications = {
    position = 'top', -- the notification position of all notifications
    icon = 'capsules', -- the notification icon for all notifications
    pharmacyTitle = 'Pharmacy',
    pharmacyDescription = 'You cancelled filling the script',
    pharmacyItemNotFound = 'There is nothing here for you - try again later',
    startOxyRunPedName = 'Aaron',
    notEnoughMoney = 'Quit wasting my time bro, come back when you ain\'t broke',
    startOxyRunCancelDescription = 'Come back whenever you are ready',
    startOxyRunPart2CancelDescription = 'Quit messin\' with me man, I don\'t have time for this..',
    startOxyRunDidntHaveItemDescription = 'I got nothing for you man, leave me alone.',
    startOxyRunAlreadyStarted = 'I just hooked you up bro - use what you got and then we\'ll talk again.',
    oxyBottleTitle = 'Oxy Bottle',
    oxyBottleDescription = 'You changed your mind and kept the bottle closed',
    oxycontinTitle = 'Oxycontin',
    oxycontinDescription = 'You changed your mind and didn\'t take it'
}

Target = {
    startOxyRunLabel = 'Talk',
    startOxyRunIcon = 'fas fa-comment',
    availableDoctors = 'View available Doctors',
    availableDoctorsIcon = 'fas fa-user-doctor',
    fillScriptLabel = 'Fill script',
    fillScriptIcon = 'fas fa-capsules'
}

ContextMenu = {
    availableDoctorsMenuTitle = 'Today\'s Doctors',
    availableDoctorsIcon = 'user-doctor'
}

ProgressCircle = {
    position = 'middle', -- The position for all progressCircle's
    checkingScriptLabel = 'Checking script..',
    checkingScriptDuration = 15000,
    openOxyBottleLabel = 'Opening bottle..',
    openOxyBottleDuration = 4000,
    poppingOxyLabel = 'Popping oxy..',
    poppingOxyDuration = 2000
}

AlertDialog = {
    startOxyRunHeader = 'Aaron',
    startOxyRunContent = 'Whats up man, you need one of them \'scripts? I\'ll hook you up but be careful with these. If you get caught, it wasn\'t from me..',
    startOxyRunConfirm = 'Agree',
    startOxyRunCancel = 'Nevermind',
    startOxyRunPart2Header = 'Aaron',
    startOxyRunPart2Content = 'Alright man, let\'s do it. I need some cash though.. this stuff doesn\'t come easy. How\'s $',
    startOxyRunPart2Confirm = 'Pay',
    startOxyRunPart2Cancel = 'No',
    fakeScriptHeader = 'Doctor',
    fakeScriptContent = 'This is fraudulent! I will not fill this for you. This is going into my shredder.. goodbye now.'
}

InputDialog = {
    header = 'Fill Prescription Information',
    nameLabel = 'Name',
    nameDescription = 'Patient\'s first & last name',
    nameIcon = 'user',
    addressLabel = 'Address',
    addressDescription = 'Patient\'s full address',
    addressPlaceholder = '420 Strawberry Ave, Los Santos, 42069',
    addressIcon = 'house',
    firstCheckboxLabel = 'Nonacute Pain',
    secondCheckboxLabel = 'Acute Pain Exception',
    dobLabel = 'Date of Birth',
    dobFormat = "DD/MM/YYYY",
    dobIcon = 'calendar',
    doctorLabel = 'Doctor Signature',
    doctorDescription = 'Approving Doctor',
    doctorIcon = 'signature'
}