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
    state.Buff.Footwork = buffactive.Footwork or false
    state.Buff.Impetus = buffactive.Impetus or false

    state.FootworkWS = M(false, 'Footwork on WS')

    info.impetus_hit_count = 0
    windower.raw_register_event('action', on_action_for_impetus)
	state.WeaponMode = M{['description']='Weapon Mode', 'H2H', 'Staff', 'Club'}
 	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive'}

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
    state.PhysicalDefenseMode:options('PDT', 'HP', 'Evasion', 'Counter')
	state.MagicalDefenseMode:options('MDT')
	state.WeaponMode:set('H2H')
	state.Stance:set('Offensive')

    update_combat_form()
    update_melee_groups()
    gear.hercTH = { name="Herculean Helm", augments={'Attack+13','"Snapshot"+3','"Treasure Hunter"+1','Accuracy+5 Attack+5',}}
    gear.hercAcc = { name="Herculean Helm", augments={'Accuracy+29','STR+6','Attack+3',}}

	send_command('bind ^` gs c cycle WeaponMode')
    select_default_macro_book()
end


-- Define sets and vars used by this job file.
function init_gear_sets()
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
		echos="Echo Drops",
		-- shihei="Shihei",
		orb="Macrocosmic Orb"
	}

    -- Idle sets
    sets.idle = {ammo="Amar Cluster",
        head="Hizamaru Somen +2",neck="Elite Royal Collar",lear="Infused Earring",rear="Etiolation Earring",
        body="Hiza. Haramaki +2",hands="Hizamaru Kote +2",ring1="Defending Ring",ring2="Vengeful Ring",
        back="Solemnity Cape",waist="Plat. Mog. Belt",legs="Mummu Kecks +2",feet="Herald's Gaiters"}

    sets.idle.Town = set_combine(sets.idle, {})
    
    sets.idle.Weak = set_combine(sets.idle, {})

    -- Resting sets
    sets.resting = set_combine(sets.idle, {body="Hesychast's Cyclas"})
		
    -- Normal melee group
    sets.engaged = {ammo="Mantoptera Eye",
        head="Hizamaru Somen +2",neck="Combatant's Torque",lear="Sherida Earring",rear="Bhikku Earring +2",
        body="Tatena. Harama. +1",hands="Mummu Wrists +2",ring1="Niqmaddu Ring",ring2="Epona's Ring",
        back="Segomo's Mantle",waist="Black Belt",legs="Hiza. Hizayoroi +2",feet="Herculean Boots"}
	
	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, { ammo="Mantoptera Eye",
			head="Malignance Chapeau",neck="Combatant's Torque",lear="Zennaroi Earring",rear="Bhikku Earring +2",
			body="Hiza. Haramaki +2",hands="Mummu Wrists +2",ring1="Cacoethic Ring +1",ring2="Regal Ring",
			back="Segomo's Mantle",waist="Olseni Belt",legs="Mummu Kecks +2",feet="Herculean Boots"})
	sets.Mode.Att= set_combine(sets.engaged, {ammo="Knobkierrie",
			head=gear.hercTH,neck="Rep. Plat. Medal",lear="Bladeborn Earring",rear="Dudgeon Earring",
			body="Tatena. Harama. +1",hands="Count's Cuffs",ring1="Overbearing Ring",ring2="Regal Ring",
			back="Phalangite Mantle",waist="Eschan Stone",legs="Hiza. Hizayoroi +2",feet="Hiza. Sune-Ate +2"})
	sets.Mode.Crit = set_combine(sets.engaged, {
			head="Adhemar Bonnet",lear="Odr Earring",
			body="Mummu Jacket +2",hands="Mummu Wrists +2",ring1="Mummu Ring",ring2="Hetairoi Ring",
			legs="Mummu Kecks +2",feet="Mummu Gamash. +2"})
	sets.Mode.DA = set_combine(sets.engaged, {
			head="Skormoth Mask",neck="Asperity Necklace",lear="Sherida Earring",rear="Brutal Earring",
			body="Bhikku Cyclas",hands="Herculean Gloves",ring1="Niqmaddu Ring",ring2="Epona's Ring",
			back="Atheling Mantle",waist="Sinew Belt",legs="Limbo Trousers",feet="Herculean Boots"})
	sets.Mode.SB = set_combine(sets.engaged, {head="Bhikku Crown"})
	sets.Mode.sTP = set_combine(sets.engaged, { ammo="Ginsen",
			head="Malignance Chapeau",neck="Anu Torque",lear="Sherida Earring",rear="Bhikku Earring +2",
			body="Tatena. Harama. +1",hands="Otronif Gloves +1",ring1="Rajas Ring",ring2="K'ayres Ring",
			back="Lupine Cape",waist="Yemaya Belt",legs="Hes. Hose",feet="Otronif Boots"})
	sets.Mode.STR = set_combine(sets.engaged, {ammo="Knobkierrie",
			head="Hizamaru Somen +2",neck="Rep. Plat. Medal",lear="Sherida Earring",rear="Bhikku Earring +2",
			body="Hiza. Haramaki +2",hands="Herculean Gloves",ring1="Niqmaddu Ring",ring2="Regal Ring",
			back="Segomo's Mantle",waist="Cornelia's Belt",legs="Hiza. Hizayoroi +2",feet="Hiza. Sune-Ate +2"})

	-- other Sets    
	sets.macc = {
		head="Malignance Chapeau",lear="Gwati Earring",rear="Bhikku Earring +2",
		ring1="Sangoma Ring"}
	sets.PDL = {head="Malignance Chapeau"}
	sets.empy = {head="Bhikku Crown",
		body="Bhikku Cyclas",hands="Bhikku Gloves",
		legs="Bhikku Hose",feet="Bhikku Gaiters"}

	sets.engaged.H2H = {}
	sets.engaged.Staff = {}
	sets.engaged.Club = {}
	sets.engaged.H2H = set_combine(sets.engaged, {main="Suwaiyas"})
	sets.engaged.H2H.Acc = set_combine(sets.engaged.H2H, sets.Mode.Acc)
	sets.engaged.H2H.Att = set_combine(sets.engaged.H2H, sets.Mode.Att)
	sets.engaged.H2H.Crit = set_combine(sets.engaged.H2H, sets.Mode.Crit)
	sets.engaged.H2H.DA = set_combine(sets.engaged.H2H, sets.Mode.DA)
	sets.engaged.H2H.SB = set_combine(sets.engaged.H2H, sets.Mode.SB)
	sets.engaged.H2H.sTP = set_combine(sets.engaged.H2H, sets.Mode.sTP)
	sets.engaged.H2H.STR = set_combine(sets.engaged.H2H, sets.Mode.STR)
	sets.engaged.Staff = set_combine(sets.engaged, {main="Malignance Pole",sub="Bloodrain Strap"})
	sets.engaged.Staff.Acc = set_combine(sets.engaged.H2H, sets.Mode.Acc)
	sets.engaged.Staff.SB = set_combine(sets.engaged.H2H, sets.Mode.SB)
	sets.engaged.Club = set_combine(sets.engaged, {main="Warp Cudgel"})
	sets.engaged.Club.Acc = set_combine(sets.engaged.H2H, sets.Mode.Acc)
	sets.engaged.Club.SB = set_combine(sets.engaged.H2H, sets.Mode.SB)
			
    -- Hundred Fists/Impetus melee set mods
    sets.engaged.HF = set_combine(sets.engaged, {})
    sets.engaged.HF.Impetus = set_combine(sets.engaged, {body="Bhikku Cyclas"})

    -- Footwork combat form
    sets.engaged.Footwork = {back="Segomo's Mantle",legs="Bhikku Hose"}
    sets.engaged.Footwork.Acc = set_combine(sets.engaged.Footwork, {})
    
    -- Precast sets to enhance JAs on use
    sets.precast.JA['Hundred Fists'] = {legs="Hes. Hose"}
    sets.precast.JA['Boost'] = {hands="Anchorite's Gloves"}
    sets.precast.JA['Dodge'] = {feet="Anch. Gaiters"}
    sets.precast.JA['Focus'] = {head="Anchorite's Crown"}
    sets.precast.JA['Counterstance'] = {feet="Hes. Gaiters"}
    sets.precast.JA['Footwork'] = {feet="Bhikku Gaiters"}
    sets.precast.JA['Formless Strikes'] = {body="Hes. Cyclas"}
    sets.precast.JA['Mantra'] = {feet="Hes. Gaiters"}

	-- MND
    sets.precast.JA['Chi Blast'] = {
        head="Hes. Crown",neck="Faith Torque",lear="Lifestorm Earring",
        body="Passion Jacket",hands="Leyline Gloves",ring1="Globidonta Ring",ring2="Metamor. Ring +1",
        waist="Rumination Sash",legs="Limbo Trousers",feet="Hippomenes Socks"}

	-- VIT
    sets.precast.JA['Chakra'] = {ammo="Tantra Tathlum",
        head="Hizamaru Somen +2",
        body="Anchorite's Cyclas",hands="Hizamaru Kote +2",
        legs="Hiza. Hizayoroi +2",feet="Hiza. Sune-Ate +2"}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {ammo="Tantra Tathlum",
        head="Mummu Bonnet +2",
        body="Passion Jacket",hands="Hizamaru Kote +2",ring1="Angel's Ring",ring2="Metamor. Ring +1",
        waist="Chaac Belt",legs="Hiza. Hizayoroi +2",feet="Herculean Boots"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    sets.precast.Step = {waist="Chaac Belt"}
    sets.precast.Flourish1 = {waist="Chaac Belt"}

    -- Fast cast sets for spells
    sets.precast.FC = {head=gear.hercTH,neck="Orunmila's Torque",lear="Etiolation Earring",
		hands="Leyline Gloves",ring1="Naji's Loop",ring2="Prolix Ring",legs="Limbo Trousers"}
    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})

    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
	sets.precast.WS = set_combine(sets.Mode.STR, {ammo="Knobkierrie",
        neck="Fotia Gorget",rear="Ishvara Earring",
        body="Herculean Vest",ring1="Cornelia's Ring",ring2="Epaminondas's Ring",
        back="Segomo's Mantle",waist="Fotia Belt",legs="Hiza. Hizayoroi +2"})    

    -- Specific weaponskill sets.
	-- Thunder, STR 30% DEX 30%
	sets.precast.WS['Combo'] = set_combine(sets.precast.WS, {})
	
	-- Thunder/Water, VIT 100%
	sets.precast.WS['Shoulder Tackle'] = set_combine(sets.precast.WS, {})
	
	-- Dark, VIT 100%
	sets.precast.WS['One Inch Punch'] = set_combine(sets.precast.WS, {})
	
	-- Wind, STR 50% DEX 50%
	sets.precast.WS['Backhand Blow'] = set_combine(sets.precast.WS, {})

	-- Thunder, STR 30% DEX 30%
	sets.precast.WS['Raging Fists'] = set_combine(sets.precast.WS, {})
	
	-- Thunder/Fire, STR 100%
	sets.precast.WS['Spinning Attack'] = set_combine(sets.precast.WS, {})
 
	-- Light/Thunder, STR 20% DEX 50%
    sets.precast.WS['Howling Fist']    = set_combine(sets.precast.WS, {})
    
	-- Wind/Thunder, STR 50% DEX 50%
    sets.precast.WS['Dragon Kick']     = set_combine(sets.precast.WS, {})
	
	-- Dark/Earth/Fire, STR 15% VIT 15%
	sets.precast.WS['Asuran Fists']    = set_combine(sets.precast.WS, {})
    
	-- Wind/Thunder/Ice, STR 40% VIT 40%
    sets.precast.WS['Tornado Kick']    = set_combine(sets.precast.WS, {})
	
	-- Fire/Light/Water, DEX 73%
    sets.precast.WS['Shijin Spiral']   = set_combine(sets.precast.WS, {
		head="Uk'uxkaj Cap",lear="Bladeborn Earring",rear="Steelflash Earring",
		hands="Otronif Gloves +1",ring1="Rajas Ring",
        legs="Jokushu Haidate",feet="Mummu Gamash. +2"})
	
	-- Light/Wind/Thunder, STR 80% 
    sets.precast.WS["Victory Smite"]   = set_combine(sets.precast.WS, {})

	-- Light/Fire, STR 50% VIT 50%
    sets.precast.WS["Ascetic's Fury"]  = set_combine(sets.precast.WS, {})
 
	-- Dark/Water, STR 30% INT 30%
    sets.precast.WS['Cataclysm'] = {
        head=gear.hercTH,neck="Baetyl Pendant",lear="Friomisi Earring",
        body="Lapidary Tunic",hands="Otronif Gloves +1",
        back="Toro Cape",legs="Limbo Trousers",feet="Herculean Boots"} 
		
    -- Midcast Sets
    -- sets.midcast.FastRecast = {}
        
    -- Specific spells
    sets.midcast.Utsusemi = {}
    
    -- Defense sets
    sets.defense.HP = {
        head="Hes. Crown",neck="Sanctity Necklace",lear="Etiolation Earring",rear="Eabani Earring",
        body="Hiza. Haramaki +2",hands="Hesychast's Gloves +1",ring1="K'ayres Ring",ring2="Overbearing Ring",
        back="Anchoret's Mantle",waist="Eschan Stone",legs="Hes. Hose",feet="Hes. Gaiters"}

    sets.defense.Counter = set_combine(sets.Mode.Acc, {ammo="Amar Cluster",
        body="Otronif Harness",hands="Count's Cuffs",rear="Bhikku Earring +2",
        back="Anchoret's Mantle",legs="Anchorite's Hose",feet="Hes. Gaiters"})

	sets.defense.Evasion = { ammo="Amar Cluster",
		head="Hizamaru Somen +2",lear="Infused Earring",rear="Eabani Earring",
		body="Hiza. Haramaki +2",hands="Hizamaru Kote +2",ring1="Vengeful Ring",ring2="Beeline Ring",
		back="Lupine Cape",legs="Hiza. Hizayoroi +2",feet="Ahosi Leggings"}
		
    sets.defense.PDT = {
        head="Malignance Chapeau",neck="Elite Royal Collar",
        body="Otronif Harness",hands="Otronif Gloves +1",ring1="Defending Ring",ring2="Patricius Ring",
        back="Solemnity Cape",waist="Black Belt",legs="Mummu Kecks +2",feet="Ahosi Leggings"}

    sets.defense.MDT = {
        head="Malignance Chapeau",neck="Elite Royal Collar",lear="Etiolation Earring",rear="Eabani Earring",
        body="Herculean Vest",hands="Otronif Gloves +1",ring1="Defending Ring",ring2="Vengeful Ring",
        back="Reiki Cloak",waist="Plat. Mog. Belt",legs="Mummu Kecks +2",feet="Ahosi Leggings"}

	sets.debuffed = set_combine(sets.defense.Evasion,sets.defense.PDT,sets.defense.MDT)
	sets.doom = set_combine(sets.debuffed,{waist="Gishdubar Sash"})
	
    sets.Kiting = {}

    sets.ExtraRegen = {}

    sets.defense.Counter.HF = set_combine(sets.defense.Counter)
    sets.defense.Counter.HF.Impetus = set_combine(sets.defense.Counter, {body="Bhikku Cyclas"})
	
    -- Quick sets for post-precast adjustments, listed here so that the gear can be Validated.
    sets.impetus_body = {body="Bhikku Cyclas"}
    sets.footwork_kick_feet = {back="Segomo's Mantle",feet="Anchorite's Gaiters"}
	-- sets.Assault = {ring2="Ulthalam's Ring"}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    -- Don't gearswap for weaponskills when Defense is on.
    if spell.type == 'WeaponSkill' and state.DefenseMode.current ~= 'None' then
        eventArgs.handled = true
    end
	check_ws_dist(spell)
end

-- Run after the general precast() is done.
function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' and state.DefenseMode.current ~= 'None' then
        if state.Buff.Impetus and (spell.english == "Ascetic's Fury" or spell.english == "Victory Smite") then
            -- Need 6 hits at capped dDex, or 9 hits if dDex is uncapped, for Tantra to tie or win.
            if (state.OffenseMode.current == 'Fodder' and info.impetus_hit_count > 5) or (info.impetus_hit_count > 8) then
                equip(sets.impetus_body)
            end
        elseif state.Buff.Footwork and (spell.english == "Dragon's Kick" or spell.english == "Tornado Kick") then
            equip(sets.footwork_kick_feet)
        end
        
        -- Replace Moonshade Earring if we're at cap TP
        -- if player.tp == 3000 then
            -- equip(sets.precast.MaxTP)
        -- end
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' and not spell.interrupted and state.FootworkWS and state.Buff.Footwork then
        send_command('cancel Footwork')
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
    -- Set Footwork as combat form any time it's active and Hundred Fists is not.
    if buff == 'Footwork' and gain and not buffactive['hundred fists'] then
        state.CombatForm:set('Footwork')
    elseif buff == "Hundred Fists" and not gain and buffactive.footwork then
        state.CombatForm:set('Footwork')
    else
        state.CombatForm:reset()
    end
    
    -- Hundred Fists and Impetus modify the custom melee groups
    if buff == "Hundred Fists" or buff == "Impetus" then
        classes.CustomMeleeGroups:clear()
        
        if (buff == "Hundred Fists" and gain) or buffactive['hundred fists'] then
            classes.CustomMeleeGroups:append('HF')
        end
        
        if (buff == "Impetus" and gain) or buffactive.impetus then
            classes.CustomMeleeGroups:append('Impetus')
        end
    end

    -- Update gear if any of the above changed
    if buff == "Hundred Fists" or buff == "Impetus" or buff == "Footwork" then
        handle_equipping_gear(player.status)
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function customize_idle_set(idleSet)
    if player.hpp < 75 then
        idleSet = set_combine(idleSet, sets.ExtraRegen)
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

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
	classes.CustomMeleeGroups:clear()
	if areas.Adoulin:contains(world.area) and buffactive.ionis then
			classes.CustomMeleeGroups:append('Adoulin')
	end
	pick_tp_weapon()

    update_combat_form()
    update_melee_groups()
end

function job_handle_equipping_gear(status, eventArgs)
	-- add_to_chat(122,'handle equiping gear')
	check_tp_lock()
	pick_tp_weapon()
end
-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function update_combat_form()
    if buffactive.footwork and not buffactive['hundred fists'] then
        state.CombatForm:set('Footwork')
    else
        state.CombatForm:reset()
    end
end

function update_melee_groups()
    classes.CustomMeleeGroups:clear()
    
    if buffactive['hundred fists'] then
        classes.CustomMeleeGroups:append('HF')
    end
    
    if buffactive.impetus then
        classes.CustomMeleeGroups:append('Impetus')
    end
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(2, 10)
		send_command('exec mnkdnc.txt')
    elseif player.sub_job == 'NIN' then
        set_macro_page(3, 10)
    elseif player.sub_job == 'WAR' then
        set_macro_page(1, 10)
    elseif player.sub_job == 'RUN' then
        set_macro_page(4, 10)
    else
        set_macro_page(1, 10)
    end
	send_command('exec mnk.txt')
end


-------------------------------------------------------------------------------------------------------------------
-- Custom event hooks.
-------------------------------------------------------------------------------------------------------------------

-- Keep track of the current hit count while Impetus is up.
function on_action_for_impetus(action)
    if state.Buff.Impetus then
        -- count melee hits by player
        if action.actor_id == player.id then
            if action.category == 1 then
                for _,target in pairs(action.targets) do
                    for _,action in pairs(target.actions) do
                        -- Reactions (bitset):
                        -- 1 = evade
                        -- 2 = parry
                        -- 4 = block/guard
                        -- 8 = hit
                        -- 16 = JA/weaponskill?
                        -- If action.reaction has bits 1 or 2 set, it missed or was parried. Reset count.
                        if (action.reaction % 4) > 0 then
                            info.impetus_hit_count = 0
                        else
                            info.impetus_hit_count = info.impetus_hit_count + 1
                        end
                    end
                end
            elseif action.category == 3 then
                -- Missed weaponskill hits will reset the counter.  Can we tell?
                -- Reaction always seems to be 24 (what does this value mean? 8=hit, 16=?)
                -- Can't tell if any hits were missed, so have to assume all hit.
                -- Increment by the minimum number of weaponskill hits: 2.
                for _,target in pairs(action.targets) do
                    for _,action in pairs(target.actions) do
                        -- This will only be if the entire weaponskill missed or was parried.
                        if (action.reaction % 4) > 0 then
                            info.impetus_hit_count = 0
                        else
                            info.impetus_hit_count = info.impetus_hit_count + 2
                        end
                    end
                end
            end
        elseif action.actor_id ~= player.id and action.category == 1 then
            -- If mob hits the player, check for counters.
            for _,target in pairs(action.targets) do
                if target.id == player.id then
                    for _,action in pairs(target.actions) do
                        -- Spike effect animation:
                        -- 63 = counter
                        -- ?? = missed counter
                        if action.has_spike_effect then
                            -- spike_effect_message of 592 == missed counter
                            if action.spike_effect_message == 592 then
                                info.impetus_hit_count = 0
                            elseif action.spike_effect_animation == 63 then
                                info.impetus_hit_count = info.impetus_hit_count + 1
                            end
                        end
                    end
                end
            end
        end
        
        --add_to_chat(123,'Current Impetus hit count = ' .. tostring(info.impetus_hit_count))
    else
        info.impetus_hit_count = 0
    end
    
end
