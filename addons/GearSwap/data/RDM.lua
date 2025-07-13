include('organizer-lib.lua')
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------
--test this
-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff.Saboteur = buffactive.saboteur or false
	state.Buff['Sublimation: Activated'] = buffactive['Sublimation: Activated'] or false
	state.WeaponMode = M{['description']='Weapon Mode', 'Sword', 'Dagger', 'Staff', 'Club'}
  	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive'}
	state.holdtp = M{['description']='holdtp', 'false', 'true'}
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'SB', 'sTP', 'STR')
    state.CastingMode:options('Normal', 'INT', 'MAB', 'MB', 'Macc', 'Mcrit', 'MDmg', 'SB')
    state.IdleMode:options('Normal', 'PDT', 'MDT')
 	state.WeaponMode:set('Sword')
	state.Stance:set('None')
	state.holdtp:set('false')

    gear.macc_staff = { name="Grioavolr", augments={'Magic burst dmg.+3%','INT+6','Mag. Acc.+24','"Mag.Atk.Bns."+22',}}

    pick_tp_weapon()
    
    select_default_macro_book()
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
		new10="",
		new11="",
		food="Pear Crepe",
		food1="Tropical Crepe",
		echos="Echo Drops",
		-- shihei="Shihei",
		orb="Macrocosmic Orb"
	}

    --------------------------------------
    -- Start defining the sets
    --------------------------------------
	sets.Day = {}
	sets.Day.Fire = {waist='Hachirin-no-Obi',back='Twilight Cape',ring2='Zodiac Ring'}
	sets.Day.Earth = {waist='Hachirin-no-Obi',back='Twilight Cape',ring2='Zodiac Ring'}
	sets.Day.Water = {waist='Hachirin-no-Obi',back='Twilight Cape',ring2='Zodiac Ring'}
	sets.Day.Wind = {waist='Hachirin-no-Obi',back='Twilight Cape',ring2='Zodiac Ring'}
	sets.Day.Ice = {waist='Hachirin-no-Obi',back='Twilight Cape',ring2='Zodiac Ring'}
	sets.Day.Thunder = {waist='Hachirin-no-Obi',back='Twilight Cape',ring2='Zodiac Ring'}
	sets.Day.Light = {waist='Hachirin-no-Obi',back='Twilight Cape',ring2='Zodiac Ring'}
	sets.Day.Dark = {waist='Hachirin-no-Obi',back='Twilight Cape',ring2='Zodiac Ring'}
	sets.Weather = {}
	sets.Weather.Fire = {waist='Hachirin-no-Obi',back='Twilight Cape'}
	sets.Weather.Earth = {waist='Hachirin-no-Obi',back='Twilight Cape'}
	sets.Weather.Water = {waist='Hachirin-no-Obi',back='Twilight Cape'}
	sets.Weather.Wind = {waist='Hachirin-no-Obi',back='Twilight Cape'}
	sets.Weather.Ice = {waist='Hachirin-no-Obi',back='Twilight Cape'}
	sets.Weather.Thunder = {waist='Hachirin-no-Obi',back='Twilight Cape'}
	sets.Weather.Light = {waist='Hachirin-no-Obi',back='Twilight Cape'}
	sets.Weather.Dark = {waist='Hachirin-no-Obi',back='Twilight Cape'}
 
    -- Normal refresh idle set
    sets.idle = {ammo="Homiliary",
        head="Viti. Chapeau +1",neck="Elite Royal Collar",lear="Moonshade Earring",rear="Ethereal Earring",
        body="Jhakri Robe +2",hands="Telchine Gloves",ring1="Defending Ring",ring2="Renaye Ring +1",
        back="Solemnity Cape",waist="Plat. Mog. Belt",legs="Carmine Cuisses +1",feet="Aya. Gambieras +2"}

    -- Resting sets
    sets.resting = set_combine(sets.idle, {main="Chatoyant Staff"})

    -- Normal melee group
    sets.engaged = { ammo="Ginsen",
        head="Aya. Zucchetto +2",neck="Combatant's Torque",lear="Sherida Earring",rear="Brutal Earring",
        body="Ayanmo Corazza +2",hands="Aya. Manopolas +2",ring1="Patricius Ring",ring2="Apate Ring",
        back="Ground. Mantle +1",waist="Sailfi Belt +1",legs="Carmine Cuisses +1",feet="Aya. Gambieras +2"}
		
	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {
        head="Malignance Chapeau",neck="Combatant's Torque",rear="Leth. Earring +1",
		body="Ayanmo Corazza +2",hands="Aya. Manopolas +2",ring1="Mars's Ring",ring2="Cacoethic Ring +1",
        back="Lupine Cape",legs="Carmine Cuisses +1",feet="Aya. Gambieras +2"})
	sets.Mode.Att= set_combine(sets.engaged, {
        head="Jhakri Coronal +2",neck="Rep. Plat. Medal",
        body="Jhakri Robe +2",hands="Jhakri Cuffs +2",ring1="Overbearing Ring",ring2="Cho'j Band",
        waist="Sulla Belt",legs="Jhakri Slops +2",feet="Jhakri Pigaches +2"})
	sets.Mode.Crit = set_combine(sets.engaged, {feet="Aya. Gambieras +2"})
	sets.Mode.DA = set_combine(sets.engaged, {nick="Asperity Necklace",lear="Sherida Earring",rear="Leth. Earring +1",
        body="Ayanmo Corazza +2",legs="Zoar Subligar"})
	sets.Mode.SB = set_combine(sets.engaged, {})
	sets.Mode.sTP = set_combine(sets.engaged, {
        head="Malignance Chapeau",neck="Anu Torque",lear="Sherida Earring",rear="Digni. Earring",
        back="Lupine Cape",legs="Jhakri Slops +2"})
	sets.Mode.STR = set_combine(sets.engaged, { ammo="Amar Cluster",
		head="Jhakri Coronal +2",neck="Rep. Plat. Medal",lear="Sherida Earring",rear="Enervating Earring",
		body="Jhakri Robe +2",hands="Jhakri Cuffs +2",ring1="Rajas Ring",ring2="Apate Ring",
		back="Buquwik Cape",waist="Sailfi Belt +1",legs="Jhakri Slops +2",feet="Jhakri Pigaches +2"})
			
	-- other Sets    
	sets.macc = {main="Marin Staff +1",sub="Enki Strap",ammo="Pemphredo Tathlum",
        head="Malignance Chapeau",neck="Erra Pendant",lear="Gwati Earring",rear="Digni. Earring",
        body="Jhakri Robe +2",hands="Jhakri Cuffs +2",ring1="Sangoma Ring",ring2="Metamor. Ring +1",
        back="Sucellos's Cape",waist="Luminary Sash",legs="Merlinic Shalwar",feet="Jhakri Pigaches +2"}
	sets.PDL = {head="Malignance Chapeau"}
	sets.empy = {head="Lethargy Chappel",
		body="Lethargy Sayon +1",hands="Lethargy Gantherots",
		legs="Leth. Fuseasu +1",feet="Leth. Houseaux +1"}

	-- Sets with weapons defined.
	sets.engaged.Club = {}
	sets.engaged.Staff = {}
	sets.engaged.Sword = {}
	sets.engaged.Dagger = {}
	-- sets.engaged.Sword = set_combine(sets.engaged, {main="Caliburnus",sub="Genmei Shield"})
	-- sets.engaged.Sword = set_combine(sets.engaged, {main="Naegling",sub="Genmei Shield"})
	sets.engaged.Sword = set_combine(sets.engaged, {main="Sakpata's Sword",sub="Genmei Shield"})
	sets.engaged.Sword.Acc = set_combine(sets.engaged.Sword, sets.Mode.Acc)
	sets.engaged.Sword.Att = set_combine(sets.engaged.Sword, sets.Mode.Att)
	sets.engaged.Sword.Crit = set_combine(sets.engaged.Sword, sets.Mode.Crit)
	sets.engaged.Sword.DA = set_combine(sets.engaged.Sword, sets.Mode.DA)
	sets.engaged.Sword.SB = set_combine(sets.engaged.Sword, sets.Mode.SB)
	sets.engaged.Sword.sTP = set_combine(sets.engaged.Sword, sets.Mode.sTP)
	sets.engaged.Sword.STR = set_combine(sets.engaged.Sword, sets.Mode.STR)
	
	sets.engaged.Club = set_combine(sets.engaged, {main="Septoptic",sub="Genmei Shield"})
	sets.engaged.Club.Acc = set_combine(sets.engaged.Club, sets.Mode.Acc)
	sets.engaged.Club.Att = set_combine(sets.engaged.Club, sets.Mode.Att)
	sets.engaged.Club.Crit = set_combine(sets.engaged.Club, sets.Mode.Crit)
	sets.engaged.Club.DA = set_combine(sets.engaged.Club, sets.Mode.DA)
	sets.engaged.Club.SB = set_combine(sets.engaged.Club, sets.Mode.SB)
	sets.engaged.Club.sTP = set_combine(sets.engaged.Club, sets.Mode.sTP)
	sets.engaged.Club.STR = set_combine(sets.engaged.Club, sets.Mode.STR)

	sets.engaged.Staff = set_combine(sets.engaged, {main="Marin Staff +1",sub="Niobid Strap"})
	sets.engaged.Staff.Acc = set_combine(sets.engaged.Staff, sets.Mode.Acc)
	sets.engaged.Staff.Att = set_combine(sets.engaged.Staff, sets.Mode.Att)
	sets.engaged.Staff.Crit = set_combine(sets.engaged.Staff, sets.Mode.Crit)
	sets.engaged.Staff.DA = set_combine(sets.engaged.Staff, sets.Mode.DA)
	sets.engaged.Staff.SB = set_combine(sets.engaged.Staff, sets.Mode.SB)
	sets.engaged.Staff.sTP = set_combine(sets.engaged.Staff, sets.Mode.sTP)
	sets.engaged.Staff.STR = set_combine(sets.engaged.Staff, sets.Mode.STR)

    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
	sets.precast.WS = set_combine(sets.Mode.STR, {ammo="Oshasha's Treatise",
		neck="Fotia Gorget",rear="Ishvara Earring",
        hands="Jhakri Cuffs +2",ring1="Cornelia's Ring",ring2="Epaminondas's Ring",waist="Fotia Belt"})    
    
	-- dark?, STR 30% MND 50% - use MAB
    sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS, {ammo="Witchstone",
        head="Jhakri Coronal +2",neck="Eddy Necklace",lear="Friomisi Earring",
        ring1="Strendu Ring",
        back="Toro Cape"})

	-- Dark/Earth, MND 73%
	sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {})

	-- none, INT 50% MND 50%
	sets.precast.WS['Spirit Taker'] = set_combine(sets.precast.WS, {})
   
    -- Precast sets to enhance JAs
    sets.precast.JA['Chainspell'] = {}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        head="Jhakri Coronal +2",lear="Roundel Earring",
        body="Atrophy Tabard +1",hands="Jhakri Cuffs +2",
        back="Refraction Cape"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}
    
    -- 80% Fast Cast (including trait) for all spells, plus 5% quick cast
    -- No other FC sets necessary.
    sets.precast.FC = {
        head="Atrophy Chapeau +1",neck="Orunmila's Torque",rear="Leth. Earring +1",
        body="Shango Robe",ring1="Kishar Ring",ring2="Prolix Ring",
        back="Swith Cape +1",waist="Embla Sash",legs="Aya. Cosciales +2",feet="Merlinic Crackows"}

    sets.precast.FC.Impact = set_combine(sets.precast.FC, {head=empty,body="Twilight Cloak"})
    
    -- Midcast Sets
    -- sets.midcast.FastRecast = {}

    sets.midcast.Cure = {main="Tamaxchi",sub="Genmei Shield",
        neck="Phalaina Locket",lear="Roundel Earring",
        body="Heka's Kalasiris",hands="Telchine Gloves",ring1="Ephedra Ring",ring2="Lebeche Ring",
        back="Swith Cape +1",waist="Witful Belt",legs="Gyve Trousers",feet="Medium's Sabots"}
        
    sets.midcast.Curaga = set_combine(sets.midcast.Cure, {})
    sets.midcast.CureSelf = set_combine(sets.midcast.Cure, {})
	
    sets.midcast.Regen = {main="Bolelabunga",lear="Pratik Earring",body="Telchine Chas.",
		feet="Telchine Pigaches"}

    sets.midcast['Enhancing Magic'] = { main="Exemplar",
        head="Atrophy Chapeau +1",rear="Leth. Earring +1",
        body="Telchine Chas.",hands="Telchine Gloves",ring1="Prolix Ring",
        back="Sucellos's Cape",waist="Embla Sash",legs="Atrophy Tights",feet="Leth. Houseaux +1"}

	sets.midcast['Enhancing Magic']['Refresh'] = set_combine(sets.midcast['Enhancing Magic'],{
		legs="Leth. Fuseau +1",back="Grapevine Cape",waist="Gishdubar Sash"})
 
    sets.midcast.Stoneskin = {waist="Siegel Sash"}

	-- Elemental Magic sets
	sets.midcast['Elemental Magic'] = {main="Marin Staff +1",sub="Enki Strap",ammo="Pemphredo Tathlum",
        head="Merlinic Hood",neck="Sanctity Necklace",lear="Crematio Earring",rear="Friomisi Earring",
        body="Merlinic Jubbah",hands="Jhakri Cuffs +2",ring1="Strendu Ring",ring2="Metamor. Ring +1",
        back="Sucellos's Cape",waist="Eschan Stone",legs="Merlinic Shalwar",feet="Merlinic Crackows"}

    sets.midcast['Elemental Magic'].INT = set_combine(sets.midcast['Elemental Magic'], 
	   {main="Marin Staff +1",sub="Enki Strap",ammo="Pemphredo Tathlum",
        head="Befouled Crown",neck="Sibyl Scarf",lear="Strophadic Earring",rear="Psystorm Earring",
        body="Jhakri Robe +2",hands="Jhakri Cuffs +2",ring1="Diamond Ring",ring2="Metamor. Ring +1",
        back="Sucellos's Cape",waist="Channeler's Stone",legs="Jhakri Slops +2",feet="Jhakri Pigaches +2"})

    sets.midcast['Elemental Magic'].MAB = set_combine(sets.midcast['Elemental Magic'], 
	   {main="Marin Staff +1",sub="Elan Strap +1",ammo="Pemphredo Tathlum",
        head="Merlinic Hood",neck="Baetyl Pendant",lear="Crematio Earring",rear="Friomisi Earring",
        body="Merlinic Jubbah",hands="Jhakri Cuffs +2",ring1="Strendu Ring",
        back="Sucellos's Cape",waist="Eschan Stone",legs="Hagondes Pants +1",feet="Merlinic Crackows"})
  
    sets.midcast['Elemental Magic'].MB = set_combine(sets.midcast['Elemental Magic'], {main=gear.macc_staff,
		neck="Mizu. Kubikazari",hands="Amalric Gages",back="Izdubar Mantle",feet="Jhakri Pigaches +2"})
  
	sets.midcast['Elemental Magic'].Macc = set_combine(sets.macc, {})
	
	sets.midcast['Elemental Magic'].Mcrit = set_combine(sets.midcast['Elemental Magic'], 
	   {body="Count's Garb",hands="Helios Gloves"})
   
    sets.midcast['Elemental Magic'].MDmg = set_combine(sets.midcast['Elemental Magic'], 
	   {main="Marin Staff +1",sub="Thrace Strap",ammo="Ghastly Tathlum +1",
        head="Buremte Hat",lear="Crematio Earring",
        back="Sucellos's Cape",waist="Sekhmet Corset",legs="Hagondes Pants +1"})
 
    sets.midcast['Elemental Magic'].Skill = set_combine(sets.midcast['Elemental Magic'], 
	   {main="Exemplar",
        neck="Incanter's Torque",lear="Strophadic Earring",feet="Navon Crackows"})
	
    sets.midcast['Enfeebling Magic'] = set_combine(sets.macc,  {sub="Mephitis Grip",
        head="Viti. Chapeau +1",neck="Weike Torque",lear="Lifestorm Earring",rear="Psystorm Earring",
        body="Lethargy Sayon +1",hands="Ayao's Gages",ring1="Kishar Ring",ring2="Metamor. Ring +1",
        back="Sucellos's Cape",feet="Medium's Sabots"})

    sets.midcast['Dia III'] = set_combine(sets.midcast['Enfeebling Magic'], {head="Viti. Chapeau +1"})

    sets.midcast['Slow II'] = set_combine(sets.midcast['Enfeebling Magic'], {head="Viti. Chapeau +1"})
        
    sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'], {head=empty,body="Twilight Cloak"})

	sets.midcast['Divine Magic'] = set_combine(sets.macc, {feet="Medium's Sabots"})
    sets.midcast['Dark Magic'] = set_combine(sets.macc, {sub="Mephitis Grip",
        head="Atrophy Chapeau +1",neck="Erra Pendant",lear="Lifestorm Earring",rear="Psystorm Earring",
        body="Vanir Cotehardie",ring1="Evanescence Ring",ring1="Kishar Ring",
        back="Refraction Cape"})

    --sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {})

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {ring2="Excelsis Ring", waist="Fucho-no-Obi"})

    sets.midcast.Aspir = set_combine(sets.midcast.Drain, {})

    -- Sets for special buff conditions on spells.
    sets.midcast.EnhancingDuration = {
		rear="Leth. Earring +1",
		body="Telchine Chas.",hands="Atrophy Gloves +1",back="Sucellos's Cape",
		waist="Embla Sash",legs="Telchine Braconi",feet="Leth. Houseaux +1"}
        
    sets.buff.ComposureOther = {head="Estoqueur's Chappel +2",
        body="Lethargy Sayon +1",hands="Estoqueur's Gantherots +2",
        legs="Leth. Fuseau +1",feet="Leth. Houseaux +1"}

    sets.buff.Saboteur = {hands="Estoqueur's Gantherots +2"}
	sets.buff.FullSublimation = {waist="Embla Sash"}
    sets.buff.PDTSublimation = set_combine(sets.buff.FullSublimation,{})

    -- Defense sets
    sets.defense.PDT = {
        head="Malignance Chapeau",neck="Elite Royal Collar",
        body="Ayanmo Corazza +2",hands="Aya. Manopolas +2",ring1="Defending Ring",
        back="Shadow Mantle",waist="Plat. Mog. Belt",legs="Aya. Cosciales +2",feet="Aya. Gambieras +2"}

    sets.defense.MDT = {
        head="Malignance Chapeau",neck="Elite Royal Collar",lear="Etiolation Earring",rear="Eabani Earring",
        body="Ayanmo Corazza +2",hands="Aya. Manopolas +2",ring1="Defending Ring",ring2="Shadow Ring",
        back="Reiki Cloak",waist="Plat. Mog. Belt",legs="Aya. Cosciales +2",feet="Aya. Gambieras +2"}
		
	sets.debuffed = set_combine(sets.defense.Evasion,sets.defense.PDT,sets.defense.MDT)
	sets.doom = set_combine(sets.debuffed,{waist="Gishdubar Sash"})

    sets.Kiting = {legs="Carmine Cuisses +1"}

    sets.latent_refresh = {waist="Fucho-no-obi"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------
function job_precast(spell, action, spellMap, eventArgs)
    if spellMap == 'Cure' or spellMap == 'Curaga' then
        handle_spells(spell)
    elseif spell.skill == 'Elemental Magic' then
		-- add_to_chat(1, 'Casting '..spell.name)
        handle_spells(spell)
        if state.CastingMode.value == 'Proc' then
            classes.CustomClass = 'Proc'
        end
    elseif spell.skill == 'Dark Magic' then
		handle_spells(spell)
    end
	check_ws_dist(spell)
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Enfeebling Magic' and state.Buff.Saboteur then
        equip(sets.buff.Saboteur)
    elseif spell.skill == 'Enhancing Magic' then
        equip(sets.midcast.EnhancingDuration)
        if buffactive.composure and spell.target.type == 'PLAYER' then
            equip(sets.buff.ComposureOther)
        end
    elseif spellMap == 'Cure' and spell.target.type == 'SELF' then
        equip(sets.midcast.CureSelf)
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
    if buff == "Sublimation: Activated" then
        handle_equipping_gear(player.status)
    end
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
	update_sublimation()
	pick_tp_weapon()
end

function update_sublimation()
    state.Buff['Sublimation: Activated'] = buffactive['Sublimation: Activated'] or false
end

function job_handle_equipping_gear(status, eventArgs)
	-- add_to_chat(122,'handle equiping gear')
	check_tp_lock()
	pick_tp_weapon()
end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Offense Mode' then
        if newValue == 'None' then
            enable('main','sub','range')
        else
            disable('main','sub','range')
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
	if state.Buff['Sublimation: Activated'] then
        if state.IdleMode.value == 'PDT' then
            idleSet = set_combine(idleSet, sets.buff.PDTSublimation)
        else
            idleSet = set_combine(idleSet, sets.buff.FullSublimation)
        end
    end
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    return idleSet
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
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
    if player.sub_job == 'DNC' then
        set_macro_page(2, 12)
    elseif player.sub_job == 'NIN' then
        set_macro_page(3, 12)
    elseif player.sub_job == 'THF' then
        set_macro_page(4, 12)
    else
        set_macro_page(1, 12)
    end
end

