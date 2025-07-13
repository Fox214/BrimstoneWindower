include('organizer-lib.lua')
-- NOTE: I do not play bst, so this will not be maintained for 'active' use. 
-- It is added to the repository to allow people to have a baseline to build from,
-- and make sure it is up-to-date with the library API.

-- Credit to Quetzalcoatl.Falkirk for most of the original work.

--[[
    Custom commands:
    
    Ctrl-F8 : Cycle through available pet food options.
    Alt-F8 : Cycle through correlation modes for pet attacks.
]]

-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

function job_setup()
	DisplayPetBuffTimers = 'true'
	-- Input Pet:TP Bonus values for Skirmish Axes used during Pet Buffs
    TP_Bonus_Main = 0
    TP_Bonus_Sub = 0
    -- 1200 Job Point Gift Bonus (Set equal to 0 if below 1200 Job Points)
    TP_Gift_Bonus = 40

    -- (Adjust Run Wild Duration based on # of Job Points)
    RunWildDuration = 340
	RunWildIcon = 'abilities/00121.png'
    RewardRegenIcon = 'spells/00023.png'
    SpurIcon = 'abilities/00037.png'
    BubbleCurtainDuration = 180
	BubbleCurtainIcon = 'spells/00048.png'
    ScissorGuardIcon = 'spells/00043.png'
    SecretionIcon = 'spells/00053.png'
    RageIcon = 'abilities/00002.png'
    RhinoGuardIcon = 'spells/00053.png'
    ZealousSnortIcon = 'spells/00057.png'
	state.WeaponMode = M{['description']='Weapon Mode', 'Axe', 'Scythe', 'Sword', 'Staff', 'Club', 'Dagger'}
	state.SubMode = M{['description']='Sub Mode', 'DW', 'Shield', 'Grip' }
	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive'}
	state.holdtp = M{['description']='holdtp', 'true', 'false'}
	state.loyalty = M{['description']='loyalty', 'true', 'false'}

	--Call Beast items
	call_beast_items = {
		CrabFamiliar="Fish Broth",
		SlipperySilas="Wormy Broth",
		HareFamiliar="Carrot Broth",
		SheepFamiliar="Herbal Broth",
		FlowerpotBill="Humus",
		TigerFamiliar="Meat Broth",
		FlytrapFamiliar="Grasshopper Broth",
		LizardFamiliar="Carrion Broth",
		MayflyFamiliar="Bug Broth",
		EftFamiliar="Mole Broth",
		BeetleFamiliar="Tree Sap",
		AntlionFamiliar="Antica Broth",
		MiteFamiliar="Blood Broth",
		KeenearedSteffi="Famous Carrot Broth",
		LullabyMelodia="Singing Herbal Broth",
		FlowerpotBen="Rich Humus",
		SaberSiravarde="Warm Meat Broth",
		FunguarFamiliar="Seedbed Soil",
		ShellbusterOrob="Quadav Bug Broth",
		ColdbloodComo="Cold Carrion Broth",
		CourierCarrie="Fish Oil Broth",
		Homunculus="Alchemist Water=",
		VoraciousAudrey="Noisy Grasshopper Broth",
		AmbusherAllie="Lively Mole Broth",
		PanzerGalahad="Scarlet Sap",
		LifedrinkerLars="Clear Blood Broth",
		ChopsueyChucky="Fragrant Antica Broth",
		AmigoSabotender="Sun Water",
		NurseryNazuna="Dancing Herbal Broth",
		CraftyClyvonne="Cunning Brain Broth",
		PrestoJulio="Chirping Grasshopper Broth",
		SwiftSieghard="Mellow Bird Broth",
		MailbusterCetas="Goblin Bug Broth",
		AudaciousAnna="Bubbling Carrion Broth",
		TurbidToloi="Auroral Broth",
		LuckyLulush="Lucky Carrot Broth",
		DipperYuly="Wool Grease",
		FlowerpotMerle="Vermihumus",
		DapperMac="Briny Broth",
		DiscreetLouise="Deepbed Soil",
		FatsoFargann="Curdled Plasma",
		FaithfulFalcorr="Lucky Broth",
		BugeyedBroncha="Savage Mole Broth",
		BloodclawShasra="Razor Brain Broth",
		GorefangHobs="Burning Carrion Broth",
		GooeyGerard="Cloudy Wheat Broth",
		CrudeRaphie="Shadowy Broth",
		DroopyDortwin="Swirling Broth",
		SunburstMalfik="Shimmering Broth",
		WarlikePatrick="Livid Broth",
		ScissorlegXerin="Spicy Broth",
		RhymingShizuna="Lyrical Broth",
		AttentiveIbuki="Salubrious Broth",
		AmiableRoche="Airy Broth",
		HeraldHenry="Translucent Broth",
		BrainyWaluis="Crumbly Soil",
		HeadbreakerKen="Blackwater Broth",
		RedolentCandi="Electrified Broth",
		CaringKiyomaro="Fizzy Broth",
		HurlerPercival="Pale Sap",
		BlackbeardRandy="Meaty Broth",
		GenerousArthur="Dire Broth",
		ThreestarLynn="Muddy Broth",
		BraveHeroGlenn="Wispy Broth",
		SharpwitHermes="Saline Broth",
		FleetReinhard="Rapid Broth",
		VivaciousVickie="Tant. Broth",
		AlluringHoney="Bug-Ridden Broth",
		BouncingBertha="Bubbly Broth",
		SwoopingZhivago="Windy Greens"
	}
	set_combat_form()
	pick_tp_weapon()
    state.RewardMode = M{['description']='Reward Mode', 'Theta', 'Eta', 'Zeta', 'Epsilon', 'Delta', 'Gamma', 'Beta', 'Alpha'}
    RewardFood = {name="Pet Food Theta"}
	-- cntl F8
    send_command('bind ^f8 gs c cycle RewardMode')

    -- Set up Monster Correlation Modes and keybind Alt-F8
    state.CorrelationMode = M{['description']='Correlation Mode', 'Neutral','Favorable'}
    send_command('bind !f8 gs c cycle CorrelationMode')
    
	-- Complete list of Ready moves
	physical_ready_moves = S{'Foot Kick','Whirl Claws','Sheep Charge','Lamb Chop','Head Butt','Wild Oats',
		'Leaf Dagger','Claw Cyclone','Razor Fang','Nimble Snap','Cyclotail','Rhino Attack','Power Attack',
		'Mandibular Bite','Big Scissors','Grapple','Spinning Top','Double Claw','Frogkick','Blockhead',
		'Brain Crush','Tail Blow','??? Needles','Needleshot','Scythe Tail','Ripper Fang','Chomp Rush',
		'Recoil Dive','Sudden Lunge','Spiral Spin','Wing Slap','Beak Lunge','Suction','Back Heel',
		'Choke Breath','Fantod','Tortoise Stomp','Sensilla Blades','Tegmina Buffet','Swooping Frenzy',
		'Pentapeck','Sweeping Gouge','Somersault','Tickling Tendrils','Pecking Flurry','Sickle Slash'}

	magic_atk_ready_moves = S{'Dust Cloud','Cursed Sphere','Venom','Toxic Spit','Bubble Shower','Drainkiss',
		'Silence Gas','Dark Spore','Fireball','Plague Breath','Snow Cloud','Charged Whisker','Purulent Ooze',
		'Corrosive Ooze','Aqua Breath','Stink Bomb','Nectarous Deluge','Nepenthic Plunge','Pestilent Plume',
		'Foul Waters','Acid Spray','Infected Leech','Gloom Spray'}

	magic_acc_ready_moves = S{'Sheep Song','Scream','Dream Flower','Roar','Gloeosuccus','Palsy Pollen',
		'Soporific','Geist Wall','Toxic Spit','Numbing Noise','Spoil','Hi-Freq Field','Sandpit','Sandblast',
		'Venom Spray','Filamented Hold','Queasyshroom','Numbshroom','Spore','Shakeshroom','Infrasonics',
		'Chaotic Eye','Blaster','Intimidate','Noisome Powder','Acid Mist','TP Drainkiss','Jettatura',
		'Molting Plumage','Spider Web'}

	multi_hit_ready_moves = S{'Pentapeck','Tickling Tendrils','Sweeping Gouge','Chomp Rush','Wing Slap',
		'Pecking Flurry'}
	tp_based_ready_moves = S{'Foot Kick','Dust Cloud','Snow Cloud','Sheep Song','Sheep Charge','Lamb Chop',
		'Head Butt','Scream','Dream Flower','Wild Oats','Leaf Dagger','Claw Cyclone','Razor Fang','Roar',
		'Gloeosuccus','Palsy Pollen','Soporific','Cursed Sphere','Somersault','Geist Wall','Numbing Noise',
		'Frogkick','Nimble Snap','Cyclotail','Spoil','Rhino Attack','Hi-Freq Field','Sandpit','Sandblast',
		'Mandibular Bite','Metallic Body','Bubble Shower','Grapple','Spinning Top','Double Claw','Spore',
		'Filamented Hold','Blockhead','Fireball','Tail Blow','Plague Breath','Brain Crush','Infrasonics',
		'Needleshot','Chaotic Eye','Blaster','Ripper Fang','Intimidate','Recoil Dive','Water Wall',
		'Sudden Lunge','Noisome Powder','Wing Slap','Beak Lunge','Suction','Drainkiss','Acid Mist',
		'TP Drainkiss','Back Heel','Jettatura','Choke Breath','Fantod','Charged Whisker','Purulent Ooze',
		'Corrosive Ooze','Tortoise Stomp','Aqua Breath','Sensilla Blades','Tegmina Buffet','Sweeping Gouge',
		'Tickling Tendrils','Pecking Flurry','Pestilent Plume','Foul Waters','Spider Web','Gloom Spray'}

	-- List of Pet Buffs and Ready moves exclusively modified by Pet TP Bonus gear.
	pet_buff_moves = S{'Reward','Spur','Run Wild','Wild Carrot','Bubble Curtain','Scissor Guard','Secretion','Rage',
		'Harden Shell','Rhino Guard','Zealous Snort'}
	include('Mote-TreasureHunter')	
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.IdleMode:options('Normal', 'Refresh', 'Reraise')
	state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'SB', 'SB', 'sTP', 'STR')
	state.WeaponskillMode:options('Normal', 'Acc', 'Mod')
	state.DefenseMode:options('None', 'Physical', 'Magical')
	state.PhysicalDefenseMode:options('PDT', 'Evasion', 'Reraise', 'Killer')
	state.MagicalDefenseMode:options('MDT', 'Reraise')
	state.WeaponMode:set('Axe')
	state.Stance:set('Offensive')
	state.SubMode:set('DW')
	state.holdtp:set('false')
	state.loyalty:set('true')
	gear.Broth = {name=""}
	gear.Offhand = {name=""}
	Twilight = false				

	pick_tp_weapon()
	select_offhand()
	select_default_macro_book()
	send_command('bind ^= gs c cycle treasuremode')
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    -- Unbinds the Reward and Correlation hotkeys.
    send_command('unbind ^f8')
    send_command('unbind !f8')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
	-- add_to_chat(122,'init gear sets')
	organizer_items = {
        new1="",
		new2="",
		new3="",
		new4="",
		new5="",
		new6="",
		new7="",
		new8="",
		new9="Grape Daifuku",
		food0="Akamochi",
		food1="Pet Food Alpha",
		food2="Pet Food Beta",
		food3="Pet Fd. Gamma",
		food4="Pet Food Delta",
		food5="Pet Fd. Epsilon",
		food6="Pet Food Zeta",
		food7="Pet Food Eta",
		food8="Pet Food Theta",
		call_beast_items,
		echos="Echo Drops",
		shihei="Shihei",
		orb="Macrocosmic Orb"
	}
	
	-- Idle sets
	sets.idle = {ammo="Demonry Core",
        head="Meghanada Visor +2",neck="Elite Royal Collar",lear="Infused Earring",rear="Moonshade Earring",
        body="Meg. Cuirie +2",hands="Meg. Gloves +2",ring1="Defending Ring",ring2="Renaye Ring +1",
        back="Solemnity Cape",waist="Plat. Mog. Belt",legs="Nukumi Quijotes +1",feet="Skd. Jambeaux +1"}
        
	-- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
	sets.idle.Town = set_combine(sets.idle, {})
	sets.idle.Field = set_combine(sets.idle, {})
	sets.idle.Weak = set_combine(sets.idle, {})
    sets.idle.Pet = set_combine(sets.idle, {})
	
	-- haste: head 5%, back 10%, feet 7%, offhand 8%
    sets.idle.Pet.Offensive = set_combine(sets.idle.Pet, {ammo="Demonry Core",
        head="Emicho Coronet",neck="Shulmanu Collar",lear="Enmerkar Earring",rear="Domes. Earring",
        body="Emicho Haubert",hands="Tali'ah Gages +2",ring1="Defending Ring",ring2="Tali'ah Ring",
        back="Artio's Mantle",waist="Incarnation Sash",legs="Tali'ah Sera. +2",feet="Tali'ah Crackows +2"})
    
	sets.idle.Pet.Defensive = set_combine(sets.idle.Pet.Offensive, {
		main="Kumbhakarna",sub="Astolfo",
        head="Anwig Salade",neck="Adad Amulet",lear="Enmerkar Earring",rear="Hypaspist Earring",
		body="Emicho Haubert",hands="Ankusa Gloves +1",
		back="Pastoralist's Mantle",legs="Nukumi Quijotes +1",feet="Ankusa Gaiters +1"})

	-- Resting sets
	sets.resting = set_combine(sets.idle.Pet.Defensive, {})

	-- Engaged sets
	-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion

	-- Normal melee group
	sets.engaged = {ammo="Demonry Core",
			head="Valorous Mask",neck="Shulmanu Collar",lear="Sherida Earring",rear="Nukumi Earring",
			body="Emicho Haubert",hands="Emicho Gauntlets",ring1="Epona's Ring",ring2="Hetairoi Ring",
			back="Artio's Mantle",waist="Hurch'lan Sash",legs="Emicho Hose",feet="Tali'ah Crackows +2"}
    sets.engaged.Killer = set_combine(sets.engaged, {body="Nukumi Gausape"})
			
	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {
			head="Tali'ah Turban +2",neck="Shulmanu Collar",lear="Zennaroi Earring",rear="Nukumi Earring",
			body="Meg. Cuirie +2",hands="Emicho Gauntlets",ring1="Cacoethic Ring +1",ring2="Regal Ring",
			back="Artio's Mantle",waist="Olseni Belt",legs="Meg. Chausses +2",feet="Meg. Jam. +2"})
	sets.Mode.Att= set_combine(sets.engaged, {
			head="Meghanada Visor +2",neck="Rep. Plat. Medal",lear="Bladeborn Earring",rear="Dudgeon Earring",
			body="Phorcys Korazin",hands="Meg. Gloves +2",ring1="Overbearing Ring",ring2="Regal Ring",
			back="Phalangite Mantle",waist="Sulla Belt",legs="Emicho Hose",feet="Meg. Jam. +2"})
	sets.Mode.Crit = set_combine(sets.engaged, {
			body="Meg. Cuirie +2",hands="Tali'ah Gages +2",ring1="Hetairoi Ring",legs="Jokushu Haidate",feet="Thereoid Greaves"})
	sets.Mode.DA = set_combine(sets.engaged, {
			head="Skormoth Mask",neck="Shulmanu Collar",lear="Sherida Earring",rear="Brutal Earring",
			body="Tali'ah Manteel +2",hands="Phorcys Mitts",ring1="Epona's Ring",ring2="Hetairoi Ring",
			back="Atheling Mantle",waist="Sarissapho. Belt",legs="Meg. Chausses +2",feet="Loyalist Sabatons"})
	sets.Mode.SB = set_combine(sets.engaged, {body="Sacro Breastplate"})
	sets.Mode.sTP = set_combine(sets.engaged, {
			head="Tali'ah Turban +2",neck="Anu Torque",lear="Sherida Earring",rear="Tripudio Earring",
			body="Valorous Mail",ring1="Rajas Ring",ring2="K'ayres Ring",
			back="Lupine Cape",waist="Yemaya Belt",legs="Phorcys Dirs",feet="Valorous Greaves"})
	sets.Mode.STR = set_combine(sets.engaged, { ammo="Amar Cluster",
			head="Valorous Mask",neck="Rep. Plat. Medal",lear="Thrud Earring",rear="Sherida Earring",
			body="Sacro Breastplate",hands="Meg. Gloves +2",ring1="Apate Ring",ring2="Regal Ring",
			back="Buquwik Cape",waist="Sailfi Belt +1",legs="Valorous Hose",feet="Meg. Jam. +2"})

	-- other Sets    
	sets.macc = {head="Malignance Chapeau",lear="Gwati Earring",ring1="Sangoma Ring",
		body="Sacro Breastplate"}
	sets.PDL = {head="Malignance Chapeau"}
	sets.empy = {head="Nukumi Cabasset",
		body="Nukumi Gausape",hands="Nukumi Manoplas +1",
		legs="Nukumi Quijotes +1",feet="Nukumi Ocreae"}

	-- Sets with weapons defined.
	sets.engaged.Axe = {}
	sets.engaged.Scythe = {}
	sets.engaged.Sword = {}
	sets.engaged.Staff = {}
	sets.engaged.Club = {}
	sets.engaged.Dagger = {}
	sets.engaged.DW = set_combine(sets.engaged, {})
	sets.engaged.Shield = set_combine(sets.engaged, {})
	sets.engaged.Grip = set_combine(sets.engaged, {})
	sets.engaged.DW.Axe = set_combine(sets.engaged, {main="Arktoi",sub=gear.Offhand})
	sets.engaged.Shield.Axe = set_combine(sets.engaged, {main="Skullrender",sub="Deliverance"})
	sets.engaged.DW.Club = set_combine(sets.engaged, {main="Warp Cudgel",sub=gear.Offhand})
	sets.engaged.Shield.Club = set_combine(sets.engaged, {main="Warp Cudgel",sub="Deliverance"})
	sets.engaged.DW.Dagger = set_combine(sets.engaged, {main="Odium",sub=gear.Offhand})
	sets.engaged.Shield.Dagger = set_combine(sets.engaged, {main="Odium",sub="Deliverance"})
	sets.engaged.Grip.Scythe = set_combine(sets.engaged, {main="Pixquizpan", sub="Pole Grip"})
	sets.engaged.Grip.Staff = set_combine(sets.engaged, {main="Gozuki Mezuki", sub="Pole Grip"})
	sets.engaged.DW.Sword = set_combine(sets.engaged, {main="Naegling",sub=gear.Offhand})
	sets.engaged.Shield.Sword = set_combine(sets.engaged, {main="Naegling",sub="Deliverance"})
	
	sets.engaged.Grip.Scythe.Acc = set_combine(sets.engaged.Grip.Scythe, sets.Mode.Acc)
	sets.engaged.Grip.Scythe.Att = set_combine(sets.engaged.Grip.Scythe, sets.Mode.Att)
	sets.engaged.Grip.Scythe.Crit = set_combine(sets.engaged.Grip.Scythe, sets.Mode.Crit)
	sets.engaged.Grip.Scythe.DA = set_combine(sets.engaged.Grip.Scythe, sets.Mode.DA)
	sets.engaged.Grip.Scythe.SB = set_combine(sets.engaged.Grip.Scythe, sets.Mode.SB)
	sets.engaged.Grip.Scythe.sTP = set_combine(sets.engaged.Grip.Scythe, sets.Mode.sTP)
	sets.engaged.Grip.Scythe.STR = set_combine(sets.engaged.Grip.Scythe, sets.Mode.STR)
	
	sets.engaged.DW.Axe.Acc = set_combine(sets.engaged.DW.Axe, sets.Mode.Acc)
	sets.engaged.DW.Axe.Att = set_combine(sets.engaged.DW.Axe, sets.Mode.Att)
	sets.engaged.DW.Axe.Crit = set_combine(sets.engaged.DW.Axe, sets.Mode.Crit)
	sets.engaged.DW.Axe.DA = set_combine(sets.engaged.DW.Axe, sets.Mode.DA)
	sets.engaged.DW.Axe.SB = set_combine(sets.engaged.DW.Axe, sets.Mode.SB)
	sets.engaged.DW.Axe.sTP = set_combine(sets.engaged.DW.Axe, sets.Mode.sTP)
	sets.engaged.DW.Axe.STR = set_combine(sets.engaged.DW.Axe, sets.Mode.STR)
	sets.engaged.Shield.Axe.Acc = set_combine(sets.engaged.Shield.Axe, sets.Mode.Acc)
	sets.engaged.Shield.Axe.Att = set_combine(sets.engaged.Shield.Axe, sets.Mode.Att)
	sets.engaged.Shield.Axe.Crit = set_combine(sets.engaged.Shield.Axe, sets.Mode.Crit)
	sets.engaged.Shield.Axe.DA = set_combine(sets.engaged.Shield.Axe, sets.Mode.DA)
	sets.engaged.Shield.Axe.SB = set_combine(sets.engaged.Shield.Axe, sets.Mode.SB)
	sets.engaged.Shield.Axe.sTP = set_combine(sets.engaged.Shield.Axe, sets.Mode.sTP)
	sets.engaged.Shield.Axe.STR = set_combine(sets.engaged.Shield.Axe, sets.Mode.STR)
	
	sets.engaged.DW.Club.Acc = set_combine(sets.engaged.DW.Club, sets.Mode.Acc)
	sets.engaged.DW.Club.Att = set_combine(sets.engaged.DW.Club, sets.Mode.Att)
	sets.engaged.DW.Club.Crit = set_combine(sets.engaged.DW.Club, sets.Mode.Crit)
	sets.engaged.DW.Club.DA = set_combine(sets.engaged.DW.Club, sets.Mode.DA)
	sets.engaged.DW.Club.SB = set_combine(sets.engaged.DW.Club, sets.Mode.SB)
	sets.engaged.DW.Club.sTP = set_combine(sets.engaged.DW.Club, sets.Mode.sTP)
	sets.engaged.DW.Club.STR = set_combine(sets.engaged.DW.Club, sets.Mode.STR)
	sets.engaged.Shield.Club.Acc = set_combine(sets.engaged.Shield.Club, sets.Mode.Acc)
	sets.engaged.Shield.Club.Att = set_combine(sets.engaged.Shield.Club, sets.Mode.Att)
	sets.engaged.Shield.Club.Crit = set_combine(sets.engaged.Shield.Club, sets.Mode.Crit)
	sets.engaged.Shield.Club.DA = set_combine(sets.engaged.Shield.Club, sets.Mode.DA)
	sets.engaged.Shield.Club.SB = set_combine(sets.engaged.Shield.Club, sets.Mode.SB)
	sets.engaged.Shield.Club.sTP = set_combine(sets.engaged.Shield.Club, sets.Mode.sTP)
	sets.engaged.Shield.Club.STR = set_combine(sets.engaged.Shield.Club, sets.Mode.STR)

	sets.engaged.DW.Dagger.Acc = set_combine(sets.engaged.DW.Dagger, sets.Mode.Acc)
	sets.engaged.DW.Dagger.Att = set_combine(sets.engaged.DW.Dagger, sets.Mode.Att)
	sets.engaged.DW.Dagger.Crit = set_combine(sets.engaged.DW.Dagger, sets.Mode.Crit)
	sets.engaged.DW.Dagger.DA = set_combine(sets.engaged.DW.Dagger, sets.Mode.DA)
	sets.engaged.DW.Dagger.SB = set_combine(sets.engaged.DW.Dagger, sets.Mode.SB)
	sets.engaged.DW.Dagger.sTP = set_combine(sets.engaged.DW.Dagger, sets.Mode.sTP)
	sets.engaged.DW.Dagger.STR = set_combine(sets.engaged.DW.Dagger, sets.Mode.STR)
	sets.engaged.Shield.Dagger.Acc = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Acc)
	sets.engaged.Shield.Dagger.Att = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Att)
	sets.engaged.Shield.Dagger.Crit = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Crit)
	sets.engaged.Shield.Dagger.DA = set_combine(sets.engaged.Shield.Dagger, sets.Mode.DA)
	sets.engaged.Shield.Dagger.SB = set_combine(sets.engaged.Shield.Dagger, sets.Mode.SB)
	sets.engaged.Shield.Dagger.sTP = set_combine(sets.engaged.Shield.Dagger, sets.Mode.sTP)
	sets.engaged.Shield.Dagger.STR = set_combine(sets.engaged.Shield.Dagger, sets.Mode.STR)

	sets.engaged.DW.Sword.Acc = set_combine(sets.engaged.DW.Sword, sets.Mode.Acc)
	sets.engaged.DW.Sword.Att = set_combine(sets.engaged.DW.Sword, sets.Mode.Att)
	sets.engaged.DW.Sword.Crit = set_combine(sets.engaged.DW.Sword, sets.Mode.Crit)
	sets.engaged.DW.Sword.DA = set_combine(sets.engaged.DW.Sword, sets.Mode.DA)
	sets.engaged.DW.Sword.SB = set_combine(sets.engaged.DW.Sword, sets.Mode.SB)
	sets.engaged.DW.Sword.sTP = set_combine(sets.engaged.DW.Sword, sets.Mode.sTP)
	sets.engaged.DW.Sword.STR = set_combine(sets.engaged.DW.Sword, sets.Mode.STR)
	sets.engaged.Shield.Sword.Acc = set_combine(sets.engaged.Shield.Sword, sets.Mode.Acc)
	sets.engaged.Shield.Sword.Att = set_combine(sets.engaged.Shield.Sword, sets.Mode.Att)
	sets.engaged.Shield.Sword.Crit = set_combine(sets.engaged.Shield.Sword, sets.Mode.Crit)
	sets.engaged.Shield.Sword.DA = set_combine(sets.engaged.Shield.Sword, sets.Mode.DA)
	sets.engaged.Shield.Sword.SB = set_combine(sets.engaged.Shield.Sword, sets.Mode.SB)
	sets.engaged.Shield.Sword.sTP = set_combine(sets.engaged.Shield.Sword, sets.Mode.sTP)
	sets.engaged.Shield.Sword.STR = set_combine(sets.engaged.Shield.Sword, sets.Mode.STR)

	sets.engaged.Grip.Staff.Acc = set_combine(sets.engaged.Grip.Staff, sets.Mode.Acc)
    --------------------------------------
    -- Precast sets
    --------------------------------------
	-- Weaponskill sets
	-- Default set for any weaponskill that isn't any more specifically defined
	sets.WSDayBonus = {head="Gavialis Helm"} 
	sets.precast.WS = set_combine(sets.Mode.STR, {ammo="Oshasha's Treatise",
		neck="Fotia Gorget",lear="Thrud Earring",rear="Nukumi Earring",
        body="Phorcys Korazin",hands="Meg. Gloves +2",ring1="Cornelia's Ring",ring2="Epaminondas's Ring",
        waist="Fotia Belt"})
	sets.precast.WS.Acc = set_combine(sets.precast.WS, {})
   
	-- Thunder/Wind, STR 60%
	sets.precast.WS['Raging Axe'] = set_combine(sets.precast.WS, {})
	
	-- Ice/Water, STR 100%
	sets.precast.WS['Smash Axe'] = set_combine(sets.precast.WS, {})
	
	-- Wind, STR 100%
	sets.precast.WS['Gale Axe'] = set_combine(sets.precast.WS, {})
	
	-- Earth/Thunder, STR 60%
	sets.precast.WS['Avalanche Axe'] = set_combine(sets.precast.WS, {})
	
	-- Earth/Thunder/Fire, STR 60%
	sets.precast.WS['Spinning Axe'] = set_combine(sets.precast.WS, {})
	
	-- Earth, STR 50%
	sets.precast.WS['Rampage'] = set_combine(sets.precast.WS, {})
	
	-- Earth/Thunder, STR 50% VIT 50%
	sets.precast.WS['Calamity'] = set_combine(sets.precast.WS, {})

	-- Earth/Thunder, STR 50% 
	sets.precast.WS['Mistral Axe'] = set_combine(sets.precast.WS, {})
	
	-- Fire/light/water, STR 50%
	sets.precast.WS['Decimation'] = set_combine(sets.precast.WS, {})
	
	-- Earth/Wind, DEX 100%
	sets.precast.WS['Bora Axe'] = set_combine(sets.precast.WS, {})
	
	-- Earth/Wind, STR 73%
	sets.precast.WS['Ruinator'] = set_combine(sets.precast.WS, {})
	
	-- Dark/Wind/Thunder, STR 40% MND 40%
	sets.precast.WS['Cloudsplitter'] = set_combine(sets.precast.WS, {})

    sets.precast.JA['Killer Instinct'] = {head="Ankusa Helm"}
    sets.precast.JA['Feral Howl'] = {body="Ankusa Jackcoat"}
    sets.precast.JA['Bestial Loyalty'] = {main="Skullrender",ammo=gear.Broth,rear="Nukumi Earring",hands="Ankusa Gloves +1"}
    sets.precast.JA['Call Beast'] = set_combine(sets.precast.JA['Bestial Loyalty'], {})
    sets.precast.JA['Familiar'] = {legs="Ankusa Trousers +1"}
    sets.precast.JA['Tame'] = {}
    sets.precast.JA['Spur'] = {back="Artio's Mantle",feet="Nukumi Ocreae"}

	-- reward gear then MND
    sets.precast.JA['Reward'] = {ammo=RewardFood,
        head="Stout Bonnet",lear="Lifestorm Earring",rear="Pratik Earring",
        body="Tot. Jackcoat +1",ring1="Metamor. Ring +1",ring2="Metamor. Ring +1",
        back="Pastoralist's Mantle",legs="Ankusa Trousers +1",feet="Ankusa Gaiters +1"}

    sets.precast.JA['Charm'] = {
        head="Ankusa Helm",neck="Ferine Necklace",lear="Handler's Earring",rear="Rimeice Earring",
        body="Tot. Jackcoat +1",hands="Ankusa Gloves +1",ring2="Metamor. Ring +1",
        legs="Ankusa Trousers +1",feet="Ankusa Gaiters +1"}

    -- CURING WALTZ
    sets.precast.Waltz = {
        head="Skormoth Mask",neck="Ferine Necklace",
        body="Tot. Jackcoat +1",hands="Emicho Gauntlets",ring2="Metamor. Ring +1",
        back="Laic Mantle",legs="Emicho Hose",feet="Meg. Jam. +2"}

    -- HEALING WALTZ
    sets.precast.Waltz['Healing Waltz'] = {}

    -- STEPS
    sets.precast.Step = set_combine(sets.Mode.Acc, {})

    -- VIOLENT FLOURISH
    sets.precast.Flourish1 = {}
    sets.precast.Flourish1['Violent Flourish'] = {body="Ankusa Jackcoat",legs="Iuitl Tights"}

    sets.precast.FC = {neck="Orunmila's Torque",lear="Etiolation Earring",
        body="Sacro Breastplate",hands="Leyline Gloves",ring1="Naji's Loop",ring2="Prolix Ring",
		legs="Limbo Trousers"}
    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})

    --------------------------------------
    -- Midcast sets
    --------------------------------------
    
    sets.midcast.FastRecast = {}

    sets.midcast.Utsusemi = set_combine(sets.midcast.FastRecast, {})

    -- PET SIC & READY MOVES
    sets.midcast.Pet.Ready = set_combine(sets.idle.Pet.Offensive, {
        hands="Nukumi Manoplas +1",
        waist="Incarnation Sash",feet="Emicho Gambieras"})
		
    sets.midcast.Pet.ReadyPhys = set_combine(sets.midcast.Pet.Ready, {})
    sets.midcast.Pet.ReadyMA = set_combine(sets.midcast.Pet.ReadyPhys, {})
    sets.midcast.Pet.ReadyMacc = set_combine(sets.midcast.Pet.Ready, {neck="Adad Amulet"})
    sets.midcast.Pet.ReadyMAB = set_combine(sets.midcast.Pet.ReadyMacc, {neck="Adad Amulet"})
    sets.midcast.Pet.ReadyBuff = set_combine(sets.midcast.Pet.Ready, {})
    sets.midcast.Pet.Ready.Unleash = set_combine(sets.midcast.Pet.Ready, {})

    sets.midcast.Pet.Neutral = {}
    sets.midcast.Pet.Favorable = {head="Nukumi Cabasset"}
	
	sets.midcast.Pet.ReadyRecast = {sub="Charmer's Merlin",legs="Desultor Tassets"}

    -- DEFENSE SETS
 	sets.defense.Evasion = {
		head="Malignance Chapeau",lear="Infused Earring",rear="Eabani Earring",
        ring1="Vengeful Ring",ring2="Beeline Ring",
		back="Lupine Cape",feet="Meg. Jam. +2"}	
	sets.defense.PDT = {
        head="Malignance Chapeau",neck="Elite Royal Collar",
        body="Meg. Cuirie +2",hands="Umuthi Gloves",ring1="Defending Ring",ring2="Patricius Ring",
        back="Solemnity Cape",waist="Plat. Mog. Belt",legs="Meg. Chausses +2",feet="Amm Greaves"}

    sets.defense.MDT = set_combine(sets.defense.PDT, {
        head="Malignance Chapeau",neck="Elite Royal Collar",lear="Etiolation Earring",rear="Eabani Earring",
        body="Savas Jawshan",ring1="Defending Ring",ring2="Moonbeam Ring",
		back="Reiki Cloak",waist="Plat. Mog. Belt",feet="Amm Greaves"})
	
    sets.defense.Killer = set_combine(sets.defense.PDT, {body="Nukumi Gausape"})
	
	sets.defense.Reraise = {head="Twilight Helm", body="Twilight Mail"}

	sets.debuffed = set_combine(sets.defense.Evasion,sets.defense.PDT,sets.defense.MDT)
    sets.Kiting = {ammo="Demonry Core",
        neck="Elite Royal Collar",
        ring1="Vengeful Ring",
        waist="Hurch'lan Sash",legs="Iuitl Tights",feet="Skd. Jambeaux +1"}

    --------------------------------------
    -- Custom buff sets
    --------------------------------------

    sets.buff['Killer Instinct'] = {body="Nukumi Gausape"}

    sets.TreasureHunter = {waist="Chaac Belt"}
    -- sets.Assault = {ring2="Ulthalam's Ring"}
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)
    -- Define class for Sic and Ready moves.
	-- add_to_chat(122,'job precast')
	    
    if physical_ready_moves:contains(spell.english) and pet.status == 'Engaged' then
		equip(sets.midcast.Pet.ReadyPhys, sets.midcast.Pet.ReadyRecast)
    end
    if multi_hit_ready_moves:contains(spell.english) and pet.status == 'Engaged' then
		equip(sets.midcast.Pet.ReadyMA, sets.midcast.Pet.ReadyRecast)
    end
    if magic_acc_ready_moves:contains(spell.english) and pet.status == 'Engaged' then
		equip(sets.midcast.Pet.ReadyMacc, sets.midcast.Pet.ReadyRecast)
    end
    if magic_atk_ready_moves:contains(spell.english) and pet.status == 'Engaged' then
		equip(sets.midcast.Pet.ReadyMAB, sets.midcast.Pet.ReadyRecast)
    end
    if pet_buff_moves:contains(spell.english) and pet.status == 'Engaged' then
		equip(sets.midcast.Pet.ReadyBuff, sets.midcast.Pet.ReadyRecast)
    end
	if spell.skill == 'Ninjutsu' then
		-- add_to_chat(1, 'Casting '..spell.name)
        handle_spells(spell)
	end
	check_ws_dist(spell)
end

function job_post_precast(spell, action, spellMap, eventArgs)
    -- If Killer Instinct is active during WS, equip Nukumi Gausape.
    if spell.type:lower() == 'weaponskill' and buffactive['Killer Instinct'] then
        equip(sets.buff['Killer Instinct'])
    end
	if spell.type == 'WeaponSkill' then
        if is_sc_element_today(spell) then
			-- add_to_chat(122,' WS Day ')
            equip(sets.WSDayBonus)
        end
	end 
end



function job_pet_post_midcast(spell, action, spellMap, eventArgs)
    -- Equip monster correlation gear, as appropriate
    equip(sets.midcast.Pet[state.CorrelationMode.value])
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

function job_buff_change(buff, gain)
	handle_debuffs()
    if buff == 'Killer Instinct' then
        handle_equipping_gear(player.status)
    end
end

function job_post_aftercast(spell, action, spellMap, eventArgs)
	-- add_to_chat(7,'post aftercast '..spell.name)
	-- don't do anything after these conditions
	if spell.type == 'Trust' or spell.name == 'Jump' or spell.name == 'Spirit Jump' then
		return
	end
	if spell.type == 'WeaponSkill' then
		delay = 4
	else	
		delay = 1
	end
	if player.sub_job == 'SAM' then
		handle_sam_ja:schedule(delay)
	end
	if player.sub_job == 'WAR' then
		handle_war_ja:schedule(delay)
	end
	handle_pet_ja()
end

function job_pet_aftercast(spell, action, spellMap, eventArgs)
    if pet_buff_moves:contains(spell.name) and DisplayPetBuffTimers == 'true' then
        -- Pet TP calculations for Ready Buff Durations
        local TP_Amount = 1000
        -- if pet_tp < 1000 then TP_Amount = TP_Amount + TP_Gift_Bonus;end
        -- if pet_tp > 1000 then TP_Amount = pet_tp + TP_Gift_Bonus;end
        if player.equipment.hands == "Ferine Manoplas +1" then TP_Amount = TP_Amount + 250;end
        if player.equipment.hands == "Ferine Manoplas +2" then TP_Amount = TP_Amount + 500;end
        if player.equipment.hands == "Nukumi Manoplas" then TP_Amount = TP_Amount + 550;end
        if player.equipment.hands == "Nukumi Manoplas +1" then TP_Amount = TP_Amount + 600;end
        if player.equipment.main == "Aymur" or player.equipment.sub == "Aymur" then TP_Amount = TP_Amount + 500;end
        if player.equipment.main == "Kumbhakarna" then TP_Amount = TP_Amount + TP_Bonus_Main;end
        if player.equipment.sub == "Kumbhakarna" then TP_Amount = TP_Amount + TP_Bonus_Sub;end
        if TP_Amount > 3000 then TP_Amount = 3000;end

        if spell.english == 'Bubble Curtain' then
            local TP_Buff_Duration = math.floor((TP_Amount - 1000)* 0.09) + BubbleCurtainDuration
            send_command('timers c "'..spell.english..'" '..TP_Buff_Duration..' down '..BubbleCurtainIcon..'')
        elseif spell.english == 'Scissor Guard' then
            local TP_Buff_Duration = math.floor(TP_Amount * 0.06)
            send_command('timers c "'..spell.english..'" '..TP_Buff_Duration..' down '..ScissorGuardIcon..'')
        elseif spell.english == 'Secretion' then
            TP_Amount = TP_Amount + 500
            if TP_Amount > 3000 then TP_Amount = 3000;end
            local TP_Buff_Duration = math.floor(TP_Amount * 0.18)
            send_command('timers c "Secretion" '..TP_Buff_Duration..' down '..SecretionIcon..'')
        elseif spell.english == 'Rage' then
            TP_Amount = TP_Amount + 500
            if TP_Amount > 3000 then TP_Amount = 3000;end
            local TP_Buff_Duration = math.floor(TP_Amount * 0.18)
            send_command('timers c "'..spell.english..'" '..TP_Buff_Duration..' down '..RageIcon..'')
        elseif spell.english == 'Rhino Guard' then
            local TP_Buff_Duration = math.floor(TP_Amount * 0.18)
            send_command('timers c "Rhino Guard" '..TP_Buff_Duration..' down '..RhinoGuardIcon..'')
        elseif spell.english == 'Zealous Snort' then
            local TP_Buff_Duration = math.floor(TP_Amount * 0.06)
            send_command('timers c "'..spell.english..'" '..TP_Buff_Duration..' down '..ZealousSnortIcon..'')
        end
    end
end

-- Called when the pet's status changes.
function job_pet_status_change(newStatus, oldStatus)
	if player.status == "Idle" then
		-- add_to_chat(122,'idle midcast')
		equip(customize_idle_set())
	end
end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
	-- add_to_chat(122,"changing state  "..stateField)
    if stateField == 'Reward Mode' then
		if newValue == 'Epsilon' or newValue == 'Gamma' then
			RewardFood.name = "Pet Fd. " .. newValue
		else
			RewardFood.name = "Pet Food " .. newValue
		end
    elseif stateField == 'Weapon Mode' then
		if newValue ~= 'Normal' then
			state.CombatWeapon:set(newValue)
		else
			state.CombatWeapon:reset()
		end
	elseif stateField == 'Sub Mode' then
		if newValue ~= 'Normal' then
			state.CombatForm:set(newValue)
		else
			state.CombatForm:reset()
		end
	end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------
function job_self_command(cmdParams, eventArgs)
	-- add_to_chat(122,'self command')
    if cmdParams[1]:lower() == 'callbeast' then
        handle_callbeast(cmdParams)
        eventArgs.handled = true
    end
end

function get_custom_wsmode(spell, spellMap, defaut_wsmode)
    
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
	if areas.Assault:contains(world.area) then
		meleeSet = set_combine(meleeSet, sets.Assault)
	end

    return meleeSet
end


-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
	-- add_to_chat(122,'job update')
	select_offhand()
	pick_tp_weapon()
end


-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    local msg = 'Melee'
    
    if state.CombatForm.has_value then
        msg = msg .. ' (' .. state.CombatForm.value .. ')'
    end
    
    msg = msg .. ': '
    
    msg = msg .. state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        msg = msg .. '/' .. state.HybridMode.value
    end
    msg = msg .. ', WS: ' .. state.WeaponskillMode.value
    
    if state.DefenseMode.value ~= 'None' then
        msg = msg .. ', ' .. 'Defense: ' .. state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
    end
    
    if state.Kiting.value then
        msg = msg .. ', Kiting'
    end

    msg = msg .. ', Reward: '..state.RewardMode.value..', Correlation: '..state.CorrelationMode.value

    add_to_chat(122, msg)

    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function job_handle_equipping_gear(status, eventArgs)
	-- add_to_chat(122,'handle equiping gear')
	check_tp_lock()
	set_combat_form()
	pick_tp_weapon()
	select_offhand()
	handle_twilight()
end

function select_offhand()
	if state.Stance.value == 'Defensive' then
		-- add_to_chat(122,'bigD')
		gear.Offhand.name = "Astolfo"
	else 
		-- add_to_chat(122,'notD')
		gear.Offhand.name = "Skullrender"
	end
	-- add_to_chat(123,'shuld use'..gear.Offhand.name)
end

function customize_idle_set(idleSet)
	-- add_to_chat(122,'cust idle')
	if not buffactive["Reraise"] then
		idleSet = set_combine(idleSet, sets.defense.Reraise)
	end
    if pet.isvalid then
		-- add_to_chat(122,'pet valid')
        if pet.status == 'Engaged' then
			-- add_to_chat(122,'pet engaged')
			if state.Stance.value == 'Defensive' then
				-- add_to_chat(122,'petD')
				idleSet = set_combine(idleSet, sets.idle.Pet.Defensive)
			else
				-- add_to_chat(122,'petOffense')
				idleSet = set_combine(idleSet, sets.idle.Pet.Offensive)
			end
        end
    end
  
    return idleSet
end

function handle_pet_ja() 
	if not areas.Cities:contains(world.area) and not (buffactive.Sneak or buffactive.Invisible) then
		local abil_recasts = windower.ffxi.get_ability_recasts()
		if not buffactive.Spur and pet.status == 'Engaged' and abil_recasts[45] == 0 then
			add_to_chat(3,'doing spur ') 
			windower.send_command('@input /pet "Spur" <me>')
			return
		end
	end
end


function handle_callbeast(cmdParams)
	-- add_to_chat(1,'Loyalty '..state.loyalty.value)
 	if not cmdParams[2] then
        add_to_chat(123,'Error: No Pet command given.')
        return
    end
    local petcall = cmdParams[2]
	-- add_to_chat(2,'petcall '..petcall)
	if call_beast_items[petcall] ~= nil then
		gear.Broth.name = call_beast_items[petcall]
		-- add_to_chat(3,'broth '..gear.Broth.name)
		if state.loyalty.value == 'true' then
			send_command('input /ja "Bestial Loyalty" <me>')
			add_to_chat(2,'Loyalty on, type //loyalty to turn off and consume jugs')
		else
			send_command('input /ja "Call Beast" <me>')
		end
	else
		add_to_chat(123,'Unknown Pet:'..petcall)
	end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'DNC' then
		set_macro_page(2, 15)
	elseif player.sub_job == 'WAR' then
		set_macro_page(3, 15)
	elseif player.sub_job == 'NIN' then
		set_macro_page(1, 15)
	else
		set_macro_page(1, 15)
	end
	send_command('exec bst.txt')
end

