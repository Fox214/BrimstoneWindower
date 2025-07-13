include('organizer-lib.lua')
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    Custom commands:
    
    gs c step
        Uses the currently configured step on the target, with either <t> or <stnpc> depending on setting.

    gs c step t
        Uses the currently configured step on the target, but forces use of <t>.
    
    
    Configuration commands:
    
    gs c cycle mainstep
        Cycles through the available steps to use as the primary step when using one of the above commands.
        
    gs c cycle altstep
        Cycles through the available steps to use for alternating with the configured main step.
        
    gs c toggle usealtstep
        Toggles whether or not to use an alternate step.
        
    gs c toggle selectsteptarget
        Toggles whether or not to use <stnpc> (as opposed to <t>) when using a step.
--]]


-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Climactic Flourish'] = buffactive['climactic flourish'] or false

    state.MainStep = M{['description']='Main Step', 'Box Step', 'Quickstep', 'Feather Step', 'Stutter Step'}
    state.AltStep = M{['description']='Alt Step', 'Quickstep', 'Feather Step', 'Stutter Step', 'Box Step'}
    state.UseAltStep = M(false, 'Use Alt Step')
    state.SelectStepTarget = M(false, 'Select Step Target')
    state.IgnoreTargetting = M(false, 'Ignore Targetting')

    state.CurrentStep = M{['description']='Current Step', 'Main', 'Alt'}
    state.SkillchainPending = M(false, 'Skillchain Pending')

	state.WeaponMode = M{['description']='Weapon Mode', 'Dagger', 'Sword', 'Club', 'H2H'}
 	state.SubMode = M{['description']='Sub Mode', 'DW' }
	state.RWeaponMode = M{['description']='RWeapon Mode', 'Stats', 'Boomerrang'}
	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive'}

	get_combat_form()
	pick_tp_weapon()
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
	state.RWeaponMode:set('Stats') 
	state.DefenseMode:options('None', 'Physical', 'Magical')
	state.PhysicalDefenseMode:options('PDT', 'Evasion')
	state.MagicalDefenseMode:options('MDT')
	state.Stance:set('Offensive')

    -- Additional local binds
    send_command('bind ^= gs c cycle mainstep')
    send_command('bind != gs c cycle altstep')
    send_command('bind ^- gs c toggle selectsteptarget')
    send_command('bind !- gs c toggle usealtstep')
    send_command('bind ^` input /ja "Chocobo Jig" <me>')
    send_command('bind !` input /ja "Chocobo Jig II" <me>')

    select_default_macro_book()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind ^=')
    send_command('unbind !=')
    send_command('unbind ^-')
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
		echos="Echo Drops",
		food="Squid Sushi",
		med1="Hi-Potion +3",
		med2="Elixer Vitae",
		med3="Icarus Wing",
		shihei="Shihei",
		orb="Macrocosmic Orb"
	}
	sets.idle = {
        head="Malignance Chapeau",neck="Elite Royal Collar",lear="Infused Earring",rear="Etiolation Earring",
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
        head="Malignance Chapeau",neck="Combatant's Torque",lear="Odr Earring",rear="Eabani Earring",
        body="Meg. Cuirie +2",hands="Herculean Gloves",ring1="Epona's Ring",ring2="Hetairoi Ring",
        back="Ground. Mantle +1",waist="Sarissapho. Belt",legs="Meg. Chausses +2",feet="Herculean Boots"}

	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {
		head="Malignance Chapeau",neck="Combatant's Torque",lear="Zennaroi Earring",rear="Macu. Earring +1",
		body="Meg. Cuirie +2",hands="Meg. Gloves +2",ring1="Cacoethic Ring +1",ring2="Regal Ring",
		back="Ground. Mantle +1",waist="Olseni Belt",legs="Meg. Chausses +2",feet="Meg. Jam. +2"})
	sets.Mode.Att= set_combine(sets.engaged, {
		head="Meghanada Visor +2",neck="Rep. Plat. Medal",lear="Bladeborn Earring",rear="Dudgeon Earring",
		body="Meg. Cuirie +2",hands="Meg. Gloves +2",ring1="Overbearing Ring",ring2="Regal Ring",
		back="Atheling Mantle",waist="Sulla Belt",legs="Meg. Chausses +2",feet="Meg. Jam. +2"})
	-- Crit then DEX
	sets.Mode.Crit = set_combine(sets.engaged, {
		head="Uk'uxkaj Cap",neck="Love Torque",lear="Odr Earring",
		body="Meg. Cuirie +2",hands="Mummu Wrists +2",ring1="Rajas Ring",
		legs="Mummu Kecks +2",feet="Herculean Boots"})
	sets.Mode.DA = set_combine(sets.engaged, {
		neck="Asperity Necklace",lear="Sherida Earring",rear="Brutal Earring",
		hands="Herculean Gloves",
		back="Canny Cape",waist="Sarissapho. Belt",legs="Meg. Chausses +2",feet="Herculean Boots"})
	sets.Mode.SB = set_combine(sets.engaged, {})
	sets.Mode.sTP = set_combine(sets.engaged, {
		head="Malignance Chapeau",neck="Combatant's Torque",lear="Sherida Earring",rear="Macu. Earring +1",
		ring1="Rajas Ring",ring2="K'ayres Ring",
		back="Lupine Cape",legs="Iuitl Tights"})
	sets.Mode.STR = set_combine(sets.engaged, {
		head="Meghanada Visor +2",neck="Rep. Plat. Medal",
		body="Meg. Cuirie +2",hands="Meg. Gloves +2",ring1="Apate Ring",ring2="Regal Ring",
		back="Lupine Cape",waist="Sailfi Belt +1",legs="Herculean Trousers",feet="Meg. Jam. +2"})

	-- other Sets    
	sets.macc = {head="Malignance Chapeau",lear="Gwati Earring",ring1="Sangoma Ring"}
	sets.PDL = {head="Malignance Chapeau"}
	sets.empy = {head="Maculele Tiara",
		body="Maculele Casaque",hands="Maculele Bangles",
		legs="Maculele Tights",feet="Maculele Toe Shoes"}

	-- Sets with weapons defined.
 	sets.engaged.Club = {}
	sets.engaged.Dagger = {}
	sets.engaged.H2H = {}
	sets.engaged.Sword = {}
	sets.engaged.DW = set_combine(sets.engaged, {})
	-- sets.engaged.Shield = set_combine(sets.engaged, {})
	sets.engaged.DW.Dagger = set_combine(sets.engaged, {main="Skinflayer",sub="Taming Sari"})
	-- sets.engaged.Shield.Dagger = set_combine(sets.engaged, {main="Skinflayer",sub="Viking Shield"})
	--Add in appropriate Ranged weapons
	sets.ranged = {}
	sets.ranged.Stats = {ranged="",ammo="Yamarang"}
	sets.ranged.Boomerrang = {ranged="Aliyat Chakram",ammo=""}
	--Finalize the sets
	sets.engaged.DW.Dagger.Boomerrang = set_combine(sets.engaged.DW.Dagger, sets.ranged.Boomerrang)
	sets.engaged.DW.Dagger.Stats = set_combine(sets.engaged.DW.Dagger, sets.ranged.Stats)
	-- sets.engaged.Shield.Dagger.Boomerrang = set_combine(sets.engaged.Shield.Dagger, sets.ranged.Boomerrang)
	-- sets.engaged.Shield.Dagger.Stats = set_combine(sets.engaged.Shield.Dagger, sets.ranged.Stats)
	sets.engaged.DW.Dagger.Acc = set_combine(sets.engaged.DW.Dagger, sets.Mode.Acc)
	sets.engaged.DW.Dagger.Att = set_combine(sets.engaged.DW.Dagger, sets.Mode.Att)
	sets.engaged.DW.Dagger.Crit = set_combine(sets.engaged.DW.Dagger, sets.Mode.Crit)
	sets.engaged.DW.Dagger.DA = set_combine(sets.engaged.DW.Dagger, sets.Mode.DA)
	-- sets.engaged.DW.Dagger.SB = set_combine(sets.engaged.DW.Dagger, {neck="Love Torque",
        -- ring2="Aife's Ring"})
	sets.engaged.DW.Dagger.sTP = set_combine(sets.engaged.DW.Dagger, sets.Mode.sTP)
	sets.engaged.DW.Dagger.STR = set_combine(sets.engaged.DW.Dagger, sets.Mode.STR)
	-- sets.engaged.Shield.Dagger.Acc = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Acc)
	-- sets.engaged.Shield.Dagger.Att = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Att)
	-- sets.engaged.Shield.Dagger.Crit = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Crit)
	-- sets.engaged.Shield.Dagger.DA = set_combine(sets.engaged.Shield.Dagger, sets.Mode.DA)
	-- sets.engaged.Shield.Dagger.SB = set_combine(sets.engaged.Shield.Dagger, {neck="Love Torque",
        -- ring2="Aife's Ring"})
	-- sets.engaged.Shield.Dagger.sTP = set_combine(sets.engaged.Shield.Dagger, sets.Mode.sTP)
	-- sets.engaged.Shield.Dagger.STR = set_combine(sets.engaged.Shield.Dagger, sets.Mode.STR)
	
	sets.engaged.DW.Sword = set_combine(sets.engaged, {main="Apaisante",sub="Taming Sari"})
	-- sets.engaged.Shield.Sword = set_combine(sets.engaged, {main="Apaisante",sub="Viking Shield"})
	sets.engaged.DW.Sword.Acc = set_combine(sets.engaged.DW.Sword, sets.Mode.Acc)
	sets.engaged.DW.Sword.Att = set_combine(sets.engaged.DW.Sword, sets.Mode.Att)
	sets.engaged.DW.Sword.Crit = set_combine(sets.engaged.DW.Sword, sets.Mode.Crit)
	sets.engaged.DW.Sword.DA = set_combine(sets.engaged.DW.Sword, sets.Mode.DA)
	sets.engaged.DW.Sword.sTP = set_combine(sets.engaged.DW.Sword, sets.Mode.sTP)
	sets.engaged.DW.Sword.STR = set_combine(sets.engaged.DW.Sword, sets.Mode.STR)
	-- sets.engaged.Shield.Sword.Acc = set_combine(sets.engaged.Shield.Sword, sets.Mode.Acc)
	-- sets.engaged.Shield.Sword.Att = set_combine(sets.engaged.Shield.Sword, sets.Mode.Att)
	-- sets.engaged.Shield.Sword.Crit = set_combine(sets.engaged.Shield.Sword, sets.Mode.Crit)
	-- sets.engaged.Shield.Sword.DA = set_combine(sets.engaged.Shield.Sword, sets.Mode.DA)
	-- sets.engaged.Shield.Sword.sTP = set_combine(sets.engaged.Shield.Sword, sets.Mode.sTP)
	-- sets.engaged.Shield.Sword.STR = set_combine(sets.engaged.Shield.Sword, sets.Mode.STR)
	sets.engaged.DW.Club = set_combine(sets.engaged, {main="Warp Cudgel",sub="Taming Sari"})
	sets.engaged.DW.Club.Acc = set_combine(sets.engaged.DW.Club, sets.Mode.Acc)
	-- sets.engaged.Shield.Club = set_combine(sets.engaged, {main="Warp Cudgel",sub="Viking Shield"})
	-- sets.engaged.Shield.Club.Acc = set_combine(sets.engaged.Shield.Club, sets.Mode.Acc)
	sets.engaged.H2H = set_combine(sets.engaged, {main="",sub=""})
	sets.engaged.H2H.Acc = set_combine(sets.engaged.Club, sets.Mode.Acc)

    -- Weaponskill sets

    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = set_combine(sets.Mode.STR, {neck="Fotia Gorget",lear="Ishvara Earring",rear="Macu. Earring +1",
        hands="Meg. Gloves +2",ring1="Cornelia's Ring",ring2="Epaminondas's Ring",waist="Fotia Belt"})

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	-- Earth, DEX 100%
	sets.precast.WS['Wasp Sting'] = set_combine(sets.precast.WS, {})

	-- Wind, DEX 40% INT 40%
	sets.precast.WS['Gust Slash'] = set_combine(sets.precast.WS, {})

	-- Water, CHR 100%
	sets.precast.WS['Shadowstitch'] = set_combine(sets.precast.WS, {})

 	-- Earth, DEX 100%
	sets.precast.WS['Viper Bite'] = set_combine(sets.precast.WS, {})
 
 	-- Wind/Thunder, DEX 40% INT 40%
	sets.precast.WS['Cyclone'] = set_combine(sets.precast.WS, {})
 
  	-- none, MND 100%
	sets.precast.WS['Energy Steal'] = set_combine(sets.precast.WS, {})
 
  	-- none, MND 100%
	sets.precast.WS['Energy Drain'] = set_combine(sets.precast.WS, {})

	-- Wind/Earth, DEX 40% CHR 40%
    sets.precast.WS['Dancing Edge'] = set_combine(sets.precast.WS, {})
	
	-- Wind/Thunder, DEX 40% AGI 40%
    sets.precast.WS["Shark Bite"] = set_combine(sets.precast.WS, {})
 
	-- Light/Dark/Earth, DEX 50%
    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, sets.Mode.Crit, {})

	-- Wind/Thunder/Earth, DEX 40% AGI 40%
    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS, {
        lear="Friomisi Earring",rear="Moonshade Earring",
        body="Lapidary Tunic",
        back="Toro Cape"})

	-- Wind/Thunder/Earth, AGI 73%
	sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {})

	-- Ice/Water/Dark, DEX 80%
    sets.precast.WS["Rudra's Storm"] = set_combine(sets.precast.WS, {})

	-- Light/Fire/Dark, DEX 60%
    sets.precast.WS['Mandalic Stab'] = set_combine(sets.precast.WS, {})

    -- Precast sets to enhance JAs

    sets.precast.JA['No Foot Rise'] = {body="Horos Casaque"}

    sets.precast.JA['Trance'] = {head="Horos Tiara"}
    

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        head="Meghanada Visor +2",lear="Roundel Earring",
        body="Dancer's Casaque",hands="Meg. Gloves +2",ring1="Metamor. Ring +1",
        back="Toetapper Mantle",legs="Meg. Chausses +2"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}
    
    sets.precast.Samba = {head="Dancer's Tiara"}

    sets.precast.Jig = {legs="Horos Tights", feet="Dancer's Toe Shoes"}

    sets.precast.Step = {hands="Dancer's Bangles",waist="Chaac Belt"}
    sets.precast.Step['Feather Step'] = {feet="Charis Toe Shoes +2"}

    sets.precast.Flourish1 = {}
    -- magic accuracy
    sets.precast.Flourish1['Violent Flourish'] = {} 
    -- acc gear
    sets.precast.Flourish1['Desperate Flourish'] = set_combine(sets.Mode.Acc, {})

    sets.precast.Flourish2 = {}
    sets.precast.Flourish2['Reverse Flourish'] = {hands="Charis Bangles +2"}

    sets.precast.Flourish3 = {}
    sets.precast.Flourish3['Striking Flourish'] = {body="Charis Casaque +2"}
    sets.precast.Flourish3['Climactic Flourish'] = {head="Charis Tiara +2"}

    -- Fast cast sets for spells
    
    sets.precast.FC = {neck="Orunmila's Torque",ring1="Prolix Ring", ring2="Naji's Loop"}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})
       
    sets.precast.Skillchain = {hands="Charis Bangles +2"}
    
    -- Midcast Sets
    -- sets.midcast.FastRecast = {}
    sets.midcast.RA = {
		head="Meghanada Visor +2",lear="Infused Earring",rear="Enervating Earring",
		body="Meg. Cuirie +2",hands="Meg. Gloves +2",ring1="Paqichikaji Ring",ring2="Cacoethic Ring +1",
		waist="Eschan Stone",legs="Meg. Chausses +2",feet="Meg. Jam. +2"}
		
    -- Specific spells
    sets.midcast.Utsusemi = {}
    
    -- Defense sets
    sets.defense.Evasion = {
        head="Malignance Chapeau",lear="Infused Earring",rear="Eabani Earring",
        body="Passion Jacket",hands="Kurys Gloves",ring1="Beeline Ring",
        back="Lupine Cape",legs="Herculean Trousers",feet="Herculean Boots"}

    sets.defense.PDT = {
        head="Malignance Chapeau",neck="Elite Royal Collar",
        body="Meg. Cuirie +2",hands="Meg. Gloves +2",ring1="Defending Ring",ring2="Patricius Ring",
        back="Solemnity Cape",waist="Plat. Mog. Belt",legs="Meg. Chausses +2",feet="Ahosi Leggings"}

    sets.defense.MDT = {
        head="Malignance Chapeau",neck="Elite Royal Collar",lear="Etiolation Earring",rear="Eabani Earring",
        body="Passion Jacket",hands="Kurys Gloves",ring1="Defending Ring",ring2="Moonbeam Ring",
        back="Reiki Cloak",waist="Plat. Mog. Belt",legs="Mummu Kecks +2",feet="Ahosi Leggings"}

	sets.debuffed = set_combine(sets.defense.Evasion,sets.defense.PDT,sets.defense.MDT)
	sets.doom = set_combine(sets.debuffed,{waist="Gishdubar Sash"})
    sets.Kiting = {feet="Skadi's Jambeaux +1"}

    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    sets.buff['Saber Dance'] = {legs="Horos Tights"}
    sets.buff['Climactic Flourish'] = {head="Charis Tiara +2"}
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    check_ws_dist(spell)
end


function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == "WeaponSkill" then
        if state.Buff['Climactic Flourish'] then
            equip(sets.buff['Climactic Flourish'])
        end
        if state.SkillchainPending.value == true then
            equip(sets.precast.Skillchain)
        end
    end
end


-- Return true if we handled the aftercast work.  Otherwise it will fall back
-- to the general aftercast() code in Mote-Include.
function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english == "Wild Flourish" then
            state.SkillchainPending:set()
            send_command('wait 5;gs c unset SkillchainPending')
        elseif spell.type:lower() == "weaponskill" then
            state.SkillchainPending:toggle()
            send_command('wait 6;gs c unset SkillchainPending')
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

function job_handle_equipping_gear(status, eventArgs)
	-- add_to_chat(122,'handle equiping gear')
	check_tp_lock()
	set_combat_form()
	pick_tp_weapon()
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff,gain)
    -- If we gain or lose any haste buffs, adjust which gear set we target.
    if S{'haste','march','embrava','haste samba'}:contains(buff:lower()) then
        determine_haste_group()
        handle_equipping_gear(player.status)
    elseif buff == 'Saber Dance' or buff == 'Climactic Flourish' then
        handle_equipping_gear(player.status)
    end
end


function job_status_change(new_status, old_status)
    if new_status == 'Engaged' then
        determine_haste_group()
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the default 'update' self-command.
function job_update(cmdParams, eventArgs)
    determine_haste_group()
end


function customize_idle_set(idleSet)
    if player.hpp < 80 and not areas.Cities:contains(world.area) then
        idleSet = set_combine(idleSet, sets.ExtraRegen)
    end
    
    return idleSet
end

function customize_melee_set(meleeSet)
    if state.DefenseMode.value ~= 'None' then
        if buffactive['saber dance'] then
            meleeSet = set_combine(meleeSet, sets.buff['Saber Dance'])
        end
        if state.Buff['Climactic Flourish'] then
            meleeSet = set_combine(meleeSet, sets.buff['Climactic Flourish'])
        end
    end
    
    return meleeSet
end

-- Handle auto-targetting based on local setup.
function job_auto_change_target(spell, action, spellMap, eventArgs)
    if spell.type == 'Step' then
        if state.IgnoreTargetting.value == true then
            state.IgnoreTargetting:reset()
            eventArgs.handled = true
        end
        
        eventArgs.SelectNPCTargets = state.SelectStepTarget.value
    end
end


-- Function to display the current relevant user state when doing an update.
-- Set eventArgs.handled to true if display was handled, and you don't want the default info shown.
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

    msg = msg .. ', ['..state.MainStep.current

    if state.UseAltStep.value == true then
        msg = msg .. '/'..state.AltStep.current
    end
    
    msg = msg .. ']'

    if state.SelectStepTarget.value == true then
        steps = steps..' (Targetted)'
    end

    add_to_chat(122, msg)

    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- User self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for custom player commands.
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1] == 'step' then
        if cmdParams[2] == 't' then
            state.IgnoreTargetting:set()
        end

        local doStep = ''
        if state.UseAltStep.value == true then
            doStep = state[state.CurrentStep.current..'Step'].current
            state.CurrentStep:cycle()
        else
            doStep = state.MainStep.current
        end        
        
        send_command('@input /ja "'..doStep..'" <t>')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_haste_group()
    -- We have three groups of DW in gear: Charis body, Charis neck + DW earrings, and Patentia Sash.

    -- For high haste, we want to be able to drop one of the 10% groups (body, preferably).
    -- High haste buffs:
    -- 2x Marches + Haste
    -- 2x Marches + Haste Samba
    -- 1x March + Haste + Haste Samba
    -- Embrava + any other haste buff
    
    -- For max haste, we probably need to consider dropping all DW gear.
    -- Max haste buffs:
    -- Embrava + Haste/March + Haste Samba
    -- 2x March + Haste + Haste Samba

    classes.CustomMeleeGroups:clear()
    
    if buffactive.embrava and (buffactive.haste or buffactive.march) and buffactive['haste samba'] then
        classes.CustomMeleeGroups:append('MaxHaste')
    elseif buffactive.march == 2 and buffactive.haste and buffactive['haste samba'] then
        classes.CustomMeleeGroups:append('MaxHaste')
    elseif buffactive.embrava and (buffactive.haste or buffactive.march or buffactive['haste samba']) then
        classes.CustomMeleeGroups:append('HighHaste')
    elseif buffactive.march == 1 and buffactive.haste and buffactive['haste samba'] then
        classes.CustomMeleeGroups:append('HighHaste')
    elseif buffactive.march == 2 and (buffactive.haste or buffactive['haste samba']) then
        classes.CustomMeleeGroups:append('HighHaste')
    end
end


-- Automatically use Presto for steps when it's available and we have less than 3 finishing moves
function auto_presto(spell)
    if spell.type == 'Step' then
        local allRecasts = windower.ffxi.get_ability_recasts()
        local prestoCooldown = allRecasts[236]
        local under3FMs = not buffactive['Finishing Move 3'] and not buffactive['Finishing Move 4'] and not buffactive['Finishing Move 5']
        
        if player.main_job_level >= 77 and prestoCooldown < 1 and under3FMs then
            cast_delay(1.1)
            send_command('@input /ja "Presto" <me>')
        end
    end
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'WAR' then
        set_macro_page(1, 20)
    elseif player.sub_job == 'NIN' then
        set_macro_page(1, 20)
    elseif player.sub_job == 'SAM' then
        set_macro_page(1, 20)
    else
        set_macro_page(1, 20)
    end
end

function get_combat_form()
	set_combat_form()
end

function pick_tp_weapon()
	-- add_to_chat(122,' pick tp weapon '..state.WeaponMode.value)
	set_combat_weapon()
	-- add_to_chat(123, 'combat weapon set to '..state.CombatWeapon.value)
end

