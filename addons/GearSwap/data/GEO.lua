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
    indi_timer = ''
    indi_duration = 180
	newLuopan = 0
	state.WeaponMode = M{['description']='Weapon Mode', 'Staff', 'Club'}
  	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive'}
	state.holdtp = M{['description']='holdtp', 'false', 'true'}
	pick_tp_weapon()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'SB', 'sTP', 'STR')
    state.CastingMode:options('Normal', 'INT', 'MAB', 'Macc', 'MDmg', 'Skill', 'Proc')
	state.IdleMode:options('Normal', 'PDT' )
 	state.WeaponMode:set('Club')
	state.Stance:set('None')
	state.holdtp:set('false')

	pick_tp_weapon()
 
    select_default_macro_book()
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    gear.macc_staff = { name="Grioavolr", augments={'Magic burst dmg.+3%','INT+6','Mag. Acc.+24','"Mag.Atk.Bns."+22',}}
    gear.idleCape = { name="Nantosuelta's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Pet: "Regen"+10',}}
    gear.nukeCape = { name="Nantosuelta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10',}}

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
		food="Pear Crepe",
		orb="Macrocosmic Orb"
	}	
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
    sets.idle = {range="Dunna",
        head="Befouled Crown",neck="Elite Royal Collar",lear="Moonshade Earring",rear="Azimuth Earring +1",
        body="Jhakri Robe +2",hands="Bagua Mitaines +1",ring1="Defending Ring",ring2="Renaye Ring +1",
        back="Solemnity Cape",waist="Plat. Mog. Belt",legs="Assid. Pants +1",feet="Geo. Sandals +3"}
	sets.idle.PDT = set_combine(sets.idle, {hands="Azimuth Gloves +2"})
	sets.PetHP = {head="Bagua Galero +2"}

   -- .Pet sets are for when Luopan is present.
    sets.idle.Pet = set_combine(sets.idle, {main="Idris",sub="Genmei Shield",range="Dunna",
        head="Azimuth Hood +2",neck="Bagua Charm +1",lear="Handler's Earring",rear="Azimuth Earring +1",
        body="Azimuth Coat +2",hands="Geo. Mitaines +2",ring2="Renaye Ring +1",
        back=gear.idleCape,legs="Psycloth Lappas",feet="Bagua Sandals +1"})

    -- .Indi sets are for when an Indi-spell is active.
    sets.idle.Indi = set_combine(sets.idle, {back=gear.idleCape,legs="Bagua Pants +1"})
    sets.idle.Pet.Indi = set_combine(sets.idle.Pet, {back=gear.idleCape})

    -- Resting sets
    sets.resting = set_combine(sets.idle, {main="Chatoyant Staff"})

    -- Normal melee group
    sets.engaged = {range="Dunna",
        head="Azimuth Hood +2",neck="Combatant's Torque",lear="Zennaroi Earring",rear="Ethereal Earring",
        body="Azimuth Coat +2",hands="Azimuth Gloves +2",ring1="Patricius Ring",ring2="Apate Ring",
        back="Kumbira Cape",waist="Olseni Belt",legs="Azimuth Tights +2",feet="Azimuth Gaiters +2"}
		
	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {
        head="Azimuth Hood +2",neck="Combatant's Torque",lear="Zennaroi Earring",rear="Digni. Earring",
		body="Azimuth Coat +2",hands="Azimuth Gloves +2",ring1="Mars's Ring",ring2="Cacoethic Ring +1",
		waist="Olseni Belt",legs="Azimuth Tights +2",feet="Azimuth Gaiters +2"})
	sets.Mode.Att= set_combine(sets.engaged, {
		head="Jhakri Coronal +2",neck="Rep. Plat. Medal",lear="Bladeborn Earring",rear="Dudgeon Earring",ring1="Overbearing Ring",
		body="Jhakri Robe +2",hands="Jhakri Cuffs +2",
		waist="Eschan Stone",legs="Jhakri Slops +2",feet="Jhakri Pigaches +2"})
	sets.Mode.Crit = set_combine(sets.engaged, {ring1="Hetairoi Ring"})
	sets.Mode.DA = set_combine(sets.engaged, {lear="Trux Earring",rear="Brutal Earring",ring1="Hetairoi Ring",legs="Querkening Brais"})
	sets.Mode.SB = set_combine(sets.engaged, {})
	sets.Mode.sTP = set_combine(sets.engaged, {lear="Enervating Earring",rear="Digni. Earring",waist="Olseni Belt",legs="Jhakri Slops +2",feet="Battlecast Gaiters"})
	sets.Mode.STR = set_combine(sets.engaged, {
		head="Jhakri Coronal +2",neck="Rep. Plat. Medal",
		body="Jhakri Robe +2",hands="Jhakri Cuffs +2",ring1="Apate Ring",ring2="Rajas Ring",
		back="Buquwik Cape",waist="Cornelia's Belt",legs="Jhakri Slops +2",feet="Jhakri Pigaches +2"})
			
	-- other Sets    
	sets.macc = {main="Marin Staff +1",sub="Enki Strap",range="Dunna",
        head="Azimuth Hood +2",neck="Bagua Charm +1",lear="Digni. Earring",rear="Azimuth Earring +1",
        body="Azimuth Coat +2",hands="Azimuth Gloves +2",ring1="Sangoma Ring",ring2="Metamor. Ring +1",
        back=gear.nukeCape,waist="Luminary Sash",legs="Azimuth Tights +2",feet="Azimuth Gaiters +2"}
	sets.PDL = {}
	sets.empy = {head="Azimuth Hood +2",
		body="Azimuth Coat +2",hands="Azimuth Gloves +2",
		legs="Azimuth Tights +2",feet="Azimuth Gaiters +2"}		

	-- Sets with weapons defined.
	sets.engaged.Club = {}
	sets.engaged.Staff = {}
	sets.engaged.Club = set_combine(sets.engaged, {main="Idris",sub="Genmei Shield"})
	sets.engaged.Club.Acc = set_combine(sets.engaged.Club, sets.Mode.Acc)
	sets.engaged.Club.Att = set_combine(sets.engaged.Club, sets.Mode.Att)
	sets.engaged.Club.Crit = set_combine(sets.engaged.Club, sets.Mode.Crit)
	sets.engaged.Club.DA = set_combine(sets.engaged.Club, sets.Mode.DA)
	sets.engaged.Club.SB = set_combine(sets.engaged.Club, sets.Mode.SB)
	sets.engaged.Club.sTP = set_combine(sets.engaged.Club, sets.Mode.sTP)
	sets.engaged.Club.STR = set_combine(sets.engaged.Club, sets.Mode.STR)

	sets.engaged.Staff = set_combine(sets.engaged, {main="Malignance Pole", sub="Khonsu"})
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
	
	-- none, INT 50% MND 50%
	sets.precast.WS['Spirit Taker'] = set_combine(sets.precast.WS, {})
 
    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	-- thunder, STR 40% MND 40%
    sets.precast.WS['Seraph Strike'] = set_combine(sets.precast.WS, {})
	
	-- none
    sets.precast.WS['Starlight'] = {rear="Moonshade Earring"}

	-- none
    sets.precast.WS['Moonlight'] = {rear="Moonshade Earring"}

	-- wind/thunder, STR 100%
    sets.precast.WS['True Strike'] = set_combine(sets.precast.WS, {})
    
	-- Water/Ice, STR 50% MND 50%
	sets.precast.WS['Flash Nova'] = set_combine(sets.precast.WS, {})

    -- Precast sets to enhance JAs
    sets.precast.JA.Bolster = {body="Bagua Tunic +1"}
    sets.precast.JA['Life cycle'] = {body="Geomancy Tunic",back=gear.idleCape}
    sets.precast.JA['Full Circle'] = {head="Azimuth Hood +2",hands="Bagua Mitaines +1"}

    -- Fast cast sets for spells
    sets.precast.FC = { range="Dunna",
        head="Vanya Hood",neck="Orunmila's Torque",lear="Etiolation Earring",
        body="Shango Robe",ring1="Kishar Ring",ring2="Prolix Ring",
        back="Lifestream Cape",waist="Embla Sash",legs="Geomancy Pants"}

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {main="Tamaxchi",sub="Genmei Shield",back="Pahtli Cape"})

    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {lear="Barkaro. Earring",hands="Bagua Mitaines +1",feet="Mallquis Clogs +2"})

    --------------------------------------
    -- Midcast sets
    --------------------------------------
    sets.midcast['Elemental Magic'] = { main="Marin Staff +1",sub="Niobid Strap",ammo="Pemphredo Tathlum",
        head="Azimuth Hood +2",neck="Sanctity Necklace",lear="Barkaro. Earring",rear="Azimuth Earring +1",
        body="Azimuth Coat +2",hands="Azimuth Gloves +2",ring1="Strendu Ring",ring2="Metamor. Ring +1",
        back=gear.nukeCape,waist="Eschan Stone",legs="Azimuth Tights +2",feet="Azimuth Gaiters +2"}

    sets.midcast['Elemental Magic'].INT = set_combine(sets.midcast['Elemental Magic'], 
	   {main="Marin Staff +1",sub="Enki Strap",ammo="Pemphredo Tathlum",
        head="Merlinic Hood",neck="Sibyl Scarf",lear="Barkaro. Earring",rear="Psystorm Earring",
        body="Jhakri Robe +2",hands="Mallquis Cuffs +1",ring1="Mallquis Ring",ring2="Metamor. Ring +1",
        back=gear.nukeCape,waist="Wanion Belt",legs="Mallquis Trews +1",feet="Mallquis Clogs +2"})

    sets.midcast['Elemental Magic'].MAB = set_combine(sets.midcast['Elemental Magic'], 
	   {main="Marin Staff +1",sub="Niobid Strap",ammo="Pemphredo Tathlum",
        head="Azimuth Hood +2",neck="Baetyl Pendant",lear="Barkaro. Earring",rear="Friomisi Earring",
        body="Merlinic Jubbah",hands="Azimuth Gloves +2",ring1="Strendu Ring",
        back=gear.nukeCape,waist="Eschan Stone",legs="Azimuth Tights +2",feet="Merlinic Crackows"})
  
    sets.midcast['Elemental Magic'].MB = set_combine(sets.midcast['Elemental Magic'], {
		main=gear.macc_staff,
        neck="Mizu. Kubikazari",
		body="Azimuth Coat +2",hands="Amalric Gages",
		legs="Azimuth Tights +2",feet="Jhakri Pigaches +2"})
  
	sets.midcast['Elemental Magic'].Macc = set_combine(sets.midcast['Elemental Magic'], sets.macc)
   
    sets.midcast['Elemental Magic'].MDmg = set_combine(sets.midcast['Elemental Magic'], 
	   {main="Marin Staff +1",sub="Thrace Strap",ammo="Ghastly Tathlum +1",
        head="Mall. Chapeau +2",lear="Crematio Earring",
        body="Mallquis Saio +1",hands="Mallquis Cuffs +1",ring1="Mallquis Ring",
        back=gear.nukeCape,waist="Sekhmet Corset",legs="Mallquis Trews +1",feet="Mallquis Clogs +2"})
 
    sets.midcast['Elemental Magic'].Skill = set_combine(sets.midcast['Elemental Magic'], 
	   {main="Exemplar",
        head="Geomancy Galero",neck="Incanter's Torque",lear="Strophadic Earring",
		body="Azimuth Coat +2",
        hands="Amalric Gages",feet="Navon Crackows"})

    sets.midcast['Enfeebling Magic'] = set_combine(sets.macc, {
        head="Befouled Crown",neck="Incanter's Torque",
        body="Shango Robe",hands="Azimuth Gloves +2",ring1="Kishar Ring",ring2="Globidonta Ring",
        back="Lifestream Cape",waist="Rumination Sash",legs="Psycloth Lappas",feet="Bagua Sandals +1"})

    sets.midcast['Dark Magic'] = set_combine(sets.macc, {
        neck="Erra Pendant",
		body="Geomancy Tunic",ring1="Evanescence Ring",ring2="Kishar Ring",
        back="Perimede Cape",waist="Rumination Sash",legs="Azimuth Tights +2"})

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'],{head="Bagua Galero +2",neck="Erra Pendant",ring2="Excelsis Ring",waist="Fucho-no-obi",feet="Merlinic Crackows"})
    
    sets.midcast.Aspir = set_combine(sets.midcast.Drain, {})
		
	sets.midcast['Enhancing Magic'] = { main="Exemplar",
        head="Befouled Crown",neck="Incanter's Torque",lear="Andoaa Earring",
		body="Telchine Chas.",hands="Telchine Gloves",
		back="Perimede Cape",waist="Embla Sash",legs="Telchine Braconi",feet="Telchine Pigaches"}
	sets.midcast['Enhancing Magic']['Refresh'] = set_combine(sets.midcast['Enhancing Magic'],{
		back="Grapevine Cape",waist="Gishdubar Sash"})
	sets.midcast.Regen = {main="Bolelabunga",sub="Genmei Shield",lear="Pratik Earring",body="Telchine Chas.",feet="Telchine Pigaches"}

    -- Base fast recast for spells
    -- sets.midcast.FastRecast = { head="Zelus Tiara",legs="Hagondes Pants +1",feet="Tutyr Sabots"}

    sets.midcast.Geomancy = {main="Idris",range="Dunna",
		head="Azimuth Hood +2",neck="Incanter's Torque",
		body="Bagua Tunic +1",hands="Geo. Mitaines +2",ring2="Renaye Ring +1",
		back="Lifestream Cape",feet="Medium's Sabots"}
    sets.midcast.Geomancy.Indi = set_combine(sets.midcast.Geomancy,{main="Idris",
		back=gear.idleCape,legs="Bagua Pants +1",feet="Azimuth Gaiters +2"})
	-- TODO: entrust with Solstice

	-- healing skill
    sets.midcast.StatusRemoval = {neck="Incanter's Torque",hands="Ayao's Gages",ring1="Ephedra Ring"}

	-- Cure %+ > healing skill > MND
    sets.midcast.Cure = set_combine(sets.midcast.StatusRemoval, {main="Tamaxchi",sub="Genmei Shield",
        head="Vanya Hood",neck="Phalaina Locket",
		body="Heka's Kalasiris",hands="Telchine Gloves",ring1="Naji's Loop",ring2="Lebeche Ring",
		back="Solemnity Cape",waist="Rumination Sash",legs="Gyve Trousers",feet="Medium's Sabots"})
    
    sets.midcast.Curaga = set_combine(sets.midcast.Cure, {})

    sets.midcast.Protectra = {}

    sets.midcast.Shellra = {}

    -- Defense sets
    sets.defense.PDT = {
        head="Azimuth Hood +2",
        body="Mallquis Saio +1",hands="Azimuth Gloves +2",ring1="Defending Ring",ring2="Patricius Ring",
        back="Solemnity Cape",waist="Plat. Mog. Belt",legs="Hagondes Pants +1",feet="Azimuth Gaiters +2"}

    sets.defense.MDT = {
		head="Azimuth Hood +2",lear="Etiolation Earring",rear="Eabani Earring",
        body="Mallquis Saio +1",hands="Azimuth Gloves +2",ring1="Defending Ring",ring2="Vengeful Ring",
        back="Solemnity Cape",waist="Plat. Mog. Belt",legs="Gyve Trousers",feet="Azimuth Gaiters +2"}
		
	sets.debuffed = set_combine(sets.defense.Evasion,sets.defense.PDT,sets.defense.MDT)
	sets.doom = set_combine(sets.debuffed,{waist="Gishdubar Sash"})
    sets.Kiting = {feet="Geo. Sandals +3"}

    sets.latent_refresh = {waist="Fucho-no-obi"}
 
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english:startswith('Indi') then
            if not classes.CustomIdleGroups:contains('Indi') then
                classes.CustomIdleGroups:append('Indi')
            end
            send_command('@timers d "'..indi_timer..'"')
            indi_timer = spell.english
            send_command('@timers c "'..indi_timer..'" '..indi_duration..' down spells/00136.png')
        elseif spell.english == 'Sleep' or spell.english == 'Sleepga' then
            send_command('@timers c "'..spell.english..' ['..spell.target.name..']" 60 down spells/00220.png')
        elseif spell.english == 'Sleep II' or spell.english == 'Sleepga II' then
            send_command('@timers c "'..spell.english..' ['..spell.target.name..']" 90 down spells/00220.png')
		elseif spell.english:startswith('Geo-') then
			newLuopan = 1
		elseif spell.english == "Life Cycle" then
            newLuopan = 0
        end
    elseif not player.indi then
        classes.CustomIdleGroups:clear()
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
    if player.indi and not classes.CustomIdleGroups:contains('Indi')then
        classes.CustomIdleGroups:append('Indi')
        handle_equipping_gear(player.status)
    elseif classes.CustomIdleGroups:contains('Indi') and not player.indi then
        classes.CustomIdleGroups:clear()
        handle_equipping_gear(player.status)
    end
end

function job_handle_equipping_gear(status, eventArgs)
	-- add_to_chat(122,'handle equiping gear')
	check_tp_lock()
	pick_tp_weapon()
end

function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Offense Mode' then
        if newValue == 'Normal' then
            disable('main','sub','range')
        else
            enable('main','sub','range')
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
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

function job_post_precast(spell, action, spellMap, eventArgs)

end

function job_post_midcast(spell, action, spellMap, eventArgs)
	if buffactive['entrust'] then
		add_to_chat(122,' entrust ')
	end
	if spell.skill == 'Elemental Magic' then
	-- add_to_chat(122,' elemental magic ')
        if is_magic_element_today(spell) then
			-- add_to_chat(122,' Element Day ')
            equip(sets.Day[spell.element])
        end
        if is_magic_element_weather(spell) then
			-- add_to_chat(122,' Element Weather ')
            equip(sets.Weather[spell.element])
        end
	end 
end

function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if spell.skill == 'Enfeebling Magic' then
            if spell.type == 'WhiteMagic' then
                return 'MndEnfeebles'
            else
                return 'IntEnfeebles'
            end
        elseif spell.skill == 'Geomancy' then
            if spell.english:startswith('Indi') then
                return 'Indi'
            end
        end
    end
end

function customize_idle_set(idleSet)
	if buffactive['reive mark'] then
		idleSet = set_combine(idleSet, sets.Reive )
	end
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
	-- add_to_chat(122,'cust idle')
    if pet.isvalid then
		-- add_to_chat(122,'pet valid')
		if newLuopan == 1 then
		end
        idleSet = set_combine(idleSet, sets.idle.Pet)
		if buffactive['Indi'] then
			-- add_to_chat(122,'PET Indi')
			idleSet = set_combine(idleSet, sets.idle.Pet.Indi)
		end
		if pet.hpp > 73 then
            if newLuopan == 1 then
                equip(sets.PetHP)
				-- add_to_chat(122,'PET HP')
				-- idleSet = set_combine(idleSet, sets.PetHP)
				disable('head')
            end
        elseif pet.hpp <= 73 then
			-- add_to_chat(122,'low pet hp enable head')
            enable('head')
            newLuopan = 0
        end
	-- else
		-- add_to_chat(122,'no pet enable head')
		-- enable('head')
		-- newLuopan = 0
    end
    return idleSet
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    classes.CustomIdleGroups:clear()
    if player.indi then
        classes.CustomIdleGroups:append('Indi')
    end
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
    set_macro_page(3, 20)
	send_command('exec geo.txt')
end

function get_combat_form()
	set_combat_form()
end
