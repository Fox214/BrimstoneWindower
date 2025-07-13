include('organizer-lib.lua')
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    Custom commands:

    gs c cycle treasuremode (set on ctrl-= by default): Cycles through the available treasure hunter modes.
    
    Treasure hunter modes:
        None - Will never equip TH gear
        Tag - Will equip TH gear sufficient for initial contact with a mob (either melee, ranged hit, or Aeolian Edge AOE)
        SATA - Will equip TH gear sufficient for initial contact with a mob, and when using SATA
        Fulltime - Will keep TH gear equipped fulltime

--]]

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
	state.WeaponMode = M{['description']='Weapon Mode', 'Dagger', 'Sword', 'Club', 'H2H', 'Staff', 'Polearm', 'Scythe'}
	state.SubMode = M{['description']='Sub Mode', 'DW', 'Shield', 'TH'}
	state.RWeaponMode = M{['description']='RWeapon Mode', 'Stats', 'Xbow', 'Boomerrang'}
 	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive'}
	set_combat_form()
	pick_tp_weapon()

    state.Buff['Sneak Attack'] = buffactive['sneak attack'] or false
    state.Buff['Trick Attack'] = buffactive['trick attack'] or false
    state.Buff['Feint'] = buffactive['feint'] or false
    
    include('Mote-TreasureHunter')

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'SB', 'sTP', 'STR')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal')
	state.WeaponMode:set('Dagger')
	state.SubMode:set('DW')
	state.RWeaponMode:set('Boomerrang') 
	state.DefenseMode:options('None', 'Physical', 'Magical')
	state.PhysicalDefenseMode:options('PDT', 'Evasion')
	state.MagicalDefenseMode:options('MDT')
	state.Stance:set('None')

    gear.hercTH = { name="Herculean Helm", augments={'Attack+13','"Snapshot"+3','"Treasure Hunter"+1','Accuracy+5 Attack+5',}}
    gear.hercAcc = { name="Herculean Helm", augments={'Accuracy+29','STR+6','Attack+3',}}

    -- Additional local binds
    -- send_command('bind ^` input /ja "Flee" <me>')
    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind !- gs c cycle targetmode')

    select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !-')
end

-- Define sets and vars used by this job file.
function init_gear_sets()   
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
		echos="Echo Drops",
		shihei="Shihei",
		orb="Macrocosmic Orb"
	}

	sets.idle = {
        head="Meghanada Visor +2",neck="Elite Royal Collar",lear="Infused Earring",rear="Etiolation Earring",
        body="Meg. Cuirie +2",hands="Meg. Gloves +2",ring1="Defending Ring",ring2="Vengeful Ring",
        back="Solemnity Cape",waist="Plat. Mog. Belt",legs="Mummu Kecks +2",feet="Skd. Jambeaux +1"}

	-- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
	sets.idle.Town = set_combine(sets.idle, {})
	sets.idle.Field = set_combine(sets.idle, {})
	sets.idle.Weak = set_combine(sets.idle, {})
	
	-- Resting sets
	sets.resting = set_combine(sets.idle, {})

	-- Normal melee group
    sets.engaged = {
        head="Malignance Chapeau",neck="Combatant's Torque",lear="Odr Earring",rear="Skulk. Earring +1",
        body="Meg. Cuirie +2",hands="Herculean Gloves",ring1="Epona's Ring",ring2="Hetairoi Ring",
        back="Canny Cape",waist="Sarissapho. Belt",legs="Meg. Chausses +2",feet="Herculean Boots"}

	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {
        head="Malignance Chapeau",neck="Combatant's Torque",lear="Zennaroi Earring",rear="Skulk. Earring +1",
        body="Meg. Cuirie +2",hands="Meg. Gloves +2",ring1="Cacoethic Ring +1",ring2="Regal Ring",
        back="Toutatis's Cape",waist="Olseni Belt",legs="Meg. Chausses +2",feet="Meg. Jam. +2"})
	sets.Mode.Att= set_combine(sets.engaged, {
        head="Meghanada Visor +2",neck="Rep. Plat. Medal",lear="Bladeborn Earring",rear="Dudgeon Earring",
        body="Meg. Cuirie +2",hands="Meg. Gloves +2",ring1="Overbearing Ring",ring2="Regal Ring",
        back="Phalangite Mantle",waist="Sulla Belt",legs="Meg. Chausses +2",feet="Meg. Jam. +2"})
	-- Crit then DEX
	sets.Mode.Crit = set_combine(sets.engaged, {
        head="Adhemar Bonnet",neck="Love Torque",lear="Odr Earring",
        body="Meg. Cuirie +2",hands="Mummu Wrists +2",ring1="Mummu Ring",ring2="Hetairoi Ring",
        back="Canny Cape",legs="Mummu Kecks +2",feet="Mummu Gamash. +2"})
	sets.Mode.DA = set_combine(sets.engaged, {
        head="Skormoth Mask",neck="Asperity Necklace",lear="Sherida Earring",rear="Brutal Earring",
        body="Skulker's Vest",hands="Herculean Gloves",ring1="Epona's Ring",ring2="Hetairoi Ring",
        back="Canny Cape",waist="Sarissapho. Belt",legs="Meg. Chausses +2",feet="Herculean Boots"})
	sets.Mode.SB = set_combine(sets.engaged, {rear="Skulk. Earring +1"})
	sets.Mode.sTP = set_combine(sets.engaged, {
        head="Malignance Chapeau",neck="Anu Torque",lear="Sherida Earring",rear="Skulk. Earring +1",
        body="Pursuer's Doublet",ring1="Rajas Ring",ring2="K'ayres Ring",
        back="Lupine Cape",waist="Olseni Belt",legs="Iuitl Tights",feet="Mummu Gamash. +2"})
	sets.Mode.STR = set_combine(sets.engaged, {
        head=gear.hercAcc,neck="Rep. Plat. Medal",lear="Sherida Earring",
        body="Meg. Cuirie +2",hands="Meg. Gloves +2",ring1="Aife's Ring",ring2="Regal Ring",
        back="Buquwik Cape",waist="Sailfi Belt +1",legs="Herculean Trousers",feet="Meg. Jam. +2"})

	-- other Sets    
	sets.macc = {head="Malignance Chapeau",lear="Gwati Earring",ring1="Sangoma Ring"}
	sets.PDL = {head="Malignance Chapeau"}
	sets.empy = {head="Skulker's Bonnet",
		body="Skulker's Vest",hands="Skulk. Armlets +1",
		legs="Skulker's Culottes",feet="Skulk. Poulaines"}

	-- Sets with weapons defined.
 	sets.engaged.Club = {}
	sets.engaged.Dagger = {}
	sets.engaged.H2H = {}
	sets.engaged.Sword = {}
	sets.engaged.DW = set_combine(sets.engaged, {})
	sets.engaged.Shield = set_combine(sets.engaged, {})
	sets.engaged.TH = set_combine(sets.engaged, {})
	sets.engaged.DW.Dagger = set_combine(sets.engaged, {main="Skinflayer",sub="Shijo"})
	sets.engaged.Shield.Dagger = set_combine(sets.engaged, {main="Skinflayer",sub="Deliverance"})
	sets.engaged.TH.Dagger = set_combine(sets.engaged,  {main="Skinflayer",sub="Taming Sari"})
	--Add in appropriate Ranged weapons
	sets.ranged = {}
	sets.ranged.Stats = {range="",ammo="Yamarang"}
	-- sets.ranged.Bow = {range="Killer Shortbow",ammo="Horn Arrow"}
	sets.ranged.Xbow = {range="Tsoa. Crossbow",ammo="Bloody Bolt"}
	sets.ranged.Boomerrang = {range="Antitail +1",ammo=""}
	--Finalize the sets
	sets.engaged.DW.Dagger.Boomerrang = set_combine(sets.engaged.DW.Dagger, sets.ranged.Boomerrang)
	-- sets.engaged.DW.Dagger.Bow = set_combine(sets.engaged.DW.Dagger, sets.ranged.Bow)
	sets.engaged.DW.Dagger.Xbow = set_combine(sets.engaged.DW.Dagger, sets.ranged.Xbow)
	sets.engaged.DW.Dagger.Stats = set_combine(sets.engaged.DW.Dagger, sets.ranged.Stats)
	sets.engaged.Shield.Dagger.Boomerrang = set_combine(sets.engaged.Shield.Dagger, sets.ranged.Boomerrang)
	-- sets.engaged.Shield.Dagger.Bow = set_combine(sets.engaged.Shield.Dagger, sets.ranged.Bow)
	sets.engaged.Shield.Dagger.Xbow = set_combine(sets.engaged.Shield.Dagger, sets.ranged.Xbow)
	sets.engaged.Shield.Dagger.Stats = set_combine(sets.engaged.Shield.Dagger, sets.ranged.Stats)
	sets.engaged.TH.Dagger.Boomerrang = set_combine(sets.engaged.TH.Dagger, sets.ranged.Boomerrang)
	-- sets.engaged.TH.Dagger.Bow = set_combine(sets.engaged.TH.Dagger, sets.ranged.Bow)
	sets.engaged.TH.Dagger.Xbow = set_combine(sets.engaged.TH.Dagger, sets.ranged.Xbow)
	sets.engaged.TH.Dagger.Stats = set_combine(sets.engaged.TH.Dagger, sets.ranged.Stats)
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
	sets.engaged.TH.Dagger.Acc = set_combine(sets.engaged.TH.Dagger, sets.Mode.Acc)
	sets.engaged.TH.Dagger.Att = set_combine(sets.engaged.TH.Dagger, sets.Mode.Att)
	sets.engaged.TH.Dagger.Crit = set_combine(sets.engaged.TH.Dagger, sets.Mode.Crit)
	sets.engaged.TH.Dagger.DA = set_combine(sets.engaged.TH.Dagger, sets.Mode.DA)
	sets.engaged.TH.Dagger.SB = set_combine(sets.engaged.TH.Dagger, sets.Mode.SB)
	sets.engaged.TH.Dagger.sTP = set_combine(sets.engaged.TH.Dagger, sets.Mode.sTP)
	sets.engaged.TH.Dagger.STR = set_combine(sets.engaged.TH.Dagger, sets.Mode.STR)
	
	sets.engaged.DW.Sword = set_combine(sets.engaged, {main="Naegling",sub="Shijo"})
	sets.engaged.Shield.Sword = set_combine(sets.engaged, {main="Naegling",sub="Deliverance"})
	sets.engaged.TH.Sword = set_combine(sets.engaged, {main="Naegling",sub="Taming Sari"})
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
	sets.engaged.DW.Club = set_combine(sets.engaged, {main="Warp Cudgel",sub="Taming Sari"})
	sets.engaged.DW.Club.Acc = set_combine(sets.engaged.DW.Club, sets.Mode.Acc)
	sets.engaged.Shield.Club = set_combine(sets.engaged, {main="Warp Cudgel",sub="Deliverance"})
	sets.engaged.Shield.Club.Acc = set_combine(sets.engaged.Shield.Club, sets.Mode.Acc)
	sets.engaged.Shield.Club.SB = set_combine(sets.engaged.Shield.Club, sets.Mode.SB)
	sets.engaged.Shield.Club.SB.Bow = set_combine(sets.engaged.Shield.Club.SB.Bow, sets.ranged.Bow)
	sets.engaged.TH.Club = set_combine(sets.engaged, {main="Warp Cudgel",sub="Taming Sari"})
	sets.engaged.TH.Club.Acc = set_combine(sets.engaged.TH.Club, sets.Mode.Acc)
	sets.engaged.DW.H2H = set_combine(sets.engaged, {main="",sub=""})
	sets.engaged.DW.H2H.Acc = set_combine(sets.engaged.Club, sets.Mode.Acc)
	sets.engaged.DW.Staff = set_combine(sets.engaged, {main="Gozuki Mezuki",sub="Pole Grip"})
	sets.engaged.DW.Staff.Acc = set_combine(sets.engaged.Staff, sets.Mode.Acc, {})
	sets.engaged.Shield.Staff = set_combine(sets.engaged, {main="Gozuki Mezuki",sub="Pole Grip"})
	sets.engaged.Shield.Staff.Acc = set_combine(sets.engaged.Staff, sets.Mode.Acc, {})
	sets.engaged.TH.Staff = set_combine(sets.engaged, {main="Gozuki Mezuki",sub="Pole Grip"})
	sets.engaged.TH.Staff.Acc = set_combine(sets.engaged.Staff, sets.Mode.Acc, {})
	sets.engaged.DW.Polearm = set_combine(sets.engaged, {main="Pitchfork +1",sub="Pole Grip"})
	sets.engaged.DW.Polearm.Acc = set_combine(sets.engaged.Polearm, sets.Mode.Acc)
	sets.engaged.Shield.Polearm = set_combine(sets.engaged, {main="Pitchfork +1",sub="Pole Grip"})
	sets.engaged.Shield.Polearm.Acc = set_combine(sets.engaged.Polearm, sets.Mode.Acc)
	sets.engaged.TH.Polearm = set_combine(sets.engaged, {main="Pitchfork +1",sub="Pole Grip"})
	sets.engaged.TH.Polearm.Acc = set_combine(sets.engaged.Polearm, sets.Mode.Acc)
	sets.engaged.DW.Scythe = set_combine(sets.engaged, {main="Ark Scythe",sub="Pole Grip"})
	sets.engaged.DW.Scythe.Acc = set_combine(sets.engaged.Scythe, sets.Mode.Acc)
	sets.engaged.Shield.Scythe = set_combine(sets.engaged, {main="Ark Scythe",sub="Pole Grip"})
	sets.engaged.Shield.Scythe.Acc = set_combine(sets.engaged.Scythe, sets.Mode.Acc)
	sets.engaged.TH.Scythe = set_combine(sets.engaged, {main="Ark Scythe",sub="Pole Grip"})
	sets.engaged.TH.Scythe.Acc = set_combine(sets.engaged.Scythe, sets.Mode.Acc)

    --------------------------------------
    -- Special sets (required by rules)
    --------------------------------------

    sets.TreasureHunter = {head=gear.hercTH, hands="Plun. Armlets", waist="Chaac Belt", feet="Skulk. Poulaines"}
    sets.TreasureHunter.ammo = set_combine(sets.TreasureHunter, {ammo="Per. Lucky Egg"})
    sets.ExtraRegen = {}
    sets.Kiting = {feet="Skd. Jambeaux +1"}

	-- SA then DEX
    sets.buff['Sneak Attack'] = {
        head="Malignance Chapeau",neck="Asperity Necklace",lear="Odr Earring",rear="Sherida Earring",
        body="Meg. Cuirie +2",hands="Skulk. Armlets +1",ring1="Rajas Ring",ring2="Apate Ring",
        back="Toutatis's Cape",waist="Wanion Belt",legs="Manibozho Brais",feet="Meg. Jam. +2"}

	-- TA then AGI
    sets.buff['Trick Attack'] = {
        head="Malignance Chapeau",neck="Asperity Necklace",lear="Infused Earring",rear="Suppanomimi",
        body="Meg. Cuirie +2",hands="Pill. Armlets +1",ring1="Rajas Ring",ring2="Apate Ring",
        back="Toutatis's Cape",waist="Yemaya Belt",legs="Mummu Kecks +2",feet="Meg. Jam. +2"}

    -- Actions we want to use to tag TH.
    sets.precast.Step = set_combine(sets.TreasureHunter, {})
    sets.precast.Flourish1 = set_combine(sets.TreasureHunter, {})
    sets.precast.JA.Provoke = set_combine(sets.TreasureHunter, {})

    --------------------------------------
    -- Precast sets
    sets.precast.JA['Collaborator'] = {head="Skulker's Bonnet"}
    sets.precast.JA['Accomplice'] = {head="Skulker's Bonnet"}
    sets.precast.JA['Flee'] = {feet="Pillager's Poulaines"}
    sets.precast.JA['Hide'] = {body="Pillager's Vest"}
    sets.precast.JA['Conspirator'] = {body="Skulker's Vest"} 
    sets.precast.JA['Steal'] = {head="Plun. Bonnet",hands="Pill. Armlets +1",waist="Key Ring Belt",legs="Pillager's Culottes",feet="Pillager's Poulaines"}
    sets.precast.JA['Mug'] = {head="Plun. Bonnet"}
    sets.precast.JA['Despoil'] = {legs="Skulker's Culottes",feet="Skulk. Poulaines"}
    sets.precast.JA['Perfect Dodge'] = {hands="Plun. Armlets"}
    sets.precast.JA['Feint'] = {legs="Plun. Culottes"} 

    sets.precast.JA['Sneak Attack'] = set_combine(sets.buff['Sneak Attack'], {})
    sets.precast.JA['Trick Attack'] = set_combine(sets.buff['Trick Attack'], {})


    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        head="Mummu Bonnet +2",
        body="Passion Jacket",hands="Buremte Gloves",ring2="Metamor. Ring +1",
        legs="Feast Hose",feet="Meg. Jam. +2"}

    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    -- Fast cast sets for spells
    sets.precast.FC = {head=gear.hercAcc,neck="Orunmila's Torque",lear="Etiolation Earring",
		hands="Leyline Gloves",ring1="Prolix Ring",ring2="Naji's Loop",legs="Limbo Trousers"}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads",body="Passion Jacket"})

	sets.precast['Elemental Magic'] = set_combine(sets.TreasureHunter, {lear="Friomisi Earring",rear="Crematio Earring",
		ring1="Patricius Ring",ring2="Metamor. Ring +1",
		back="Toro Cape",legs="Iuitl Tights"})

    -- Ranged snapshot gear
    sets.precast.RA = {
		head="Meghanada Visor +2",neck="Combatant's Torque",
		hands="Iuitl Wristbands",
		waist="Yemaya Belt",legs="Nahtirah Trousers",feet="Meg. Jam. +2"}


    -- Weaponskill sets

    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = set_combine(sets.Mode.STR, {neck="Fotia Gorget",rear="Ishvara Earring",
        hands="Meg. Gloves +2",ring1="Cornelia's Ring",ring2="Epaminondas's Ring",
        back="Toutatis's Cape",waist="Fotia Belt"})
 
    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	-- Earth, DEX 100%
	sets.precast.WS['Wasp Sting'] = set_combine(sets.precast.WS, {})

	-- Wind, DEX 40% INT 40%
	sets.precast.WS['Gust Slash'] = set_combine(sets.precast.WS, {legs="Limbo Trousers",feet="Herculean Boots"})

	-- Water, CHR 100%
	sets.precast.WS['Shadowstitch'] = set_combine(sets.precast.WS, {})

 	-- Earth, DEX 100%
	sets.precast.WS['Viper Bite'] = set_combine(sets.precast.WS, {})
 
 	-- Wind/Thunder, DEX 40% INT 40%
	sets.precast.WS['Cyclone'] = set_combine(sets.precast.WS, {body="Lapidary Tunic",ring2="Metamor. Ring +1",
		legs="Limbo Trousers",feet="Herculean Boots"})
	sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS['Cyclone'], {})
 
  	-- none, MND 100%
	sets.precast.WS['Energy Steal'] = set_combine(sets.precast.WS, {})
 
  	-- none, MND 100%
	sets.precast.WS['Energy Drain'] = set_combine(sets.precast.WS, {})

	-- Wind/Earth, DEX 40% CHR 40%
    sets.precast.WS['Dancing Edge'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Dancing Edge'].SA = set_combine(sets.precast.WS['Dancing Edge'], {})
    sets.precast.WS['Dancing Edge'].TA = set_combine(sets.precast.WS['Dancing Edge'], {})
    sets.precast.WS['Dancing Edge'].SATA = set_combine(sets.precast.WS['Dancing Edge'], {})
	
	-- Wind/Thunder, DEX 40% AGI 40%
    sets.precast.WS["Shark Bite"] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Shark Bite'].SA = set_combine(sets.precast.WS['Shark Bite'], {
        body="Pillager's Vest",legs="Pillager's Culottes"})
    sets.precast.WS['Shark Bite'].TA = set_combine(sets.precast.WS['Shark Bite'], {
        body="Pillager's Vest",legs="Pillager's Culottes"})
    sets.precast.WS['Shark Bite'].SATA = set_combine(sets.precast.WS['Shark Bite'], {
        body="Pillager's Vest",legs="Pillager's Culottes"})

	-- Light/Dark/Earth, DEX 50%
    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, sets.Mode.Crit, {})
    sets.precast.WS['Evisceration'].SA = set_combine(sets.precast.WS['Evisceration'], {})
    sets.precast.WS['Evisceration'].TA = set_combine(sets.precast.WS['Evisceration'], {})
    sets.precast.WS['Evisceration'].SATA = set_combine(sets.precast.WS['Evisceration'], {})

	-- Wind/Thunder/Earth, DEX 40% AGI 40%
    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS, {
        lear="Friomisi Earring",rear="Crematio Earring",
        body="Lapidary Tunic",hands="Leyline Gloves",
        back="Toro Cape",legs="Limbo Trousers",feet="Herculean Boots"})
    sets.precast.WS['Aeolian Edge'].TH = set_combine(sets.precast.WS['Aeolian Edge'], sets.TreasureHunter)

	-- Wind/Thunder/Earth, AGI 73%
	sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Exenterator'].SA = set_combine(sets.precast.WS['Exenterator'], {})
    sets.precast.WS['Exenterator'].TA = set_combine(sets.precast.WS['Exenterator'], {})
    sets.precast.WS['Exenterator'].SATA = set_combine(sets.precast.WS['Exenterator'], {})

	-- Ice/Water/Dark, DEX 80%
    sets.precast.WS["Rudra's Storm"] = set_combine(sets.precast.WS, {})
    sets.precast.WS["Rudra's Storm"].SA = set_combine(sets.precast.WS["Rudra's Storm"], {
        body="Pillager's Vest",legs="Pillager's Culottes"})
    sets.precast.WS["Rudra's Storm"].TA = set_combine(sets.precast.WS["Rudra's Storm"], {
        body="Pillager's Vest",legs="Pillager's Culottes"})
    sets.precast.WS["Rudra's Storm"].SATA = set_combine(sets.precast.WS["Rudra's Storm"], {
        body="Pillager's Vest",legs="Pillager's Culottes"})

	-- Light/Fire/Dark, DEX 60%
    sets.precast.WS['Mandalic Stab'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Mandalic Stab'].SA = set_combine(sets.precast.WS['Mandalic Stab'], {
        body="Pillager's Vest",legs="Pillager's Culottes"})
    sets.precast.WS['Mandalic Stab'].TA = set_combine(sets.precast.WS['Mandalic Stab'], {
        body="Pillager's Vest",legs="Pillager's Culottes"})
    sets.precast.WS['Mandalic Stab'].SATA = set_combine(sets.precast.WS['Mandalic Stab'], {
        body="Pillager's Vest",legs="Pillager's Culottes"})

	--------------------------------------
    -- Midcast sets
    --------------------------------------
    -- sets.midcast.FastRecast = {}
	
	sets.midcast['Elemental Magic'] = set_combine(sets.TreasureHunter, {lear="Friomisi Earring",rear="Crematio Earring",
		neck="Incanter's Torque",ring1="Patricius Ring",ring2="Metamor. Ring +1",
		back="Toro Cape",legs="Iuitl Tights"})

    -- Specific spells
    sets.midcast.Utsusemi = {
        head=gear.hercAcc,
        body="Pillager's Vest",hands="Pill. Armlets +1",
        back="Canny Cape",legs="Kaabnax Trousers"}

    -- Ranged gear
    sets.midcast.RA = {
        head="Malignance Chapeau",neck="Combatant's Torque",lear="Infused Earring",rear="Enervating Earring",
        body="Meg. Cuirie +2",hands="Meg. Gloves +2",ring1="Paqichikaji Ring",ring2="Cacoethic Ring +1",
        waist="Eschan Stone",legs="Meg. Chausses +2",feet="Meg. Jam. +2"}

    sets.midcast.RA.Acc = set_combine(sets.midcast.RA, {waist="Flax Sash"})

	-- Defense sets

    sets.defense.Evasion = {
        head="Malignance Chapeau",lear="Infused Earring",rear="Eabani Earring",
        body="Herculean Vest",hands="Mummu Wrists +2",ring1="Vengeful Ring",ring2="Beeline Ring",
        back="Canny Cape",legs="Herculean Trousers",feet="Herculean Boots"}

    sets.defense.PDT = {
        head="Malignance Chapeau",neck="Elite Royal Collar",
        body="Meg. Cuirie +2",hands="Meg. Gloves +2",ring1="Defending Ring",ring2="Patricius Ring",
        back="Solemnity Cape",waist="Plat. Mog. Belt",legs="Meg. Chausses +2",feet="Ahosi Leggings"}

    sets.defense.MDT = {
        head="Malignance Chapeau",neck="Elite Royal Collar",lear="Etiolation Earring",rear="Eabani Earring",
        body="Herculean Vest",hands="Kurys Gloves",ring1="Defending Ring",ring2="Moonbeam Ring",
        back="Reiki Cloak",waist="Plat. Mog. Belt",legs="Mummu Kecks +2",feet="Ahosi Leggings"}
	
	sets.debuffed = set_combine(sets.defense.Evasion,sets.defense.PDT,sets.defense.MDT)
	sets.doom = set_combine(sets.debuffed,{waist="Gishdubar Sash"})

 	-- Melee sets for in Adoulin, which has an extra 2% Haste from Ionis.
	sets.engaged.Adoulin = set_combine(sets.engaged, {})
	-- sets.Assault = {ring2="Ulthalam's Ring"}
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    check_ws_dist(spell)
end

-- Run after the general precast() is done.
function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.english == 'Aeolian Edge' and state.TreasureMode.value ~= 'None' then
		if state.RWeaponMode.value == 'Stats' then
			equip(sets.TreasureHunter.ammo)
		else
			equip(sets.TreasureHunter)
		end	
    elseif spell.english=='Sneak Attack' or spell.english=='Trick Attack' or spell.type == 'WeaponSkill' then
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            if state.RWeaponMode.value == 'Stats' then
				equip(sets.TreasureHunter.ammo)
			else
				equip(sets.TreasureHunter)
			end	
        end
    end
end

-- Run after the general midcast() set is constructed.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if state.TreasureMode.value ~= 'None' and spell.action_type == 'Ranged Attack' then
		if state.RWeaponMode.value == 'Stats' then
			equip(sets.TreasureHunter.ammo)
		else
			equip(sets.TreasureHunter)
		end	
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    -- Weaponskills wipe SATA/Feint.  Turn those state vars off before default gearing is attempted.
    if spell.type == 'WeaponSkill' and not spell.interrupted then
        state.Buff['Sneak Attack'] = false
        state.Buff['Trick Attack'] = false
        state.Buff['Feint'] = false
    end
end

-- Run after the default aftercast() is done.
-- eventArgs is the same one used in job_aftercast, in case information needs to be persisted.
function job_post_aftercast(spell, action, spellMap, eventArgs)
    -- If Feint is active, put that gear set on on top of regular gear.
    -- This includes overlaying SATA gear.
    check_buff('Feint', eventArgs)
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
        if not midaction() then
            handle_equipping_gear(player.status)
        end
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function get_custom_wsmode(spell, spellMap, defaut_wsmode)
    local wsmode

    if state.Buff['Sneak Attack'] then
        wsmode = 'SA'
    end
    if state.Buff['Trick Attack'] then
        wsmode = (wsmode or '') .. 'TA'
    end

    return wsmode
end


-- Called any time we attempt to handle automatic gear equips (ie: engaged or idle gear).
function job_handle_equipping_gear(playerStatus, eventArgs)
    -- Check that ranged slot is locked, if necessary
    -- check_range_lock()

    -- Check for SATA when equipping gear.  If either is active, equip
    -- that gear specifically, and block equipping default gear.
    check_buff('Sneak Attack', eventArgs)
    check_buff('Trick Attack', eventArgs)
	
	check_tp_lock()
	set_combat_form()
	pick_tp_weapon()
end


function customize_idle_set(idleSet)
    if player.hpp < 80 then
        idleSet = set_combine(idleSet, sets.ExtraRegen)
    end

    return idleSet
end


function customize_melee_set(meleeSet)
	if areas.Assault:contains(world.area) then
		meleeSet = set_combine(meleeSet, sets.Assault)
	end
	if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end

    return meleeSet
end


-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    th_update(cmdParams, eventArgs)
	-- classes.CustomMeleeGroups:clear()
	-- if areas.Adoulin:contains(world.area) and buffactive.ionis then
			-- classes.CustomMeleeGroups:append('Adoulin')
	-- end
	pick_tp_weapon()
end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
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
    
    if state.Kiting.value == true then
        msg = msg .. ', Kiting'
    end

    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: '..state.PCTargetMode.value
    end

    if state.SelectNPCTargets.value == true then
        msg = msg .. ', Target NPCs'
    end
    
    msg = msg .. ', TH: ' .. state.TreasureMode.value

    add_to_chat(122, msg)
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

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- State buff checks that will equip buff gear and mark the event as handled.
function check_buff(buff_name, eventArgs)
    if state.Buff[buff_name] then
        equip(sets.buff[buff_name] or {})
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
			if state.RWeaponMode.value == 'Stats' then
				equip(sets.TreasureHunter.ammo)
			else
				equip(sets.TreasureHunter)
			end	
        end
        eventArgs.handled = true
    end
end


-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
    if category == 2 or -- any ranged attack
        --category == 4 or -- any magic action
        (category == 3 and param == 30) or -- Aeolian Edge
        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
        then return true
    end
end


-- Function to lock the ranged slot if we have a ranged weapon equipped.
function check_range_lock()
    if player.equipment.range ~= 'empty' then
        disable('range', 'ammo')
    else
        enable('range', 'ammo')
    end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'DNC' then
		set_macro_page(3, 4)
		send_command('exec thfdnc.txt')
	elseif player.sub_job == 'WAR' then
		set_macro_page(2, 4)
	elseif player.sub_job == 'NIN' then
		set_macro_page(1, 4)
	else
		set_macro_page(1, 4)
	end
	send_command('exec thf.txt')
end
