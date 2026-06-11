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
	state.WeaponMode = M{['description']='Weapon Mode', 'Staff', 'Club', 'Scythe', 'Polearm'}
  	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive'}
	state.holdtp = M{['description']='holdtp', 'false', 'true'}
	pick_tp_weapon()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'SB', 'sTP', 'STR', 'DT', 'Meva')
    state.CastingMode:options('Normal', 'Death', 'INT', 'MAB', 'MB', 'Macc', 'Mcrit', 'MDmg', 'Proc')
	state.IdleMode:options('Normal', 'PDT', 'Death')
 	state.WeaponMode:set('Staff')
	state.Stance:set('None')
	state.holdtp:set('false')
   
    -- state.MagicBurst = M(false, 'Magic Burst')

    lowTierNukes = S{'Stone', 'Water', 'Aero', 'Fire', 'Blizzard', 'Thunder',
        'Stone II', 'Water II', 'Aero II', 'Fire II', 'Blizzard II', 'Thunder II',
        'Stone III', 'Water III', 'Aero III', 'Fire III', 'Blizzard III', 'Thunder III',
        'Stonega', 'Waterga', 'Aeroga', 'Firaga', 'Blizzaga', 'Thundaga',
        'Stonega II', 'Waterga II', 'Aeroga II', 'Firaga II', 'Blizzaga II', 'Thundaga II'}

    gear.macc_staff = { name="Grioavolr", augments={'Magic burst dmg.+3%','INT+6','Mag. Acc.+24','"Mag.Atk.Bns."+22',}}
    
    -- Additional local binds
    send_command('bind ^` input /ma Stun <t>')
    -- send_command('bind @` gs c activate MagicBurst')
	pick_tp_weapon()
 
    select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind @`')
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
		food="Pear Crepe",
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
    sets.idle = {ammo="Pemphredo Tathlum",
        head="Volte Beret",neck="Null Loop",lear="Moonshade Earring",rear="Ethereal Earring",
        body="Jhakri Robe +2",hands="Telchine Gloves",ring1="Murky Ring",ring2="Renaye Ring +1",
        back="Solemnity Cape",waist="Null Belt",legs="Assid. Pants +1",feet="Herald's Gaiters"}
	sets.idle.Death = {main="Lathi",sub="Niobid Strap",ammo="Ghastly Tathlum +1",
		head="Pixie Hairpin +1",neck="Sanctity Necklace",lear="Etiolation Earring",rear="Evans Earring",
        body="Nyame Mail",hands="Nyame Gauntlets",ring1="Sangoma Ring",ring2="Adoulin Ring",
		legs="Spae. Tonban +1",feet="Nyame Sollerets"}

    -- Resting sets
    sets.resting = set_combine(sets.idle, {main="Chatoyant Staff"})

    -- Normal melee group
    sets.engaged = { ammo="Amar Cluster",
        head="Jhakri Coronal +2",neck="Null Loop",lear="Bladeborn Earring",rear="Steelflash Earring",
        body="Jhakri Robe +2",hands="Jhakri Cuffs +2",ring1="Adoulin Ring",ring2="Cacoethic Ring +1",
        back="Kumbira Cape",waist="Null Belt",legs="Miasmic Pants",feet="Jhakri Pigaches +2"}
		
	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {ammo="Amar Cluster",
		head="Jhakri Coronal +2",neck="Null Loop",lear="Zennaroi Earring",rear="Digni. Earring",
		body="Jhakri Robe +2",hands="Jhakri Cuffs +2",ring1="Mars's Ring",ring2="Cacoethic Ring +1",
		waist="Null Belt",legs="Jhakri Slops +2",feet="Jhakri Pigaches +2"})
	sets.Mode.Att= set_combine(sets.engaged, {ammo="Oshasha's Treatise",
		head="Jhakri Coronal +2",neck="Rep. Plat. Medal",lear="Bladeborn Earring",rear="Dudgeon Earring",
		body="Jhakri Robe +2",hands="Jhakri Cuffs +2",ring1="Adoulin Ring",
		waist="Eschan Stone",legs="Jhakri Slops +2",feet="Jhakri Pigaches +2"})
	sets.Mode.Crit = set_combine(sets.engaged, {ring2="Hetairoi Ring"})
	sets.Mode.DA = set_combine(sets.engaged, {lear="Trux Earring",rear="Brutal Earring",ring2="Hetairoi Ring",legs="Querkening Brais"})
	sets.Mode.SB = set_combine(sets.engaged, {neck="Combatant's Torque"})
	sets.Mode.sTP = set_combine(sets.engaged, {neck="Combatant's Torque",lear="Enervating Earring",rear="Digni. Earring",
		waist="Olseni Belt",legs="Jhakri Slops +2",feet="Battlecast Gaiters"})
	sets.Mode.STR = set_combine(sets.engaged, {ammo="Amar Cluster",
		head="Jhakri Coronal +2",neck="Rep. Plat. Medal",
		body="Jhakri Robe +2",hands="Jhakri Cuffs +2",ring1="Rajas Ring",ring2="Apate Ring",
		back="Buquwik Cape",waist="Cornelia's Belt",legs="Jhakri Slops +2",feet="Jhakri Pigaches +2"})
	sets.Mode.DT = {
        head="Nyame Helm",neck="Null Loop",
        body="Nyame Mail",hands="Nyame Gauntlets",ring1="Murky Ring",ring2="Patricius Ring",
        back="Solemnity Cape",waist="Plat. Mog. Belt",legs="Nyame Flanchard",feet="Nyame Sollerets"}
    sets.Mode.Meva = {
        head="Nyame Helm",neck="Elite Royal Collar",lear="Etiolation Earring",rear="Eabani Earring",
        body="Nyame Mail",hands="Nyame Gauntlets",ring1="Murky Ring",ring2="Vengeful Ring",
        back="Solemnity Cape",waist="Null Belt",legs="Nyame Flanchard",feet="Nyame Sollerets"}			

	-- other Sets    
	sets.macc = {main="Bunzi's Rod",sub="Ammurapi Shield",ammo="Pemphredo Tathlum",
        head="Merlinic Hood",neck="Null Loop",lear="Malignance Earring",rear="Wicce Earring +1",
        body="Jhakri Robe +2",hands="Jhakri Cuffs +2",ring1="Sangoma Ring",ring2="Metamor. Ring +1",
        back="Taranus's Cape",waist="Null Belt",legs="Merlinic Shalwar",feet="Jhakri Pigaches +2"}
	sets.PDL = {}
	sets.empy = {head="Wicce Petasos",
		body="Wicce Coat",hands="Wicce Gloves",
		legs="Goetia Chausses +1",feet="Goetia Sabots +1"}

	-- Sets with weapons defined.
	sets.engaged.Club = {}
	sets.engaged.Staff = {}
	sets.engaged.Club = set_combine(sets.engaged, {main="Maxentius",sub="Genmei Shield"})
	sets.engaged.Club.Acc = set_combine(sets.engaged.Club, sets.Mode.Acc)
	sets.engaged.Club.Att = set_combine(sets.engaged.Club, sets.Mode.Att)
	sets.engaged.Club.Crit = set_combine(sets.engaged.Club, sets.Mode.Crit)
	sets.engaged.Club.DA = set_combine(sets.engaged.Club, sets.Mode.DA)
	sets.engaged.Club.sTP = set_combine(sets.engaged.Club, sets.Mode.sTP)
	sets.engaged.Club.STR = set_combine(sets.engaged.Club, sets.Mode.STR)
	sets.engaged.Club.DT = set_combine(sets.engaged.Club, sets.Mode.DT)
	sets.engaged.Club.Meva = set_combine(sets.engaged.Club, sets.Mode.Meva)
	
	sets.engaged.Staff = set_combine(sets.engaged, {main="Malignance Pole", sub="Khonsu"})
	sets.engaged.Staff.Acc = set_combine(sets.engaged.Staff, sets.Mode.Acc)
	sets.engaged.Staff.Att = set_combine(sets.engaged.Staff, sets.Mode.Att)
	sets.engaged.Staff.Crit = set_combine(sets.engaged.Staff, sets.Mode.Crit)
	sets.engaged.Staff.DA = set_combine(sets.engaged.Staff, sets.Mode.DA)
	sets.engaged.Staff.sTP = set_combine(sets.engaged.Staff, sets.Mode.sTP)
	sets.engaged.Staff.STR = set_combine(sets.engaged.Staff, sets.Mode.STR)
	sets.engaged.Staff.DT = set_combine(sets.engaged.Staff, sets.Mode.DT)
	sets.engaged.Staff.Meva = set_combine(sets.engaged.Staff, sets.Mode.Meva)
	
	sets.engaged.Scythe = set_combine(sets.engaged, {main="Pixquizpan", sub="Khonsu"})
	sets.engaged.Scythe.Acc = set_combine(sets.engaged.Scythe, sets.Mode.Acc)
	sets.engaged.Scythe.Att = set_combine(sets.engaged.Scythe, sets.Mode.Att)
	sets.engaged.Scythe.Crit = set_combine(sets.engaged.Scythe, sets.Mode.Crit)
	sets.engaged.Scythe.DA = set_combine(sets.engaged.Scythe, sets.Mode.DA)
	sets.engaged.Scythe.sTP = set_combine(sets.engaged.Scythe, sets.Mode.sTP)
	sets.engaged.Scythe.STR = set_combine(sets.engaged.Scythe, sets.Mode.STR)

	sets.engaged.Polearm = set_combine(sets.engaged, {main="Pitchfork +1",sub="Khonsu"})
	sets.engaged.Polearm.Acc = set_combine(sets.engaged.Polearm, sets.Mode.Acc)

	
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
	sets.precast.WS = set_combine(sets.Mode.STR, {ammo="Oshasha's Treatise",
		neck="Fotia Gorget",rear="Ishvara Earring",
        hands="Jhakri Cuffs +2",ring1="Cornelia's Ring",ring2="Epaminondas's Ring",
        waist="Fotia Belt"})
    
	-- none, INT 50% MND 50%
	sets.precast.WS['Spirit Taker'] = set_combine(sets.precast.WS, {head="Befouled Crown",body="Supay Weskit"})
    
	-- Water/Ice/Thunder/Wind, INT 80%
	sets.precast.WS['Vidohunir'] = set_combine(sets.precast.WS, {
        lear="Friomisi Earring",
		ring2="Persis Ring",
        back="Toro Cape",legs="Hagondes Pants +1",feet="Merlinic Crackows"})
		
	-- self target, 20% mp recovered at 1k tp
	sets.precast.WS['Myrkr'] = set_combine(sets.precast.WS, {})	
		
    ---- Precast Sets ----
    
    -- Precast sets to enhance JAs
    sets.precast.JA['Mana Wall'] = {feet="Goetia Sabots"}
    sets.precast.JA['Elemental Seal'] = {}

    sets.precast.JA.Manafont = {body="Arch. Coat"}
    
    -- equip to maximize HP (for Tarus) and minimize MP loss before using convert
    sets.precast.JA.Convert = {}


    -- Fast cast sets for spells

    sets.precast.FC = { 
		head="Vanya Hood",neck="Orunmila's Torque",lear="Malignance Earring",rear="Etiolation Earring",
        body="Shango Robe",ring1="Kishar Ring",ring2="Prolix Ring",
		back="Perimede Cape",waist="Embla Sash",legs="Psycloth Lappas",feet="Merlinic Crackows"}

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {neck="Incanter's Torque",waist="Siegel Sash"})

    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {head="Wicce Petasos",lear="Barkaro. Earring"})

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {body="Heka's Kalasiris",ring1="Naji's Loop",back="Pahtli Cape"})
    
    sets.precast.FC.Curaga = set_combine(sets.precast.FC.Cure,{})
	
	sets.precast.FC.Death = set_combine(sets.idle.Death,{})
	sets.precast.FC.Impact = set_combine(sets.precast.FC['Elemental Magic'], {head=empty,body="Twilight Cloak"})
	sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {main="Daybreak"})

    ---- Midcast Sets ----
	-- This is equiped first during casting, haste or recast- time can be used but gets overwritten by other midcast sets
    -- sets.midcast.FastRecast = {body="Wicce Coat",feet="Tutyr Sabots"}

	-- healing skill
    sets.midcast.StatusRemoval = {neck="Incanter's Torque",hands="Ayao's Gages",ring1="Ephedra Ring"}

	-- Cure %+ > healing skill > MND
    sets.midcast.Cure = set_combine(sets.midcast.StatusRemoval, {main="Tamaxchi",sub="Genmei Shield",
        head="Vanya Hood",neck="Phalaina Locket",lear="Roundel Earring",
        body="Heka's Kalasiris",hands="Telchine Gloves",ring1="Naji's Loop",ring2="Lebeche Ring",
        back="Solemnity Cape",legs="Gyve Trousers",feet="Medium's Sabots"})

    sets.midcast.Curaga = set_combine(sets.midcast.Cure, {})
	
	sets.midcast.Regen = {main="Bolelabunga",sub="Genmei Shield",lear="Pratik Earring",body="Telchine Chas."}
    
	sets.midcast['Enhancing Magic'] = { main="Exemplar",
        head="Befouled Crown",neck="Incanter's Torque",lear="Andoaa Earring",
        body="Telchine Chas.",hands="Telchine Gloves",
		back="Perimede Cape",waist="Embla Sash",legs="Telchine Braconi",feet="Telchine Pigaches"}
	sets.midcast['Enhancing Magic']['Refresh'] = set_combine(sets.midcast['Enhancing Magic'],{
		back="Grapevine Cape",waist="Gishdubar Sash",feet="Inspirited Boots"})
	sets.midcast['Enhancing Magic']['Aquaveil'] = set_combine(sets.midcast['Enhancing Magic'],{
		main="Vadose Rod",head="Chironic Hat"})

    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {waist="Siegel Sash"})

	sets.midcast.Death = set_combine(sets.idle.Death,{})
	-- Elemental Magic sets
	sets.midcast['Elemental Magic'] = {main="Bunzi's Rod",sub="Ammurapi Shield",ammo="Pemphredo Tathlum",
        head="Merlinic Hood",neck="Sanctity Necklace",lear="Malignance Earring",rear="Wicce Earring +1",
        body="Merlinic Jubbah",hands="Jhakri Cuffs +2",ring1="Adoulin Ring",ring2="Metamor. Ring +1",
        back="Taranus's Cape",waist="Sacro Cord",legs="Merlinic Shalwar",feet="Merlinic Crackows"}

	sets.midcast['Elemental Magic'].Death = set_combine(sets.midcast.Death, {})
		
    sets.midcast['Elemental Magic'].INT = set_combine(sets.midcast['Elemental Magic'], 
	   {main="Marin Staff +1",sub="Enki Strap",ammo="Pemphredo Tathlum",
        head="Mall. Chapeau +2",neck="Sibyl Scarf",lear="Malignance Earring",rear="Psystorm Earring",
        body="Mallquis Saio +2",hands="Mallquis Cuffs +2",ring1="Freke Ring",ring2="Metamor. Ring +1",
        back="Taranus's Cape",waist="Channeler's Stone",legs="Mallquis Trews +2",feet="Mallquis Clogs +2"})

    sets.midcast['Elemental Magic'].MAB = set_combine(sets.midcast['Elemental Magic'], 
	   {main="Bunzi's Rod",sub="Ammurapi Shield",ammo="Pemphredo Tathlum",
        head="Merlinic Hood",neck="Baetyl Pendant",lear="Malignance Earring",rear="Friomisi Earring",
        body="Merlinic Jubbah",hands="Jhakri Cuffs +2",ring1="Adoulin Ring",ring2="Strendu Ring",
        back="Taranus's Cape",waist="Sacro Cord",legs="Merlinic Shalwar",feet="Merlinic Crackows"})
  
    sets.midcast['Elemental Magic'].MB = set_combine(sets.midcast['Elemental Magic'], 
	   {main="Bunzi's Rod",sub="Ammurapi Shield",
		head="Nyame Helm",neck="Mizu. Kubikazari",
        body="Nyame Mail",hands="Amalric Gages",ring1="Mujin Band",
        back="Taranus's Cape",legs="Nyame Flanchard",feet="Jhakri Pigaches +2"})
  
	sets.midcast['Elemental Magic'].Macc = set_combine(sets.midcast['Elemental Magic'], sets.macc)
	
	sets.midcast['Elemental Magic'].Mcrit = set_combine(sets.midcast['Elemental Magic'], 
	   {body="Count's Garb",hands="Wicce Gloves",waist="Maniacus Sash"})
   
    sets.midcast['Elemental Magic'].MDmg = set_combine(sets.midcast['Elemental Magic'], 
	   {main="Bunzi's Rod",sub="Culminus",ammo="Ghastly Tathlum +1",
        head="Mall. Chapeau +2",lear="Crematio Earring",rear="Wicce Earring +1",
        body="Mallquis Saio +2",hands="Mallquis Cuffs +2",ring1="Mallquis Ring",
        back="Taranus's Cape",waist="Sekhmet Corset",legs="Mallquis Trews +2",feet="Mallquis Clogs +2"})
 
    -- Minimal damage gear for procs.
    sets.midcast['Elemental Magic'].Proc = {main="Chatoyant Staff", sub="Mephitis Grip",
        neck="Elite Royal Collar"}

    sets.midcast['Enfeebling Magic'] = set_combine(sets.macc, {
        head="Befouled Crown",neck="Incanter's Torque",
        body="Shango Robe",hands="Ayao's Gages",ring1="Kishar Ring",ring2="Globidonta Ring",
        waist="Rumination Sash",legs="Psycloth Lappas",feet="Medium's Sabots"})
        
    sets.midcast.ElementalEnfeeble = set_combine(sets.midcast['Enfeebling Magic'], {})

    sets.midcast['Dark Magic'] = set_combine(sets.macc, {
        neck="Erra Pendant",lear="Abyssal Earring",
        body="Shango Robe",hands="Arch. Gloves",ring1="Evanescence Ring",ring2="Kishar Ring",
        back="Bane Cape",legs="Spae. Tonban +1",feet="Goetia Sabots"})

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'],{head="Merlinic Hood",neck="Erra Pendant",ring2="Excelsis Ring",waist="Fucho-no-obi",feet="Merlinic Crackows"})
    
    sets.midcast.Aspir = set_combine(sets.midcast.Drain, {feet="Arch. Sabots +1"})
	sets.midcast.Aspir.Death = {main="Lathi",sub="Niobid Strap",ammo="Ghastly Tathlum +1"}

    sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'],{})

    sets.midcast.BardSong = set_combine(sets.macc, {neck="Incanter's Torque",
        back="Kumbira Cape"})
	sets.midcast.Impact = set_combine(sets.macc, {head=empty,body="Twilight Cloak"})
	sets.midcast.Dispelga = set_combine(sets.macc, {main="Daybreak"})
    -- Defense sets
    sets.defense.PDT = set_combine(sets.Mode.DT, {})
	sets.defense.MDT = set_combine(sets.Mode.Meva, {})
	sets.debuffed = set_combine(sets.Mode.DT,sets.Mode.Meva)
	sets.doom = set_combine(sets.debuffed,{waist="Gishdubar Sash"})
		
    sets.Kiting = {ring1="Vengeful Ring"}

    sets.latent_refresh = {sub="Oneiros Grip",waist="Fucho-no-obi"}

    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    sets.buff['Mana Wall'] = {back="Taranus's Cape",feet="Goetia Sabots"}
	sets.buff.FullSublimation = {waist="Embla Sash"}
    sets.buff.PDTSublimation = set_combine(sets.buff.FullSublimation,{})

    -- sets.magic_burst = {hands="Amalric Gages",back="Taranus's Cape"}
	sets.RecoverMP = {body="Spae. Coat +1"}
	sets.Reive = {neck="Arciela's Grace +1"}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if spellMap == 'Cure' or spellMap == 'Curaga' then
        handle_spells(spell)
    elseif spell.skill == 'Elemental Magic' then
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

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)

end

function job_post_midcast(spell, action, spellMap, eventArgs)
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
    if spell.skill == 'Elemental Magic' and default_spell_map ~= 'ElementalEnfeeble' then
        if player.mpp <= 21 then 
			equip(sets.RecoverMP) 
		end
    end
    -- if spell.skill == 'Elemental Magic' and state.MagicBurst.value then
        -- equip(sets.magic_burst)
    -- end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    -- Lock feet after using Mana Wall.
    if not spell.interrupted then
        if spell.english == 'Mana Wall' then
            enable('feet')
            equip(sets.buff['Mana Wall'])
            disable('feet')
        -- elseif spell.skill == 'Elemental Magic' then
            -- state.MagicBurst:reset()
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    -- Unlock feet when Mana Wall buff is lost.
	handle_debuffs()
    if buff == "Mana Wall" and not gain then
        enable('feet')
        handle_equipping_gear(player.status)
    end
    if buff == "Sublimation: Activated" then
        handle_equipping_gear(player.status)
    end
end

function job_handle_equipping_gear(status, eventArgs)
	-- add_to_chat(122,'handle equiping gear')
	check_tp_lock()
	pick_tp_weapon()
end

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


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------
-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
	update_sublimation()
	pick_tp_weapon()
end

function update_sublimation()
    state.Buff['Sublimation: Activated'] = buffactive['Sublimation: Activated'] or false
end

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.skill == 'Elemental Magic' and default_spell_map ~= 'ElementalEnfeeble' then
        --[[ No real need to differentiate with current gear.
        if lowTierNukes:contains(spell.english) then
            return 'LowTierNuke'
        else
            return 'HighTierNuke'
        end
        --]]
    end
end

-- Modify the default idle set after it was constructed.
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
    if state.CastingMode.value == 'Death' then
		idleSet = set_combine(sets.idle.Death, {})
	end
    return idleSet
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
    set_macro_page(1, 11)
	send_command('exec blm.txt')
end

