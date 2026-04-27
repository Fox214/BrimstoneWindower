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
    -- List of pet weaponskills to check for
    petWeaponskills = S{"Slapstick", "Knockout", "Magic Mortar",
        "Chimera Ripper", "String Clipper",  "Cannibal Blade", "Bone Crusher", "String Shredder",
        "Arcuballista", "Daze", "Armor Piercer", "Armor Shatterer"}
    
    -- Map automaton heads to combat roles
    petModes = {
        ['Harlequin Head'] = 'Melee',
        ['Sharpshot Head'] = 'Ranged',
        ['Valoredge Head'] = 'Tank',
        ['Stormwaker Head'] = 'Magic',
        ['Soulsoother Head'] = 'Heal',
        ['Spiritreaver Head'] = 'Nuke'
        }

    -- Subset of modes that use magic
    magicPetModes = S{'Nuke','Heal','Magic'}
    
    -- Var to track the current pet mode.
    state.PetMode = M{['description']='Pet Mode', 'None', 'Melee', 'Ranged', 'Tank', 'Magic', 'Heal', 'Nuke'}
	state.WeaponMode = M{['description']='Weapon Mode', 'H2H', 'H2HM', 'Staff', 'Club'}
	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive'}
	state.holdtp = M{['description']='holdtp', 'false', 'true'}
	state.immuno = M{['description']='immuno', 'false', 'true'}
	get_combat_form()
	pick_tp_weapon()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'SB', 'sTP', 'STR', 'Eva', 'DT', 'Meva')
	state.WeaponskillMode:options('Normal')
	state.DefenseMode:options('None', 'Physical', 'Magical')
	state.PhysicalDefenseMode:options('PDT', 'Evasion')
	state.MagicalDefenseMode:options('MDT')
	state.WeaponMode:set('H2H')
	state.Stance:set('Offensive')
	state.holdtp:set('false')
	state.immuno:set('false')
	pick_tp_weapon()

    -- Default maneuvers 1, 2, 3 and 4 for each pet mode.
    defaultManeuvers = {
        ['Melee'] = {'Fire Maneuver', 'Thunder Maneuver', 'Wind Maneuver', 'Light Maneuver'},
        ['Ranged'] = {'Wind Maneuver', 'Fire Maneuver', 'Thunder Maneuver', 'Light Maneuver'},
        ['Tank'] = {'Earth Maneuver', 'Dark Maneuver', 'Light Maneuver', 'Wind Maneuver'},
        ['Magic'] = {'Ice Maneuver', 'Light Maneuver', 'Dark Maneuver', 'Earth Maneuver'},
        ['Heal'] = {'Light Maneuver', 'Dark Maneuver', 'Water Maneuver', 'Earth Maneuver'},
        ['Nuke'] = {'Ice Maneuver', 'Dark Maneuver', 'Light Maneuver', 'Earth Maneuver'}
    }

    update_pet_mode()
    select_default_macro_book()
end


-- Define sets used by this job file.
function init_gear_sets()
	organizer_items = {
        new1="",
		new2="",
		new3="",
		new4="",
		new5="",
		new6="",
		echos="Echo Drops",
		food="Squid Sushi",
		food2="Akamochi",
		food3="Grape Daifuku",
		shihei="Shihei",
		orb="Macrocosmic Orb",
		orb1="Moon Orb"
	}
	-- Idle sets

    sets.idle = {
        head="Null Masque",neck="Elite Royal Collar",lear="Alabaster Earring",rear="Infused Earring",
        body="Hiza. Haramaki +2",hands="Nyame Gauntlets",ring1="Murky Ring",ring2="Vengeful Ring",
        back="Contriver's Cape",waist="Null Belt",legs="Nyame Flanchard",feet="Hippomenes Socks"}

    sets.idle.Town = set_combine(sets.idle, {rear="Kara. Earring +1"})
     
	-- Set for idle while pet is out (eg: pet regen gear)
    sets.idle.Pet = set_combine(sets.idle, {head="Pantin Taj +2",back="Contriver's Cape"})

    -- Idle sets to wear while pet is engaged
    sets.idle.Pet.Engaged = { main="Pitre Fists",range="Animator P",ammo="Automat. Oil +3",
        head="Foire Taj +3",neck="Adad Amulet",lear="Enmerkar Earring",rear="Kara. Earring +1",
        body="Nyame Mail",hands="Mpaca's Gloves",ring1="Murky Ring",ring2="Tali'ah Ring",
        back="Visucius's Mantle",waist="Incarnation Sash",legs="Nyame Flanchard",feet="Mpaca's Boots"}

    sets.idle.Pet.Engaged.Ranged = set_combine(sets.idle.Pet.Engaged, {
		range="Animator P",ammo="Automat. Oil +3",
		hands="Cirque Guanti",
		back="Visucius's Mantle",legs="Cirq. Pantaloni +1"})

    sets.idle.Pet.Engaged.Nuke = set_combine(sets.idle.Pet.Engaged, {
		main="Ohtas",range="Animator P",ammo="Automat. Oil +3",
		neck="Adad Amulet",legs="Cirq. Pantaloni +1",feet="Foire Babouches +3"})

    sets.idle.Pet.Engaged.Magic = set_combine(sets.idle.Pet.Engaged, {
		main="Ohtas",range="Animator P",ammo="Automat. Oil +3",
		head="Pantin Taj +2",neck="Adad Amulet",
		legs="Cirq. Pantaloni +1",feet="Cirque Scarpe +2"})
		
   sets.idle.Pet.Engaged.Heal = set_combine(sets.idle.Pet.Magic, {
		legs="Foire Churidars +3"})

	sets.idle.Pet.Offensive = set_combine(sets.idle.Pet.Engaged, {})
    
	sets.idle.Pet.Defensive = set_combine(sets.idle.Pet.Engaged, {
		head="Anwig Salade",lear="Enmerkar Earring",rear="Hypaspist Earring",
		back="Visucius's Mantle",legs="Foire Churidars +3"})
		
	-- Resting sets
    sets.resting = {}

	-- Normal melee group
    sets.engaged = {
        head="Foire Taj +3",neck="Shulmanu Collar",lear="Schere Earring",rear="Kara. Earring +1",
        body="Nyame Mail",hands="Mpaca's Gloves",ring1="Niqmaddu Ring",ring2="Epona's Ring",
        back="Visucius's Mantle",waist="Hurch'lan Sash",legs="Mpaca's Hose",feet="Mpaca's Boots"}

	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {
		head="Foire Taj +3",neck="Shulmanu Collar",rear="Kara. Earring +1",
        body="Foire Tobe +3",hands="Foire Dastanas +3",ring1="Cacoethic Ring +1",ring2="Regal Ring",
        back="Visucius's Mantle",waist="Null Belt",legs="Foire Churidars +3",feet="Foire Dastanas +3"})
	sets.Mode.Att= set_combine(sets.engaged, {
        head="Nyame Helm",neck="Rep. Plat. Medal",
        body="Nyame Mail",hands="Mpaca's Gloves",ring1="Overbearing Ring",ring2="Regal Ring",
        back="Visucius's Mantle",waist="Eschan Stone",legs="Nyame Flanchard",feet="Nyame Sollerets"})
	sets.Mode.Crit = set_combine(sets.engaged, {hands="Tali'ah Gages +2",legs="Mpaca's Hose"})
	sets.Mode.DA = set_combine(sets.engaged, {lear="Schere Earring",rear="Brutal Earring",
        body="Tali'ah Manteel +2",hands="Mpaca's Gloves",ring1="Niqmaddu Ring",ring2="Epona's Ring",
		back="Null Shawl",legs="Mpaca's Hose"})
	sets.Mode.SB = set_combine(sets.engaged, {lear="Schere Earring"})
	sets.Mode.sTP = set_combine(sets.engaged, {neck="Combatant's Torque",lear="Crep. Earring",rear="Tripudio Earring",
		back="Null Shawl"})
	sets.Mode.STR = set_combine(sets.engaged, {
		head="Mpaca's Cap",neck="Rep. Plat. Medal",lear="Schere Earring",
        body="Hiza. Haramaki +2",hands="Regal Cpt. Gloves",ring1="Niqmaddu Ring",ring2="Regal Ring",
        back="Lupine Cape",waist="Cornelia's Belt",legs="Hiza. Hizayoroi +2",feet="Hiza. Sune-Ate +2"})
	sets.Mode.Eva = set_combine(sets.engaged, {
        head="Null Masque",neck="Elite Royal Collar",lear="Infused Earring",rear="Eabani Earring",
        body="Nyame Mail",hands="Nyame Gauntlets",ring1="Vengeful Ring",ring2="Beeline Ring",
        back="Lupine Cape",waist="Null Belt",legs="Nyame Flanchard",feet="Nyame Sollerets"})
    sets.Mode.DT = set_combine(sets.engaged, {
        head="Null Masque",neck="Elite Royal Collar",lear="Alabaster Earring",
        body="Nyame Mail",hands="Nyame Gauntlets",ring1="Murky Ring",
        back="Solemnity Cape",waist="Plat. Mog. Belt",legs="Nyame Flanchard",feet="Nyame Sollerets"})
    sets.Mode.Meva = set_combine(sets.engaged, {
        head="Nyame Helm",neck="Elite Royal Collar",lear="Etiolation Earring",rear="Eabani Earring",
        body="Nyame Mail",hands="Nyame Gauntlets",ring1="Murky Ring",
        back="Null Shawl",waist="Null Belt",legs="Nyame Flanchard",feet="Nyame Sollerets"})
		
	-- other Sets 
	sets.macc = {head="Malignance Chapeau",neck="Null Loop",lear="Crep. Earring",rear="Digni. Earring",
		body="Nyame Mail",hands="Nyame Gauntlets",ring1="Sangoma Ring",
		back="Null Shawl",waist="Null Belt",legs="Nyame Flanchard",feet="Nyame Sollerets"}
	sets.PDL = {head="Malignance Chapeau"}
	sets.empy = {head="Karagoz Cappello",
		body="Karagoz Farsetto",hands="Cirque Guanti",
		legs="Cirq. Pantaloni +1",feet="Karagoz Scarpe"}		
	
	--Initialize Main Weapons
	sets.engaged.H2H = {}
	sets.engaged.Staff = {}
	sets.engaged.Club = {}
	sets.engaged.H2H = set_combine(sets.engaged, {main="Pitre Fists"})
	sets.engaged.H2H.Acc = set_combine(sets.engaged.H2H, sets.Mode.Acc)
	sets.engaged.H2H.Att = set_combine(sets.engaged.H2H, sets.Mode.Att)
	sets.engaged.H2H.Crit = set_combine(sets.engaged.H2H, sets.Mode.Crit)
	sets.engaged.H2H.DA = set_combine(sets.engaged.H2H, sets.Mode.DA)
	sets.engaged.H2H.SB = set_combine(sets.engaged.H2H, sets.Mode.SB)
	sets.engaged.H2H.sTP = set_combine(sets.engaged.H2H, sets.Mode.sTP)
	sets.engaged.H2H.STR = set_combine(sets.engaged.H2H, sets.Mode.STR)
	sets.engaged.H2H.Eva = set_combine(sets.engaged.H2H, sets.Mode.Eva)
	sets.engaged.H2H.DT = set_combine(sets.engaged.H2H, sets.Mode.DT)
	sets.engaged.H2H.Meva = set_combine(sets.engaged.H2H, sets.Mode.Meva)
	
	sets.engaged.H2HM = set_combine(sets.engaged, {main="Godhands"})
	sets.engaged.H2HM.Acc = set_combine(sets.engaged.H2HM, sets.Mode.Acc)
	sets.engaged.H2HM.Att = set_combine(sets.engaged.H2HM, sets.Mode.Att)
	sets.engaged.H2HM.Crit = set_combine(sets.engaged.H2HM, sets.Mode.Crit)
	sets.engaged.H2HM.DA = set_combine(sets.engaged.H2HM, sets.Mode.DA)
	sets.engaged.H2HM.SB = set_combine(sets.engaged.H2HM, sets.Mode.SB)
	sets.engaged.H2HM.sTP = set_combine(sets.engaged.H2HM, sets.Mode.sTP)
	sets.engaged.H2HM.STR = set_combine(sets.engaged.H2HM, sets.Mode.STR)
	sets.engaged.H2HM.Eva = set_combine(sets.engaged.H2HM, sets.Mode.Eva)
	sets.engaged.H2HM.DT = set_combine(sets.engaged.H2HM, sets.Mode.DT)
	sets.engaged.H2HM.Meva = set_combine(sets.engaged.H2HM, sets.Mode.Meva)

	sets.engaged.Staff = set_combine(sets.engaged, {main="Gozuki Mezuki",sub="Bloodrain Strap"})
	sets.engaged.Staff.Acc = set_combine(sets.engaged.H2H, sets.Mode.Acc)
	sets.engaged.Staff.SB = set_combine(sets.engaged.H2H, sets.Mode.SB)
	
	sets.engaged.Club = set_combine(sets.engaged, {main="Warp Cudgel"})
	sets.engaged.Club.Acc = set_combine(sets.engaged.H2H, sets.Mode.Acc)
	sets.engaged.Club.SB = set_combine(sets.engaged.H2H, sets.Mode.SB)

    -- Precast Sets
    -- Fast cast sets for spells
    sets.precast.FC = {neck="Orunmila's Torque",legs="Gyve Trousers",ring1="Naji's Loop",ring2="Prolix Ring"}
    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})
    
    -- Precast sets to enhance JAs
    sets.precast.JA['Activate'] = {back="Visucius's Mantle",feet="Mpaca's Boots"}
    sets.precast.JA['Deus Ex Automata'] = set_combine(sets.precast.JA['Activate'], {})
    sets.precast.JA['Overdrive'] = {body="Pitre Tobe"}
    sets.precast.JA['Tactical Switch'] = {feet="Cirque Scarpe +2"}
    sets.precast.JA['Repair'] = {ammo="Automat. Oil +3",lear="Pratik Earring",feet="Foire Babouches +3"}
    sets.precast.JA.Maneuver = {neck="Buffoon's Collar",body="Cirque Farsetto +2",hands="Foire Dastanas +3"}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        head="Nyame Helm",lear="Roundel Earring",
        body="Nyame Mail",hands="Nyame Gauntlets",ring1="Metamor. Ring +1",
        legs="Nyame Flanchard",feet="Nyame Sollerets"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}
       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = set_combine(sets.Mode.STR, {
        head="Mpaca's Cap",neck="Fotia Gorget",rear="Ishvara Earring",
        body="Foire Tobe +3",ring1="Cornelia's Ring",ring2="Epaminondas's Ring",
        waist="Fotia Belt",legs="Hiza. Hizayoroi +2"})
        
    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Stringing Pummel'] = set_combine(sets.precast.WS, {})

    sets.precast.WS['Victory Smite'] = set_combine(sets.precast.WS, {})

    sets.precast.WS['Shijin Spiral'] = set_combine(sets.precast.WS, {})
    
    -- Midcast Sets
    -- sets.midcast.FastRecast = {}
        
    -- Midcast sets for pet actions
    sets.midcast.Pet.Cure = {legs="Pup. Churidars"}

    sets.midcast.Pet['Elemental Magic'] = {neck="Adad Amulet"}

    sets.midcast.Pet.WeaponSkill = {head="Cirque Cappello +2", hands="Cirque Guanti", legs="Cirq. Pantaloni +1"}

    -- Defense sets
	sets.defense = {}
	sets.defense.Evasion = set_combine(sets.Mode.Eva, {})
	sets.defense.PDT = set_combine(sets.Mode.DT, {})
	sets.defense.MDT = set_combine(sets.Mode.Meva, {})
	sets.debuffed = set_combine(sets.Mode.DT,sets.Mode.Meva)
	sets.doom = set_combine(sets.debuffed,sets.defense.Reraise,{waist="Gishdubar Sash"})

    sets.Kiting = {}
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

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    check_ws_dist(spell)
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when pet is about to perform an action
function job_pet_midcast(spell, action, spellMap, eventArgs)
    if petWeaponskills:contains(spell.english) then
        classes.CustomClass = "Weaponskill"
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if buff == 'Wind Maneuver' then
        handle_equipping_gear(player.status)
    end
end

function job_handle_equipping_gear(status, eventArgs)
	-- add_to_chat(122,'handle equiping gear')
	check_tp_lock()
	pick_tp_weapon()
end

-- Called when a player gains or loses a pet.
-- pet == pet gained or lost
-- gain == true if the pet was gained, false if it was lost.
function job_pet_change(pet, gain)
    update_pet_mode()
end

-- Called when the pet's status changes.
function job_pet_status_change(newStatus, oldStatus)
    if newStatus == 'Engaged' then
        display_pet_status()
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    update_pet_mode()
end


-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    display_pet_status()
end


-------------------------------------------------------------------------------------------------------------------
-- User self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for custom player commands.
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1] == 'maneuver' then
        if pet.isvalid then
            local man = defaultManeuvers[state.PetMode.value]
            if man and tonumber(cmdParams[2]) then
                man = man[tonumber(cmdParams[2])]
            end

            if man then
                send_command('input /pet "'..man..'" <me>')
            end
        else
            add_to_chat(123,'No valid pet.')
        end
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function customize_idle_set(idleSet)
	if not buffactive["Reraise"] then
		idleSet = set_combine(idleSet, sets.defense.Reraise)
	end
    if pet.isvalid then
        if pet.status == 'Engaged' then
			if state.Stance.value == 'Defensive' then
				idleSet = set_combine(idleSet, sets.idle.Pet.Defensive)
			else
				idleSet = set_combine(idleSet, sets.idle.Pet.Offensive)
			end
        end
    end
  
    return idleSet
end


-- Get the pet mode value based on the equipped head of the automaton.
-- Returns nil if pet is not valid.
function get_pet_mode()
    if pet.isvalid then
        return petModes[pet.head] or 'None'
    else
        return 'None'
    end
end

-- Update state.PetMode, as well as functions that use it for set determination.
function update_pet_mode()
    state.PetMode:set(get_pet_mode())
    update_custom_groups()
end

-- Update custom groups based on the current pet.
function update_custom_groups()
    classes.CustomIdleGroups:clear()
    if pet.isvalid then
        classes.CustomIdleGroups:append(state.PetMode.value)
    end
end

-- Display current pet status.
function display_pet_status()
    if pet.isvalid then
        local petInfoString = pet.name..' ['..pet.head..']: '..tostring(pet.status)..'  TP='..tostring(pet.tp)..'  HP%='..tostring(pet.hpp)
        
        if magicPetModes:contains(state.PetMode.value) then
            petInfoString = petInfoString..'  MP%='..tostring(pet.mpp)
        end
        
        add_to_chat(122,petInfoString)
    end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(2, 20)
    elseif player.sub_job == 'NIN' then
        set_macro_page(2, 20)
    elseif player.sub_job == 'THF' then
        set_macro_page(2, 20)
    else
        set_macro_page(2, 20)
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

