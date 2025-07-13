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
    state.Buff.Sentinel = buffactive.sentinel or false
    state.Buff.Cover = buffactive.cover or false
    state.Buff.Doom = buffactive.Doom or false
	state.WeaponMode = M{['description']='Weapon Mode', 'Sword', 'GreatSword', 'Staff', 'Club', 'Polearm'}
	state.SubMode = M{['description']='Sub Mode', 'DW', 'Shield', 'Grip'}
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
	state.DefenseMode:options('None', 'Physical', 'Magical')
	state.WeaponMode:set('Sword')
	state.Stance:set('Defensive')
	state.SubMode:set('Shield')
    state.CastingMode:options('Normal', 'Resistant')
    state.PhysicalDefenseMode:options('PDT', 'Evasion', 'HP', 'Reraise', 'Charm')
    state.MagicalDefenseMode:options('MDT', 'HP', 'Reraise', 'Charm')
    Twilight = false
    
    state.ExtraDefenseMode = M{['description']='Extra Defense Mode', 'None', 'MP', 'Knockback', 'MP_Knockback'}
    state.EquipShield = M(false, 'Equip Shield w/Defense')

    update_defense_mode()
    
    send_command('bind ^f11 gs c cycle MagicalDefenseMode')
    send_command('bind !f11 gs c cycle ExtraDefenseMode')
    send_command('bind @f10 gs c toggle EquipShield')
    send_command('bind @f11 gs c toggle EquipShield')

 	pick_tp_weapon()
    select_default_macro_book()
end

function user_unload()
    send_command('unbind ^f11')
    send_command('unbind !f11')
    send_command('unbind @f10')
    send_command('unbind @f11')
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

	-- Idle sets
	sets.idle = {head="Sulevia's Mask +2",neck="Elite Royal Collar",lear="Moonshade Earring",rear="Ethereal Earring",
		body="Sulevia's Plate. +2",hands="Sulev. Gauntlets +2",ring1="Defending Ring",ring2="Moonbeam Ring",
		back="Solemnity Cape",waist="Plat. Mog. Belt",legs="Carmine Cuisses +1",feet="Sulev. Leggings +2"}

	-- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
	sets.idle.Town = set_combine(sets.idle, {})
	sets.idle.Field = set_combine(sets.idle, {})
	sets.idle.Weak = set_combine(sets.idle, {})

	-- Resting sets
	sets.resting = set_combine(sets.idle, {})

		-- Normal melee group
	sets.engaged = { ammo="Amar Cluster",
		head="Sulevia's Mask +2",neck="Combatant's Torque",lear="Ethereal Earring",rear="Chev. Earring +1",
		body="Sulevia's Plate. +2",hands="Sulev. Gauntlets +2",ring1="Patricius Ring",ring2="Moonbeam Ring",
		back="Atheling Mantle",waist="Sarissapho. Belt",legs="Sulev. Cuisses +2",feet="Sulev. Leggings +2"}
			
	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {
        head="Flam. Zucchetto +2",neck="Combatant's Torque",lear="Zennaroi Earring",rear="Chev. Earring +1",
        body="Valorous Mail",hands="Emicho Gauntlets",ring1="Cacoethic Ring +1",ring2="Regal Ring",
        back="Lupine Cape",waist="Nu Sash",legs="Carmine Cuisses +1",feet="Flam. Gambieras +2"})
	sets.Mode.Att= set_combine(sets.engaged, {
        head="Sulevia's Mask +2",neck="Rep. Plat. Medal",lear="Bladeborn Earring",rear="Dudgeon Earring",
        body="Phorcys Korazin",hands="Sulev. Gauntlets +2",ring1="Overbearing Ring",ring2="Regal Ring",
        back="Atheling Mantle",waist="Zoran's Belt",legs="Emicho Hose",feet="Sulev. Leggings +2"})
	sets.Mode.Crit = set_combine(sets.engaged, {hands="Flam. Manopolas +2"})
	sets.Mode.DA = set_combine(sets.engaged, {
        head="Flam. Zucchetto +2",neck="Asperity Necklace",lear="Trux Earring",rear="Brutal Earring",
        body="Valorous Mail",hands="Sulev. Gauntlets +2",
        legs="Sulev. Cuisses +2",feet="Flam. Gambieras +2"})
	sets.Mode.SB = set_combine(sets.engaged, {body="Sacro Breastplate"})
	sets.Mode.sTP = set_combine(sets.engaged, {
        head="Sulevia's Mask +2",neck="Combatant's Torque",lear="Tripudio Earring",rear="Enervating Earring",
        body="Flamma Korazin +2",hands="Emicho Gauntlets",ring1="Rajas Ring",ring2="K'ayres Ring",
        back="Lupine Cape",legs="Flamma Dirs +2",feet="Flam. Gambieras +2"})
	sets.Mode.STR = set_combine(sets.engaged, {
		head="Flam. Zucchetto +2",neck="Rep. Plat. Medal",lear="Thrud Earring",
		body="Sulevia's Plate. +2",hands="Sulev. Gauntlets +2",ring1="Apate Ring",ring2="Regal Ring",
		back="Buquwik Cape",waist="Sailfi Belt +1",legs="Valorous Hose",feet="Flam. Gambieras +2"})
			
	-- other Sets    
	sets.macc = {lear="Gwati Earring",ring1="Sangoma Ring",
		body="Sacro Breastplate"}
	sets.PDL = {}
	sets.empy = {head="Chevalier's Armet",
		body="Chevalier's Cuirass",hands="Chevalier's Gauntlets",
		legs="Chevalier's Cuisses",feet="Chevalier's Sabatons"}

	-- Sets with weapons defined.
	sets.engaged.GreatSword = {}
	sets.engaged.Sword = {}
	sets.engaged.Staff = {}
	sets.engaged.Polearm = {}
	sets.engaged.Club = {}
	sets.engaged.DW = set_combine(sets.engaged, {})
	sets.engaged.Shield = set_combine(sets.engaged, {})
	sets.engaged.Grip = set_combine(sets.engaged, {})
	sets.engaged.DW.Club = set_combine(sets.engaged, {main="Divinity",sub="Kumbhakarna"})
	sets.engaged.Shield.Club = set_combine(sets.engaged, {main="Divinity",sub="Deliverance"})
	sets.engaged.Grip.GreatSword = set_combine(sets.engaged, {main="Tunglmyrkvi",sub="Pole Grip"})
	sets.engaged.Grip.Polearm = set_combine(sets.engaged, {main="Gondo-Shizunori", sub="Pole Grip"})
	sets.engaged.Grip.Staff = set_combine(sets.engaged, {main="Malignance Pole", sub="Pole Grip"})
	sets.engaged.DW.Sword = set_combine(sets.engaged, {main="Naegling",sub="Sakpata's Sword"})
	-- sets.engaged.Shield.Sword = set_combine(sets.engaged, {main="Caliburnus",sub="Deliverance"})
	sets.engaged.Shield.Sword = set_combine(sets.engaged, {main="Sakpata's Sword",sub="Deliverance"})

	sets.engaged.Grip.GreatSword.Acc = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.Acc)
	sets.engaged.Grip.GreatSword.Att = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.Att)
	sets.engaged.Grip.GreatSword.Crit = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.Crit)
	sets.engaged.Grip.GreatSword.DA = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.DA)
	sets.engaged.Grip.GreatSword.SB = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.SB)
	sets.engaged.Grip.GreatSword.sTP = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.sTP)
	sets.engaged.Grip.GreatSword.STR = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.STR)
	
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

	sets.engaged.Grip.Polearm.Acc = set_combine(sets.engaged.Grip.Polearm, sets.Mode.Acc)
	sets.engaged.Grip.Polearm.Att = set_combine(sets.engaged.Grip.Polearm, sets.Mode.Att)
	sets.engaged.Grip.Polearm.Crit = set_combine(sets.engaged.Grip.Polearm, sets.Mode.Crit)
	sets.engaged.Grip.Polearm.DA = set_combine(sets.engaged.Grip.Polearm, sets.Mode.DA)
	sets.engaged.Grip.Polearm.SB = set_combine(sets.engaged.Grip.Polearm, sets.Mode.SB)
	sets.engaged.Grip.Polearm.sTP = set_combine(sets.engaged.Grip.Polearm, sets.Mode.sTP)
	sets.engaged.Grip.Polearm.STR = set_combine(sets.engaged.Grip.Polearm, sets.Mode.STR)

	sets.engaged.Grip.Staff.Acc = set_combine(sets.engaged.Grip.Staff, sets.Mode.Acc)
	sets.engaged.Grip.Staff.Att = set_combine(sets.engaged.Grip.Staff, sets.Mode.Att)
	sets.engaged.Grip.Staff.Crit = set_combine(sets.engaged.Grip.Staff, sets.Mode.Crit)
	sets.engaged.Grip.Staff.DA = set_combine(sets.engaged.Grip.Staff, sets.Mode.DA)
	sets.engaged.Grip.Staff.SB = set_combine(sets.engaged.Grip.Staff, sets.Mode.SB)
	sets.engaged.Grip.Staff.sTP = set_combine(sets.engaged.Grip.Staff, sets.Mode.sTP)
	sets.engaged.Grip.Staff.STR = set_combine(sets.engaged.Grip.Staff, sets.Mode.STR)
	-- Weaponskill sets
	-- Default set for any weaponskill that isn't any more specifically defined
	sets.WSDayBonus = {head="Gavialis Helm"} 

	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	sets.precast.WS = set_combine(sets.Mode.STR, {
		neck="Fotia Gorget",lear="Thrud Earring",rear="Ishvara Earring",
		body="Phorcys Korazin",ring1="Cornelia's Ring",ring2="Epaminondas's Ring",
		waist="Fotia Belt",feet="Sulev. Leggings +2"})

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
	sets.precast.WS['Vorpal Blade'] = set_combine(sets.precast.WS, sets.Mode.Crit, {})

	-- Earth/Thunder/Wind, STR 50% MND 50%
	sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {})

	-- dark?, STR 30% MND 50% - use MAB
	sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS, sets.engaged.MAB)

	-- Dark/Earth, MND 73%
	sets.precast.WS['Rquiescat'] = set_combine(sets.precast.WS, {})
	
	-- Dark/Earth, STR 50% MND 50%
	sets.precast.WS['Swift Blade'] = set_combine(sets.precast.WS, {neck="Soil Gorget",waist="Soil Belt"})
	
	-- Light/Fire/Water, Enmity
    sets.precast.WS['Atonement'] = {ammo="Oshasha's Treatise",
        head="Reverence Coronet +1",neck="Light Gorget",lear="Creed Earring",rear="Steelflash Earring",
        body="Creed Cuirass",hands="Reverence Gauntlets +1",ring1="Rajas Ring",ring2="Vexer Ring",
        waist="Light Belt",legs="Reverence Breeches +1",feet="Caballarius Leggings"}

		-- none, INT 50% MND 50%
	sets.precast.WS['Spirit Taker'] = set_combine(sets.precast.WS, {})

	-- Earth/Wind/Thunder, STR 73%
	sets.precast.WS['Resolution'] = set_combine(sets.precast.WS, {})

	-- Light, STR 30% DEX 30%
	sets.precast.WS['Double Thrust'] = set_combine(sets.precast.WS, {neck="Light Gorget",body="Rheic Korazin +3",waist="Light Belt"})
		
	-- Light/Thunder, STR 40% INT 40%
	sets.precast.WS['Thunder Thrust'] = set_combine(sets.precast.WS, {neck="Light Gorget",body="Rheic Korazin +3",waist="Light Belt"})

	-- Light/Thunder, STR 40% INT 40% 
	sets.precast.WS['Raiden Thrust'] = set_combine(sets.precast.WS, {neck="Light Gorget",body="Rheic Korazin +3",waist="Light Belt"})

	-- Thunder, STR 100%
	sets.precast.WS['Leg Sweep'] = set_combine(sets.precast.WS, {body="Rheic Korazin +3"})

	-- Darkness, STR 20% DEX 20% 
	sets.precast.WS['Penta Thrust'] = set_combine(sets.precast.WS, {neck="Shadow Gorget",body="Rheic Korazin +3",waist="Shadow Belt"})

	-- Light/Water, STR 50% AGI 50% 
	sets.precast.WS['Vorpal Thrust'] = set_combine(sets.precast.WS, {neck="Light Gorget",body="Rheic Korazin +3",waist="Light Belt"})

	-- Dark/Earth/Ice, STR 100% -->
	sets.precast.WS['Impulse Drive'] = set_combine(sets.precast.WS, {body="Rheic Korazin +3"})

	-- Light/Earth, STR 40% DEX 40%-->
	sets.precast.WS['Sonic Thrust'] = set_combine(sets.precast.WS, {neck="Light Gorget",body="Rheic Korazin +3",waist="Light Belt"})

	-- Dark/Earth/Light, STR 85% -->
	sets.precast.WS['Stardiver'] = set_combine(sets.precast.WS, {neck="Light Gorget",body="Rheic Korazin +3",back="Atheling Mantle",waist="Light Belt"})

    -- Precast sets to enhance JAs
    sets.precast.JA['Invincible'] = {legs="Caballarius Breeches"}
    sets.precast.JA['Holy Circle'] = {feet="Reverence Leggings +1"}
    sets.precast.JA['Shield Bash'] = {hands="Caballarius Gauntlets"}
    sets.precast.JA['Sentinel'] = {feet="Caballarius Leggings"}
    sets.precast.JA['Rampart'] = {head="Caballarius Coronet"}
    sets.precast.JA['Fealty'] = {body="Caballarius Surcoat"}
    sets.precast.JA['Divine Emblem'] = {feet="Creed Sabatons +2"}
    sets.precast.JA['Cover'] = {head="Reverence Coronet +1",body="Vlr. Surcoat +1"}

    -- add mnd for Chivalry
    sets.precast.JA['Chivalry'] = {
        head="Reverence Coronet +1",
        body="Reverence Surcoat +1",hands="Reverence Gauntlets +1",ring1="Leviathan Ring",
        back="Weard Mantle",legs="Reverence Breeches +1",feet="Whirlpool Greaves"}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {ammo="Sonia's Plectrum",
        head="Reverence Coronet +1",
        hands="Reverence Gauntlets +1",
        back="Iximulew Cape",legs="Reverence Breeches +1",feet="Whirlpool Greaves"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}
    
    sets.precast.Step = {waist="Chaac Belt"}
    sets.precast.Flourish1 = {waist="Chaac Belt"}

    -- Fast cast sets for spells
    
    sets.precast.FC = {ammo="Incantor Stone",
        neck="Orunmila's Torque",rear="Loquacious Earring",
		body="Sacro Breastplate",ring1="Kishar Ring",ring2="Prolix Ring"}

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})

       
    --------------------------------------
    -- Midcast sets
    --------------------------------------
    -- sets.midcast.FastRecast = {}
        
    sets.midcast.Enmity = {ammo="Iron Gobbet",
        head="Reverence Coronet +1",neck="Invidia Torque",
        body="Obviation Cuirass",hands="Reverence Gauntlets +1",ring1="Vexer Ring",
        legs="Reverence Breeches +1",feet="Caballarius Leggings"}

    sets.midcast.Flash = set_combine(sets.midcast.Enmity, {})
    
    sets.midcast.Stun = sets.midcast.Flash
    
    sets.midcast.Cure = {ammo="Iron Gobbet",
        neck="Invidia Torque",lear="Hospitaler Earring",rear="Chev. Earring +1",
        body="Reverence Surcoat +1",hands="Buremte Gloves",ring1="Naji's Loop",ring2="Lebeche Ring",
        legs="Reverence Breeches +1",feet="Caballarius Leggings"}

    sets.midcast['Enhancing Magic'] = {waist="Olympus Sash",legs="Reverence Breeches +1"}
    
	sets.midcast['Divine Magic'] = set_combine(sets.macc, {
        body="Sacro Breastplate"})

    sets.midcast.Protect = {ring1="Sheltered Ring"}
    sets.midcast.Shell = {ring1="Sheltered Ring"}
    
    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------

    sets.Kiting = {legs="Carmine Cuisses +1"}

    sets.latent_refresh = {waist="Fucho-no-obi"}


    --------------------------------------
    -- Defense sets
    --------------------------------------
    
    -- Extra defense sets.  Apply these on top of melee or defense sets.
    sets.Knockback = {back="Repulse Mantle"}
    sets.MP = {neck="Creed Collar"}
    sets.MP_Knockback = {neck="Creed Collar",back="Repulse Mantle"}
    
    -- If EquipShield toggle is on (Win+F10 or Win+F11), equip the weapon/shield combos here
    -- when activating or changing defense mode:
    sets.PhysicalShield = {main="Sakpata's Sword",sub="Deliverance"} -- Ochain
    sets.MagicalShield = {main="Sakpata's Sword",sub="Deliverance"} -- Aegis

    -- Basic defense sets.
    sets.defense.Reraise = {head="Twilight Helm", body="Twilight Mail"}

    sets.defense.Evasion = {
        head="Flam. Zucchetto +2",lear="Infused Earring",rear="Eabani Earring",
        body="Sacro Breastplate",hands="Emicho Gauntlets",ring1="Vengeful Ring",ring2="Beeline Ring",
        back="Lupine Cape",legs="Sulev. Cuisses +2",feet="Flam. Gambieras +2"}
    sets.defense.PDT = {ammo="Iron Gobbet",
        head="Sulevia's Mask +2",neck="Elite Royal Collar",lear="Creed Earring",rear="Chev. Earring +1",
        body="Sulevia's Plate. +2",hands="Sulev. Gauntlets +2",ring1="Defending Ring",
        back="Shadow Mantle",waist="Plat. Mog. Belt",legs="Sulev. Cuisses +2",feet="Sulev. Leggings +2"}
    sets.defense.HP = {ammo="Iron Gobbet",
        head="Reverence Coronet +1",neck="Elite Royal Collar",lear="Creed Earring",rear="Eabani Earring",
        body="Sacro Breastplate",hands="Emicho Gauntlets",ring1="Defending Ring",ring2="Moonbeam Ring",
        back="Reiki Cloak",waist="Plat. Mog. Belt",legs="Reverence Breeches +1",feet="Flam. Gambieras +2"}
    sets.defense.Charm = {ammo="Iron Gobbet",
        head="Reverence Coronet +1",neck="Lavalier +1",lear="Creed Earring",
        body="Reverence Surcoat +1",hands="Reverence Gauntlets +1",ring1="Defending Ring",
        back="Shadow Mantle",legs="Reverence Breeches +1",feet="Reverence Leggings +1"}
    -- To cap MDT with Shell IV (52/256), need 76/256 in gear.
    -- Shellra V can provide 75/256, which would need another 53/256 in gear.
    sets.defense.MDT = {
        head="Sulevia's Mask +2",neck="Elite Royal Collar",lear="Etiolation Earring",rear="Chev. Earring +1",
        body="Sulevia's Plate. +2",hands="Sulev. Gauntlets +2",ring1="Defending Ring",ring2="Moonbeam Ring",
        back="Reiki Cloak",waist="Plat. Mog. Belt",legs="Sulev. Cuisses +2",feet="Sulev. Leggings +2"}

	sets.debuffed = set_combine(sets.defense.Evasion,sets.defense.PDT,sets.defense.MDT)
	sets.doom = set_combine(sets.debuffed,{waist="Gishdubar Sash"})
    sets.buff.Cover = {head="Reverence Coronet +1", body="Vlr. Surcoat +1"}
end


-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    check_ws_dist(spell)
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_midcast(spell, action, spellMap, eventArgs)
    -- If DefenseMode is active, apply that gear over midcast
    -- choices.  Precast is allowed through for fast cast on
    -- spells, but we want to return to def gear before there's
    -- time for anything to hit us.
    -- Exclude Job Abilities from this restriction, as we probably want
    -- the enhanced effect of whatever item of gear applies to them,
    -- and only one item should be swapped out.
    if state.DefenseMode.value ~= 'None' and spell.type ~= 'JobAbility' then
        handle_equipping_gear(player.status)
        eventArgs.handled = true
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when the player's status changes.
function job_state_change(field, new_value, old_value)
    classes.CustomDefenseGroups:clear()
    classes.CustomDefenseGroups:append(state.ExtraDefenseMode.current)
    if state.EquipShield.value == true then
        classes.CustomDefenseGroups:append(state.DefenseMode.current .. 'Shield')
    end

    classes.CustomMeleeGroups:clear()
    classes.CustomMeleeGroups:append(state.ExtraDefenseMode.current)
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    update_defense_mode()
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    if state.Buff.Doom then
        idleSet = set_combine(idleSet, sets.buff.Doom)
    end
	-- add_to_chat(122,'customize idle set')
    if not buffactive["Reraise"] then
		idleSet = set_combine(idleSet, sets.defense.Reraise)
	end
    return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if state.Buff.Doom then
        meleeSet = set_combine(meleeSet, sets.buff.Doom)
    end
    
    return meleeSet
end

function customize_defense_set(defenseSet)
    if state.ExtraDefenseMode.value ~= 'None' then
        defenseSet = set_combine(defenseSet, sets[state.ExtraDefenseMode.value])
    end
    
    if state.EquipShield.value == true then
        defenseSet = set_combine(defenseSet, sets[state.DefenseMode.current .. 'Shield'])
    end
    
    if state.Buff.Doom then
        defenseSet = set_combine(defenseSet, sets.buff.Doom)
    end
    
    return defenseSet
end


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
        msg = msg .. ', Defense: ' .. state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
    end

    if state.ExtraDefenseMode.value ~= 'None' then
        msg = msg .. ', Extra: ' .. state.ExtraDefenseMode.value
    end
    
    if state.EquipShield.value == true then
        msg = msg .. ', Force Equip Shield'
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

    add_to_chat(122, msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function update_defense_mode()
    if player.equipment.main == 'Kheshig Blade' and not classes.CustomDefenseGroups:contains('Kheshig Blade') then
        classes.CustomDefenseGroups:append('Kheshig Blade')
    end
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(5, 13)
    elseif player.sub_job == 'NIN' then
        set_macro_page(4, 13)
    elseif player.sub_job == 'RDM' then
        set_macro_page(3, 13)
    else
        set_macro_page(1, 13)
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
	if spell.type == 'WeaponSkill' then
        if is_sc_element_today(spell) then
			-- add_to_chat(122,' WS Day ')
            equip(sets.WSDayBonus)
        end
	end 
end

function job_handle_equipping_gear(status, eventArgs)
	-- add_to_chat(122,'handle equiping gear')
	check_tp_lock()
	set_combat_form()
	pick_tp_weapon()
    handle_twilight()
end
