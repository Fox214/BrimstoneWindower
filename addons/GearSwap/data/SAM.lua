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
    state.Buff.Sengikori = buffactive.Sengikori or false
    state.Buff['Meikyo Shisui'] = buffactive['Meikyo Shisui'] or false
	state.WeaponMode = M{['description']='Weapon Mode', 'GreatKatana', 'GreatKatana2', 'Polearm', 'Sword'}
	state.RWeaponMode = M{['description']='RWeapon Mode', 'Stats', 'Bow'}
	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive'}
	state.holdtp = M{['description']='holdtp', 'false', 'true'}
	
	set_combat_form()
	pick_tp_weapon()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.
function user_setup()
	state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'SB', 'sTP', 'STR')
	state.WeaponskillMode:options('Normal')
	state.DefenseMode:options('None', 'Physical', 'Magical')
	state.PhysicalDefenseMode:options('PDT', 'Evasion')
	state.MagicalDefenseMode:options('MDT')
	state.WeaponMode:set('GreatKatana')
	state.Stance:set('Offensive')
	state.RWeaponMode:set('Stats') 
	state.holdtp:set('false')
    Twilight = false
	
	pick_tp_weapon()

    -- Additional local binds
    send_command('bind ^` input /ja "Hasso" <me>')
    send_command('bind !` input /ja "Seigan" <me>')

    select_default_macro_book()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !-')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    gear.stpCape={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Damage taken-5%'}}
    gear.wsdCape={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%'}}
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
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
		orb="Macrocosmic Orb"
	}
    -- Sets to return to when not performing an action.
	-- Idle sets
	sets.idle = {head="Valorous Mask",neck="Elite Royal Collar",lear="Infused Earring",rear="Etiolation Earring",
        body="Hiza. Haramaki +2",hands="Umuthi Gloves",ring1="Defending Ring",ring2="Vengeful Ring",
        back=gear.stpCape,waist="Plat. Mog. Belt",legs="Hiza. Hizayoroi +2",feet="Danzo Sune-Ate"}

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
    -- Delay 450 GK, 25 Save TP => 65 Store TP for a 5-hit (25 Store TP in gear)
    sets.engaged = {
        head="Flam. Zucchetto +2",neck="Ganesha's Mala",lear="Bladeborn Earring",rear="Kasuga Earring +1",
        body="Tatena. Harama. +1",hands="Flam. Manopolas +2",ring1="Niqmaddu Ring",ring2="Hetairoi Ring",
        back=gear.stpCape,waist="Sailfi Belt +1",legs="Wakido Haidate +3",feet="Valorous Greaves"}
		
	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {
		head="Flam. Zucchetto +2",neck="Combatant's Torque",lear="Zennaroi Earring",rear="Digni. Earring",
		body="Valorous Mail",hands="Flam. Manopolas +2",ring1="Cacoethic Ring +1",ring2="Regal Ring",
		back=gear.stpCape,waist="Olseni Belt",legs="Wakido Haidate +3",feet="Wakido Sune. +3"})
	sets.Mode.Att = set_combine(sets.engaged, {
		head="Hizamaru Somen +2",neck="Rep. Plat. Medal",lear="Bladeborn Earring",rear="Dudgeon Earring",
		body="Sakonji Domaru +2",hands="Valorous Mitts",ring1="Overbearing Ring",ring2="Regal Ring",
		back="Phalangite Mantle",waist="Sulla Belt",legs="Wakido Haidate +3",feet="Wakido Sune. +3"})
	sets.Mode.Crit = set_combine(sets.engaged, {
		head="Valorous Mask",
		body="Tatena. Harama. +1",hands="Flam. Manopolas +2",ring2="Hetairoi Ring",
		legs="Jokushu Haidate",feet="Thereoid Greaves"})
	sets.Mode.DA = set_combine(sets.engaged, {
		head="Flam. Zucchetto +2",neck="Ganesha's Mala",lear="Trux Earring",rear="Brutal Earring",
		body="Tatena. Harama. +1",hands="Phorcys Mitts",ring1="Niqmaddu Ring",ring2="Hetairoi Ring",
		back="Atheling Mantle",waist="Ioskeha Belt",legs="Zoar Subligar",feet="Flam. Gambieras +2"})
	sets.Mode.SB = set_combine(sets.engaged, {})
	sets.Mode.sTP = set_combine(sets.engaged, {
		head="Flam. Zucchetto +2",neck="Combatant's Torque",lear="Tripudio Earring",rear="Kasuga Earring +1",
		body="Kasuga Domaru",hands="Otronif Gloves +1",ring1="Rajas Ring",ring2="K'ayres Ring",
		back=gear.stpCape,waist="Yemaya Belt",legs="Wakido Haidate +3",feet="Valorous Greaves"})
	sets.Mode.STR = set_combine(sets.engaged, {
		head="Flam. Zucchetto +2",neck="Rep. Plat. Medal",lear="Thrud Earring",
		body="Hiza. Haramaki +2",hands="Flam. Manopolas +2",ring1="Niqmaddu Ring",ring2="Regal Ring",
		back=gear.wsdCape,waist="Sailfi Belt +1",legs="Valorous Hose",feet="Flam. Gambieras +2"})
			
	-- other Sets    
	sets.macc = {lear="Gwati Earring",
		body="Sacro Breastplate",ring1="Sangoma Ring"}
	sets.PDL = {}
	sets.empy = {head="Kasuga Kabuto",
		body="Kasuga Domaru",hands="Kasuga Kote",
		legs="Kasuga Haidate",feet="Kasuga Sune-Ate"}

	-- Sets with weapons defined.
	sets.engaged.Polearm = {}
	sets.engaged.GreatKatana = {}
	sets.engaged.GreatKatana = set_combine(sets.engaged, {main="Dojikiri Yasutsuna",sub="Khonsu"})
	sets.engaged.GreatKatana2 = set_combine(sets.engaged, {main="Norifusa",sub="Khonsu"})
	sets.engaged.Polearm = set_combine(sets.engaged, {main="Pitchfork +1", sub="Khonsu"})
	sets.engaged.Sword = set_combine(sets.engaged, {main="Tanmogayi +1", sub="Deliverance"})
	--Add in appropriate Ranged weapons
	sets.ranged = {}
	sets.ranged.Stats = {range="",ammo="Knobkierrie"}
	sets.ranged.Bow = {range="Killer Shortbow",ammo="Horn Arrow"}
	sets.ranged.Bow = {}
	
	sets.engaged.GreatKatana.Stats = set_combine(sets.engaged.GreatKatana, sets.ranged.Stats)
	sets.engaged.GreatKatana.Bow = set_combine(sets.engaged.GreatKatana, sets.ranged.Bow)

	sets.engaged.GreatKatana.Acc = set_combine(sets.engaged.GreatKatana, sets.Mode.Acc)
	sets.engaged.GreatKatana.Att = set_combine(sets.engaged.GreatKatana, sets.Mode.Att)
	sets.engaged.GreatKatana.Crit = set_combine(sets.engaged.GreatKatana, sets.Mode.Crit)
	sets.engaged.GreatKatana.DA = set_combine(sets.engaged.GreatKatana, sets.Mode.DA)
	sets.engaged.GreatKatana.sTP = set_combine(sets.engaged.GreatKatana, sets.Mode.sTP)
	sets.engaged.GreatKatana.STR = set_combine(sets.engaged.GreatKatana, sets.Mode.STR)
	
    sets.engaged.GreatKatana2.Stats = set_combine(sets.engaged.GreatKatana2, sets.ranged.Stats)
	sets.engaged.GreatKatana2.Bow = set_combine(sets.engaged.GreatKatana2, sets.ranged.Bow)

	sets.engaged.GreatKatana2.Acc = set_combine(sets.engaged.GreatKatana2, sets.Mode.Acc)
	sets.engaged.GreatKatana2.Att = set_combine(sets.engaged.GreatKatana2, sets.Mode.Att)
	sets.engaged.GreatKatana2.Crit = set_combine(sets.engaged.GreatKatana2, sets.Mode.Crit)
	sets.engaged.GreatKatana2.DA = set_combine(sets.engaged.GreatKatana2, sets.Mode.DA)
	sets.engaged.GreatKatana2.sTP = set_combine(sets.engaged.GreatKatana2, sets.Mode.sTP)
	sets.engaged.GreatKatana2.STR = set_combine(sets.engaged.GreatKatana2, sets.Mode.STR)

	sets.engaged.Polearm.Stats = set_combine(sets.engaged.Polearm, sets.ranged.Stats)
	sets.engaged.Polearm.Bow = set_combine(sets.engaged.Polearm, sets.ranged.Bow)

	sets.engaged.Polearm.Acc = set_combine(sets.engaged.Polearm, sets.Mode.Acc)
	sets.engaged.Polearm.Att = set_combine(sets.engaged.Polearm, sets.Mode.Att)
	sets.engaged.Polearm.Crit = set_combine(sets.engaged.Polearm, sets.Mode.Crit)
	sets.engaged.Polearm.DA = set_combine(sets.engaged.Polearm, sets.Mode.DA)
	sets.engaged.Polearm.Skill = set_combine(sets.engaged.Polearm, {
			neck="Combatant's Torque",lear="Tripudio Earring"})
	sets.engaged.Polearm.sTP = set_combine(sets.engaged.Polearm, sets.Mode.sTP)
	sets.engaged.Polearm.STR = set_combine(sets.engaged.Polearm, sets.Mode.STR)
	
	sets.engaged.Sword.Stats = set_combine(sets.engaged.Sword, sets.ranged.Stats)
	sets.engaged.Sword.Bow = set_combine(sets.engaged.Sword, sets.ranged.Bow)

	sets.engaged.Sword.Acc = set_combine(sets.engaged.Sword, sets.Mode.Acc)
	sets.engaged.Sword.Att = set_combine(sets.engaged.Sword, sets.Mode.Att)
	sets.engaged.Sword.Crit = set_combine(sets.engaged.Sword, sets.Mode.Crit)
	sets.engaged.Sword.DA = set_combine(sets.engaged.Sword, sets.Mode.DA)
	sets.engaged.Sword.sTP = set_combine(sets.engaged.Sword, sets.Mode.sTP)
	sets.engaged.Sword.STR = set_combine(sets.engaged.Sword, sets.Mode.STR)

 	-- Default set for any weaponskill that isn't any more specifically defined
	sets.WSDayBonus = {head="Gavialis Helm"} 

	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	sets.precast.WS = set_combine(sets.Mode.STR, {
        neck="Fotia Gorget",lear="Thrud Earring",rear="Kasuga Earring +1",
        body="Sakonji Domaru +2",ring1="Cornelia's Ring",ring2="Epaminondas's Ring",
        back=gear.wsdCape,waist="Fotia Belt",legs="Wakido Haidate +3"})
 
    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
 	-- Light/Earth, STR 60%
	sets.precast.WS['Tachi: Enpi'] = set_combine(sets.precast.WS, {})
 	
	-- Ice, STR 60%
	sets.precast.WS['Tachi: Hobaku'] = set_combine(sets.precast.WS, {ring1="Metamor. Ring +1"})
 
  	-- Light/Thunder, STR 60%
	sets.precast.WS['Tachi: Goten'] = set_combine(sets.precast.WS, {})
  	
	-- Fire, STR 75%
	sets.precast.WS['Tachi: Kagero'] = set_combine(sets.precast.WS, {})
	
	-- Earth/Wind, STR 30%
	sets.precast.WS['Tachi: Jinpu'] = set_combine(sets.precast.WS, {})
 
   	-- Water/Thunder, STR 50% MND 30%
	sets.precast.WS['Tachi: Koki'] = set_combine(sets.precast.WS, {})
 
	-- Ice/Wind,, STR 75%
    sets.precast.WS['Tachi: Yukikaze'] = set_combine(sets.precast.WS, {})

	-- Water/Ice, STR 75%
    sets.precast.WS['Tachi: Gekko'] = set_combine(sets.precast.WS, {})

	-- Fire/Light/Dark, STR 75%
    sets.precast.WS['Tachi: Kasha'] = set_combine(sets.precast.WS, {})

	-- Dark/Earth, STR 40% CHR 60%
    sets.precast.WS['Tachi: Ageha'] = set_combine(sets.precast.WS, {})
    
	-- Wind/Thunder/Dark, STR 73%
    sets.precast.WS['Tachi: Shoha'] = set_combine(sets.precast.WS, {})

	-- Light/Water/Ice, STR 80%
	sets.precast.WS['Tachi: Fudo'] = set_combine(sets.precast.WS, {})

	-- Ice/Earth/Dark, STR 50%
    sets.precast.WS['Tachi: Rana'] = set_combine(sets.precast.WS, {})
 
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


    -- Precast Sets
    -- Precast sets to enhance JAs
    sets.precast.JA.Meditate = {head="Wakido Kabuto",hands="Sakonji Kote",back=gear.stpCape}
    sets.precast.JA['Warding Circle'] = {head="Wakido Kabuto"}
    sets.precast.JA['Blade Bash'] = {hands="Sakonji Kote"}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        head="Hizamaru Somen +2",
        body="Hiza. Haramaki +2",hands="Buremte Gloves",
        legs="Wakido Haidate +3",feet="Hiza. Sune-Ate +2"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

	-- Fast cast sets for spells
	sets.precast.FC = {
        neck="Orunmila's Torque",lear="Etiolation Earring",
        body="Sacro Breastplate",hands="Leyline Gloves",ring1="Naji's Loop", ring2="Prolix Ring",
        legs="Limbo Trousers"}

    -- Snapshot for ranged
    sets.precast.RA = {waist="Yemaya Belt"}

    -- Midcast Sets
    -- sets.midcast.FastRecast = {}

	-- Racc, Ratt, AGI
    sets.midcast.RA = {
        neck="Combatant's Torque",lear="Infused Earring",rear="Enervating Earring",
        ring1="Paqichikaji Ring",ring2="Cacoethic Ring +1",
        waist="Eschan Stone",feet="Wakido Sune. +3"}
     
    -- Defense sets
    sets.defense.Evasion = {
        head="Hizamaru Somen +2",neck="Elite Royal Collar",lear="Infused Earring",rear="Eabani Earring",
        body="Sacro Breastplate",hands="Hizamaru Kote +2",ring1="Vengeful Ring",ring2="Beeline Ring",
        back="Lupine Cape",legs="Hiza. Hizayoroi +2",feet="Hiza. Sune-Ate +2"}

	sets.defense.PDT = {
        head="Lithelimb Cap",neck="Elite Royal Collar",lear="Bladeborn Earring",rear="Steelflash Earring",
        body="Valorous Mail",hands="Otronif Gloves +1",ring1="Defending Ring",ring2="Patricius Ring",
        back="Solemnity Cape",waist="Plat. Mog. Belt",legs="Valorous Hose",feet="Amm Greaves"}

    sets.defense.MDT = {
        head="Valorous Mask",neck="Elite Royal Collar",lear="Etiolation Earring",rear="Eabani Earring",
        body="Savas Jawshan",hands="Otronif Gloves +1",ring1="Defending Ring",ring2="Vengeful Ring",
        back="Reiki Cloak",waist="Plat. Mog. Belt",legs="Wakido Haidate +3",feet="Amm Greaves"}

	sets.debuffed = set_combine(sets.defense.Evasion,sets.defense.PDT,sets.defense.MDT)
	sets.doom = set_combine(sets.debuffed,{waist="Gishdubar Sash"})
	
    sets.Kiting = {feet="Danzo Sune-ate"}

    sets.defense.Reraise = {head="Twilight Helm",body="Twilight Mail"}

	sets.buff.Hasso = {legs="Kasuga Haidate",feet="Wakido Sune. +3"}
	sets.buff.Seigan = {legs="Kasuga Kabuto"}
    sets.buff.Sekkanoki = {hands="Kasuga Kote"}
    sets.buff.Sengikori = {feet="Kasuga Sune-ate"}
    sets.buff['Meikyo Shisui'] = {feet="Sakonji Sune-ate"}
	-- sets.Assault = {ring2="Ulthalam's Ring"}
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic target handling to be done.
function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' then
        -- Change any GK weaponskills to polearm weaponskill if we're using a polearm.
        if player.equipment.main=='Quint Spear' or player.equipment.main=='Quint Spear' then
            if spell.english:startswith("Tachi:") then
                send_command('@input /ws "Penta Thrust" '..spell.target.raw)
                eventArgs.cancel = true
            end
        end
    end
end

-- Run after the default precast() is done.
-- eventArgs is the same one used in job_precast, in case information needs to be persisted.
function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type:lower() == 'weaponskill' then
        if state.Buff.Sengikori then
            equip(sets.buff.Sengikori)
        end
        if state.Buff['Meikyo Shisui'] then
            equip(sets.buff['Meikyo Shisui'])
        end
    end
	check_ws_dist(spell)
end

function job_post_precast(spell, action, spellMap, eventArgs)
	-- add_to_chat(3,'post precast')
	if spell.type == 'WeaponSkill' then
        if is_sc_element_today(spell) then
			-- add_to_chat(122,' WS Day ')
            equip(sets.WSDayBonus)
        end
	end 
end


-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)

end


function job_buff_change(buff, gain)
	handle_debuffs()
	handle_sam_ja()
	if player.sub_job == 'WAR' then
		handle_war_ja()
	end
end
-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
	classes.CustomMeleeGroups:clear()
	if areas.Adoulin:contains(world.area) and buffactive.ionis then
		classes.CustomMeleeGroups:append('Adoulin')
	end
	pick_tp_weapon()
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
	if areas.Assault:contains(world.area) then
		meleeSet = set_combine(meleeSet, sets.Assault)
	end

    return meleeSet
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
	-- add_to_chat(122,'customize idle set')
    if not buffactive["Reraise"] then
		idleSet = set_combine(idleSet, sets.defense.Reraise)
	end
    return idleSet
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)

end

function job_handle_equipping_gear(status, eventArgs)
	-- add_to_chat(122,'handle equiping gear')
	check_tp_lock()
	set_combat_form()
	pick_tp_weapon()
	handle_twilight()
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'WAR' then
		set_macro_page(1, 9)
	elseif player.sub_job == 'DNC' then
		set_macro_page(2, 9)
	elseif player.sub_job == 'THF' then
		set_macro_page(3, 9)
	elseif player.sub_job == 'NIN' then
		set_macro_page(4, 9)
	else
		set_macro_page(1, 9)
	end
	send_command('exec sam.txt')
end

function job_self_command(cmdParams, eventArgs)

end
