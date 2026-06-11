include('organizer-lib.lua')
-------------------------------------------------------------------------------------------------------------------
-- Initialization function that defines sets and variables to be used.
-------------------------------------------------------------------------------------------------------------------
 
-- IMPORTANT: Make sure to also get the Mote-Include.lua file (and its supplementary files) to go with this.
 
-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
     
    -- Load and initialize the include file.
    include('Mote-Include.lua')
end
 
-- Setup vars that are user-independent.
function job_setup()
	state.WeaponMode = M{['description']='Weapon Mode', 'GreatAxe', 'Axe', 'GreatSword', 'Scythe', 'Sword', 'Staff', 'Polearm', 'Club', 'Dagger', 'H2H', 'Katana', 'GreatKatana'}
	state.SubMode = M{['description']='Sub Mode', 'DW', 'Shield', 'Grip'}
	state.RWeaponMode = M{['description']='RWeapon Mode', 'Stats', 'Bow', 'Xbow', 'Boomerrang'}
	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive'}
  	state.holdtp = M{['description']='holdtp', 'false', 'true'}
	state.immuno = M{['description']='immuno', 'false', 'true'}
	set_combat_form()
	pick_tp_weapon()
end
 
 
-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	-- Options: Override default values
	state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'SB', 'sTP', 'STR', 'Eva', 'DT', 'Meva')
	state.WeaponskillMode:options('Normal')
	state.DefenseMode:options('None', 'Physical', 'Magical')
	state.PhysicalDefenseMode:options('PDT', 'Evasion', 'Reraise')
	state.MagicalDefenseMode:options('MDT', 'Reraise')
	state.WeaponMode:set('GreatAxe')
	state.Stance:set('Offensive')
	state.SubMode:set('Grip')
	state.RWeaponMode:set('Stats') 
	state.holdtp:set('false')
	state.immuno:set('false')
    Twilight = false
	gear.JobAmmo = {name="Seeth. Bomblet +1"}
	gear.JobRanged = {name=""}
	gear.XBowAmmo = "Bloody Bolt"
	gear.XBowRanged = "Tsoa. Crossbow"
	gear.StatsAmmo = "Seeth. Bomblet +1"
	gear.WSAmmo = "Knobkierrie"
	gear.useWSAmmo = {name="Knobkierrie"}
	gear.empty = ""
	pick_tp_weapon()
	select_default_macro_book()
end
 
-- Called when this job file is unloaded (eg: job change)
function file_unload()
    if binds_on_unload then
        binds_on_unload()
    end
 
    send_command('unbind ^`')
    send_command('unbind !-')
end
 
 
-- Define sets and vars used by this job file.
function init_gear_sets()
	-- Sets to return to when not performing an action.
    gear.wsdCape={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Damage taken-5%',}}
    gear.tpCape={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Damage taken-5%',}}
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
        food1="Sublime Sushi",
		echos="Echo Drops",
		shihei="Shihei",
		XBowAmmo="Bloody Bolt",
		XBowRanged="Tsoa. Crossbow",
		Boomerrang="Antitail +1",
		StatsAmmo="Coiste Bodhar",
		WSAmmo="Knobkierrie",
		orb="Macrocosmic Orb"
	}
	gear.JobAmmo = {name="Seeth. Bomblet +1"}
	gear.JobRanged = {name=""}
	gear.XBowAmmo = "Bloody Bolt"
	gear.XBowRanged = "Tsoa. Crossbow"
	gear.StatsAmmo = "Coiste Bodhar"
	gear.Boomerrang = "Antitail +1"
	gear.WSAmmo = "Knobkierrie"
	gear.useWSAmmo = {name="Knobkierrie"}
	gear.empty = ""
	-- For closetCleaner
	sets.vars = { main=gear.WSAmmo, sub=gear.XBowAmmo, ranged=gear.XBowRanged, ammo=gear.StatsAmmo,
		body=gear.Boomerrang, ring1=gear.useWSAmmo}
	-- Idle sets
	sets.idle = {head="Valorous Mask",neck="Null Loop",lear="Infused Earring",rear="Etiolation Earring",
		body="Sakpata's Plate",hands="Nyame Gauntlets",ring1="Defending Ring",ring2="Patricius Ring",
		back=gear.tpCape,waist="Plat. Mog. Belt",legs="Sakpata's Cuisses",feet="Nyame Sollerets"}

	-- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
	sets.idle.Town = set_combine(sets.idle, {})
	sets.idle.Field = set_combine(sets.idle, {})
	sets.idle.Weak = set_combine(sets.idle, {})

	-- Resting sets
	sets.resting = set_combine(sets.idle, {})

	-- Engaged sets
	-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion

	-- Normal melee group
	sets.engaged = {
		head="Flam. Zucchetto +2",neck="Asperity Necklace",lear="Mache Earring",rear="Brutal Earring",
		body="Sakpata's Plate",hands="Sakpata's Gauntlets",ring1="Adoulin Ring",ring2="Cacoethic Ring +1",
		back=gear.tpCape,waist="Sailfi Belt +1",legs="Sakpata's Cuisses",feet="Flamma Gambieras +2"}
			
	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {
		head="Alhazen Hat +1",neck="Null Loop",lear="Zennaroi Earring",rear="Digni. Earring",
		body="Flamma Korazin +2",hands="Tatena. Gote +1",ring1="Flamma Ring",ring2="Woodsman Ring",
		back="Ground. Mantle +1",waist="Olseni Belt",legs="Sulev. Cuisses +2",feet="Arke Gambieras"})
	sets.Mode.Att= set_combine(sets.engaged, {
		head="Sulevia's Mask +2",neck="Rep. Plat. Medal",lear="Bladeborn Earring",rear="Dudgeon Earring",
		body="Sacro Breastplate",hands="Sulev. Gauntlets +2",ring1="Adoulin Ring",ring2="Regal Ring",
		back="Phalangite Mantle",waist="Sulla Belt",legs="Emicho Hose",feet="Sulev. Leggings +2"})
	sets.Mode.Crit = set_combine(sets.engaged, {
		head="Valorous Mask",
		body="Tatena. Harama. +1",hands="Flam. Manopolas +2",ring2="Hetairoi Ring",legs="Jokushu Haidate",feet="Thereoid Greaves"})
	sets.Mode.DA = set_combine(sets.engaged, {
		head="Flam. Zucchetto +2",neck="Asperity Necklace",lear="Schere Earring",rear="Boii Earring",
		body="Sakpata's Plate",hands="Tatena. Gote +1",ring1="Niqmaddu Ring",ring2="Hetairoi Ring",
		back="Cichol's Mantle",waist="Sailfi Belt +1",legs="Sakpata's Cuisses",feet="Pumm. Calligae +1"})
	sets.Mode.SB = set_combine(sets.engaged, {lear="Schere Earring",body="Sacro Breastplate"})
	sets.Mode.sTP = set_combine(sets.engaged, {
		head="Sulevia's Mask +2",neck="Combatant's Torque",lear="Tripudio Earring",rear="Enervating Earring",
		body="Flamma Korazin +2",hands="Tatena. Gote +1",ring1="Flamma Ring",ring2="K'ayres Ring",
		back="Lupine Cape",waist="Olseni Belt",legs="Flamma Dirs +2",feet="Valorous Greaves"})
	sets.Mode.STR = set_combine(sets.engaged, {
		head="Flam. Zucchetto +2",neck="Rep. Plat. Medal",lear="Thrud Earring",
		body="Flamma Korazin +2",hands="Sakpata's Gauntlets",ring1="Flamma Ring",ring2="Rajas Ring",
		back=gear.wsdCape,waist="Sailfi Belt +1",legs="Flamma Dirs +2",feet="Flamma Gambieras +2"})
	sets.Mode.Eva = set_combine(sets.engaged, {
		head="Nyame Helm",lear="Infused Earring",rear="Eabani Earring",
		body="Nyame Mail",hands="Nyame Gauntlets",ring1="Vengeful Ring",ring2="Beeline Ring",
		back="Lupine Cape",legs="Nyame Flanchard",feet="Nyame Sollerets"})
	sets.Mode.DT = set_combine(sets.engaged, {
		head="Nyame Helm",neck="Null Loop",
		body="Arke Corazza",hands="Nyame Gauntlets",ring1="Defending Ring",ring2="Patricius Ring",
		back=gear.tpCape,waist="Plat. Mog. Belt",legs="Arke Cosciales",feet="Sakpata's Leggings"})
	sets.Mode.Meva = set_combine(sets.engaged, {
		head="Nyame Helm",neck="Elite Royal Collar",lear="Etiolation Earring",rear="Eabani Earring",
		body="Nyame Mail",hands="Nyame Gauntlets",ring1="Defending Ring",ring2="Moonbeam Ring",
		back="Reiki Cloak",waist="Plat. Mog. Belt",legs="Sakpata's Cuisses",feet="Sakpata's Leggings"})
	
	-- other Sets 
	sets.macc = {
		head="Flam. Zucchetto +2",neck="Null Loop",lear="Gwati Earring",
		body="Sakpata's Plate",hands="Nyame Gauntlets",ring1="Flamma Ring",ring2="Sangoma Ring",
		legs="Sakpata's Cuisses",feet="Flam. Gambieras +1"}
	sets.PDL = {body="Sakpata's Plate",legs="Sakpata's Cuisses",feet="Sakpata's Leggings"}
	sets.empy = {head="Boii Mask",
		body="Boii Lorica",hands="Boii Mufflers",
		legs="Boii Cuisses",feet="Boii Calligae"}		
	
	--Initialize Main Weapons
	sets.engaged.GreatAxe = {}
	sets.engaged.Axe = {}
	sets.engaged.GreatSword = {}
	sets.engaged.Scythe = {}
	sets.engaged.Sword = {}
	sets.engaged.Staff = {}
	sets.engaged.Polearm = {}
	sets.engaged.Club = {}
	sets.engaged.Dagger = {}
	sets.engaged.H2H = {}
	sets.engaged.Katana = {}
	sets.engaged.GreatKatana = {}
	sets.engaged.DW = set_combine(sets.engaged, {})
	sets.engaged.Shield = set_combine(sets.engaged, {})
	sets.engaged.Grip = set_combine(sets.engaged, {})
	sets.engaged.DW.Axe = set_combine(sets.engaged, {main="Beryllium Pick",sub="Kustawi +1"})
	sets.engaged.Shield.Axe = set_combine(sets.engaged, {main="Beryllium Pick",sub="Adapa Shield"})
	sets.engaged.DW.Club = set_combine(sets.engaged, {main="Loxotic Mace",sub="Beryllium Pick"})
	sets.engaged.Shield.Club = set_combine(sets.engaged, {main="Loxotic Mace",sub="Adapa Shield"})
	sets.engaged.DW.Dagger = set_combine(sets.engaged, {main="Kustawi +1",sub="Kumbhakarna"})
	sets.engaged.Shield.Dagger = set_combine(sets.engaged, {main="Kustawi +1",sub="Adapa Shield"})
	sets.engaged.Grip.GreatAxe = set_combine(sets.engaged, {main="Bunzi's Chopper",sub="Khonsu"})
	sets.engaged.Grip.GreatKatana = set_combine(sets.engaged, {main="Ark Tachi",sub="Khonsu"})
	sets.engaged.Grip.GreatSword = set_combine(sets.engaged, {main="Kaja Claymore",sub="Khonsu"})
	sets.engaged.Grip.H2H = set_combine(sets.engaged, {main=empty,sub=empty})
	sets.engaged.DW.Katana = set_combine(sets.engaged, {main="Trainee Burin",sub="Kumbhakarna"})
	sets.engaged.Shield.Katana = set_combine(sets.engaged, {main="Trainee Burin",sub="Adapa Shield"})
	sets.engaged.Grip.Polearm = set_combine(sets.engaged, {main="Shining One", sub="Khonsu"})
	sets.engaged.Grip.Scythe = set_combine(sets.engaged, {main="Maliya Sickle", sub="Khonsu"})
	sets.engaged.Grip.Staff = set_combine(sets.engaged, {main="Ungeri Staff", sub="Khonsu"})
	sets.engaged.DW.Sword = set_combine(sets.engaged, {main="Naegling",sub="Kumbhakarna"})
	sets.engaged.Shield.Sword = set_combine(sets.engaged, {main="Naegling",sub="Adapa Shield"})
	--Add in appropriate Ranged weapons
	sets.ranged = {}
	sets.ranged.Stats = {range=gear.JobRanged,ammo=gear.JobAmmo}
	sets.ranged.XBow = {range=gear.JobRanged,ammo=gear.JobAmmo}
	sets.ranged.Boomerrang = {range=gear.JobRanged,ammo=gear.JobAmmo}
	
	sets.engaged.DW.Axe.Xbow = set_combine(sets.engaged.DW.Axe, sets.ranged.Xbow)
	sets.engaged.DW.Axe.Stats = set_combine(sets.engaged.DW.Axe, sets.ranged.Stats)
	sets.engaged.Shield.Axe.Xbow = set_combine(sets.engaged.Shield.Axe, sets.ranged.Xbow)
	sets.engaged.Shield.Axe.Stats = set_combine(sets.engaged.Shield.Axe, sets.ranged.Stats)
	sets.engaged.DW.Club.Xbow = set_combine(sets.engaged.DW.Club, sets.ranged.Xbow)
	sets.engaged.DW.Club.Stats = set_combine(sets.engaged.DW.Club, sets.ranged.Stats)
	sets.engaged.Shield.Club.Xbow = set_combine(sets.engaged.Shield.Club, sets.ranged.Xbow)
	sets.engaged.Shield.Club.Stats = set_combine(sets.engaged.Shield.Club, sets.ranged.Stats)
	sets.engaged.DW.Dagger.Xbow = set_combine(sets.engaged.DW.Dagger, sets.ranged.Xbow)
	sets.engaged.DW.Dagger.Stats = set_combine(sets.engaged.DW.Dagger, sets.ranged.Stats)
	sets.engaged.Shield.Dagger.Xbow = set_combine(sets.engaged.Shield.Dagger, sets.ranged.Xbow)
	sets.engaged.Shield.Dagger.Stats = set_combine(sets.engaged.Shield.Dagger, sets.ranged.Stats)
	sets.engaged.DW.Katana.Xbow = set_combine(sets.engaged.DW.Katana, sets.ranged.Xbow)
	sets.engaged.DW.Katana.Stats = set_combine(sets.engaged.DW.Katana, sets.ranged.Stats)
	sets.engaged.Shield.Katana.Xbow = set_combine(sets.engaged.Shield.Katana, sets.ranged.Xbow)
	sets.engaged.Shield.Katana.Stats = set_combine(sets.engaged.Shield.Katana, sets.ranged.Stats)
	sets.engaged.DW.Sword.Xbow = set_combine(sets.engaged.DW.Sword, sets.ranged.Xbow)
	sets.engaged.DW.Sword.Stats = set_combine(sets.engaged.DW.Sword, sets.ranged.Stats)
	sets.engaged.Shield.Sword.Xbow = set_combine(sets.engaged.Shield.Sword, sets.ranged.Xbow)
	sets.engaged.Shield.Sword.Stats = set_combine(sets.engaged.Shield.Sword, sets.ranged.Stats)

	sets.engaged.Grip.GreatAxe.Xbow = set_combine(sets.engaged.Grip.GreatAxe, sets.ranged.Xbow)
	sets.engaged.Grip.GreatAxe.Stats = set_combine(sets.engaged.Grip.GreatAxe, sets.ranged.Stats)
	sets.engaged.Grip.GreatSword.Xbow = set_combine(sets.engaged.Grip.GreatSword, sets.ranged.Xbow)
	sets.engaged.Grip.GreatSword.Stats = set_combine(sets.engaged.Grip.GreatSword, sets.ranged.Stats)
	sets.engaged.Grip.GreatKatana.Xbow = set_combine(sets.engaged.Grip.GreatKatana, sets.ranged.Xbow)
	sets.engaged.Grip.GreatKatana.Stats = set_combine(sets.engaged.Grip.GreatKatana, sets.ranged.Stats)
	sets.engaged.Grip.H2H.Xbow = set_combine(sets.engaged.Grip.H2H, sets.ranged.Xbow)
	sets.engaged.Grip.H2H.Stats = set_combine(sets.engaged.Grip.H2H, sets.ranged.Stats)
	sets.engaged.Grip.Scythe.Xbow = set_combine(sets.engaged.Grip.Scythe, sets.ranged.Xbow)
	sets.engaged.Grip.Scythe.Stats = set_combine(sets.engaged.Grip.Scythe, sets.ranged.Stats)
	sets.engaged.Grip.Polearm.Xbow = set_combine(sets.engaged.Grip.Polearm, sets.ranged.Xbow)
	sets.engaged.Grip.Polearm.Stats = set_combine(sets.engaged.Grip.Polearm, sets.ranged.Stats)
	sets.engaged.Grip.Staff.Xbow = set_combine(sets.engaged.Grip.Staff, sets.ranged.Xbow)
	sets.engaged.Grip.Staff.Stats = set_combine(sets.engaged.Grip.Staff, sets.ranged.Stats)
	
	sets.engaged.Grip.GreatAxe.Acc = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.Acc)
	sets.engaged.Grip.GreatAxe.Att = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.Att)
	sets.engaged.Grip.GreatAxe.Crit = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.Crit)
	sets.engaged.Grip.GreatAxe.DA = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.DA)
	sets.engaged.Grip.GreatAxe.SB = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.SB)
	sets.engaged.Grip.GreatAxe.sTP = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.sTP)
	sets.engaged.Grip.GreatAxe.STR = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.STR)
	sets.engaged.Grip.GreatAxe.Eva = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.Eva)
	sets.engaged.Grip.GreatAxe.DT = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.DT)
	sets.engaged.Grip.GreatAxe.Meva = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.Meva)

	sets.engaged.Grip.GreatSword.Acc = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.Acc)
	sets.engaged.Grip.GreatSword.Att = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.Att)
	sets.engaged.Grip.GreatSword.Crit = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.Crit)
	sets.engaged.Grip.GreatSword.DA = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.DA)
	sets.engaged.Grip.GreatSword.SB = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.SB)
	sets.engaged.Grip.GreatSword.sTP = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.sTP)
	sets.engaged.Grip.GreatSword.STR = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.STR)
	sets.engaged.Grip.GreatSword.Eva = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.Eva)
	sets.engaged.Grip.GreatSword.DT = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.DT)
	sets.engaged.Grip.GreatSword.Meva = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.Meva)
	
	sets.engaged.Grip.Scythe.Acc = set_combine(sets.engaged.Grip.Scythe, sets.Mode.Acc)
	sets.engaged.Grip.Scythe.Att = set_combine(sets.engaged.Grip.Scythe, sets.Mode.Att)
	sets.engaged.Grip.Scythe.Crit = set_combine(sets.engaged.Grip.Scythe, sets.Mode.Crit)
	sets.engaged.Grip.Scythe.DA = set_combine(sets.engaged.Grip.Scythe, sets.Mode.DA)
	sets.engaged.Grip.Scythe.SB = set_combine(sets.engaged.Grip.Scythe, sets.Mode.SB)
	sets.engaged.Grip.Scythe.sTP = set_combine(sets.engaged.Grip.Scythe, sets.Mode.sTP)
	sets.engaged.Grip.Scythe.STR = set_combine(sets.engaged.Grip.Scythe, sets.Mode.STR)
	sets.engaged.Grip.Scythe.Eva = set_combine(sets.engaged.Grip.Scythe, sets.Mode.Eva)
	sets.engaged.Grip.Scythe.DT = set_combine(sets.engaged.Grip.Scythe, sets.Mode.DT)
	sets.engaged.Grip.Scythe.Meva = set_combine(sets.engaged.Grip.Scythe, sets.Mode.Meva)

	sets.engaged.Grip.GreatKatana.Acc = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.Acc)
	sets.engaged.Grip.H2H.Acc = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.Acc)
	
	sets.engaged.DW.Axe.Acc = set_combine(sets.engaged.DW.Axe, sets.Mode.Acc)
	sets.engaged.DW.Axe.Att = set_combine(sets.engaged.DW.Axe, sets.Mode.Att)
	sets.engaged.DW.Axe.Crit = set_combine(sets.engaged.DW.Axe, sets.Mode.Crit)
	sets.engaged.DW.Axe.DA = set_combine(sets.engaged.DW.Axe, sets.Mode.DA)
	sets.engaged.DW.Axe.SB = set_combine(sets.engaged.DW.Axe, sets.Mode.SB)
	sets.engaged.DW.Axe.sTP = set_combine(sets.engaged.DW.Axe, sets.Mode.sTP)
	sets.engaged.DW.Axe.STR = set_combine(sets.engaged.DW.Axe, sets.Mode.STR)
	sets.engaged.DW.Axe.Eva = set_combine(sets.engaged.DW.Axe, sets.Mode.Eva)
	sets.engaged.DW.Axe.DT = set_combine(sets.engaged.DW.Axe, sets.Mode.DT)
	sets.engaged.DW.Axe.Meva = set_combine(sets.engaged.DW.Axe, sets.Mode.Meva)
	sets.engaged.Shield.Axe.Acc = set_combine(sets.engaged.Shield.Axe, sets.Mode.Acc)
	sets.engaged.Shield.Axe.Att = set_combine(sets.engaged.Shield.Axe, sets.Mode.Att)
	sets.engaged.Shield.Axe.Crit = set_combine(sets.engaged.Shield.Axe, sets.Mode.Crit)
	sets.engaged.Shield.Axe.DA = set_combine(sets.engaged.Shield.Axe, sets.Mode.DA)
	sets.engaged.Shield.Axe.SB = set_combine(sets.engaged.Shield.Axe, sets.Mode.SB)
	sets.engaged.Shield.Axe.sTP = set_combine(sets.engaged.Shield.Axe, sets.Mode.sTP)
	sets.engaged.Shield.Axe.STR = set_combine(sets.engaged.Shield.Axe, sets.Mode.STR)
	sets.engaged.Shield.Axe.Eva = set_combine(sets.engaged.Shield.Axe, sets.Mode.Eva)
	sets.engaged.Shield.Axe.DT = set_combine(sets.engaged.Shield.Axe, sets.Mode.DT)
	sets.engaged.Shield.Axe.Meva = set_combine(sets.engaged.Shield.Axe, sets.Mode.Meva)
	
	sets.engaged.DW.Club.Acc = set_combine(sets.engaged.DW.Club, sets.Mode.Acc)
	sets.engaged.DW.Club.Att = set_combine(sets.engaged.DW.Club, sets.Mode.Att)
	sets.engaged.DW.Club.Crit = set_combine(sets.engaged.DW.Club, sets.Mode.Crit)
	sets.engaged.DW.Club.DA = set_combine(sets.engaged.DW.Club, sets.Mode.DA)
	sets.engaged.DW.Club.SB = set_combine(sets.engaged.DW.Club, sets.Mode.SB)
	sets.engaged.DW.Club.sTP = set_combine(sets.engaged.DW.Club, sets.Mode.sTP)
	sets.engaged.DW.Club.STR = set_combine(sets.engaged.DW.Club, sets.Mode.STR)
	sets.engaged.DW.Club.Eva = set_combine(sets.engaged.DW.Club, sets.Mode.Eva)
	sets.engaged.DW.Club.DT = set_combine(sets.engaged.DW.Club, sets.Mode.DT)
	sets.engaged.DW.Club.Meva = set_combine(sets.engaged.DW.Club, sets.Mode.Meva)
	sets.engaged.Shield.Club.Acc = set_combine(sets.engaged.Shield.Club, sets.Mode.Acc)
	sets.engaged.Shield.Club.Att = set_combine(sets.engaged.Shield.Club, sets.Mode.Att)
	sets.engaged.Shield.Club.Crit = set_combine(sets.engaged.Shield.Club, sets.Mode.Crit)
	sets.engaged.Shield.Club.DA = set_combine(sets.engaged.Shield.Club, sets.Mode.DA)
	sets.engaged.Shield.Club.SB = set_combine(sets.engaged.Shield.Club, sets.Mode.SB)
	sets.engaged.Shield.Club.sTP = set_combine(sets.engaged.Shield.Club, sets.Mode.sTP)
	sets.engaged.Shield.Club.STR = set_combine(sets.engaged.Shield.Club, sets.Mode.STR)
	sets.engaged.Shield.Club.Eva = set_combine(sets.engaged.Shield.Club, sets.Mode.Eva)
	sets.engaged.Shield.Club.DT = set_combine(sets.engaged.Shield.Club, sets.Mode.DT)
	sets.engaged.Shield.Club.Meva = set_combine(sets.engaged.Shield.Club, sets.Mode.Meva)

	sets.engaged.DW.Dagger.Acc = set_combine(sets.engaged.DW.Dagger, sets.Mode.Acc)
	sets.engaged.DW.Dagger.Att = set_combine(sets.engaged.DW.Dagger, sets.Mode.Att)
	sets.engaged.DW.Dagger.Crit = set_combine(sets.engaged.DW.Dagger, sets.Mode.Crit)
	sets.engaged.DW.Dagger.DA = set_combine(sets.engaged.DW.Dagger, sets.Mode.DA)
	sets.engaged.DW.Dagger.SB = set_combine(sets.engaged.DW.Dagger, sets.Mode.SB)
	sets.engaged.DW.Dagger.sTP = set_combine(sets.engaged.DW.Dagger, sets.Mode.sTP)
	sets.engaged.DW.Dagger.STR = set_combine(sets.engaged.DW.Dagger, sets.Mode.STR)
	sets.engaged.DW.Dagger.Eva = set_combine(sets.engaged.DW.Dagger, sets.Mode.Eva)
	sets.engaged.DW.Dagger.DT = set_combine(sets.engaged.DW.Dagger, sets.Mode.DT)
	sets.engaged.DW.Dagger.Meva = set_combine(sets.engaged.DW.Dagger, sets.Mode.Meva)
	sets.engaged.Shield.Dagger.Acc = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Acc)
	sets.engaged.Shield.Dagger.Att = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Att)
	sets.engaged.Shield.Dagger.Crit = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Crit)
	sets.engaged.Shield.Dagger.DA = set_combine(sets.engaged.Shield.Dagger, sets.Mode.DA)
	sets.engaged.Shield.Dagger.SB = set_combine(sets.engaged.Shield.Dagger, sets.Mode.SB)
	sets.engaged.Shield.Dagger.sTP = set_combine(sets.engaged.Shield.Dagger, sets.Mode.sTP)
	sets.engaged.Shield.Dagger.STR = set_combine(sets.engaged.Shield.Dagger, sets.Mode.STR)
	sets.engaged.Shield.Dagger.Eva = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Eva)
	sets.engaged.Shield.Dagger.DT = set_combine(sets.engaged.Shield.Dagger, sets.Mode.DT)
	sets.engaged.Shield.Dagger.Meva = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Meva)

	sets.engaged.DW.Katana.Acc = set_combine(sets.engaged.DW.Katana, sets.Mode.Acc)
	sets.engaged.DW.Katana.Att = set_combine(sets.engaged.DW.Katana, sets.Mode.Att)
	sets.engaged.DW.Katana.Crit = set_combine(sets.engaged.DW.Katana, sets.Mode.Crit)
	sets.engaged.DW.Katana.DA = set_combine(sets.engaged.DW.Katana, sets.Mode.DA)
	sets.engaged.DW.Katana.SB = set_combine(sets.engaged.DW.Katana, sets.Mode.SB, {})
	sets.engaged.DW.Katana.sTP = set_combine(sets.engaged.DW.Katana, sets.Mode.sTP)
	sets.engaged.DW.Katana.STR = set_combine(sets.engaged.DW.Katana, sets.Mode.STR)
	sets.engaged.Shield.Katana.Acc = set_combine(sets.engaged.Shield.Katana, sets.Mode.Acc)
	sets.engaged.Shield.Katana.Att = set_combine(sets.engaged.Shield.Katana, sets.Mode.Att)
	sets.engaged.Shield.Katana.Crit = set_combine(sets.engaged.Shield.Katana, sets.Mode.Crit)
	sets.engaged.Shield.Katana.DA = set_combine(sets.engaged.Shield.Katana, sets.Mode.DA)
	sets.engaged.Shield.Katana.SB = set_combine(sets.engaged.Shield.Katana, sets.Mode.SB)
	sets.engaged.Shield.Katana.sTP = set_combine(sets.engaged.Shield.Katana, sets.Mode.sTP)
	sets.engaged.Shield.Katana.STR = set_combine(sets.engaged.Shield.Katana, sets.Mode.STR)

	sets.engaged.DW.Sword.Acc = set_combine(sets.engaged.DW.Sword, sets.Mode.Acc)
	sets.engaged.DW.Sword.Att = set_combine(sets.engaged.DW.Sword, sets.Mode.Att)
	sets.engaged.DW.Sword.Crit = set_combine(sets.engaged.DW.Sword, sets.Mode.Crit)
	sets.engaged.DW.Sword.DA = set_combine(sets.engaged.DW.Sword, sets.Mode.DA)
	sets.engaged.DW.Sword.SB = set_combine(sets.engaged.DW.Sword, sets.Mode.SB, {})
	sets.engaged.DW.Sword.sTP = set_combine(sets.engaged.DW.Sword, sets.Mode.sTP)
	sets.engaged.DW.Sword.STR = set_combine(sets.engaged.DW.Sword, sets.Mode.STR)
	sets.engaged.DW.Sword.Eva = set_combine(sets.engaged.DW.Sword, sets.Mode.Eva)
	sets.engaged.DW.Sword.DT = set_combine(sets.engaged.DW.Sword, sets.Mode.DT)
	sets.engaged.DW.Sword.Meva = set_combine(sets.engaged.DW.Sword, sets.Mode.Meva)
	sets.engaged.Shield.Sword.Acc = set_combine(sets.engaged.Shield.Sword, sets.Mode.Acc)
	sets.engaged.Shield.Sword.Att = set_combine(sets.engaged.Shield.Sword, sets.Mode.Att)
	sets.engaged.Shield.Sword.Crit = set_combine(sets.engaged.Shield.Sword, sets.Mode.Crit)
	sets.engaged.Shield.Sword.DA = set_combine(sets.engaged.Shield.Sword, sets.Mode.DA)
	sets.engaged.Shield.Sword.SB = set_combine(sets.engaged.Shield.Sword, sets.Mode.SB, {})
	sets.engaged.Shield.Sword.sTP = set_combine(sets.engaged.Shield.Sword, sets.Mode.sTP)
	sets.engaged.Shield.Sword.STR = set_combine(sets.engaged.Shield.Sword, sets.Mode.STR)
	sets.engaged.Shield.Sword.Eva = set_combine(sets.engaged.Shield.Sword, sets.Mode.Eva)
	sets.engaged.Shield.Sword.DT = set_combine(sets.engaged.Shield.Sword, sets.Mode.DT)
	sets.engaged.Shield.Sword.Meva = set_combine(sets.engaged.Shield.Sword, sets.Mode.Meva)

	sets.engaged.Grip.Polearm.Acc = set_combine(sets.engaged.Grip.Polearm, sets.Mode.Acc)
	sets.engaged.Grip.Polearm.Att = set_combine(sets.engaged.Grip.Polearm, sets.Mode.Att)
	sets.engaged.Grip.Polearm.Crit = set_combine(sets.engaged.Grip.Polearm, sets.Mode.Crit)
	sets.engaged.Grip.Polearm.DA = set_combine(sets.engaged.Grip.Polearm, sets.Mode.DA)
	sets.engaged.Grip.Polearm.SB = set_combine(sets.engaged.Grip.Polearm, sets.Mode.SB)
	sets.engaged.Grip.Polearm.sTP = set_combine(sets.engaged.Grip.Polearm, sets.Mode.sTP)
	sets.engaged.Grip.Polearm.STR = set_combine(sets.engaged.Grip.Polearm, sets.Mode.STR)
	sets.engaged.Grip.Polearm.Eva = set_combine(sets.engaged.Grip.Polearm, sets.Mode.Eva)
	sets.engaged.Grip.Polearm.DT = set_combine(sets.engaged.Grip.Polearm, sets.Mode.DT)
	sets.engaged.Grip.Polearm.Meva = set_combine(sets.engaged.Grip.Polearm, sets.Mode.Meva)			

	sets.engaged.Grip.Staff.Acc = set_combine(sets.engaged.Grip.Staff, sets.Mode.Acc)
	sets.engaged.Grip.Staff.Att = set_combine(sets.engaged.Grip.Staff, sets.Mode.Att)
	sets.engaged.Grip.Staff.Crit = set_combine(sets.engaged.Grip.Staff, sets.Mode.Crit)
	sets.engaged.Grip.Staff.DA = set_combine(sets.engaged.Grip.Staff, sets.Mode.DA)
	sets.engaged.Grip.Staff.SB = set_combine(sets.engaged.Grip.Staff, sets.Mode.SB)
	sets.engaged.Grip.Staff.sTP = set_combine(sets.engaged.Grip.Staff, sets.Mode.sTP)
	sets.engaged.Grip.Staff.STR = set_combine(sets.engaged.Grip.Staff, sets.Mode.STR)
	sets.engaged.Grip.Staff.Eva = set_combine(sets.engaged.Grip.Staff, sets.Mode.Eva)
	sets.engaged.Grip.Staff.DT = set_combine(sets.engaged.Grip.Staff, sets.Mode.DT)
	sets.engaged.Grip.Staff.Meva = set_combine(sets.engaged.Grip.Staff, sets.Mode.Meva)			
	
	-- Precast Sets
    sets.precast.JA.Berserk = {body="Pumm. Lorica +1",back="Cichol's Mantle",feet="Agoge Calligae"}
    sets.precast.JA['Aggressor'] = {head="Fighter's Mask",body="Warrior's Lorica"}
    sets.precast.JA['Mighty Strikes'] = {hands="Agoge Mufflers +1"}
    sets.precast.JA['Blood Rage'] = {body="Boii Lorica"}
    sets.precast.JA['Warcry'] = {head="Agoge Mask +2"}
    sets.precast.JA['Restraint'] = {head="Boii Mufflers"}
    sets.precast.JA['Retaliation'] = {head="Boii Calligae",hands="Pumm. Mufflers"}
    sets.precast.JA['Tomahawk'] = {ammo="Thr. Tomahawk",feet="Agoge Calligae"}
    sets.precast.JA["Warrior's Charge"] = {legs="Warrior's Cuisses"}
	sets.precast.JA['Jump'] = {feet="Ostro Greaves"}
	sets.precast.JA['High Jump'] = set_combine(sets.precast.JA['Jump'], {})
	sets.precast.JA['Super Jump'] = {
			head="Twilight Helm",
			body="Twilight Mail"}
    
	-- Sets to apply to any actions of spell.type
	-- Waltz set (chr and vit)
	sets.precast.Waltz = {
		head="Nyame Helm",
		body="Sacro Breastplate",hands="Buremte Gloves",ring1="Metamor. Ring +1",
		legs="Nyame Flanchard",feet="Nyame Sollerets"}
		   
	-- Don't need any special gear for Healing Waltz.
	sets.precast.Waltz['Healing Waltz'] = {}
   
	-- Fast cast sets for spells
	sets.precast.FC = {neck="Orunmila's Torque",lear="Etiolation Earring",
		body="Sacro Breastplate",hands="Leyline Gloves",ring1="Naji's Loop",ring2="Prolix Ring",
		legs="Limbo Trousers"}

	-- Midcast Sets
	-- sets.midcast.FastRecast = {}     

	-- Ranged gear
    sets.midcast.RA = {
        head="Nyame Helm",neck="Null Loop",lear="Enervating Earring",
        body="Nyame Mail",hands="Nyame Gauntlets",ring1="Paqichikaji Ring",ring2="Cacoethic Ring +1",
        waist="Eschan Stone",legs="Nyame Flanchard",feet="Nyame Sollerets"}
		   
	-- Weaponskill sets
	-- Default set for any weaponskill that isn't any more specifically defined
	sets.WSDayBonus = {head="Gavialis Helm"} 
	sets.precast.WS = set_combine(sets.Mode.STR, {
		head="Agoge Mask +2",neck="Fotia Gorget",lear="Thrud Earring",rear="Ishvara Earring",
		body="Pumm. Lorica +1",hands="Sakpata's Gauntlets",ring1="Cornelia's Ring",ring2="Epaminondas's Ring",
		back=gear.wsdCape,waist="Fotia Belt",feet="Sulev. Leggings +2"})
   
	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	-- Thunder, STR 60% VIT 60%
	sets.precast.WS['Shield Break'] = set_combine(sets.precast.WS, {})

	-- Earth, STR 60% 
	sets.precast.WS['Iron Tempest'] = set_combine(sets.precast.WS, {})

	-- Earth/Water, STR 60% 
	sets.precast.WS['Sturmwind'] = set_combine(sets.precast.WS, {})

	-- Thunder, STR 60% VIT 60%
	sets.precast.WS['Armor Break'] = set_combine(sets.precast.WS, {})

	-- Dark, STR 100%
	sets.precast.WS['Keen Edge'] = set_combine(sets.precast.WS, {})

	-- Thunder, STR 60% VIT 60%
	sets.precast.WS['Weapon Break'] = set_combine(sets.precast.WS, {})

	-- Ice/Water, STR 50% 
	sets.precast.WS['Raging Rush'] = set_combine(sets.precast.WS, {})
	
	-- Ice/Water, STR 50% VIT 50%
	sets.precast.WS['Full Break'] = set_combine(sets.precast.WS, {})
	
	-- Ice/Water/Wind, STR 60% VIT 60%
	sets.precast.WS['Steel Cyclone'] = set_combine(sets.precast.WS, {})
	
	-- Earth/Thunder/Wind, STR 60%
	sets.precast.WS['Fell Cleave'] = set_combine(sets.precast.WS, {})
	
	-- Fire/Light/Dark, STR 60%
	sets.precast.WS['Upheaval'] = set_combine(sets.precast.WS, {})
	
	-- Wind/Thunder/Light, STR 80%
	sets.precast.WS["Ukko's Fury"] = set_combine(sets.precast.WS, {
		head="Sakpata's Helm",body="Sakpata's Plate",hands="Sakpata's Gauntlets",legs="Sakpata's Cuisses"})
	
	-- Earth/Thunder/Wind, STR 50%
	sets.precast.WS["King's Justice"] = set_combine(sets.precast.WS, {})
	
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
	
	-- Earth/Wind/Thunder, STR 73%
	sets.precast.WS['Resolution'] = set_combine(sets.precast.WS, {})

	-- Light, STR 30% DEX 30%
	sets.precast.WS['Double Thrust'] = set_combine(sets.precast.WS, {})
		
	-- Light/Thunder, STR 40% INT 40%
	sets.precast.WS['Thunder Thrust'] = set_combine(sets.precast.WS, {})

	-- Light/Thunder, STR 40% INT 40% 
	sets.precast.WS['Raiden Thrust'] = set_combine(sets.precast.WS, {})

	-- Thunder, STR 100%
	sets.precast.WS['Leg Sweep'] = set_combine(sets.precast.WS, {})

	-- Darkness, STR 20% DEX 20% 
	sets.precast.WS['Penta Thrust'] = set_combine(sets.precast.WS, {})

	-- Light/Water, STR 50% AGI 50% 
	sets.precast.WS['Vorpal Thrust'] = set_combine(sets.precast.WS, {})

	-- Dark/Earth/Ice, STR 100% -->
	sets.precast.WS['Impulse Drive'] = set_combine(sets.precast.WS, {})

	-- Light/Earth, STR 40% DEX 40%-->
	sets.precast.WS['Sonic Thrust'] = set_combine(sets.precast.WS, {})

	-- Dark/Earth/Light, STR 85% -->
	sets.precast.WS['Stardiver'] = set_combine(sets.precast.WS, {})

	-- Defense sets
	sets.defense = {}
	sets.defense.Reraise = {head="Twilight Helm", body="Twilight Mail"}
	sets.defense.Evasion = set_combine(sets.Mode.Eva, {})
	sets.defense.PDT = set_combine(sets.Mode.DT, {})
	sets.defense.MDT = set_combine(sets.Mode.Meva, {})
	sets.debuffed = set_combine(sets.Mode.DT,sets.Mode.Meva)
	sets.doom = set_combine(sets.debuffed,sets.defense.Reraise,{waist="Gishdubar Sash"})

	sets.Kiting = {}

	-- Melee sets for in Adoulin, which has an extra 2% Haste from Ionis.
	sets.engaged.Adoulin = set_combine(sets.engaged, {})
	-- sets.Assault = {ring2="Ulthalam's Ring"}
end
 
-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks that are called to process player actions at specific points in time.
-------------------------------------------------------------------------------------------------------------------
 
-- Set eventArgs.handled to true if we don't want any automatic target handling to be done.
function job_pretarget(spell, action, spellMap, eventArgs)
	-- add_to_chat(120,'stance is '..state.Stance.value)
end
 
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    check_ws_dist(spell)
end
 
-- Run after the default precast() is done.
-- eventArgs is the same one used in job_precast, in case information needs to be persisted.
function job_post_precast(spell, action, spellMap, eventArgs)
	if spell.type == 'WeaponSkill' then
        if is_sc_element_today(spell) then
			-- add_to_chat(122,' WS Day ')
            equip(sets.WSDayBonus)
        end
	end 
end
 
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)

end
 
-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
   
end
 
-- Runs when a pet initiates an action.
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_pet_midcast(spell, action, spellMap, eventArgs)
	-- add_to_chat(122,'pet midcast')
end

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
end
 
-- Run after the default pet midcast() is done.
-- eventArgs is the same one used in job_pet_midcast, in case information needs to be persisted.
function job_pet_post_midcast(spell, action, spellMap, eventArgs)
    -- add_to_chat(122,'pet post midcast')   
end
 
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
	--add_to_chat(122,'aftercast')
end
 
-- Run after the default aftercast() is done.
-- eventArgs is the same one used in job_aftercast, in case information needs to be persisted.
function job_post_aftercast(spell, action, spellMap, eventArgs)
	-- add_to_chat(122,'post aftercast')
end
 
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_pet_aftercast(spell, action, spellMap, eventArgs)
	-- add_to_chat(122,'pet aftercast')
end
 
-- Run after the default pet aftercast() is done.
-- eventArgs is the same one used in job_pet_aftercast, in case information needs to be persisted.
function job_pet_post_aftercast(spell, action, spellMap, eventArgs)
	-- add_to_chat(122,'post pet aftercast')
end
 
-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
-------------------------------------------------------------------------------------------------------------------
 
-- Called before the Include starts constructing melee/idle/resting sets.
-- Can customize state or custom melee class values at this point.
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_handle_equipping_gear(status, eventArgs)
	-- add_to_chat(122,'handle equiping gear')
	check_tp_lock()
	set_combat_form()
	pick_tp_weapon()
	handle_twilight()
end
 
function select_ammo_type(t)
	if state.RWeaponMode.value == "Stats" then
		gear.JobAmmo.name = gear.StatsAmmo
		gear.JobRanged.name = gear.empty
	elseif state.RWeaponMode.value == "Bow" then
		gear.JobAmmo.name = gear.BowAmmo
		gear.useWSAmmo.name = gear.BowAmmo
		gear.JobRanged.name = gear.BowRanged
	elseif state.RWeaponMode.value == "XBow" then
		gear.JobAmmo.name = gear.XBowAmmo
		gear.useWSAmmo.name = gear.XBowAmmo
		gear.JobRanged.name = gear.XBowRanged
	elseif state.RWeaponMode.value == "Boomerrang" then
		gear.JobAmmo.name = gear.Boomerrang
		gear.useWSAmmo.name = gear.Boomerrang
		gear.JobRanged.name = gear.Boomerrang
	else
		gear.JobAmmo.name = gear.StatsAmmo
		gear.useWSAmmo.name = gear.WSAmmo
		gear.JobRanged.name = gear.empty
	end
end 
 
-- Return a customized weaponskill mode to use for weaponskill sets.
-- Don't return anything if you're not overriding the default value.
function get_custom_wsmode(spell, action, spellMap)
	-- add_to_chat(122,'get custom wsmode')
end
 
-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
	-- add_to_chat(122,'customize idle set')
    if not buffactive["Reraise"] then
		idleSet = set_combine(idleSet, sets.defense.Reraise)
	end
    return idleSet
end
 
-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
	if areas.Assault:contains(world.area) then
		meleeSet = set_combine(meleeSet, sets.Assault)
	end

    return meleeSet
end
 
-------------------------------------------------------------------------------------------------------------------
-- General hooks for other events.
-------------------------------------------------------------------------------------------------------------------
 
-- Called when the player's status changes.
function job_status_change(newStatus, oldStatus, eventArgs)
	-- add_to_chat(122,'job_status_change')
end
 
-- Called when the player's pet's status changes.
function job_pet_status_change(newStatus, oldStatus, eventArgs)
 
end
 
-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
	handle_debuffs()
	handle_war_ja()
	if player.sub_job == 'SAM' then
		handle_sam_ja()
	end
end
 
-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------
 
-- Called for custom player commands.
function job_self_command(cmdParams, eventArgs)
 
end
 
-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
	classes.CustomMeleeGroups:clear()
	if areas.Adoulin:contains(world.area) and buffactive.ionis then
			classes.CustomMeleeGroups:append('Adoulin')
	end
	if areas.Assault:contains(world.area) then
			classes.CustomMeleeGroups:append('Assault')
	end
	pick_tp_weapon()
	select_ammo_type('melee')
end
 
-- Job-specific toggles.
function job_toggle(field)
 
end
 
-- Request job-specific mode lists.
-- Return the list, and the current value for the requested field.
function job_get_mode_list(field)
 
end
 
-- Set job-specific mode values.
-- Return true if we recognize and set the requested field.
function job_set_mode(field, val)
 
end
 
-- Handle auto-targetting based on local setup.
function job_auto_change_target(spell, action, spellMap, eventArgs)
 
end
 
-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
 
end
 
-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_groups()
	-- add_to_chat(122,' determine groups')
	-- classes.CustomMeleeGroups:clear()
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'NIN' then
		set_macro_page(1, 8)
	elseif player.sub_job == 'SAM' then
		set_macro_page(1, 8)
	elseif player.sub_job == 'DNC' then
		set_macro_page(3, 8)
	else
		set_macro_page(1, 8)
	end
	send_command('exec war.txt')
end
