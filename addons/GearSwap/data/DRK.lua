include('organizer-lib.lua')
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

	-- Load and initialize the include file.
	include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
	state.WeaponMode = M{['description']='Weapon Mode', 'Scythe', 'GreatSword', 'GreatAxe', 'Sword', 'Club', 'Axe', 'Staff', 'Dagger'}
	state.SubMode = M{['description']='Sub Mode', 'Grip', 'DW', 'Shield'}
	state.RWeaponMode = M{['description']='RWeapon Mode', 'Stats', 'Xbow'}
  	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive'}
	set_combat_form()
	pick_tp_weapon()
end


-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'SB', 'sTP', 'STR')
	state.WeaponskillMode:options('Normal')
	state.CastingMode:options('Normal')
	state.DefenseMode:options('None', 'Physical', 'Magical')
	state.PhysicalDefenseMode:options('PDT', 'Evasion', 'Reraise')
	state.MagicalDefenseMode:options('MDT', 'Reraise')
	state.WeaponMode:set('Scythe')
	state.Stance:set('Offensive')
	state.SubMode:set('Grip')
	state.RWeaponMode:set('Stats') 
    Twilight = false

	pick_tp_weapon()
	select_default_macro_book()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()

end

function init_gear_sets()
	organizer_items = {
        new1="",
		new2="",
		new3="",
		new4="",
        new5="",
        new6="",
		new7="",
		echos="Echo Drops",
		shihei="Shihei",
		orb="Macrocosmic Orb"
	}
	-- add_to_chat(122,'init gear sets')
	--------------------------------------
	-- Start defining the sets
	--------------------------------------
	-- Sets to return to when not performing an action.
   
	-- Idle sets
	sets.idle = {head="Valorous Mask",neck="Elite Royal Collar",lear="Moonshade Earring",rear="Ethereal Earring",
		body="Sulevia's Plate. +2",hands="Sulev. Gauntlets +2",ring1="Defending Ring",ring2="Patricius Ring",
		back="Solemnity Cape",waist="Plat. Mog. Belt",legs="Carmine Cuisses +1",feet="Sulev. Leggings +2"}

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
		head="Flam. Zucchetto +2",neck="Ganesha's Mala",lear="Bladeborn Earring",rear="Steelflash Earring",
		body="Valorous Mail",hands="Ig. Gauntlets +2",ring1="Niqmaddu Ring",ring2="Hetairoi Ring",
		back="Atheling Mantle",waist="Ioskeha Belt",legs="Sulev. Cuisses +2",feet="Flam. Gambieras +2"}
			
	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {
        head="Flam. Zucchetto +2",neck="Combatant's Torque",lear="Zennaroi Earring",rear="Heath. Earring +1",
        body="Valorous Mail",hands="Emicho Gauntlets",ring1="Cacoethic Ring +1",ring2="Regal Ring",
        back="Lupine Cape",waist="Olseni Belt",legs="Carmine Cuisses +1",feet="Flam. Gambieras +2"})
	sets.Mode.Att= set_combine(sets.engaged, {
        head="Sulevia's Mask +2",neck="Rep. Plat. Medal",lear="Bladeborn Earring",rear="Heath. Earring +1",
        body="Phorcys Korazin",hands="Sulev. Gauntlets +2",ring1="Overbearing Ring",ring2="Regal Ring",
        back="Atheling Mantle",waist="Sulla Belt",legs="Emicho Hose",feet="Sulev. Leggings +2"})
	sets.Mode.Crit = set_combine(sets.engaged, {hands="Flam. Manopolas +2"})
	sets.Mode.DA = set_combine(sets.engaged, {
        head="Flam. Zucchetto +2",neck="Ganesha's Mala",lear="Trux Earring",rear="Brutal Earring",
        body="Valorous Mail",hands="Sulev. Gauntlets +2",ring1="Niqmaddu Ring",ring2="Hetairoi Ring",
        waist="Ioskeha Belt",legs="Sulev. Cuisses +2",feet="Flam. Gambieras +2"})
	sets.Mode.SB = set_combine(sets.engaged, {body="Sacro Breastplate"})
	sets.Mode.sTP = set_combine(sets.engaged, {
        head="Sulevia's Mask +2",neck="Combatant's Torque",lear="Tripudio Earring",rear="Enervating Earring",
        body="Valorous Mail",hands="Emicho Gauntlets",ring1="Rajas Ring",ring2="K'ayres Ring",
        back="Lupine Cape",legs="Phorcys Dirs",feet="Flam. Gambieras +2"})
	sets.Mode.STR = set_combine(sets.engaged, {
        head="Flam. Zucchetto +2",neck="Rep. Plat. Medal",lear="Thrud Earring",
        body="Ignominy Cuirass +2",hands="Sulev. Gauntlets +2",ring1="Niqmaddu Ring",ring2="Regal Ring",
        back="Lupine Cape",waist="Sailfi Belt +1",legs="Sulev. Cuisses +2",feet="Flam. Gambieras +2"})
			
	-- other Sets    
	sets.macc = {lear="Gwati Earring",ring1="Sangoma Ring",
		body="Sacro Breastplate"}
	sets.PDL = {}
	sets.empy = {head="Heathen's Burgonet",
		body="Heathen's Cuirass",hands="Heathen's Gauntlets",
		legs="Heathen's Flanchard",feet="Heathen's Sollerets"}

	-- Sets with weapons defined.
	sets.engaged.GreatAxe = {}
	sets.engaged.Axe = {}
	sets.engaged.GreatSword = {}
	sets.engaged.Scythe = {}
	sets.engaged.Sword = {}
	sets.engaged.Staff = {}
	sets.engaged.Club = {}
	sets.engaged.Dagger = {}
	sets.engaged.DW = set_combine(sets.engaged, {})
	sets.engaged.Shield = set_combine(sets.engaged, {})
	sets.engaged.Grip = set_combine(sets.engaged, {})
	sets.engaged.DW.Axe = set_combine(sets.engaged, {main="Kumbhakarna",sub="Perun +1"})
	sets.engaged.Shield.Axe = set_combine(sets.engaged, {main="Kumbhakarna",sub="Adapa Shield"})
	sets.engaged.DW.Club = set_combine(sets.engaged, {main="Warp Cudgel",sub="Kumbhakarna"})
	sets.engaged.Shield.Club = set_combine(sets.engaged, {main="Warp Cudgel",sub="Adapa Shield"})
	sets.engaged.DW.Dagger = set_combine(sets.engaged, {main="Twilight Knife",sub="Kumbhakarna"})
	sets.engaged.Shield.Dagger = set_combine(sets.engaged, {main="Twilight Knife",sub="Adapa Shield"})
	sets.engaged.Grip.GreatAxe = set_combine(sets.engaged, {main="Ixtab",sub="Khonsu"})
	sets.engaged.Grip.GreatSword = set_combine(sets.engaged, {main="Zulfiqar",sub="Khonsu"})
	sets.engaged.Grip.Scythe = set_combine(sets.engaged, {main="Deathbane", sub="Khonsu"})
	sets.engaged.Grip.Staff = set_combine(sets.engaged, {main="Gozuki Mezuki", sub="Khonsu"})
	sets.engaged.DW.Sword = set_combine(sets.engaged, {main="Naegling",sub="Tanmogayi +1"})
	sets.engaged.Shield.Sword = set_combine(sets.engaged, {main="Naegling",sub="Adapa Shield"})
	--Add in appropriate Ranged weapons
	sets.ranged = {}
	sets.ranged.Stats = {ranged="",ammo="Knobkierrie"}
	sets.ranged.Xbow = {ranged="Tsoa. Crossbow",ammo="Bloody Bolt"}
	
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
	sets.engaged.DW.Sword.Xbow = set_combine(sets.engaged.DW.Sword, sets.ranged.Xbow)
	sets.engaged.DW.Sword.Stats = set_combine(sets.engaged.DW.Sword, sets.ranged.Stats)
	sets.engaged.Shield.Sword.Xbow = set_combine(sets.engaged.Shield.Sword, sets.ranged.Xbow)
	sets.engaged.Shield.Sword.Stats = set_combine(sets.engaged.Shield.Sword, sets.ranged.Stats)

	sets.engaged.Grip.GreatAxe.Xbow = set_combine(sets.engaged.Grip.GreatAxe, sets.ranged.Xbow)
	sets.engaged.Grip.GreatAxe.Stats = set_combine(sets.engaged.Grip.GreatAxe, sets.ranged.Stats)
	sets.engaged.Grip.GreatSword.Xbow = set_combine(sets.engaged.Grip.GreatSword, sets.ranged.Xbow)
	sets.engaged.Grip.GreatSword.Stats = set_combine(sets.engaged.Grip.GreatSword, sets.ranged.Stats)
	sets.engaged.Grip.Scythe.Xbow = set_combine(sets.engaged.Grip.Scythe, sets.ranged.Xbow)
	sets.engaged.Grip.Scythe.Stats = set_combine(sets.engaged.Grip.Scythe, sets.ranged.Stats)
	sets.engaged.Grip.Staff.Xbow = set_combine(sets.engaged.Grip.Staff, sets.ranged.Xbow)
	sets.engaged.Grip.Staff.Stats = set_combine(sets.engaged.Grip.Staff, sets.ranged.Stats)
	
	sets.engaged.Grip.GreatAxe.Acc = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.Acc)
	sets.engaged.Grip.GreatAxe.Att = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.Att)
	sets.engaged.Grip.GreatAxe.Crit = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.Crit)
	sets.engaged.Grip.GreatAxe.DA = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.DA)
	sets.engaged.Grip.GreatAxe.SB = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.SB)
	sets.engaged.Grip.GreatAxe.sTP = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.sTP)
	sets.engaged.Grip.GreatAxe.STR = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.STR)

	sets.engaged.Grip.GreatSword.Acc = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.Acc)
	sets.engaged.Grip.GreatSword.Att = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.Att)
	sets.engaged.Grip.GreatSword.Crit = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.Crit)
	sets.engaged.Grip.GreatSword.DA = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.DA)
	sets.engaged.Grip.GreatSword.SB = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.SB)
	sets.engaged.Grip.GreatSword.sTP = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.sTP)
	sets.engaged.Grip.GreatSword.STR = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.STR)
	
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
	sets.engaged.Grip.Staff.Att = set_combine(sets.engaged.Grip.Staff, sets.Mode.Att)
	sets.engaged.Grip.Staff.Crit = set_combine(sets.engaged.Grip.Staff, sets.Mode.Crit)
	sets.engaged.Grip.Staff.DA = set_combine(sets.engaged.Grip.Staff, sets.Mode.DA)
	sets.engaged.Grip.Staff.SB = set_combine(sets.engaged.Grip.Staff, sets.Mode.SB)
	sets.engaged.Grip.Staff.sTP = set_combine(sets.engaged.Grip.Staff, sets.Mode.sTP)
	sets.engaged.Grip.Staff.STR = set_combine(sets.engaged.Grip.Staff, sets.Mode.STR)	
	--------------------------------------
	-- Precast sets
	--------------------------------------
	-- Weaponskill sets
	-- Default set for any weaponskill that isn't any more specifically defined
	sets.WSDayBonus = {head="Gavialis Helm"} 

	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	sets.precast.WS = set_combine(sets.Mode.STR, {
		neck="Fotia Gorget",lear="Thrud Earring",rear="Heath. Earring +1",
		body="Ignominy Cuirass +2",ring1="Cornelia's Ring",ring2="Epaminondas's Ring",
		back=gear.wsdCape,waist="Fotia Belt",feet="Sulev. Leggings +2"})
   
	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	-- Earth, STR 100%
	sets.precast.WS['Slice'] = set_combine(sets.precast.WS, {})
	
	-- Water, STR 40% INT 40%
	sets.precast.WS['Dark Harvest'] = set_combine(sets.precast.WS, {})

	-- Water/Ice, STR 40% INT 40%
	sets.precast.WS['Shadow of Death'] = set_combine(sets.precast.WS, {})
	
	-- Earth/Dark, STR 60% MND 60%
	sets.precast.WS['Nightmare Scythe'] = set_combine(sets.precast.WS, {})
	
	-- Earth/Water, STR 100%
	sets.precast.WS['Spinning Scythe'] = set_combine(sets.precast.WS, {})
	
	-- Earth/Light, STR 100%
	sets.precast.WS['Vorpal Scythe'] = set_combine(sets.precast.WS, {})
	
	-- Ice, STR 30% MND 50%
	sets.precast.WS['Guillotine'] = set_combine(sets.precast.WS, {})
	
	-- Water/Ice, STR 60% MND 60%
	sets.precast.WS['Cross Reaper'] = set_combine(sets.precast.WS, {})

	-- Water/Earth/Ice, STR 50% INT 50%
	sets.precast.WS['Spiral Hell'] = set_combine(sets.precast.WS, {})
	
	-- Fire/Light/Dark, STR 20% INT 20%
	sets.precast.WS['Insurgency'] = set_combine(sets.precast.WS, {})

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

	-- Sets to apply to arbitrary JAs
	sets.precast.JA['Weapon Bash'] = {hands="Ig. Gauntlets +2"}
	sets.precast.JA['Dark Seal'] = {head="Abs. Burgeonet +2"}
	sets.precast.JA['Diabolic Eye'] = {hands="Abs. Gauntlets +2"}
	sets.precast.JA['Blood Weapon'] = {body="Abs. Cuirass +2"}
	sets.precast.JA['Souleater'] = {head="Ig. Burgeonet +2"}
    
    -- Fast cast sets for spells

    sets.precast.FC = { 
		neck="Orunmila's Torque",lear="Etiolation Earring",
        body="Sacro Breastplate",ring1="Kishar Ring",ring2="Prolix Ring"}

    sets.precast.FC['Dark Magic'] = set_combine(sets.precast.FC, {head="Abs. Burgeonet +2"})
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {neck="Incanter's Torque"})

    sets.precast.FC['Enfeebling Magic'] = set_combine(sets.precast.FC, {})
   
    -- Fast cast gear for specific spells or spell maps
	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})

    -- Elemental Magic sets
	sets.midcast['Elemental Magic'] = set_combine(sets.macc, {
        neck="Sanctity Necklace",rear="Friomisi Earring",
        body="Sacro Breastplate",ring1="Metamor. Ring +1",ring2="Metamor. Ring +1",
        waist="Eschan Stone"})

    sets.midcast['Elemental Magic'].Macc =  set_combine(set_combine(sets.macc, {})
	
    sets.midcast['Enfeebling Magic'] = set_combine(sets.macc, {
		neck="Incanter's Torque",
        body="Ignominy Cuirass +2",ring1="Kishar Ring",ring2="Globidonta Ring"})
        
    sets.midcast['Dark Magic'] = set_combine(sets.macc, {
        head="Ig. Burgeonet +2",neck="Erra Pendant",
        hands="Abs. Gauntlets +2",ring1="Evanescence Ring",ring2="Kishar Ring"})

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'],{neck="Erra Pendant",ring2="Excelsis Ring"})
    
    sets.midcast.Aspir = set_combine(sets.midcast.Drain, {})

    sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'],{})

	-- Specific spells
	sets.midcast.Utsusemi = {}

	-- Defense sets
	sets.defense = {}
	
	sets.defense.Evasion = {
        head="Flam. Zucchetto +2",lear="Infused Earring",rear="Eabani Earring",
        body="Sacro Breastplate",hands="Flam. Manopolas +2",ring1="Vengeful Ring",ring2="Beeline Ring",
        legs="Limbo Trousers",feet="Flam. Gambieras +2"}

	sets.defense.PDT = {
        head="Sulevia's Mask +2",neck="Elite Royal Collar",
        body="Sulevia's Plate. +2",hands="Sulev. Gauntlets +2",ring1="Defending Ring",ring2="Patricius Ring",
        back="Solemnity Cape",waist="Plat. Mog. Belt",legs="Sulev. Cuisses +2",feet="Sulev. Leggings +2"}

	sets.defense.MDT = {
        head="Sulevia's Mask +2",neck="Elite Royal Collar",lear="Etiolation Earring",rear="Eabani Earring",
        body="Sulevia's Plate. +2",hands="Sulev. Gauntlets +2",ring1="Defending Ring",ring2="Moonbeam Ring",
        back="Reiki Cloak",waist="Plat. Mog. Belt",legs="Sulev. Cuisses +2",feet="Sulev. Leggings +2"}

	sets.defense.Reraise = {head="Twilight Helm", body="Twilight Mail"}

	sets.debuffed = set_combine(sets.defense.Evasion,sets.defense.PDT,sets.defense.MDT)
	sets.doom = set_combine(sets.debuffed,{waist="Gishdubar Sash"})
	
	sets.Kiting = {legs="Carmine Cuisses +1"}

	-- These sets use a piece of gear in specific situations, need to customize_idle_set or customize_melee_set
	-- sets.Assault = {ring2="Ulthalam's Ring"}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic target handling to be done.
function job_pretarget(spell, action, spellMap, eventArgs)

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

end

-- Run after the default pet midcast() is done.
-- eventArgs is the same one used in job_pet_midcast, in case information needs to be persisted.
function job_pet_post_midcast(spell, action, spellMap, eventArgs)

end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)

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
	if player.sub_job == 'SAM' then
		handle_sam_ja:schedule(delay)
	end
	if player.sub_job == 'WAR' then
		handle_war_ja:schedule(delay)
	end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_pet_aftercast(spell, action, spellMap, eventArgs)

end

-- Run after the default pet aftercast() is done.
-- eventArgs is the same one used in job_pet_aftercast, in case information needs to be persisted.
function job_pet_post_aftercast(spell, action, spellMap, eventArgs)

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when the player's status changes.
function job_status_change(newStatus, oldStatus, eventArgs)

end

-- Called when the player's pet's status changes.
function job_pet_status_change(newStatus, oldStatus, eventArgs)

end

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
	if player.sub_job == 'SAM' then
		handle_sam_ja()
	end
	if player.sub_job == 'WAR' then
		handle_war_ja()
	end
end

-- Called when a generally-handled state value has been changed.
function job_state_change(stateField, newValue, oldValue)
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
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called before the Include starts constructing melee/idle/resting sets.
-- Can customize state or custom melee class values at this point.
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_handle_equipping_gear(status, eventArgs)
	check_tp_lock()
	set_combat_form()
	pick_tp_weapon()
	handle_twilight()
end

-- Custom spell mapping.
-- Return custom spellMap value that can override the default spell mapping.
-- Don't return anything to allow default spell mapping to be used.
function job_get_spell_map(spell, default_spell_map)

end

-- Return a customized weaponskill mode to use for weaponskill sets.
-- Don't return anything if you're not overriding the default value.
function get_custom_wsmode(spell, spellMap, default_wsmode)

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
	return meleeSet
end

-- Modify the default defense set after it was constructed.
function customize_defense_set(defenseSet)
	return defenseSet
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
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)

end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for custom player commands.
function job_self_command(cmdParams, eventArgs)

end

-- Job-specific toggles.
function job_toggle_state(field)

end

-- Request job-specific mode lists.
-- Return the list, and the current value for the requested field.
function job_get_option_modes(field)

end

-- Set job-specific mode values.
-- Return true if we recognize and set the requested field.
function job_set_option_mode(field, val)

end

-- Handle auto-targetting based on local setup.
function job_auto_change_target(spell, action, spellMap, eventArgs)

end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'WAR' then
		set_macro_page(1, 14)
	elseif player.sub_job == 'NIN' then
		set_macro_page(1, 14)
	elseif player.sub_job == 'SAM' then
		set_macro_page(1, 14)
	else
		set_macro_page(1, 14)
	end
end

