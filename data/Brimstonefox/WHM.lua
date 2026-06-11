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
	state.Buff['Sublimation: Activated'] = buffactive['Sublimation: Activated'] or false
    state.Buff['Afflatus Solace'] = buffactive['Afflatus Solace'] or false
    state.Buff['Afflatus Misery'] = buffactive['Afflatus Misery'] or false
	state.WeaponMode = M{['description']='Weapon Mode', 'Staff', 'Club'}
  	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive'}
  	state.holdtp = M{['description']='holdtp', 'false', 'true'}
    state.immuno = M{['description']='immuno', 'false', 'true'}
	pick_tp_weapon()

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'SB', 'sTP', 'STR', 'DT', 'Meva')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT', 'Capacity')
	state.WeaponMode:set('Club')
	state.Stance:set('None')
	state.holdtp:set('false')
	state.immuno:set('false')
	pick_tp_weapon()

    select_default_macro_book()
end

-- Define sets and vars used by this job file.
function init_gear_sets()
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
		new10="",
		echos="Echo Drops",
		-- shihei="Shihei",
		orb="Macrocosmic Orb"
	}
    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
    sets.idle = { ammo="Homiliary",
        head="Null Masque",neck="Elite Royal Collar",lear="Alabaster Earring",rear="Moonshade Earring",
        body="Theo. Bliaut +2",hands="Telchine Gloves",ring1="Murky Ring",ring2="Renaye Ring +1",
        back="Solemnity Cape",waist="Null Belt",legs="Assid. Pants +1",feet="Herald's Gaiters"}

    -- Resting sets
    sets.resting = set_combine(sets.idle, {})

    -- Normal melee group
    sets.engaged = {
        head="Aya. Zucchetto +2",neck="Null Loop",lear="Crep. Earring",rear="Ebers Earring +1",
        body="Ayanmo Corazza +2",hands="Aya. Manopolas +2",ring1="Patricius Ring",ring2="Hetairoi Ring",
        back="Null Shawl",waist="Null Belt",legs="Assid. Pants +1",feet="Aya. Gambieras +2"}

	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {
        head="Aya. Zucchetto +2",neck="Null Loop",lear="Zennaroi Earring",rear="Ebers Earring +1",
		body="Ayanmo Corazza +2",hands="Aya. Manopolas +2",ring1="Mars's Ring",ring2="Cacoethic Ring +1",
		back="Null Shawl",waist="Null Belt",legs="Aya. Cosciales +2",feet="Aya. Gambieras +2"})
	sets.Mode.Att = set_combine(sets.engaged, {
        head="Nyame Helm",neck="Rep. Plat. Medal",lear="Bladeborn Earring",rear="Dudgeon Earring",
        body="Nyame Mail",hands="Nyame Gauntlets",ring1="Overbearing Ring",ring2="Ilabrat Ring",
		waist="Eschan Stone",legs="Nyame Flanchard",feet="Nyame Sollerets"})
	sets.Mode.Crit = set_combine(sets.engaged, {ring1="Hetairoi Ring",feet="Aya. Gambieras +2"})
	sets.Mode.DA = set_combine(sets.engaged, {
        lear="Trux Earring",rear="Brutal Earring",
        body="Ayanmo Corazza +2",ring1="Hetairoi Ring",
        back="Null Shawl",legs="Querkening Brais"})
	sets.Mode.SB = set_combine(sets.engaged, {})
	sets.Mode.sTP = set_combine(sets.engaged, {
        head="Aya. Zucchetto +2",neck="Combatant's Torque",lear="Crep. Earring",rear="Tripudio Earring",
		ring2="Ilabrat Ring",
		back="Null Shawl",waist="Yemaya Belt",feet="Battlecast Gaiters"})
	sets.Mode.STR = set_combine(sets.engaged, { ammo="Amar Cluster",
		head="Nyame Helm",neck="Rep. Plat. Medal",
		body="Ayanmo Corazza +2",hands="Aya. Manopolas +2",ring1="Rajas Ring",ring2="Apate Ring",
		back="Buquwik Cape",waist="Cornelia's Belt",legs="Aya. Cosciales +2",feet="Aya. Gambieras +2"})
	sets.Mode.DT = { ammo="Crepuscular Pebble",
        head="Nyame Helm",neck="Elite Royal Collar",lear="Alabaster Earring",rear="Ebers Earring +1",
		body="Nyame Mail",hands="Nyame Gauntlets",ring1="Murky Ring",ring2="Patricius Ring",
		back="Solemnity Cape",waist="Plat. Mog. Belt",legs="Nyame Flanchard",feet="Nyame Sollerets"}
    sets.Mode.Meva = {
        head="Nyame Helm",neck="Elite Royal Collar",lear="Etiolation Earring",rear="Ebers Earring +1",
        body="Nyame Mail",hands="Nyame Gauntlets",ring1="Murky Ring",ring2="Vengeful Ring",
        back="Null Shawl",waist="Null Belt",legs="Nyame Flanchard",feet="Nyame Sollerets"}			
		
	-- other Sets    
	sets.macc = {
		head="Nyame Helm",neck="Null Loop",lear="Crep. Earring",rear="Malignance Earring",
		body="Nyame Mail",hands="Nyame Gauntlets",ring1="Sangoma Ring",
		back="Null Shawl",waist="Null Belt",legs="Nyame Flanchard",feet="Nyame Sollerets"}
	sets.PDL = {ammo="Crepuscular Pebble"}
	sets.empy = {head="Ebers Cap +1",
		body="Ebers Bliaut",hands="Ebers Mitts",
		legs="Ebers Pantaloons",feet="Ebers Duckbills"}

	-- Sets with weapons defined.
	sets.engaged.Club = {}
	sets.engaged.Staff = {}
	sets.engaged.Club = set_combine(sets.engaged, {main="Maxentius",sub="Genmei Shield"})
	sets.engaged.Club.Acc = set_combine(sets.engaged.Club, sets.Mode.Acc)
	sets.engaged.Club.Att = set_combine(sets.engaged.Club, sets.Mode.Att)
	sets.engaged.Club.Crit = set_combine(sets.engaged.Club, sets.Mode.Crit)
	sets.engaged.Club.DA = set_combine(sets.engaged.Club, sets.Mode.DA)
	sets.engaged.Club.SB = set_combine(sets.engaged.Club, sets.Mode.SB)
	sets.engaged.Club.sTP = set_combine(sets.engaged.Club, sets.Mode.sTP)
	sets.engaged.Club.STR = set_combine(sets.engaged.Club, sets.Mode.STR)
	sets.engaged.Club.DT = set_combine(sets.engaged.Club, sets.Mode.DT)
	sets.engaged.Club.Meva = set_combine(sets.engaged.Club, sets.Mode.Meva)

	sets.engaged.Staff = set_combine(sets.engaged, {main="Malignance Pole", sub="Enki Strap"})
	sets.engaged.Staff.Acc = set_combine(sets.engaged.Staff, sets.Mode.Acc)
	sets.engaged.Staff.Att = set_combine(sets.engaged.Staff, sets.Mode.Att)
	sets.engaged.Staff.Crit = set_combine(sets.engaged.Staff, sets.Mode.Crit)
	sets.engaged.Staff.DA = set_combine(sets.engaged.Staff, sets.Mode.DA)
	sets.engaged.Staff.SB = set_combine(sets.engaged.Staff, sets.Mode.SB)
	sets.engaged.Staff.sTP = set_combine(sets.engaged.Staff, sets.Mode.sTP)
	sets.engaged.Staff.STR = set_combine(sets.engaged.Staff, sets.Mode.STR)
	sets.engaged.Staff.DT = set_combine(sets.engaged.Staff, sets.Mode.DT)
	sets.engaged.Staff.Meva = set_combine(sets.engaged.Staff, sets.Mode.Meva)

    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
	sets.precast.WS = set_combine(sets.Mode.STR, {ammo="Oshasha's Treatise",
		neck="Fotia Gorget",rear="Ishvara Earring",
        ring1="Cornelia's Ring",ring2="Epaminondas's Ring",waist="Fotia Belt"})    
    
	-- Ice/Water, STR 50% MND 50%
    sets.precast.WS['Flash Nova'] = set_combine(sets.precast.WS, {
        head="Nyame Helm",lear="Friomisi Earring",rear="Malignance Earring",
        body="Nyame Mail",hands="Nyame Gauntlets",ring1="Rajas Ring",ring2="Strendu Ring",
        back="Toro Cape",legs="Nyame Flanchard",feet="Nyame Sollerets"})
 
	-- none, INT 50% MND 50%
	sets.precast.WS['Spirit Taker'] = set_combine(sets.precast.WS, {})

    -- Precast Sets
    -- Fast cast sets for spells
    sets.precast.FC = {main=gear.FastcastStaff,ammo="Incantor Stone",
        head="Vanya Hood",neck="Orunmila's Torque",lear="Etiolation Earring",rear="Malignance Earring",
        body="Inyanga Jubbah +2",hands="Fanatic Gloves",ring1="Kishar Ring",ring2="Prolix Ring",
        back="Alaunus's Cape",waist="Embla Sash",legs="Aya. Cosciales +2",feet="Navon Crackows"}
        
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})

    sets.precast.FC.Stoneskin = set_combine(sets.precast.FC['Enhancing Magic'], {head="Umuthi Hat",body="Ebers Bliaut"})

    sets.precast.FC['Healing Magic'] = set_combine(sets.precast.FC, {legs="Ebers Pantaloons"})

    sets.precast.FC.StatusRemoval = set_combine(sets.precast.FC['Healing Magic'])

    sets.precast.FC.Cure = set_combine(sets.precast.FC['Healing Magic'], {
		main="Queller Rod",sub="Genmei Shield",
		head="Theo. Cap +1",
        back="Pahtli Cape"})
    sets.precast.FC.Curaga = set_combine(sets.precast.FC.Cure, {})
    sets.precast.FC.CureSolace = set_combine(sets.precast.FC.Cure, {})
	sets.precast.FC.Impact = set_combine(sets.precast.FC['Elemental Magic'], {head=empty,body="Crepuscular Cloak"})
	sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {main="Daybreak",sub="Ammurapi Shield"})
    -- CureMelee spell map should default back to Healing Magic.
    
    -- Precast sets to enhance JAs
    sets.precast.JA.Benediction = {body="Piety Bliaut +1"}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
		head="Nyame Helm",rear="Roundel Earring",
		body="Nyame Mail",hands="Nyame Gauntlets",
		legs="Nyame Flanchard",feet="Nyame Sollerets"}
    
    -- Midcast Sets
    -- Cure sets
	sets.midcast.Healing = {
		neck="Incanter's Torque",rear="Ebers Earring +1",
		hands="Inyan. Dastanas +2"}

	sets.midcast.CureMelee = set_combine(sets.midcast.Healing, {ammo="Incantor Stone",
        head="Ebers Cap +1",neck="Phalaina Locket",lear="Glorious Earring",rear="Roundel Earring",
        body="Theo. Bliaut +2",hands="Telchine Gloves",ring1="Naji's Loop",ring2="Lebeche Ring",
        back="Solemnity Cape",legs="Sifahir Slacks",feet="Piety Duckbills +1"})

	sets.midcast.Cure = set_combine(sets.midcast.CureMelee, {main="Queller Rod",sub="Genmei Shield"})

    sets.midcast.CureSolace =  set_combine(sets.midcast.CureMelee, {main="Queller Rod",sub="Genmei Shield",
        body="Ebers Bliaut",back="Alaunus's Cape"})

    sets.midcast.Curaga = set_combine(sets.midcast.CureMelee, {main="Queller Rod",sub="Genmei Shield"})

	-- healing
    sets.midcast.StatusRemoval = set_combine(sets.midcast.Healing, {
        head="Ebers Cap +1",neck="Incanter's Torque",hands="Inyan. Dastanas +2",ring1="Ephedra Ring",
		back="Mending Cape",legs="Piety Pantaln. +1"})

    sets.midcast.Cursna = set_combine(sets.midcast.StatusRemoval, {
        head="Ebers Cap +1",neck="Incanter's Torque",
        body="Ebers Bliaut",hands="Fanatic Gloves",ring1="Ephedra Ring",
        back="Alaunus's Cape",legs="Theo. Pant. +1",feet="Gende. Galoshes"})

    -- 110 total Enhancing Magic SB; caps even without Light Arts
    sets.midcast['Enhancing Magic'] = { main="Exemplar",sub="Enki Strap",
        head="Befouled Crown",neck="Incanter's Torque",lear="Andoaa Earring",
        body="Telchine Chas.",hands="Telchine Gloves",
        back="Mending Cape",waist="Embla Sash",legs="Telchine Braconi",feet="Telchine Pigaches"}
	sets.midcast['Enhancing Magic']['Refresh'] = set_combine(sets.midcast['Enhancing Magic'],{
		back="Grapevine Cape",waist="Gishdubar Sash",feet="Inspirited Boots"})
	sets.midcast['Enhancing Magic']['Aquaveil'] = set_combine(sets.midcast['Enhancing Magic'],{
		main="Vadose Rod",head="Chironic Hat"})
		
    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
        waist="Siegel Sash",legs="Gende. Spats +1",feet="Gende. Galoshes"})

    sets.midcast.Auspice = {feet="Ebers Duckbills"}

    sets.midcast.BarElement = {
        head="Ebers Cap +1",
        body="Ebers Bliaut",hands="Ebers Mitts",
        back="Mending Cape",legs="Piety Pantaln. +1",feet="Ebers Duckbills"}

    sets.midcast.Regen = set_combine(sets.midcast['Enhancing Magic'], {main="Bolelabunga",sub="Ammurapi Shield",
		head="Inyanga Tiara +2",lear="Pratik Earring",
        body="Piety Bliaut +1",hands="Ebers Mitts",
        waist="Embla Sash",legs="Theo. Pant. +1",feet="Telchine Pigaches"})
		
    sets.midcast.Protectra = {feet="Piety Duckbills +1"}

    sets.midcast.Shellra = {legs="Piety Pantaln. +1"}

    sets.midcast['Divine Magic'] = set_combine(sets.macc, {main="Bunzi's Rod",sub="Ammurapi Shield",ammo="Pemphredo Tathlum",
        head="Volte Beret",neck="Incanter's Torque",lear="Regal Earring",rear="Malignance Earring",
        body="Nyame Mail",hands="Fanatic Gloves",ring1="Globidonta Ring",
        waist="Sacro Cord",legs="Theo. Pant. +1",feet="Chironic Slippers"})

    sets.midcast['Dark Magic'] = set_combine(sets.macc, {
		main="Bunzi's Rod",sub="Ammurapi Shield",ammo="Pemphredo Tathlum",
        head="Inyanga Tiara +2",neck="Erra Pendant",
        body="Shango Robe",hands="Inyan. Dastanas +2",ring1="Evanescence Ring",ring2="Kishar Ring",
        back="Perimede Cape",waist="Sacro Cord",legs="Inyanga Shalwar +2",feet="Inyan. Crackows +2"})
	
	sets.midcast.Misery = {legs="Piety Pantaln. +1"}
	sets.midcast.Solace = {feet="Piety Duckbills +1"}

    -- Custom spell classes
 	
	-- don't set_combine() these handled progressively in customize_enfeeble_sets in job_post_midcast
	-- those in the later will use the slots in the former when appropriate (so leave stuff like INT blank if you'd rather have macc or skill)
	sets.midcast.Enfeebling = {}
	sets.midcast.Enfeebling.Skill = set_combine(sets.macc, {
        head="Befouled Crown",neck="Incanter's Torque",
        body="Theo. Bliaut +2",hands="Inyan. Dastanas +2",ring2="Globidonta Ring",
        back="Alaunus's Cape",waist="Rumination Sash",legs="Mystagog Slacks",feet="Piety Duckbills +1"})
	sets.midcast.Enfeebling.MND = {}
	sets.midcast.Enfeebling.INT = {}
	sets.midcast.Enfeebling.effect = {feet="Uk'uxkaj Boots"}
	sets.midcast.Enfeebling.duration = {ring1="Kishar Ring"}
	sets.midcast.Enfeebling.immuno = {legs="Chironic Hose"}
	
	sets.midcast.Impact = set_combine(sets.macc, {head=empty,body="Crepuscular Cloak"})
	sets.midcast.Dispelga = set_combine(sets.macc, {main="Daybreak",sub="Ammurapi Shield"})
    -- Defense sets
    sets.defense.PDT = set_combine(sets.Mode.DT, {})
	sets.defense.MDT = set_combine(sets.Mode.Meva, {})
	sets.debuffed = set_combine(sets.Mode.DT,sets.Mode.Meva)
	sets.doom = set_combine(sets.debuffed,{waist="Gishdubar Sash"})
	
    sets.Kiting = {}

    sets.latent_refresh = {waist="Fucho-no-obi"}

    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    sets.buff['Divine Caress'] = {hands="Ebers Mitts",back="Mending Cape"}
	sets.buff.FullSublimation = {waist="Embla Sash"}
    sets.buff.PDTSublimation = set_combine(sets.buff.FullSublimation,{})

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------
-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
	handle_debuffs()
    if buff == "Sublimation: Activated" then
        handle_equipping_gear(player.status)
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if spell.english == "Paralyna" and buffactive.Paralyzed then
        -- no gear swaps if we're paralyzed, to avoid blinking while trying to remove it.
        eventArgs.handled = true
    end
	if spell.skill == 'Healing Magic' then
		handle_spells(spell)
	end
	check_ws_dist(spell)
end


function job_post_midcast(spell, action, spellMap, eventArgs)
    -- Apply Divine Caress boosting items as highest priority over other gear, if applicable.
    if spellMap == 'StatusRemoval' and buffactive['Divine Caress'] then
        equip(sets.buff['Divine Caress'])
    end
    if spellMap == 'Holy' and buffactive['Afflatus Solace'] then
        equip(sets.midcast.Misery)
    end
    if spellMap == 'Banish' and buffactive['Afflatus Misery'] then
        equip(sets.midcast.Solace)
    end
	customize_enfeeble_sets(spell)
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Offense Mode' then
        if newValue == 'Normal' then
            disable('main','sub','range')
        else
            enable('main','sub','range')
        end
    end
end

function job_handle_equipping_gear(status, eventArgs)
	-- add_to_chat(122,'handle equiping gear')
	if player.status == 'Engaged' then
		check_tp_lock()
	end
	pick_tp_weapon()
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if (default_spell_map == 'Cure' or default_spell_map == 'Curaga') and player.status == 'Engaged' then
            return "CureMelee"
        elseif default_spell_map == 'Cure' and state.Buff['Afflatus Solace'] then
            return "CureSolace"
        end
    end
end


function customize_idle_set(idleSet)
    if state.Buff['Sublimation: Activated'] then
        if state.IdleMode.value == 'PDT' then
            idleSet = set_combine(idleSet, sets.buff.PDTSublimation)
        else
            idleSet = set_combine(idleSet, sets.buff.FullSublimation)
        end
    end
	if buffactive['reive mark'] then
		idleSet = set_combine(idleSet, sets.Reive )
	end
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    return idleSet
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    if cmdParams[1] == 'user' and not areas.Cities:contains(world.area) then
        local needsArts = 
            player.sub_job:lower() == 'sch' and
            not buffactive['Light Arts'] and
            not buffactive['Addendum: White'] and
            not buffactive['Dark Arts'] and
            not buffactive['Addendum: Black']
            
        if not buffactive['Afflatus Solace'] and not buffactive['Afflatus Misery'] then
            if needsArts then
                send_command('@input /ja "Afflatus Solace" <me>;wait 1.2;input /ja "Light Arts" <me>')
            else
                send_command('@input /ja "Afflatus Solace" <me>')
            end
        end
    end
	update_sublimation()
	pick_tp_weapon()
end

function update_sublimation()
    state.Buff['Sublimation: Activated'] = buffactive['Sublimation: Activated'] or false
end

-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    set_macro_page(1, 7)
	send_command('exec whm.txt')
end

