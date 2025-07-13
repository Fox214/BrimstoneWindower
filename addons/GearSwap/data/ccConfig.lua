-- Jobs you want to execute with, recomment put all active jobs you have lua for will look for <job>.lua or <playername>_<job>.lua files
ccjobs = { 'BLM', 'BLU', 'BRD', 'BST', 'COR', 'DNC', 'DRG', 'DRK', 'GEO', 'MNK', 'NIN', 'PLD', 'PUP', 'RDM', 'RNG', 'RUN', 'SAM', 'SCH', 'SMN', 'THF', 'WAR', 'WHM' }
-- Put any items in your inventory here you don't want to show up in the final report
-- recommended for furniture, food, meds, pop items or any gear you know you want to keep for some reason
-- use * for anything. 
ccignore = { "Rem's Tale*", "Storage Slip *", "Deed of*", "* Virtue", "Dragua's Scale",
            "Glittering Yarn", "Dim. Ring*", "Cupboard", "*VCS*", "*Abjuration*", "* Organ",
            "Mecisto. Mantle", "Homing Ring", "* Plans", "Orblight", "Yellow 3D Almirah",
            "* Statue", "Luminion Chip", "* Mannequin", "R. Bamboo Grass", "Coiled Yarn",
            "Stationery Set", "* Flag", "Bonbori", "Imperial Standard", "* Bed", "Adamant. Statue",
            "Festival Dolls", "Taru Tot Toyset", "Bookshelf", "Guild Flyers", "San d'Orian Tree",
            "*Signet Staff", "Capacity Ring", "Facility Ring", "Trizek Ring", "Bam. Grass Basket", "Portafurnace",
            "* Sign", "* Apron", "Toolbag *", "* Crepe", "*Sushi*", "* Stable Collar", "Plovid Effluvium",
            "Gem of the *", "Inoshishinofuda", "Ichigohitofuri", "Chonofuda", "Shikanofuda", "Shihei", "Midras*Helm*", "Cobra Staff", "Ram Staff", "Fourth Staff",
            "Warp Ring", "Chocobo Whistle", "Warp Cudgel", "* Broth", "Tavnazian Ring", "Official Reflector",
            "Pashhow Ring", "Dredger Hose", "Trench Tunic", "Sanjaku.Tenugui", "Katana.kazari", "Sanjaku.Tenugui",
            "Carver's Torque", "Kabuto.kazari", "Etched Memory", "Trbl. Hatchet", "Maat's Cap", "Trbl. Pickaxe",
            "Olduum Ring", "Linkpearl", "Caliber Ring", "Vana'clock", "Signal Pearl", "Windy Greens", "Nexus Cape",
            "Wastebasket", "Sickle", "Carpenter's Gloves", "Shinobi.Tabi", "Guardian Board", "* Pie", "Pet Food *",
            "Reraise *", "P. * Card", "Diorite", "Abdhaljs Seal", "Kin's Scale", "*Curry*", "Crepe B. Helene",
            "Rounsey Wand", "Tant. Broth", "Fu's Scale", "Kyou's Scale", "Kei's Scale", "Kin's Scale"
            }            
-- This is the most use of an item you want to show up in the report
-- Set to nil or delete for unlimited
ccmaxuse = nil
-- List bags you want to not check against, needs to match "Location" column in <player>_report.txt
ccskipBags = S{ 'Storage', 'Temporary' }
-- this prints out the _sets _ignored and _inventory files
ccDebug = true