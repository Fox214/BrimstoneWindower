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
	state.immuno = M{['description']='immuno', 'false', 'true'}
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'SB', 'sTP', 'STR', 'DT', 'Meva')
    state.CastingMode:options('Normal', 'INT', 'MAB', 'MB', 'Macc', 'Mcrit', 'MDmg')
    state.IdleMode:options('Normal', 'PDT', 'MDT')
 	state.WeaponMode:set('Sword')
	state.Stance:set('None')
	state.holdtp:set('false')
	state.immuno:set('false')
    gear.macc_staff = { name="Grioavolr", augments={'Magic burst dmg.+3%','INT+6','Mag. Acc.+24','"Mag.Atk.Bns."+22',}}

    pick_tp_weapon()
    
    select_default_macro_book()
end


-- Define sets and vars used by this job file.
function init_gear_sets()
	organizer_items = {
        new1="Augury Cuisses +1",
		new2="Bunzi's Pants",
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
	sets.Day.Fire = {waist='Hachirin-no-Obi',ring2='Zodiac Ring'}
	sets.Day.Earth = {waist='Hachirin-no-Obi',ring2='Zodiac Ring'}
	sets.Day.Water = {waist='Hachirin-no-Obi',ring2='Zodiac Ring'}
	sets.Day.Wind = {waist='Hachirin-no-Obi',ring2='Zodiac Ring'}
	sets.Day.Ice = {waist='Hachirin-no-Obi',ring2='Zodiac Ring'}
	sets.Day.Thunder = {waist='Hachirin-no-Obi',ring2='Zodiac Ring'}
	sets.Day.Light = {waist='Hachirin-no-Obi',ring2='Zodiac Ring'}
	sets.Day.Dark = {waist='Hachirin-no-Obi',ring2='Zodiac Ring'}
	sets.Weather = {}
	sets.Weather.Fire = {waist='Hachirin-no-Obi'}
	sets.Weather.Earth = {waist='Hachirin-no-Obi'}
	sets.Weather.Water = {waist='Hachirin-no-Obi'}
	sets.Weather.Wind = {waist='Hachirin-no-Obi'}
	sets.Weather.Ice = {waist='Hachirin-no-Obi'}
	sets.Weather.Thunder = {waist='Hachirin-no-Obi'}
	sets.Weather.Light = {waist='Hachirin-no-Obi'}
	sets.Weather.Dark = {waist='Hachirin-no-Obi'}
 
    -- Normal refresh idle set
    sets.idle = {main="Naegling",sub="Archduke's Shield",ammo="Homiliary",
        head="Viti. Chapeau +1",neck="Null Loop",lear="Moonshade Earring",rear="Ethereal Earring",
        body="Jhakri Robe +2",hands="Telchine Gloves",ring1="Defending Ring",ring2="Renaye Ring +1",
        back="Sucellos's Cape",waist="Plat. Mog. Belt",legs="Carmine Cuisses +1",feet="Atro. Boots +3"}

    -- Resting sets
    sets.resting = set_combine(sets.idle, {main="Chatoyant Staff"})

    -- Normal melee group
    sets.engaged = { ammo="Coiste Bodhar",
        head="Aya. Zucchetto +2",neck="Null Loop",lear="Sherida Earring",rear="Brutal Earring",
        body="Ayanmo Corazza +2",hands="Atrophy Gloves +3",ring1="Adoulin Ring",ring2="Apate Ring",
        back="Ground. Mantle +1",waist="Sailfi Belt +1",legs="Atrophy Tights +3",feet="Atro. Boots +3"}
		
	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {
        head="Malignance Chapeau",neck="Null Loop",rear="Leth. Earring +1",
		body="Ayanmo Corazza +2",hands="Atrophy Gloves +3",ring1="Mars's Ring",ring2="Cacoethic Ring +1",
        back="Lupine Cape",legs="Atrophy Tights +3",feet="Atro. Boots +3"})
	sets.Mode.Att= set_combine(sets.engaged, {
        head="Jhakri Coronal +2",neck="Rep. Plat. Medal",
        body="Jhakri Robe +2",hands="Jhakri Cuffs +2",ring1="Adoulin Ring",ring2="Ilabrat Ring",
        waist="Sulla Belt",legs="Jhakri Slops +2",feet="Jhakri Pigaches +2"})
	sets.Mode.Crit = set_combine(sets.engaged, {feet="Aya. Gambieras +2"})
	sets.Mode.DA = set_combine(sets.engaged, { ammo="Coiste Bodhar",
		neck="Asperity Necklace",lear="Sherida Earring",rear="Leth. Earring +1",
        body="Ayanmo Corazza +2",legs="Zoar Subligar"})
	sets.Mode.SB = set_combine(sets.engaged, {lear="Sherida Earring"})
	sets.Mode.sTP = set_combine(sets.engaged, { ammo="Coiste Bodhar",
        head="Malignance Chapeau",neck="Anu Torque",lear="Sherida Earring",rear="Digni. Earring",
        back="Lupine Cape",legs="Jhakri Slops +2",ring2="Ilabrat Ring"})
	sets.Mode.STR = set_combine(sets.engaged, { ammo="Amar Cluster",
		head="Jhakri Coronal +2",neck="Rep. Plat. Medal",lear="Sherida Earring",rear="Enervating Earring",
		body="Jhakri Robe +2",hands="Jhakri Cuffs +2",ring1="Rajas Ring",ring2="Apate Ring",
		back="Buquwik Cape",waist="Sailfi Belt +1",legs="Jhakri Slops +2",feet="Jhakri Pigaches +2"})
	sets.Mode.DT = set_combine(sets.engaged, {
        head="Nyame Helm",neck="Null Loop",
        body="Bunzi's Robe",hands="Nyame Gauntlets",ring1="Defending Ring",
        back="Sucellos's Cape",waist="Plat. Mog. Belt",legs="Nyame Flanchard",feet="Nyame Sollerets"})
    sets.Mode.Meva = set_combine(sets.engaged, {
        head="Nyame Helm",neck="Elite Royal Collar",lear="Etiolation Earring",rear="Eabani Earring",
        body="Bunzi's Robe",hands="Nyame Gauntlets",ring1="Defending Ring",ring2="Shadow Ring",
        back="Reiki Cloak",waist="Plat. Mog. Belt",legs="Nyame Flanchard",feet="Nyame Sollerets"})	
	-- other Sets    
	sets.macc = {main="Marin Staff +1",sub="Enki Strap",ammo="Pemphredo Tathlum",
        head="Atrophy Chapeau +3",neck="Null Loop",lear="Snotra Earring",rear="Leth. Earring +1",
        body="Atrophy Tabard +3",hands="Jhakri Cuffs +2",ring1="Sangoma Ring",ring2="Metamor. Ring +1",
        back="Sucellos's Cape",waist="Famine Sash",legs="Jhakri Slops +2",feet="Jhakri Pigaches +2"}
	sets.PDL = {head="Malignance Chapeau"}
	sets.empy = {head="Lethargy Chappel",
		body="Lethargy Sayon +1",hands="Lethargy Gantherots",
		legs="Leth. Fuseau +1",feet="Leth. Houseaux +1"}

	-- Sets with weapons defined.
	sets.engaged.Club = {}
	sets.engaged.Staff = {}
	sets.engaged.Sword = {}
	sets.engaged.Dagger = {}
	-- sets.engaged.Sword = set_combine(sets.engaged, {main="Caliburnus",sub="Genbu's Shield"})
	-- sets.engaged.Sword = set_combine(sets.engaged, {main="Naegling",sub="Genbu's Shield"})
	sets.engaged.Sword = set_combine(sets.engaged, {main="Naegling",sub="Genbu's Shield"})
	sets.engaged.Sword.Acc = set_combine(sets.engaged.Sword, sets.Mode.Acc)
	sets.engaged.Sword.Att = set_combine(sets.engaged.Sword, sets.Mode.Att)
	sets.engaged.Sword.Crit = set_combine(sets.engaged.Sword, sets.Mode.Crit)
	sets.engaged.Sword.DA = set_combine(sets.engaged.Sword, sets.Mode.DA)
	sets.engaged.Sword.SB = set_combine(sets.engaged.Sword, sets.Mode.SB)
	sets.engaged.Sword.sTP = set_combine(sets.engaged.Sword, sets.Mode.sTP)
	sets.engaged.Sword.STR = set_combine(sets.engaged.Sword, sets.Mode.STR)
	sets.engaged.Sword.DT = set_combine(sets.engaged.Sword, sets.Mode.DT)
	sets.engaged.Sword.Meva = set_combine(sets.engaged.Sword, sets.Mode.Meva)	
	
	sets.engaged.Club = set_combine(sets.engaged, {main="Bunzi's Rod",sub="Genbu's Shield"})
	sets.engaged.Club.Acc = set_combine(sets.engaged.Club, sets.Mode.Acc)
	sets.engaged.Club.Att = set_combine(sets.engaged.Club, sets.Mode.Att)
	sets.engaged.Club.Crit = set_combine(sets.engaged.Club, sets.Mode.Crit)
	sets.engaged.Club.DA = set_combine(sets.engaged.Club, sets.Mode.DA)
	sets.engaged.Club.SB = set_combine(sets.engaged.Club, sets.Mode.SB)
	sets.engaged.Club.sTP = set_combine(sets.engaged.Club, sets.Mode.sTP)
	sets.engaged.Club.STR = set_combine(sets.engaged.Club, sets.Mode.STR)
	sets.engaged.Club.DT = set_combine(sets.engaged.Club, sets.Mode.DT)
	sets.engaged.Club.Meva = set_combine(sets.engaged.Club, sets.Mode.Meva)
	
	sets.engaged.Staff = set_combine(sets.engaged, {main="Marin Staff +1",sub="Benthos Grip"})
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
    sets.precast.JA['Chainspell'] = {body="Vitiation Tabard"}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        head="Nyame Helm",lear="Roundel Earring",
        body="Atrophy Tabard +1",hands="Nyame Gauntlets",
        back="Refraction Cape",legs="Nyame Flanchard",}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}
    
    -- 80% Fast Cast (including trait) for all spells, plus 5% quick cast
    -- No other FC sets necessary.
    sets.precast.FC = {
        head="Atrophy Chapeau +3",neck="Orunmila's Torque",lear="Malignance Earring",rear="Leth. Earring +1",
        body="Vitiation Tabard",ring1="Kishar Ring",ring2="Prolix Ring",
        back="Swith Cape +1",waist="Embla Sash",legs="Aya. Cosciales +2",feet="Merlinic Crackows"}

    sets.precast.FC.Impact = set_combine(sets.precast.FC, {head=empty,body="Twilight Cloak"})
    
    sets.precast.FC.Impact = set_combine(sets.precast.FC, {head=empty,body="Crepuscular Cloak"})
	sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {main="Daybreak"})
    -- Midcast Sets
    sets.midcast.Healing = {
		neck="Incanter's Torque",body="Vitiation Tabard"}
		
    sets.midcast.Cure = set_combine(sets.midcast.Healing,  {main="Bunzi's Rod",sub="Genbu's Shield",
        neck="Phalaina Locket",lear="Roundel Earring",
        body="Bunzi's Robe",hands="Telchine Gloves",ring1="Ephedra Ring",ring2="Lebeche Ring",
        back="Swith Cape +1",waist="Witful Belt",legs="Atrophy Tights +3",feet="Medium's Sabots"})
        
    sets.midcast.Curaga = set_combine(sets.midcast.Cure, {})
    sets.midcast.CureSelf = set_combine(sets.midcast.Cure, {})
 
	-- healing
    sets.midcast.StatusRemoval = set_combine(sets.midcast.Healing, {
        neck="Incanter's Torque",ring1="Ephedra Ring"})

    sets.midcast.Cursna = set_combine(sets.midcast.StatusRemoval, {
        neck="Incanter's Torque",
        ring1="Ephedra Ring",
        feet="Gende. Galoshes"})
		
    sets.midcast['Enhancing Magic'] = { main="Exemplar",
        head="Atrophy Chapeau +3",rear="Leth. Earring +1",
        body="Vitiation Tabard",hands="Atrophy Gloves +3",ring1="Prolix Ring",
        back="Sucellos's Cape",waist="Embla Sash",legs="Atrophy Tights +3",feet="Leth. Houseaux +1"}

	sets.midcast.Regen = set_combine(sets.midcast['Enhancing Magic'],{
		main="Bolelabunga",lear="Pratik Earring",
		body="Telchine Chas.",
		feet="Telchine Pigaches"})
	sets.midcast['Enhancing Magic']['Refresh'] = set_combine(sets.midcast['Enhancing Magic'],{
		body="Atrophy Tabard +3",
		legs="Leth. Fuseau +1",back="Grapevine Cape",waist="Gishdubar Sash"})
 
    sets.midcast.Stoneskin = {waist="Siegel Sash"}

	-- Elemental Magic sets
	sets.midcast['Elemental Magic'] = {main="Bunzi's Rod",sub="Ammurapi Shield",ammo="Pemphredo Tathlum",
        head="Merlinic Hood",neck="Sanctity Necklace",lear="Malignance Earring",rear="Friomisi Earring",
        body="Merlinic Jubbah",hands="Jhakri Cuffs +2",ring1="Adoulin Ring",ring2="Metamor. Ring +1",
        back="Sucellos's Cape",waist="Eschan Stone",legs="Merlinic Shalwar",feet="Merlinic Crackows"}

    sets.midcast['Elemental Magic'].INT = set_combine(sets.midcast['Elemental Magic'], 
	   {main="Marin Staff +1",sub="Benthos Grip",ammo="Pemphredo Tathlum",
        head="Atrophy Chapeau +3",neck="Sibyl Scarf",lear="Malignance Earring",rear="Psystorm Earring",
        body="Jhakri Robe +2",hands="Jhakri Cuffs +2",ring1="Diamond Ring",ring2="Metamor. Ring +1",
        back="Sucellos's Cape",waist="Channeler's Stone",legs="Jhakri Slops +2",feet="Jhakri Pigaches +2"})

    sets.midcast['Elemental Magic'].MAB = set_combine(sets.midcast['Elemental Magic'], 
	   {main="Bunzi's Rod",sub="Ammurapi Shield",ammo="Pemphredo Tathlum",
        head="Merlinic Hood",neck="Baetyl Pendant",lear="Malignance Earring",rear="Friomisi Earring",
        body="Merlinic Jubbah",hands="Jhakri Cuffs +2",ring1="Adoulin Ring",
        back="Sucellos's Cape",waist="Eschan Stone",legs="Hagondes Pants +1",feet="Merlinic Crackows"})
  
    sets.midcast['Elemental Magic'].MB = set_combine(sets.midcast['Elemental Magic'], 
	   {main="Bunzi's Rod",sub="Ammurapi Shield",
		head="Atrophy Chapeau +3",neck="Mizu. Kubikazari",
		body="Nyame Mail",hands="Amalric Gages",ring1="Mujin Band",
		back="Izdubar Mantle",legs="Nyame Flanchard",feet="Jhakri Pigaches +2"})
  
	sets.midcast['Elemental Magic'].Macc = set_combine(sets.macc, {head="Atro. Chapeau +2"})
	
	sets.midcast['Elemental Magic'].Mcrit = set_combine(sets.midcast['Elemental Magic'], 
	   {body="Count's Garb",hands="Helios Gloves"})
   
    sets.midcast['Elemental Magic'].MDmg = set_combine(sets.midcast['Elemental Magic'], 
	   {main="Bunzi's Rod",sub="Ammurapi Shield",ammo="Ghastly Tathlum +1",
        head="Buremte Hat",lear="Crematio Earring",
        back="Sucellos's Cape",waist="Sekhmet Corset",legs="Hagondes Pants +1"})
 
 	-- don't set_combine() these handled progressively in customize_enfeeble_sets in job_post_midcast
	-- those in the later will use the slots in the former when appropriate (so leave stuff like INT blank if you'd rather have macc or skill)
	sets.midcast.Enfeebling = {}
	sets.midcast.Enfeebling.Skill = set_combine(sets.macc, {
        head="Viti. Chapeau +1",neck="Incanter's Torque",
        body="Atrophy Tabard +3",hands="Ayao's Gages",ring2="Globidonta Ring",
        back="Sucellos's Cape",waist="Rumination Sash",legs="Psycloth Lappas",feet="Medium's Sabots"})
	sets.midcast.Enfeebling.MND = {}
	sets.midcast.Enfeebling.INT = {}
	sets.midcast.Enfeebling.effect = {feet="Uk'uxkaj Boots"}
	sets.midcast.Enfeebling.duration = {lear="Snotra Earring",ring1="Kishar Ring"}
	sets.midcast.Enfeebling.immuno = {}


        
    sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'], {head=empty,body="Twilight Cloak"})

	sets.midcast['Divine Magic'] = set_combine(sets.macc, {feet="Medium's Sabots"})
    sets.midcast['Dark Magic'] = set_combine(sets.macc, {sub="Mephitis Grip",
        head="Atrophy Chapeau +3",neck="Erra Pendant",lear="Abyssal Earring",rear="Psystorm Earring",
        body="Vanir Cotehardie",ring1="Evanescence Ring",ring1="Kishar Ring",
        back="Refraction Cape"})

    --sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {})

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {ring2="Excelsis Ring", waist="Fucho-no-Obi"})

    sets.midcast.Aspir = set_combine(sets.midcast.Drain, {})

    -- Sets for special buff conditions on spells.
    sets.midcast.EnhancingDuration = {
		rear="Leth. Earring +1",
		body="Telchine Chas.",hands="Atrophy Gloves +3",
		back="Sucellos's Cape",waist="Embla Sash",legs="Telchine Braconi",feet="Leth. Houseaux +1"}
        
    sets.buff.ComposureOther = {head="Estoqueur's Chappel +2",
        body="Lethargy Sayon +1",hands="Estoqueur's Gantherots +2",
        legs="Leth. Fuseau +1",feet="Leth. Houseaux +1"}

    sets.buff.Saboteur = {hands="Estoqueur's Gantherots +2"}
	sets.buff.FullSublimation = {waist="Embla Sash"}
    sets.buff.PDTSublimation = set_combine(sets.buff.FullSublimation,{})

    -- Defense sets
    sets.defense = {}
	sets.defense.Reraise = {head="Twilight Helm", body="Twilight Mail"}
	sets.defense.Evasion = set_combine(sets.Mode.Eva, {})
	sets.defense.PDT = set_combine(sets.Mode.DT, {})
	sets.defense.MDT = set_combine(sets.Mode.Meva, {})
	sets.debuffed = set_combine(sets.Mode.DT,sets.Mode.Meva)
	sets.doom = set_combine(sets.debuffed,sets.defense.Reraise,{waist="Gishdubar Sash"})


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
	customize_enfeeble_sets(spell)
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

