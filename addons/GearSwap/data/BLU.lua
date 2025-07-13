include('organizer-lib.lua')
-------------------------------------------------------------------------------------------------------------------
-- Initialization function that defines sets and variables to be used.
-------------------------------------------------------------------------------------------------------------------
-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
     
    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

-- Setup vars that are user-independent. state.Buff vars initialized here will automatically be tracked.
function job_setup()
	state.WeaponMode = M{['description']='Weapon Mode', 'Sword', 'Club', 'Staff', 'Polearm', 'Scythe'}
	state.SubMode = M{['description']='Sub Mode', 'DW', 'Shield'}
 	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive'}
	state.holdtp = M{['description']='holdtp', 'false', 'true'}
    
	set_combat_form()
	pick_tp_weapon()

	state.Buff['Burst Affinity'] = buffactive['Burst Affinity'] or false
	state.Buff['Chain Affinity'] = buffactive['Chain Affinity'] or false
	state.Buff.Convergence = buffactive.Convergence or false
	state.Buff.Diffusion = buffactive.Diffusion or false
	state.Buff.Efflux = buffactive.Efflux or false
	state.Buff['Unbridled Learning'] = buffactive['Unbridled Learning'] or false
	
	-- Mappings for gear sets to use for various blue magic spells.
	-- While Str isn't listed for each, it's generally assumed as being at least
	-- moderately signficant, even for spells with other mods.
	-- Physical Spells --
	-- Physical spells with no particular (or known) stat mods
	blue_magic_maps = {}
	blue_magic_maps.Physical = S{
		'Bilgestorm',
		'Heavy Strike'
	}
	-- Spells with heavy accuracy penalties, that need to prioritize accuracy first.
	-- blue_magic_maps.Physical = S{
		-- 'Heavy Strike'
	-- }
	-- Physical spells with Str stat mod
	blue_magic_maps.PhysicalStr = S{
		'Battle Dance','Bloodrake','Death Scissors','Dimensional Death',
		'Empty Thrash','Quadrastrike','Spinal Cleave',
		'Uppercut','Vertical Cleave'
	}
	-- Physical spells with Dex stat mod
	blue_magic_maps.PhysicalDex = S{
		'Amorphic Spikes','Asuran Claws','Barbed Crescent','Claw Cyclone','Disseverment',
		'Foot Kick','Frenetic Rip','Goblin Rush','Hysteric Barrage','Paralyzing Triad',
		'Seedspray','Sickle Slash','Smite of Rage','Terror Touch','Thrashing Assault',
		'Vanity Dive'
	}
	-- Physical spells with Vit stat mod
	blue_magic_maps.PhysicalVit = S{
		'Body Slam','Cannonball','Delta Thrust','Glutinous Dart','Grand Slam',
		'Power Attack','Quad. Continuum','Sprout Smack','Sub-zero Smash'
	}
	-- Physical spells with Agi stat mod
	blue_magic_maps.PhysicalAgi = S{
		'Benthic Typhoon','Feather Storm','Helldive','Hydro Shot','Jet Stream',
		'Pinecone Bomb','Spiral Spin','Wild Oats'
	}
	-- Physical spells with Int stat mod
	blue_magic_maps.PhysicalInt = S{
		'Mandibular Bite','Queasyshroom'
	}
	-- Physical spells with Mnd stat mod
	blue_magic_maps.PhysicalMnd = S{
		'Ram Charge','Screwdriver','Tourbillion'
	}
	-- Physical spells with Chr stat mod
	blue_magic_maps.PhysicalChr = S{
		'Bludgeon'
	}
	-- Physical spells with HP stat mod
	blue_magic_maps.PhysicalHP = S{
		'Final Sting'
	}
	-- Magical Spells --
	-- Magical spells with the typical Int mod
	blue_magic_maps.Magical = S{
		'Blastbomb','Blazing Bound','Bomb Toss','Cursed Sphere','Dark Orb','Death Ray','Scouring Spate','Searing Tempest','Nectarous Deluge',
		'Diffusion Ray','Droning Whirlwind','Embalming Earth','Firespit','Foul Waters','Tenebral Crush','Atramentous Libations',
		'Ice Break','Leafstorm','Maelstrom','Rail Cannon','Regurgitation','Rending Deluge','Entomb','Anvil Lightning','Molting Plumage',
		'Retinal Glare','Tem. Upheaval','Water Bomb','Palling Salvo','Silent Storm','Spectral floe','Blinding Fulgor'
	}
	blue_magic_maps.MagicalDmg = S{
		'Subduction'
	}
	-- Magical spells with a primary Mnd mod
	blue_magic_maps.MagicalMnd = S{
		'Acrid Stream','Evryone. Grudge','Magic Hammer','Mind Blast'
	}
	-- Magical spells with a primary Chr mod
	blue_magic_maps.MagicalChr = S{
		'Eyes On Me','Mysterious Light'
	}
	-- Magical spells with a Vit stat mod (on top of Int)
	blue_magic_maps.MagicalVit = S{
		'Thermal Pulse'
	}
	-- Magical spells with a Dex stat mod (on top of Int)
	blue_magic_maps.MagicalDex = S{
		'Charged Whisker','Gates of Hades'
	}
	-- Magical spells (generally debuffs) that we want to focus on magic accuracy over damage.
	-- Add Int for damage where available, though.
	blue_magic_maps.MagicAccuracy = S{
		'1000 Needles','Absolute Terror','Actinic Burst','Auroral Drape','Awful Eye',
		'Blank Gaze','Blistering Roar','Blood Drain','Blood Saber','Chaotic Eye',
		'Cimicine Discharge','Cold Wave','Corrosive Ooze','Demoralizing Roar','Digest',
		'Dream Flower','Enervation','Feather Tickle','Filamented Hold','Frightful Roar',
		'Geist Wall','Hecatomb Wave','Infrasonics','Jettatura','Light of Penance',
		'Lowing','Mind Blast','Mortal Ray','MP Drainkiss','Osmosis','Reaving Wind',
		'Sandspin','Sandspray','Sheep Song','Soporific','Sound Blast','Stinking Gas',
		'Sub-zero Smash','Venom Shell','Voracious Trunk','Yawn'
	}
	-- Breath-based spells
	blue_magic_maps.Breath = S{
		'Bad Breath','Flying Hip Press','Frost Breath','Heat Breath',
		'Hecatomb Wave','Magnetite Cloud','Poison Breath','Radiant Breath','Self-Destruct',
		'Thunder Breath','Vapor Spray','Wind Breath'
	}
	-- Stun spells
	blue_magic_maps.Stun = S{
		'Blitzstrahl','Frypan','Head Butt','Sudden Lunge','Tail slap','Temporal Shift',
		'Thunderbolt','Whirl of Rage'
	}
	-- Healing spells
	blue_magic_maps.Healing = S{
		'Healing Breeze','Magic Fruit','Plenilune Embrace','Pollen','White Wind',
		'Wild Carrot'
	}
	-- Buffs that depend on blue magic skill
	blue_magic_maps.SkillBasedBuff = S{
		'Barrier Tusk','Diamondhide','Magic Barrier','Metallic Body','Plasma Charge',
		'Pyric Bulwark','Reactor Cool'
	}
	-- Other general buffs
	blue_magic_maps.Buff = S{
		'Amplification','Animating Wail','Battery Charge','Carcharian Verve','Cocoon',
		'Erratic Flutter','Exuviation','Fantod','Feather Barrier','Harden Shell',
		'Memento Mori','Nat. Meditation','Occultation','Orcish Counterstance','Refueling',
		'Regeneration','Saline Coat','Triumphant Roar','Warm-Up','Winds of Promyvion',
		'Zephyr Mantle'
	}
	-- Spells that require Unbridled Learning to cast.
	unbridled_spells = S{
		'Absolute Terror','Bilgestorm','Blistering Roar','Bloodrake','Carcharian Verve','Cesspool','Cruel Joke',
		'Droning Whirlwind','Gates of Hades','Harden Shell','Mighty Guard','Pyric Bulwark','Tearing Gust','Thunderbolt',
		'Tourbillion'
	}
    
	include('Mote-TreasureHunter')
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job. Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------
-- Setup vars that are user-dependent. Can override this function in a sidecar file.
function user_setup()
	-- add_to_chat(122,'user setup')
	-- Options: Override default values
	state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'SB', 'sTP', 'STR', 'Learning')
	state.WeaponskillMode:options('Normal')
	state.CastingMode:options('Normal')
	state.IdleMode:options('Normal', 'Learning')
	state.WeaponMode:set('Sword')
	state.SubMode:set('DW')
	state.TreasureMode:set('Tag')
	state.DefenseMode:options('None', 'Physical', 'Magical')
	state.PhysicalDefenseMode:options('PDT', 'Evasion')
	state.MagicalDefenseMode:options('MDT')
	state.Stance:set('None')
	state.holdtp:set('false')
    gear.hercTH = { name="Herculean Helm", augments={'Attack+13','"Snapshot"+3','"Treasure Hunter"+1','Accuracy+5 Attack+5',}}
    gear.hercAcc = { name="Herculean Helm", augments={'Accuracy+29','STR+6','Attack+3',}}

	select_default_macro_book()
	send_command('bind ^= gs c cycle treasuremode')
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	if binds_on_unload then
        binds_on_unload()
    end
 
    send_command('unbind ^`')
    send_command('unbind !-')
end

-- Set up gear sets.
function init_gear_sets()
	-- add_to_chat(122,'init gear sets')
    gear.hercTH = { name="Herculean Helm", augments={'Attack+13','"Snapshot"+3','"Treasure Hunter"+1','Accuracy+5 Attack+5',}}
    gear.hercAcc = { name="Herculean Helm", augments={'Accuracy+29','STR+6','Attack+3',}}
	--------------------------------------
	-- Start defining the sets
	--------------------------------------
	-- extra stuff
	organizer_items = {
        new1="",
		new2="",
		new3="",
		new4="",
		new5="",
		new6="",
		new7="",
		new8="",
		new9="",
		food="Squid Sushi",
		food1="Sublime Sushi",
		food2="Pear Crepe",
		food3="Tropical Crepe",
		echos="Echo Drops",
		shihei="Shihei",
		orb="Macrocosmic Orb"
	}	
	-- Sets to return to when not performing an action.
	sets.Learning = {ammo="Mavi Tathlum",
		head="Luh. Keffiyeh +1",neck="Incanter's Torque",
		body="Assim. Jubbah +3",hands="Assim. Bazu. +1",ring1="Defending Ring",ring2="Renaye Ring +1",
		back="Cornflower Cape",legs="Hashishin Tayt +2",feet="Luhlaza Charuqs +1"}
   
	-- Idle sets
	sets.idle = {ammo="Amar Cluster",
		head="Rawhide Mask",neck="Elite Royal Collar",lear="Moonshade Earring",rear="Ethereal Earring",
		body="Hashishin Mintan +2",hands="Hashi. Bazu. +2",ring1="Defending Ring",ring2="Renaye Ring +1",
		back="Solemnity Cape",waist="Plat. Mog. Belt",legs="Carmine Cuisses +1",feet="Aya. Gambieras +2"}

	-- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
	sets.idle.Learning = set_combine(sets.idle, sets.Learning)

	-- Resting sets
	sets.resting = set_combine(sets.idle, {})

	-- Engaged sets
	-- Variations for TP weapon and (optional) offense/defense modes. Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion
	-- Normal melee group
	sets.engaged = {ammo="Mantoptera Eye",
		head="Hashishin Kavuk +2",neck="Combatant's Torque",lear="Odr Earring",rear="Eabani Earring",
		body="Hashishin Mintan +2",hands="Herculean Gloves",ring1="Epona's Ring",ring2="Hetairoi Ring",
		back="Atheling Mantle",waist="Sarissapho. Belt",legs="Hashishin Tayt +2",feet="Herculean Boots"}

	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {ammo="Mantoptera Eye",
			head="Hashishin Kavuk +2",neck="Combatant's Torque",lear="Zennaroi Earring",rear="Hashishin Earring",
			body="Hashishin Mintan +2",hands="Aya. Manopolas +2",ring1="Mars's Ring",ring2="Cacoethic Ring +1",
			back="Rosmerta's Cape",waist="Olseni Belt",legs="Carmine Cuisses +1",feet="Aya. Gambieras +2"})
	sets.Mode.Att= set_combine(sets.engaged, {
			head="Hashishin Kavuk +2",neck="Rep. Plat. Medal",lear="Bladeborn Earring",rear="Dudgeon Earring",
			body="Hashishin Mintan +2",hands="Jhakri Cuffs +2",ring1="Overbearing Ring",ring2="Cho'j Band",
			back="Phalangite Mantle",waist="Sulla Belt",legs="Jhakri Slops +2",feet="Jhakri Pigaches +2"})
	sets.Mode.Crit = set_combine(sets.engaged, {
			head="Adhemar Bonnet",lear="Odr Earring",
			body="Sayadio's Kaftan",hands="Herculean Gloves",ring2="Hetairoi Ring",
			feet="Thereoid Greaves"})
	sets.Mode.DA = set_combine(sets.engaged, {
			head="Adhemar Bonnet",neck="Asperity Necklace",lear="Trux Earring",rear="Brutal Earring",
			body="Ayanmo Corazza +2",hands="Herculean Gloves",ring1="Epona's Ring",ring2="Hetairoi Ring",
			back="Atheling Mantle",waist="Sarissapho. Belt",legs="Zoar Subligar",feet="Herculean Boots"})
	sets.Mode.SB = set_combine(sets.engaged, {})
	sets.Mode.sTP = set_combine(sets.engaged, { ammo="Ginsen",
			head="Malignance Chapeau",neck="Combatant's Torque",lear="Enervating Earring",rear="Digni. Earring",
			body="Herculean Vest",ring1="Rajas Ring",ring2="K'ayres Ring",
			waist="Yemaya Belt",legs="Jhakri Slops +2",feet="Battlecast Gaiters"})
	sets.Mode.STR = set_combine(sets.engaged, {ammo="Mantoptera Eye",
			head="Jhakri Coronal +2",neck="Rep. Plat. Medal",
			body="Assim. Jubbah +3",hands="Herculean Gloves",ring1="Rajas Ring",ring2="Apate Ring",
			back="Buquwik Cape",waist="Sailfi Belt +1",legs="Jhakri Slops +2",feet="Jhakri Pigaches +2"})

	-- other Sets    
	sets.macc = {ammo="Pemphredo Tathlum",
		head="Hashishin Kavuk +2",neck="Erra Pendant",lear="Digni. Earring",rear="Gwati Earring",
		body="Hashishin Mintan +2",hands="Jhakri Cuffs +2",ring1="Sangoma Ring",ring2="Metamor. Ring +1",
		back="Cornflower Cape",waist="Luminary Sash",legs="Jhakri Slops +2",feet="Jhakri Pigaches +2"}
	sets.PDL = {head="Malignance Chapeau"}
	sets.empy = {head="Hashishin Kavuk +2",
		body="Hashishin Mintan +2",hands="Hashi. Bazu. +2",
		legs="Hashishin Tayt +2",feet="Hashi. Basmak +1"}

	-- Sets with weapons defined.
 	sets.engaged.Club = {}
	sets.engaged.Sword = {}
	sets.engaged.DW = set_combine(sets.engaged, {})
	sets.engaged.Shield = set_combine(sets.engaged, {})
	sets.engaged.DW.Sword = set_combine(sets.engaged, {main="Naegling",sub="Sakpata's Sword"})
	sets.engaged.Shield.Sword = set_combine(sets.engaged, {main="Caliburnus",sub="Genmei Shield",lear="Digni. Earring",rear="Hashishin Earring"})
	sets.engaged.DW.Sword.Acc = set_combine(sets.engaged.DW.Sword, sets.Mode.Acc)
	sets.engaged.DW.Sword.Att = set_combine(sets.engaged.DW.Sword, sets.Mode.Att)
	sets.engaged.DW.Sword.Crit = set_combine(sets.engaged.DW.Sword, sets.Mode.Crit)
	sets.engaged.DW.Sword.DA = set_combine(sets.engaged.DW.Sword, sets.Mode.DA)
	sets.engaged.DW.Sword.SB = set_combine(sets.engaged.DW.Sword, {})
	sets.engaged.DW.Sword.sTP = set_combine(sets.engaged.DW.Sword, sets.Mode.sTP)
	sets.engaged.DW.Sword.STR = set_combine(sets.engaged.DW.Sword, sets.Mode.STR)
	sets.engaged.DW.Sword.Learning = set_combine(sets.engaged.DW.Sword, sets.Learning)
	sets.engaged.Shield.Sword.Acc = set_combine(sets.engaged.Shield.Sword, sets.Mode.Acc)
	sets.engaged.Shield.Sword.Att = set_combine(sets.engaged.Shield.Sword, sets.Mode.Att)
	sets.engaged.Shield.Sword.Crit = set_combine(sets.engaged.Shield.Sword, sets.Mode.Crit)
	sets.engaged.Shield.Sword.DA = set_combine(sets.engaged.Shield.Sword, sets.Mode.DA)
	sets.engaged.Shield.Sword.SB = set_combine(sets.engaged.Shield.Sword, {})
	sets.engaged.Shield.Sword.sTP = set_combine(sets.engaged.Shield.Sword, sets.Mode.sTP)
	sets.engaged.Shield.Sword.STR = set_combine(sets.engaged.Shield.Sword, sets.Mode.STR)
	sets.engaged.Shield.Sword.Learning = set_combine(sets.engaged.Shield.Sword, sets.Learning)
	sets.engaged.DW.Club = set_combine(sets.engaged, {main="Septoptic",sub="Iris"})
	sets.engaged.Shield.Club = set_combine(sets.engaged, {main="Tamaxchi",sub="Genmei Shield"})
	sets.engaged.DW.Club.Acc = set_combine(sets.engaged.DW.Club, sets.Mode.Acc)
	sets.engaged.Shield.Club.Acc = set_combine(sets.engaged.Shield.Club, sets.Mode.Acc)
	sets.engaged.DW.Staff = set_combine(sets.engaged, {main="Gozuki Mezuki",sub="Bloodrain Strap"})
	sets.engaged.Shield.Staff = set_combine(sets.engaged, {main="Gozuki Mezuki",sub="Bloodrain Strap"})
	sets.engaged.DW.Staff.Acc = set_combine(sets.engaged.DW.Staff, sets.Mode.Acc, {})
	sets.engaged.Shield.Staff.Acc = set_combine(sets.engaged.Shield.Staff, sets.Mode.Acc, {})
	sets.engaged.DW.Polearm = set_combine(sets.engaged, {main="Pitchfork +1",sub="Bloodrain Strap"})
	sets.engaged.Shield.Polearm = set_combine(sets.engaged, {main="Pitchfork +1",sub="Bloodrain Strap"})
	sets.engaged.DW.Polearm.Acc = set_combine(sets.engaged.DW.Polearm, sets.Mode.Acc)
	sets.engaged.Shield.Polearm.Acc = set_combine(sets.engaged.Shield.Polearm, sets.Mode.Acc)
	sets.engaged.DW.Scythe = set_combine(sets.engaged, {main="Ark Scythe",sub="Bloodrain Strap"})
	sets.engaged.Shield.Scythe = set_combine(sets.engaged, {main="Ark Scythe",sub="Bloodrain Strap"})
	sets.engaged.DW.Scythe.Acc = set_combine(sets.engaged.DW.Polearm, sets.Mode.Acc)
	sets.engaged.Shield.Scythe.Acc = set_combine(sets.engaged.Shield.Polearm, sets.Mode.Acc)

	sets.engaged.DEX = {
		head="Malignance Chapeau",neck="Love Torque",lear="Odr Earring",
		body="Ayanmo Corazza +2",hands="Aya. Manopolas +2",ring1="Rajas Ring",ring2="Apate Ring",
		back="Rosmerta's Cape",waist="Wanion Belt",legs="Gyve Trousers",feet="Aya. Gambieras +2"}
	sets.engaged.AGI = {
		head="Malignance Chapeau",lear="Infused Earring",rear="Suppanomimi",
		body="Sayadio's Kaftan",hands="Iuitl Wristbands",ring2="Apate Ring",
		back="Lupine Cape",legs="Aya. Cosciales +2",feet="Aya. Gambieras +2"}
	sets.engaged.Physical = {ammo="Mavi Tathlum",
		head="Jhakri Coronal +2",neck="Mavi Scarf",lear="Mavi Earring",
		body="Assim. Jubbah +3",hands="Jhakri Cuffs +2",ring1="Rajas Ring",ring2="Apate Ring",
		back="Cornflower Cape",waist="Wanion Belt",legs="Hashishin Tayt +2",feet="Assim. Charuqs +1"}
	sets.engaged.MAB = { ammo="Pemphredo Tathlum",
		head="Hashishin Kavuk +2",neck="Baetyl Pendant",lear="Friomisi Earring",rear="Crematio Earring",
		body="Hashishin Mintan +2",hands="Jhakri Cuffs +2",ring1="Strendu Ring",
		back="Cornflower Cape",waist="Eschan Stone",legs="Jhakri Slops +2",feet="Jhakri Pigaches +2"}
	sets.engaged.BlueSkill = set_combine(sets.macc, {ammo="Mavi Tathlum",
		head="Luh. Keffiyeh +1",neck="Incanter's Torque",lear="Mavi Earring",rear="Hashishin Earring",
		body="Assim. Jubbah +3",hands="Ayao's Gages",ring2="Renaye Ring +1",
		back="Cornflower Cape",legs="Hashishin Tayt +2",feet="Luhlaza Charuqs +1"})
	sets.engaged.Learning = set_combine(sets.engaged, sets.Learning)
	sets.self_healing = {neck="Phalaina Locket",hands="Buremte Gloves"}
	
	-- Precast Sets
	sets.buff['Burst Affinity'] = {feet="Hashi. Basmak +1"}
	sets.buff['Chain Affinity'] = {head="Hashishin Kavuk +2", feet="Assim. Charuqs +1"}
	sets.buff.Convergence = {head="Luh. Keffiyeh +1"}
	sets.buff.Diffusion = {feet="Luhlaza Charuqs +1"}
	sets.buff.Enchainment = {body="Luhlaza Jubbah"}
	sets.buff.Efflux = {back="Rosmerta's Cape",legs="Hashishin Tayt +2"}
	-- Precast sets to enhance JAs
	sets.precast.JA['Azure Lore'] = {hands="Luhlaza Bazubands"}
	-- Waltz set (chr and vit)
	sets.precast.Waltz = {
		head="Hashishin Kavuk +2",
		body="Passion Jacket",hands="Jhakri Cuffs +2",
		legs="Hashishin Tayt +2",feet="Hippomenes Socks"}
	-- Don't need any special gear for Healing Waltz.
	sets.precast.Waltz['Healing Waltz'] = {}
	-- Fast cast sets for spells
	sets.precast.FC = {
		head=gear.hercAcc,neck="Orunmila's Torque",lear="Etiolation Earring",
		body="Luhlaza Jubbah",hands="Leyline Gloves",ring1="Kishar Ring",ring2="Prolix Ring",
		back="Perimede Cape",legs="Psycloth Lappas"}
	sets.precast.FC['Blue Magic'] = set_combine(sets.precast.FC, {body="Hashishin Mintan +2",hands="Hashi. Bazu. +2"})

    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	sets.precast.WS = set_combine(sets.Mode.STR, {ammo="Oshasha's Treatise",
		head="Hashishin Kavuk +2",neck="Fotia Gorget",rear="Ishvara Earring",
        body="Assim. Jubbah +3",hands="Jhakri Cuffs +2",ring1="Cornelia's Ring",ring2="Epaminondas's Ring",
        back="Rosmerta's Cape",waist="Fotia Belt"})

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	-- Earth, STR 40% DEX 40%
	sets.precast.WS['Fast Blade'] = set_combine(sets.precast.WS, {})

	-- Fire, STR 40% INT 40%
	sets.precast.WS['Burning Blade'] = set_combine(sets.precast.WS, {})

	-- Fire/Wind, STR 40% INT 40%
	sets.precast.WS['Red Lotus Blade'] = set_combine(sets.precast.WS, {})

	-- Thunder, STR 100%
	sets.precast.WS['Flat Blade'] = set_combine(sets.precast.WS, {})

	-- Earth, STR 40% MND 40%
	sets.precast.WS['Shining Blade'] = set_combine(sets.precast.WS, {})

	-- Earth, STR 40% MND 40%
	sets.precast.WS['Seraph Blade'] = set_combine(sets.precast.WS, {})

	-- Water/Thunder, STR 100%
	sets.precast.WS['Circle Blade'] = set_combine(sets.precast.WS, {})

	-- HP
	sets.precast.WS['Spirits Within'] = set_combine(sets.precast.WS, {})

	-- Earth/Thunder, STR 60%
	sets.precast.WS['Vorpal Blade'] = set_combine(sets.precast.WS, sets.Mode.Crit, {body="Assim. Jubbah +3"})

	-- Earth/Thunder/Wind, STR 50% MND 50%
	sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {})

	-- dark?, STR 30% MND 50% - use MAB
	sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS, sets.engaged.MAB)

	-- Dark/Earth, MND 73%
	sets.precast.WS['Rquiescat'] = set_combine(sets.precast.WS, {})
	
	-- Light/Water/Ice, DEX 80%
	sets.precast.WS['Chant du Cygne'] = set_combine(sets.engaged.DEX, sets.precast.WS, {})

	-- Earth/Water/Ice, STR 30% DEX 20% INT 30%
	sets.precast.WS['Expiacion'] = set_combine(sets.precast.WS, {})

	-- Dark/Water, STR 40% MND 40% 
	sets.precast.WS['Sunburst'] = set_combine(sets.precast.WS, {})

	-- Midcast Sets
	-- sets.midcast.FastRecast = {body="Luhlaza Jubbah",hands="Hashi. Bazu. +2",legs="Homam Cosciales"}
	sets.midcast['Blue Magic'] = set_combine(sets.engaged.BlueSkill, {})
	-- Physical Spells --
	sets.midcast['Blue Magic'].Physical = set_combine(sets.engaged.Physical, sets.midcast['Blue Magic'])
	sets.midcast['Blue Magic'].PhysicalStr = set_combine(sets.midcast['Blue Magic'].Physical,
		sets.Mode.STR)
	sets.midcast['Blue Magic'].PhysicalDex = set_combine(sets.midcast['Blue Magic'].Physical,
		sets.engaged.DEX)
	sets.midcast['Blue Magic'].PhysicalVit = set_combine(sets.midcast['Blue Magic'].Physical,
		{hands="Assim. Bazu. +1"})
	sets.midcast['Blue Magic'].PhysicalAgi = set_combine(sets.midcast['Blue Magic'].Physical,
		sets.engaged.AGI)
	sets.midcast['Blue Magic'].PhysicalInt = set_combine(sets.midcast['Blue Magic'].Physical,
		{lear="Psystorm Earring",
		body="Hashishin Mintan +2",hands="Assim. Bazu. +1",
		waist="Wanion Belt",back="Toro Cape",legs="Miasmic Pants",feet="Battlecast Gaiters"})
	sets.midcast['Blue Magic'].PhysicalMnd = set_combine(sets.midcast['Blue Magic'].Physical,
		{lear="Lifestorm Earring",
		body="Hashishin Mintan +2",hands="Assim. Bazu. +1",
		back="Pahtli Cape",legs="Feast Hose"})
	sets.midcast['Blue Magic'].PhysicalChr = set_combine(sets.midcast['Blue Magic'].Physical,
		{hands="Assim. Bazu. +1",back="Kumbira Cape",
		waist="Chaac Belt",legs="Feast Hose"})
	sets.midcast['Blue Magic'].PhysicalHP = set_combine(sets.midcast['Blue Magic'].Physical,{})
	-- Magical Spells --
	sets.midcast['Blue Magic'].Magical = set_combine(sets.engaged.BlueSkill, sets.engaged.MAB)
	sets.midcast['Blue Magic'].Magical.Resistant = set_combine(sets.midcast['Blue Magic'].Magical,
		{legs="Miasmic Pants",feet="Hashi. Basmak +1"})
	sets.midcast['Blue Magic'].MagicalMnd = set_combine(sets.midcast['Blue Magic'].Magical, {ring1="Metamor. Ring +1", ring2="Perception Ring"})
	sets.midcast['Blue Magic'].MagicalChr = set_combine(sets.midcast['Blue Magic'].Magical, {ring1="Metamor. Ring +1"})
	sets.midcast['Blue Magic'].MagicalVit = set_combine(sets.midcast['Blue Magic'].Magical, {})
	sets.midcast['Blue Magic'].MagicalDex = set_combine(sets.midcast['Blue Magic'].Magical, {})
	sets.midcast['Blue Magic'].MagicAccuracy = set_combine(sets.midcast['Blue Magic'].Magical, sets.engaged.Macc)
	sets.midcast['Blue Magic'].MagicalDmg = set_combine(sets.midcast['Blue Magic'].Magical, {ammo="Ghastly Tathlum +1"})
	-- Breath Spells --
	sets.midcast['Blue Magic'].Breath = {ammo="Mavi Tathlum",
		head="Luh. Keffiyeh +1",lear="Lifestorm Earring",rear="Psystorm Earring",
		body="Assim. Jubbah +3",hands="Hashi. Bazu. +2",
		back="Cornflower Cape",waist="Glassblower's Belt",legs="Hashishin Tayt +2",feet="Hashi. Basmak +1"}
	-- Other Types --
	sets.midcast['Blue Magic'].Stun = set_combine(sets.midcast['Blue Magic'].MagicAccuracy,
		{waist="Chaac Belt"})
	sets.midcast['Blue Magic']['White Wind'] = {
		neck="Phalaina Locket",
		hands="Buremte Gloves",ring1="K'ayres Ring",
		legs="Carmine Cuisses +1",feet="Battlecast Gaiters"}
	sets.midcast['Blue Magic'].Healing = {
		lear="Lifestorm Earring",
		hands="Telchine Gloves",
		back="Solemnity Cape",legs="Carmine Cuisses +1",feet="Battlecast Gaiters"}
	sets.midcast['Blue Magic'].SkillBasedBuff = set_combine(sets.engaged.BlueSkill, {})
	sets.midcast['Blue Magic']['Battery Charge'] = set_combine(sets.engaged.BlueSkill, {back="Grapevine Cape"})
	sets.midcast['Blue Magic'].Buff = {}
	
	-- healing skill
    sets.midcast.StatusRemoval = {neck="Incanter's Torque",ring1="Ephedra Ring"}

	-- Cure %+ > healing skill > MND
    sets.midcast.Cure = set_combine(sets.midcast.StatusRemoval, {
        neck="Phalaina Locket",
        body="Vrikodara Jupon",hands="Telchine Gloves",ring1="Naji's Loop",ring2="Lebeche Ring",
        back="Solemnity Cape",legs="Gyve Trousers",feet="Medium's Sabots"})

	-- Sets to return to when not performing an action.
	-- Gear for learning spells: +skill and AF hands.
	sets.latent_refresh = {waist="Fucho-no-obi"}
	-- Defense sets
	sets.defense.Evasion = {
		head="Malignance Chapeau",lear="Infused Earring",rear="Eabani Earring",
		body="Hashishin Mintan +2",hands="Herculean Gloves",ring1="Vengeful Ring",ring2="Beeline Ring",
		back="Lupine Cape",legs="Herculean Trousers",feet="Ahosi Leggings"}
	sets.defense.PDT = {
		head="Malignance Chapeau",neck="Elite Royal Collar",
		body="Hashishin Mintan +2",hands="Hashi. Bazu. +2",ring1="Defending Ring",ring2="Patricius Ring",
		back="Solemnity Cape",waist="Plat. Mog. Belt",legs="Aya. Cosciales +2",feet="Ahosi Leggings"}
	sets.defense.MDT = {
		head="Malignance Chapeau",neck="Elite Royal Collar",lear="Etiolation Earring",rear="Eabani Earring",
		body="Hashishin Mintan +2",hands="Hashi. Bazu. +2",ring1="Defending Ring",ring2="Moonbeam Ring",
		back="Reiki Cloak",waist="Plat. Mog. Belt",legs="Aya. Cosciales +2",feet="Aya. Gambieras +2"}
	sets.debuffed = set_combine(sets.defense.Evasion,sets.defense.PDT, sets.defense.MDT)
	sets.doom = set_combine(sets.debuffed,{waist="Gishdubar Sash"})
    sets.Kiting = {legs="Carmine Cuisses +1"}
	sets.TreasureHunter = {ammo="Per. Lucky Egg", head=gear.hercTH, waist="Chaac Belt"}
    
	-- These sets use a piece of gear in specific situations, need to customize_idle_set or customize_melee_set
	sets.Reive = {neck="Arciela's Grace +1"}
	sets.Assault = {ring2="Ulthalam's Ring"}
	
	sets.buff.FullSublimation = {waist="Embla Sash"}
    sets.buff.PDTSublimation = set_combine(sets.buff.FullSublimation,{})
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
	-- if unbridled_spells:contains(spell.english) and not (state.Buff['Unbridled Learning'] or state.Buff['Unbridled Wisdom']) then
		-- eventArgs.cancel = true
		-- windower.send_command('@input /ja "Unbridled Learning" <me>; wait 1.5; input /ma "'..spell.name..'" '..spell.target.name)
	-- end
	if spell.skill == 'Ninjutsu' then
		-- add_to_chat(1, 'Casting '..spell.name)
        handle_spells(spell)
    end
	check_ws_dist(spell)
end
-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
	-- Add enhancement gear for Chain Affinity, etc.
	if spell.skill == 'Blue Magic' then
		for buff,active in pairs(state.Buff) do
			if active and sets.buff[buff] then
				equip(sets.buff[buff])
			end
		end
		if spellMap == 'Healing' and spell.target.type == 'SELF' and sets.self_healing then
			equip(sets.self_healing)
		end
	end
	-- If in learning mode, keep on gear intended to help with that, regardless of action.
	if state.OffenseMode == 'Learning' then
		equip(sets.Learning)
	end
end

-- Run after the default aftercast() is done.
-- eventArgs is the same one used in job_aftercast, in case information needs to be persisted.
function job_post_aftercast(spell, action, spellMap, eventArgs)
	-- add_to_chat(7,'post aftercast '..spell.name)
	-- don't do anything after these conditions
	if spell.type == 'Trust' then
		return
	end
	if spell.type == 'WeaponSkill' then
		delay = 4
	else	
		delay = 1
	end
	if player.sub_job == 'WAR' then
		handle_war_ja:schedule(delay)
	end
end
 
-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------
-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
	handle_debuffs()
	if state.Buff[buff] ~= nil then
		state.Buff[buff] = gain
	end
end

function job_handle_equipping_gear(status, eventArgs)
	-- add_to_chat(122,'handle equiping gear')
	check_tp_lock()
	pick_tp_weapon()
end
-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------
-- Custom spell mapping.
-- Return custom spellMap value that can override the default spell mapping.
-- Don't return anything to allow default spell mapping to be used.
function job_get_spell_map(spell, default_spell_map)
	if spell.skill == 'Blue Magic' then
		for category,spell_list in pairs(blue_magic_maps) do
			if spell_list:contains(spell.english) then
				return category
			end
		end
	end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
	-- add_to_chat(122,'customize idle set')
	if buffactive['reive mark'] then
		-- add_to_chat(122,'reive')
		idleSet = set_combine(idleSet, sets.Reive )
		-- add_to_chat(123,'idle set1: '..idleSet["neck"])
	end
	if player.mpp < 51 then
		idleSet =  set_combine(idleSet, sets.latent_refresh)
	end
	-- add_to_chat(123,'idle set2: '..idleSet["neck"])
	return idleSet
end

function customize_melee_set(meleeSet)
	-- add_to_chat(122,'customize melee set')
	if areas.Assault:contains(world.area) then
		meleeSet = set_combine(meleeSet, sets.Assault)
	end
    return meleeSet
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
	local dwString = ''
	if state.CombatForm == 'DW' then
		dwString = ' (DW)'
	end
	local defenseString = ''
	if state.Defense.Active then
		local defMode = state.Defense.PhysicalMode
		if state.Defense.Type == 'Magical' then
			defMode = state.Defense.MagicalMode
		end
		defenseString = 'Defense: '..state.Defense.Type..' '..defMode..', '
	end
	local pcTarget = ''
	if state.PCTargetMode ~= 'default' then
		pcTarget = ', Target PC: '..state.PCTargetMode
	end
	local npcTarget = ''
	if state.SelectNPCTargets then
		pcTarget = ', Target NPCs'
	end
	add_to_chat(122,'Melee'..dwString..': '..state.OffenseMode..'/'..state.DefenseMode..', WS: '..state.WeaponskillMode..', '..defenseString..
	'Kiting: '..on_off_names[state.Kiting]..pcTarget..npcTarget)
	eventArgs.handled = true
	if stateField == 'Weapon Mode' then
		if newValue ~= 'Normal' then
			state.CombatWeapon:set(newValue)
		else
			state.CombatWeapon:reset()
		end
	end
	if stateField == 'Sub Mode' then
		if newValue ~= 'Normal' then
			state.CombatForm:set(newValue)
		else
			state.CombatForm:reset()
		end
	end
end
-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------
-- Handle notifications of user state values being changed.
function job_state_change(stateField, newValue, oldValue)
	-- add_to_chat(121,' job state change ')
	if stateField == 'Weapon Mode' then
		if newValue ~= 'Normal' then
			state.CombatWeapon:set(newValue)
		else
			state.CombatWeapon:reset()
		end
	end
	if stateField == 'Sub Mode' then
		if newValue ~= 'Normal' then
			state.CombatForm:set(newValue)
		else
			state.CombatForm:reset()
		end
	end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'DNC' then
		set_macro_page(2, 3)
	else
		set_macro_page(1, 3)
	end
	send_command('exec blu.txt')
end