Config = {}


--
--██╗░░░░░██╗░░░██╗░██████╗████████╗██╗░░░██╗░█████╗░░░██╗██╗
--██║░░░░░██║░░░██║██╔════╝╚══██╔══╝╚██╗░██╔╝██╔══██╗░██╔╝██║
--██║░░░░░██║░░░██║╚█████╗░░░░██║░░░░╚████╔╝░╚██████║██╔╝░██║
--██║░░░░░██║░░░██║░╚═══██╗░░░██║░░░░░╚██╔╝░░░╚═══██║███████║
--███████╗╚██████╔╝██████╔╝░░░██║░░░░░░██║░░░░█████╔╝╚════██║
--╚══════╝░╚═════╝░╚═════╝░░░░╚═╝░░░░░░╚═╝░░░░╚════╝░░░░░░╚═╝


--Thank you for downloading this script!

--Below you can change multiple options to suit your server needs.

Config.CoreSettings = {
    Notify = {
        Type = 'qb', -- notification type, support for qb-core notify, okokNotify, mythic_notify and ox_lib notify
        --use 'qb' for default qb-core notify
        --use 'okok' for okokNotify
        --use 'mythic' for myhthic_notify
        --use 'ox' for ox_lib notify
    },
    Target = {
        Type = 'qb', -- support for qb-target and ox_target    
        --use 'qb' for qb-target
        --use 'ox' for ox_target
    },
    Inventory = { -- support for qb-inventory and ox_inventory
        Type = 'qb',
        --use 'qb' for qb-inventory
        --use 'ox' for ox_inventory
        --use 'custom' for your own inventory - you will need to add support to the addItem() and removeItem() and addMoney() function respectively in xmas_server.lua
    },
    Security = {
        KickPlayer = false, -- kick the player from the server if they fail the distance checks
        Prints = true, -- send prints to the server console with information of who failed the distance check
        MaxDist = 4.0, -- max distance player is allowed from the present object without failing the distance check - do not set this lower than the target distance for the object for obvious reasons
    },
    Timers = {
        CollectPresent = 5000, -- time it takes to collect a present
        OpenPresents = 5000, -- time it takes to open a present - THIS IS MULTIPLIED BY THE AMOUNT THE PLAYER CHOOSES TO OPEN
    },
    Chances = {
        GetPresent = 75, -- chance in % to collect a present or get coal
        CashInPresents = 100, -- chance to find cash when opening presents
    },
    Blips = {
        Presents = true, -- set to true to enable blips for ALL presents
        Exchange = true, -- set to true to enable blips for ALL exchangers
    },
    Sound = {
        Enabled = true, -- requires interact sound - play custom sound when exchanging xmas tokens
        ChristmasCheer = 'christmascheer', -- name of sound file - this must be placed inside interact-sound/client/html/sounds folder
    },
    Buffs = {
        Health = { -- adds health to the player when eating
            Enabled = true,
            Amount = math.random(10,20), -- amount to increase
        },
        Armour = { -- adds armour to the player when eating
            Enabled = true,
            Amount = math.random(10,20), -- amount to increase
        },
        Stress = { -- removes stress from the player when eating
            Enabled = true,
            Amount = math.random(10,20), -- amount to reduce
        },
    },
}


Config.InteractionLocations = {
    Presents = {
        Prop = 'xm3_prop_xm3_present_01a', --name of present prop
        Icon = 'fa-solid fa-hand-point-up', -- target icon
        Label = 'Collect Present', -- target label
        Distance = 2.0, -- target distance - do not set this higher than the max distance threshold for searching the presents as it will kick players for protection
        Locations = { -- name must be unique
            { 
                Name = "present1", 
                Coords = vector4(-1454.46, -1273.63, 3.4, 250.51), 
            },
            { 
                Name = "present2", 
                Coords = vector4(-1452.45, -1282.55, 3.66, 197.99),
            },            
            { 
                Name = "present3", 
                Coords = vector4(-1444.66, -1286.83, 3.98, 279.26),
            },
        },

    },
    Snowmen = { 
        Prop = 'xm3_prop_xm3_snowman_01a', --name of present prop
        Icon = 'fa-solid fa-hand-point-up', -- target icon
        Label = 'Open Christmas Presents', -- target label
        Distance = 2.0, -- target distance
        Locations = { -- name must be unique
            { 
                Name = "snowman1",
                Coords = vector4(-1420.29, -1258.2, 4.08, 64.32),
            },
            { 
                Name = "snowman2",  
                Coords = vector4(218.47, -867.81, 30.49, 314.67),
            },
            { 
                Name = "snowman3",  
                Coords = vector4(-1341.54, -18.16, 51.84, 248.2),
            },
        },
        
    },  
}



Config.XmasTreats = { -- add or remove food items and change hunger replenishment values below

    --<! IMPORTANT NOTES !>--
    
    --['xmascookie'] - this is the item name
    --Replenish - amount of hunger to replenish
    --AnimDict - animation dictionary
    --Anim - animation
    --Flags - animation flags
    --Prop - name of prop model
    --Bone - bone index for prop
    --Pos - vec3 value for prop position
    --Rot - vec3 value for prop rotation

    ['xmascookie'] = {
        Replenish = math.random(10,20),
        AnimDict = 'mp_player_inteat@burger',
        Anim = 'mp_player_int_eat_burger',
        Flags = 41,
        Prop = 'pata_christmasfood2', -- should be in rpemotes by default
        Bone = 18905,
        Pos = vec3(0.17, -0.04, 0.03),
        Rot = vec3(13.0, -180.0, 1.0),
    },
    ['xmascandycane'] = { 
        Replenish = math.random(10,20),
        AnimDict = 'mp_player_inteat@burger',
        Anim = 'mp_player_int_eat_burger',
        Flags = 41,
        Prop = 'w_me_candy_xm3', -- base game prop
        Bone = 18905,
        Pos = vec3(0.12, -0.16, 0.07),
        Rot = vec3(-109.0, 0.0, 0.0),
    },
    ['xmaschocolate'] = { 
        Replenish = math.random(10,20),
        AnimDict = 'mp_player_inteat@burger',
        Anim = 'mp_player_int_eat_burger',
        Flags = 41,
        Prop = 'prop_choc_ego', -- base game prop
        Bone = 60309,
        Pos = vec3(0.0, 0.0, 0.0),
        Rot = vec3(0.0, 0.0, 0.0),
    },
    ['xmasmincepie'] = { 
        Replenish = math.random(10,20),
        AnimDict = 'mp_player_inteat@burger',
        Anim = 'mp_player_int_eat_burger',
        Flags = 41,
        Prop = 'pata_christmasfood6', -- should be in rpemotes by default
        Bone = 60309,
        Pos = vec3(0.01, 0.02, -0.01),
        Rot = vec3(-170.17, 87.67, 30.05),
    },
    ['xmasgingerbread'] = { 
        Replenish = math.random(10,20),
        AnimDict = 'mp_player_inteat@burger',
        Anim = 'mp_player_int_eat_burger',
        Flags = 41,
        Prop = 'bzzz_food_xmas_gingerbread_a', -- should be in rpemotes by default
        Bone = 60309,
        Pos = vec3(0.0, 0.0, 0.0),
        Rot = vec3(0.0, 0.0, 0.0),
    },
}


Config.Animations = {
    CollectPresent = {
        AnimDict = 'amb@medic@standing@kneel@enter',
        Anim = 'enter', 
        Flags = 41,
    },
    OpenPresents = {
        AnimDict = 'misscarsteal4@aliens',
        Anim = 'rehearsal_base_idle_director',
        Flags = 41,
    },
}


Config.Language = {
    ProgressBar = {
        CollectPresent = 'Collecting present',
        OpenPresents = 'Opening presents',
    },
    Notifications = {
        Busy = 'You are already doing something!',
        Cancelled = 'Action cancelled!',
        CantCarry = 'You cant carry anymore!',
        FoundCash = 'Nice! you found some cash',
        GoatCoal = 'You must have been naughty - you got some coal!',
        InvalidAmount = 'You have entered an invalid amount!',
        MissingItems = 'You are missing items!',
        NotEnough = 'You dont have enough to do that!',
    },
}