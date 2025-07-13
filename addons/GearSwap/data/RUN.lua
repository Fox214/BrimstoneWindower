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


-- Setup vars that are user-independent.
function job_setup()
    -- Table of entries
    rune_timers = T{}
    -- entry = rune, index, expires
    
    if player.main_job_level >= 65 then
        max_runes = 3
    elseif player.main_job_level >= 35 then
        max_runes = 2
    elseif player.main_job_level >= 5 then
        max_runes = 1
    else
        max_runes = 0
    end
	state.WeaponMode = M{['description']='Weapon Mode', 'GreatSword', 'Sword', 'GreatAxe', 'Axe', 'Club'}
	state.SubMode = M{['description']='Sub Mode', 'DW', 'Shield', 'Grip'}
	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive'}
 
	set_combat_form()
	pick_tp_weapon()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

function user_setup()
	state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'SB', 'sTP', 'STR')
	state.WeaponskillMode:options('Normal')
	state.DefenseMode:options('None', 'Physical', 'Magical')
	state.PhysicalDefenseMode:options('PDT', 'Evasion', 'Reraise')
	state.MagicalDefenseMode:options('MDT', 'Reraise')
	state.WeaponMode:set('GreatSword')
	state.Stance:set('None')
	state.SubMode:set('Grip')

	pick_tp_weapon()
	select_default_macro_book()
end


function init_gear_sets()
    gear.hercTH = { name="Herculean Helm", augments={'Attack+13','"Snapshot"+3','"Treasure Hunter"+1','Accuracy+5 Attack+5',}}
    gear.hercAcc = { name="Herculean Helm", augments={'Accuracy+29','STR+6','Attack+3',}}

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
		echos="Echo Drops",
		-- shihei="Shihei",
		orb="Macrocosmic Orb"
	}	
	-- Idle sets
	sets.idle = { ammo="Homiliary",
		head="Rawhide Mask",neck="Elite Royal Collar",lear="Moonshade Earring",rear="Ethereal Earring",
		body="Vrikodara Jupon",hands="Aya. Manopolas +2",ring1="Defending Ring",ring2="Renaye Ring +1",
		back="Evasionist's Cape",waist="Plat. Mog. Belt",legs="Carmine Cuisses +1",feet="Aya. Gambieras +2"}
			
	-- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
	sets.idle.Town = set_combine(sets.idle, {})
 	sets.idle.Field = set_combine(sets.idle, {})
	sets.idle.Weak = set_combine(sets.idle, {})
    sets.idle.Refresh = set_combine(sets.idle, {body="Runeist Coat", waist="Fucho-no-obi"})
           
	-- Resting sets
	sets.resting = set_combine(sets.idle, {})

	-- Engaged sets
	-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion

	-- Normal melee group
	sets.engaged = {ammo="Yamarang",
        head="Aya. Zucchetto +2",neck="Combatant's Torque",lear="Sherida Earring",rear="Erilaz Earring +1",
        body="Ayanmo Corazza +2",hands="Aya. Manopolas +2",ring1="Niqmaddu Ring",ring2="Moonbeam Ring",
        back="Atheling Mantle",waist="Ioskeha Belt",legs="Meg. Chausses +2",feet="Aya. Gambieras +2"}
			
	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, { ammo="Yamarang",
        head="Meghanada Visor +2",neck="Combatant's Torque",lear="Zennaroi Earring",rear="Digni. Earring",
        body="Meg. Cuirie +2",hands="Meg. Gloves +2",ring1="Cacoethic Ring +1",ring2="Regal Ring",
        back="Ground. Mantle +1",waist="Olseni Belt",legs="Carmine Cuisses +1",feet="Meg. Jam. +2"})
	sets.Mode.Att= set_combine(sets.engaged, {ammo="Knobkierrie",
        head="Meghanada Visor +2",neck="Rep. Plat. Medal",lear="Bladeborn Earring",rear="Dudgeon Earring",
        body="Meg. Cuirie +2",hands="Meg. Gloves +2",ring1="Overbearing Ring",ring2="Regal Ring",
        back="Phalangite Mantle",waist="Sulla Belt",legs="Carmine Cuisses +1",feet="Meg. Jam. +2"})
	sets.Mode.Crit = set_combine(sets.engaged, {
        head="Adhemar Bonnet",lear="Odr Earring",
		body="Meg. Cuirie +2",ring2="Hetairoi Ring",feet="Thereoid Greaves"})
	sets.Mode.DA = set_combine(sets.engaged, {
        head="Skormoth Mask",neck="Asperity Necklace",lear="Sherida Earring",rear="Brutal Earring",
        body="Ayanmo Corazza +2",hands="Herculean Gloves",ring1="Niqmaddu Ring",ring2="Epona's Ring",
        waist="Ioskeha Belt",legs="Meg. Chausses +2",feet="Thaumas Nails"})
	sets.Mode.SB = set_combine(sets.engaged, {})
	sets.Mode.sTP = set_combine(sets.engaged, { ammo="Yamarang",
        head="Aya. Zucchetto +2",neck="Anu Torque",lear="Sherida Earring",rear="Digni. Earring",
        body="Herculean Vest",hands="Umuthi Gloves",ring1="Rajas Ring",ring2="K'ayres Ring",
        back="Lupine Cape",waist="Yemaya Belt",legs="Herculean Trousers"})
	sets.Mode.STR = set_combine(sets.engaged, {ammo="Seeth. Bomblet +1",
        head=gear.hercAcc,neck="Rep. Plat. Medal",lear="Sherida Earring",
        body="Meg. Cuirie +2",hands="Meg. Gloves +2",ring1="Niqmaddu Ring",ring2="Regal Ring",
        back="Ogma's Cape",waist="Sailfi Belt +1",legs="Herculean Trousers",feet="Meg. Jam. +2"})
			
	-- other Sets    
	sets.macc = {lear="Gwati Earring",ring1="Sangoma Ring"}
	sets.PDL = {}
	sets.empy = {head="Erilaz Galea",
		body="Erilaz Surcoat",hands="Erilaz Gauntlets",
		legs="Erilaz Guards",feet="Erilaz Greaves"}		

	-- Sets with weapons defined.
	sets.engaged.GreatAxe = {}
	sets.engaged.Axe = {}
	sets.engaged.GreatSword = {}
	sets.engaged.Sword = {}
	sets.engaged.Club = {}
	sets.engaged.DW = set_combine(sets.engaged, {})
	sets.engaged.Shield = set_combine(sets.engaged, {})
	sets.engaged.Grip = set_combine(sets.engaged, {})
	sets.engaged.DW.Axe = set_combine(sets.engaged, {main="Perun +1",sub="Loxotic Mace"})
	sets.engaged.Shield.Axe = set_combine(sets.engaged, {main="Perun +1",sub="Viking Shield"})
	sets.engaged.DW.Club = set_combine(sets.engaged, {main="Loxotic Mace",sub="Kumbhakarna"})
	sets.engaged.Shield.Club = set_combine(sets.engaged, {main="Loxotic Mace",sub="Viking Shield"})
	sets.engaged.Grip.GreatAxe = set_combine(sets.engaged, {main="Elephas Axe",sub="Khonsu"})
	sets.engaged.Grip.GreatSword = set_combine(sets.engaged, {main="Aettir",sub="Khonsu"})
	sets.engaged.DW.Sword = set_combine(sets.engaged, {main="Naegling",sub="Kumbhakarna"})
	sets.engaged.Shield.Sword = set_combine(sets.engaged, {main="Naegling",sub="Viking Shield"})
	
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

    sets.engaged.repulse = {}

    sets.enmity = {hands="Futhark Mitons +1",back="Phalangite Mantle"}

	--------------------------------------
	-- Precast sets
	--------------------------------------
	-- Weaponskill sets
	-- Default set for any weaponskill that isn't any more specifically defined
	sets.precast.WS = set_combine(sets.Mode.STR, {ammo="Knobkierrie",
        neck="Fotia Gorget",rear="Ishvara Earring",
        body="Herculean Vest",hands="Meg. Gloves +2",ring1="Cornelia's Ring",ring2="Epaminondas's Ring",
        back="Ogma's Cape",waist="Fotia Belt"})    
	sets.WSDayBonus = {} 

 	-- Earth, STR 100%
	sets.precast.WS['Hard Slash'] = set_combine(sets.precast.WS, {})
	
	-- Light, STR 60% VIT 60%
	sets.precast.WS['Power Slash'] = set_combine(sets.precast.WS, {})
	
	-- Ice, STR 40% INT 40%
	sets.precast.WS['Frostbite'] = set_combine(sets.precast.WS, {})
	
	-- Ice/Wind, STR 40% INT 40%
	sets.precast.WS['Freezebite'] = set_combine(sets.precast.WS, {})
	
	-- Water, STR 30% MND 30%
	sets.precast.WS['Shockwaver'] = set_combine(sets.precast.WS, {})
	
	-- Earth, STR 80% 
	sets.precast.WS['Crescent Moon'] = set_combine(sets.precast.WS, {})
	
	-- Earth/Thunder, STR 40% AGI 40%
	sets.precast.WS['Sickle Moon'] = set_combine(sets.precast.WS, {})
	
	-- Wind/Thunder, STR 30% INT 30%
	sets.precast.WS['Spinning Slash'] = set_combine(sets.precast.WS, {})
	
	-- Wind/Thunder/Ice/Water, STR 50% INT 50%
	sets.precast.WS['Ground Strike'] = set_combine(sets.precast.WS, {})
	
	-- Wind/Thunder/Ice, VIT 80%
	sets.precast.WS['Herculean Slash'] = set_combine(sets.precast.WS, {})

	-- Wind/Thunder/Earth, STR 73%
    sets.precast.WS['Resolution'] = set_combine(sets.precast.WS,{})
		
    -- Wind/Thunder/Fire/Light, DEX 80%
    sets.precast.WS['Dimidiation'] = set_combine(sets.precast.WS, {})

	-- Precast sets to enhance JAs
    sets.precast.JA['Vallation'] = {body="Runeist Coat",back="Ogma's Cape",legs="Futhark trousers +1"}
    sets.precast.JA['Valiance'] = set_combine(sets.precast.JA['Vallation'], {})
    sets.precast.JA['Pflug'] = {feet="Runeist Bottes"}
    sets.precast.JA['Battuta'] = {head="Futhark Bandeau +1"}
    sets.precast.JA['Liement'] = {body="Futhark Coat"}
    sets.precast.JA['Lunge'] = {neck="Eddy Necklace",lear="Friomisi Earring",rear="Crematio Earring",
        back="Evasionist's Cape", waist="Yamabuki-no-obi", legs="Iuitl Tights"}
    sets.precast.JA['Swipe'] = set_combine(sets.precast.JA['Lunge'], {})
    sets.precast.JA['Gambit'] = {hands="Runeist Mitons"}
    sets.precast.JA['Rayke'] = {feet="Futhark Boots +1"}
    sets.precast.JA['Elemental Sforzo'] = {body="Futhark Coat"}
    sets.precast.JA['Swordplay'] = {hands="Futhark Mitons +1"}
    sets.precast.JA['Embolden'] = {}
    sets.precast.JA['Vivacious Pulse'] = {}
    sets.precast.JA['One For All'] = {}
    sets.precast.JA['Provoke'] = set_combine(sets.enmity, {})


	-- Fast cast sets for spells
    sets.precast.FC = {
        head=gear.hercAcc,neck="Orunmila's Torque",lear="Etiolation Earring",
        body="Vrikodara Jupon",hands="Leyline Gloves",ring1="Kishar Ring",ring2="Prolix Ring",
        legs="Aya. Cosciales +2"}
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {neck="Incanter's Torque",waist="Siegel Sash", legs="Futhark Trousers +1"})
    sets.precast.FC['Divine Magic'] = set_combine(sets.precast.FC, {neck="Erra Pendant"})
    sets.precast.FC['Utsusemi: Ichi'] = set_combine(sets.precast.FC, {neck='Magoraga beads',body="Passion Jacket"})
    sets.precast.FC['Utsusemi: Ni'] = set_combine(sets.precast.FC['Utsusemi: Ichi'], {})

	--------------------------------------
	-- Midcast sets
	--------------------------------------
	-- sets.midcast.FastRecast = {}     
    sets.midcast['Enhancing Magic'] = {neck="Incanter's Torque",rear="Andoaa Earring",hands="Runeist Mitons",legs="Carmine Cuisses +1"}
    sets.midcast['Divine Magic'] = { ammo="Pemphredo Tathlum",
		neck="Incanter's Torque",ring1="Metamor. Ring +1",ring2="Metamor. Ring +1",
		hands="Leyline Gloves",
		back="Izdubar Mantle",waist="Eschan Stone",legs="Rune. Trousers +1",feet="Aya. Gambieras +2"}
    sets.midcast['Regen'] = {head="Runeist Bandeau",lear="Pratik Earring",legs="Futhark Trousers +1"}
    sets.midcast['Stoneskin'] = set_combine(sets.midcast['Enhancing Magic'],{waist="Siegel Sash"})
    sets.midcast.Cure = {neck="Phalaina Locket",lear="Roundel Earring",
		body="Vrikodara Jupon",hands="Buremte Gloves",ring1="Naji's Loop",ring2="Lebeche Ring",
		back="Solemnity Cape",legs="Carmine Cuisses +1",feet="Futhark Boots +1"}
	
	--Defense
	sets.defense.Evasion = { ammo="Amar Cluster",
		head=gear.hercAcc,lear="Infused Earring",rear="Eabani Earring",
		body="Passion Jacket",hands="Kurys Gloves",ring1="Vengeful Ring",ring2="Beeline Ring",
		back="Evasionist's Cape",legs="Herculean Trousers",feet="Herculean Boots"}

	sets.defense.PDT = {
		head="Meghanada Visor +2",neck="Elite Royal Collar",rear="Erilaz Earring +1",
		body="Meg. Cuirie +2",hands="Meg. Gloves +2",ring1="Defending Ring",ring2="Patricius Ring",
		back="Evasionist's Cape",waist="Plat. Mog. Belt",legs="Meg. Chausses +2",feet="Ahosi Leggings"}

	sets.defense.MDT = {
		head="Aya. Zucchetto +2",neck="Elite Royal Collar",lear="Etiolation Earring",rear="Erilaz Earring +1",
		body="Futhark Coat",hands="Kurys Gloves",ring1="Defending Ring",ring2="Moonbeam Ring",
		back="Reiki Cloak",waist="Plat. Mog. Belt",legs="Aya. Cosciales +2",feet="Aya. Gambieras +2"}
		
	sets.debuffed = set_combine(sets.defense.Evasion,sets.defense.PDT,sets.defense.MDT)
	sets.doom = set_combine(sets.debuffed,{waist="Gishdubar Sash"})

	sets.Kiting = {legs="Carmine Cuisses +1"}
	-- sets.Assault = {ring2="Ulthalam's Ring"}
end

------------------------------------------------------------------
-- Action events
------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    check_ws_dist(spell)
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.english == 'Lunge' or spell.english == 'Swipe' then
        local obi = get_obi(get_rune_obi_element())
        if obi then
            equip({waist=obi})
        end
    end
end


function job_aftercast(spell)
    if not spell.interrupted then
        if spell.type == 'Rune' then
            update_timers(spell)
        elseif spell.name == "Lunge" or spell.name == "Gambit" or spell.name == 'Rayke' then
            reset_timers()
        elseif spell.name == "Swipe" then
            send_command(trim(1))
        end
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
	if player.sub_job == 'SAM' then
		handle_sam_ja:schedule(delay)
	end
	if player.sub_job == 'WAR' then
		handle_war_ja:schedule(delay)
	end
end

-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
-- General hooks for other events.
-------------------------------------------------------------------------------------------------------------------

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
	pick_tp_weapon()
end
-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
	if areas.Assault:contains(world.area) then
		meleeSet = set_combine(meleeSet, sets.Assault)
	end

    return meleeSet
end

function determine_groups()
	-- add_to_chat(122,' determine groups')
	classes.CustomMeleeGroups:clear()
end

function get_rune_obi_element()
    weather_rune = buffactive[elements.rune_of[world.weather_element] or '']
    day_rune = buffactive[elements.rune_of[world.day_element] or '']
    
    local found_rune_element
    
    if weather_rune and day_rune then
        if weather_rune > day_rune then
            found_rune_element = world.weather_element
        else
            found_rune_element = world.day_element
        end
    elseif weather_rune then
        found_rune_element = world.weather_element
    elseif day_rune then
        found_rune_element = world.day_element
    end
    
    return found_rune_element
end

function get_obi(element)
    if element and elements.obi_of[element] then
        return (player.inventory[elements.obi_of[element]] or player.wardrobe[elements.obi_of[element]]) and elements.obi_of[element]
    end
end


------------------------------------------------------------------
-- Timer manipulation
------------------------------------------------------------------

-- Add a new run to the custom timers, and update index values for existing timers.
function update_timers(spell)
    local expires_time = os.time() + 300
    local entry_index = rune_count(spell.name) + 1

    local entry = {rune=spell.name, index=entry_index, expires=expires_time}

    rune_timers:append(entry)
    local cmd_queue = create_timer(entry).. ';wait 0.05;'
    
    cmd_queue = cmd_queue .. trim()

    add_to_chat(123,'cmd_queue='..cmd_queue)

    send_command(cmd_queue)
end

-- Get the command string to create a custom timer for the provided entry.
function create_timer(entry)
    local timer_name = '"Rune: ' .. entry.rune .. '-' .. tostring(entry.index) .. '"'
    local duration = entry.expires - os.time()
    return 'timers c ' .. timer_name .. ' ' .. tostring(duration) .. ' down'
end

-- Get the command string to delete a custom timer for the provided entry.
function delete_timer(entry)
    local timer_name = '"Rune: ' .. entry.rune .. '-' .. tostring(entry.index) .. '"'
    return 'timers d ' .. timer_name .. ''
end

-- Reset all timers
function reset_timers()
    local cmd_queue = ''
    for index,entry in pairs(rune_timers) do
        cmd_queue = cmd_queue .. delete_timer(entry) .. ';wait 0.05;'
    end
    rune_timers:clear()
    send_command(cmd_queue)
end

-- Get a count of the number of runes of a given type
function rune_count(rune)
    local count = 0
    local current_time = os.time()
    for _,entry in pairs(rune_timers) do
        if entry.rune == rune and entry.expires > current_time then
            count = count + 1
        end
    end
    return count
end

-- Remove the oldest rune(s) from the table, until we're below the max_runes limit.
-- If given a value n, remove n runes from the table.
function trim(n)
    local cmd_queue = ''

    local to_remove = n or (rune_timers:length() - max_runes)

    while to_remove > 0 and rune_timers:length() > 0 do
        local oldest
        for index,entry in pairs(rune_timers) do
            if oldest == nil or entry.expires < rune_timers[oldest].expires then
                oldest = index
            end
        end
        
        cmd_queue = cmd_queue .. prune(rune_timers[oldest].rune)
        to_remove = to_remove - 1
    end
    
    return cmd_queue
end

-- Drop the index of all runes of a given type.
-- If the index drops to 0, it is removed from the table.
function prune(rune)
    local cmd_queue = ''
    
    for index,entry in pairs(rune_timers) do
        if entry.rune == rune then
            cmd_queue = cmd_queue .. delete_timer(entry) .. ';wait 0.05;'
            entry.index = entry.index - 1
        end
    end

    for index,entry in pairs(rune_timers) do
        if entry.rune == rune then
            if entry.index == 0 then
                rune_timers[index] = nil
            else
                cmd_queue = cmd_queue .. create_timer(entry) .. ';wait 0.05;'
            end
        end
    end
    
    return cmd_queue
end


------------------------------------------------------------------
-- Reset events
------------------------------------------------------------------

windower.raw_register_event('zone change',reset_timers)
windower.raw_register_event('logout',reset_timers)
windower.raw_register_event('status change',function(new, old)
    if gearswap.res.statuses[new].english == 'Dead' then
        reset_timers()
    end
end)

function job_handle_equipping_gear(status, eventArgs)
	-- add_to_chat(122,'handle equiping gear')
	check_tp_lock()
	set_combat_form()
	pick_tp_weapon()
end

function select_default_macro_book()
    set_macro_page(1, 19)
	send_command('exec run.txt')
end

function job_buff_change(buff, gain)
	handle_debuffs()
	determine_groups()
	if player.sub_job == 'SAM' then
		handle_sam_ja()
	end
	if player.sub_job == 'WAR' then
		handle_war_ja()
	end
end

function customize_idle_set(idleSet)
	if buffactive['reive mark'] then
		idleSet = set_combine(idleSet, sets.Reive )
	end
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    return idleSet
end