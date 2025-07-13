include('organizer-lib.lua')
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
        Custom commands:

        Shorthand versions for each strategem type that uses the version appropriate for
        the current Arts.

                                        Light Arts              Dark Arts

        gs c scholar light              Light Arts/Addendum
        gs c scholar dark                                       Dark Arts/Addendum
        gs c scholar cost               Penury                  Parsimony
        gs c scholar speed              Celerity                Alacrity
        gs c scholar aoe                Accession               Manifestation
        gs c scholar power              Rapture                 Ebullience
        gs c scholar duration           Perpetuance
        gs c scholar accuracy           Altruism                Focalization
        gs c scholar enmity             Tranquility             Equanimity
        gs c scholar skillchain                                 Immanence
        gs c scholar addendum           Addendum: White         Addendum: Black
--]]



-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    info.addendumNukes = S{"Stone IV", "Water IV", "Aero IV", "Fire IV", "Blizzard IV", "Thunder IV",
        "Stone V", "Water V", "Aero V", "Fire V", "Blizzard V", "Thunder V"}

    state.Buff['Sublimation: Activated'] = buffactive['Sublimation: Activated'] or false
    update_active_strategems()
	state.WeaponMode = M{['description']='Weapon Mode', 'Staff', 'Club'}
  	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive'}
	state.ElementMode = M{['description']='elementmode', 'dark', 'earth', 'fire', 'ice', 'light', 'thunder', 'water', 'wind'}
	state.holdtp = M{['description']='holdtp', 'false', 'true'}
    gear.macc_staff = { name="Grioavolr", augments={'Magic burst dmg.+3%','INT+6','Mag. Acc.+24','"Mag.Atk.Bns."+22',}}
	pick_tp_weapon()
	include('Mote-TreasureHunter')
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'SB', 'sTP', 'STR')
    state.CastingMode:options('Normal', 'INT', 'MAB', 'MB', 'Macc', 'Mcrit', 'MDmg', 'Skill', 'Proc', 'TH')
	state.IdleMode:options('Normal', 'PDT' )
	state.WeaponMode:set('Staff')
	state.Stance:set('None')
	state.TreasureMode:set('Tag')
	state.holdtp:set('false')
	state.ElementMode:set('fire')

    info.low_nukes = S{"Stone", "Water", "Aero", "Fire", "Blizzard", "Thunder"}
    info.mid_nukes = S{"Stone II", "Water II", "Aero II", "Fire II", "Blizzard II", "Thunder II",
                       "Stone III", "Water III", "Aero III", "Fire III", "Blizzard III", "Thunder III",
                       "Stone IV", "Water IV", "Aero IV", "Fire IV", "Blizzard IV", "Thunder IV",}
    info.high_nukes = S{"Stone V", "Water V", "Aero V", "Fire V", "Blizzard V", "Thunder V"}

    send_command('bind ^` input /ma Stun <t>')
	pick_tp_weapon()
    select_default_macro_book()
end

function user_unload()
    send_command('unbind ^`')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
    gear.macc_staff = { name="Grioavolr", augments={'Magic burst dmg.+3%','INT+6','Mag. Acc.+24','"Mag.Atk.Bns."+22',}}

	-- extra stuff
	-- need helix set
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
		food2="Tropical Crepe",
		echos="Echo Drops",
		-- shihei="Shihei",
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

    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
    sets.idle = { main="Akademos",sub="Khonsu",ammo="Homiliary",
        head="Befouled Crown",neck="Elite Royal Collar",lear="Moonshade Earring",rear="Ethereal Earring",
        body="Arbatel Gown +3",hands="Telchine Gloves",ring1="Defending Ring",ring2="Renaye Ring +1",
        back="Lugh's Cape",waist="Plat. Mog. Belt",legs="Assid. Pants +1",feet="Herald's Gaiters"}
	sets.idle.Field = set_combine(sets.idle, {})
	
    sets.idle.Field.Stun = set_combine(sets.idle, {ammo="Incantor Stone",
        lear="Psystorm Earring",rear="Lifestorm Earring",
        feet="Acad. Loafers"})

    -- Resting sets
    sets.resting = set_combine(sets.idle, {})

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Club.Accuracy.Evasion
    sets.engaged = { ammo="Homiliary",
        head="Arbatel Bonnet +2",neck="Combatant's Torque",lear="Bladeborn Earring",rear="Steelflash Earring",
        body="Arbatel Gown +3",hands="Arbatel Bracers +2",ring1="Patricius Ring",ring2="Apate Ring",
        waist="Eschan Stone",legs="Arbatel Pants +3",feet="Arbatel Loafers +2"}

	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {ammo="Amar Cluster",
		head="Arbatel Bonnet +2",neck="Combatant's Torque",lear="Zennaroi Earring",rear="Digni. Earring",
		body="Arbatel Gown +3",hands="Arbatel Bracers +2",ring1="Mars's Ring",ring2="Cacoethic Ring +1",
		waist="Olseni Belt",legs="Arbatel Pants +3",feet="Arbatel Loafers +2"})
	sets.Mode.Att= set_combine(sets.engaged, {
		head="Jhakri Coronal +2",neck="Rep. Plat. Medal",lear="Bladeborn Earring",rear="Dudgeon Earring",
		body="Jhakri Robe +2",hands="Jhakri Cuffs +2",ring1="Overbearing Ring",ring2="Cho'j Band",
		waist="Eschan Stone",legs="Jhakri Slops +2",feet="Jhakri Pigaches +2"})
	sets.Mode.Crit = set_combine(sets.engaged, {ring2="Hetairoi Ring"})
	sets.Mode.DA = set_combine(sets.engaged, {lear="Trux Earring",rear="Brutal Earring",
        ring2="Hetairoi Ring",legs="Querkening Brais"})
	sets.Mode.SB = set_combine(sets.engaged, {neck="Combatant's Torque"})
	sets.Mode.sTP = set_combine(sets.engaged, {neck="Combatant's Torque",rear="Digni. Earring",waist="Olseni Belt",
        legs="Jhakri Slops +2",feet="Battlecast Gaiters"})
	sets.Mode.STR = set_combine(sets.engaged, { ammo="Amar Cluster",
		head="Jhakri Coronal +2",neck="Rep. Plat. Medal",
		body="Jhakri Robe +2",hands="Jhakri Cuffs +2",ring1="Rajas Ring",ring2="Apate Ring",
		back="Buquwik Cape",waist="Cornelia's Belt",legs="Jhakri Slops +2",feet="Jhakri Pigaches +2"})
			
	-- other Sets    
	sets.macc = {lear="Gwati Earring",ring1="Sangoma Ring"}
	sets.PDL = {}
	sets.empy = {head="Arbatel Bonnet +2",
		body="Arbatel Gown +3",hands="Arbatel Bracers +2",
		legs="Arbatel Pants +3",feet="Arbatel Loafers +2"}		

	-- Sets with weapons defined.
	sets.engaged.Club = {}
	sets.engaged.Staff = {}
	sets.engaged.Club = set_combine(sets.engaged, {main="Bolelabunga",sub="Genmei Shield"})
	sets.engaged.Club.Acc = set_combine(sets.engaged.Club, sets.Mode.Acc)
	sets.engaged.Club.Att = set_combine(sets.engaged.Club, sets.Mode.Att)
	sets.engaged.Club.Crit = set_combine(sets.engaged.Club, sets.Mode.Crit)
	sets.engaged.Club.DA = set_combine(sets.engaged.Club, sets.Mode.DA)
	sets.engaged.Club.SB = set_combine(sets.engaged.Club, sets.Mode.SB, {})
	sets.engaged.Club.sTP = set_combine(sets.engaged.Club, sets.Mode.sTP)
	sets.engaged.Club.STR = set_combine(sets.engaged.Club, sets.Mode.STR)

	sets.engaged.Staff = set_combine(sets.engaged, {main="Musa", sub="Khonsu"})
	sets.engaged.Staff.Acc = set_combine(sets.engaged.Staff, sets.Mode.Acc)
	sets.engaged.Staff.Att = set_combine(sets.engaged.Staff, sets.Mode.Att)
	sets.engaged.Staff.Crit = set_combine(sets.engaged.Staff, sets.Mode.Crit)
	sets.engaged.Staff.DA = set_combine(sets.engaged.Staff, sets.Mode.DA)
	sets.engaged.Staff.SB = set_combine(sets.engaged.Staff, sets.Mode.SB, {})
	sets.engaged.Staff.sTP = set_combine(sets.engaged.Staff, sets.Mode.sTP)
	sets.engaged.Staff.STR = set_combine(sets.engaged.Staff, sets.Mode.STR)

    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
	sets.precast.WS = set_combine(sets.Mode.STR, {ammo="Oshasha's Treatise",
        neck="Fotia Gorget", rear="Ishvara Earring",
        hands="Jhakri Cuffs +2",ring1="Cornelia's Ring",ring2="Epaminondas's Ring",
        waist="Fotia Belt"})    
    
	-- Dark/Earth/Light, MND 80%
    sets.precast.WS['Omniscience'] = set_combine(sets.precast.WS, {})
 
	-- none, INT 50% MND 50%
	sets.precast.WS['Spirit Taker'] = set_combine(sets.precast.WS, {})

    -- Precast Sets
    sets.precast.JA['Tabula Rasa'] = {legs="Peda. Pants +1"}

    -- Fast cast sets for spells
    sets.precast.FC = {main="Musa",sub="Khonsu",ammo="Incantor Stone",
        head="Vanya Hood",neck="Orunmila's Torque",lear="Etiolation Earring",
        body="Shango Robe",ring1="Kishar Ring",ring2="Prolix Ring",
        back="Perimede Cape",waist="Embla Sash",legs="Psycloth Lappas",feet="Acad. Loafers"}

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})

    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {head="Mall. Chapeau +2",lear="Barkaro. Earring",hands="Mallquis Cuffs +1",feet="Mallquis Clogs +2"})

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {body="Heka's Kalasiris",back="Pahtli Cape"})

    sets.precast.FC.Curaga = set_combine(sets.precast.FC.Cure, {})

    sets.precast.FC.Impact = set_combine(sets.precast.FC['Elemental Magic'], {head=empty,body="Twilight Cloak"})

    -- Midcast Sets
    -- sets.midcast.FastRecast = {feet="Tutyr Sabots"}

	-- healing skill
    sets.midcast.StatusRemoval = {
		neck="Incanter's Torque",
		body="Pedagogy Gown",hands="Ayao's Gages",ring1="Ephedra Ring",legs="Acad. Pants +1",feet="Peda. Loafers"}

    sets.midcast.Cursna = set_combine(sets.midcast.StatusRemoval, {
        ring1="Ephedra Ring",
        feet="Gende. Galoshes"})
	
	-- Cure %+ > healing skill > MND
    sets.midcast.Cure = set_combine(sets.midcast.StatusRemoval, {main="Musa",sub="Khonsu",ammo="Incantor Stone",
        head="Vanya Hood",neck="Phalaina Locket",lear="Lifestorm Earring",
        body="Heka's Kalasiris",hands="Telchine Gloves",ring1="Naji's Loop",ring2="Lebeche Ring",
        back="Solemnity Cape",legs="Gyve Trousers",feet="Medium's Sabots"})

    sets.midcast.CureWithLightWeather = set_combine(sets.midcast.Cure, {ammo="Incantor Stone",
        lear="Lifestorm Earring",
        body="Heka's Kalasiris",
        back="Twilight Cape",waist="Hachirin-no-Obi"})

    sets.midcast.Curaga = set_combine(sets.midcast.Cure, {})

    sets.midcast.Regen = {main="Musa",sub="Khonsu",
		head="Arbatel Bonnet +2",lear="Pratik Earring",
		body="Telchine Chas.",hands="Arbatel Bracers +2",
		back="Lugh's Cape",waist="Embla Sash",legs="Telchine Braconi",feet="Telchine Pigaches"}

    sets.midcast['Enhancing Magic'] = {main="Musa",sub="Khonsu",ammo="Savant's Treatise",
        head="Arbatel Bonnet +2",neck="Incanter's Torque",lear="Andoaa Earring",
        body="Pedagogy Gown",hands="Telchine Gloves",
        back="Perimede Cape",waist="Embla Sash",legs="Telchine Braconi",feet="Telchine Pigaches"}
	sets.midcast['Enhancing Magic']['Refresh'] = set_combine(sets.midcast['Enhancing Magic'],{
		back="Grapevine Cape",waist="Gishdubar Sash"})
	sets.midcast['Enhancing Magic']['Aquaveil'] = set_combine(sets.midcast['Enhancing Magic'],{
		head="Chironic Hat"})

    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {waist="Siegel Sash"})

    sets.midcast.Storm = set_combine(sets.midcast['Enhancing Magic'], {feet="Peda. Loafers"})

    sets.midcast.Protect = {}
    sets.midcast.Protectra = set_combine(sets.midcast.Protect, {})

    sets.midcast.Shell = {}
    sets.midcast.Shellra = set_combine(sets.midcast.Shell, {})

    -- Elemental Magic sets are default for handling low-tier nukes.
    sets.midcast['Elemental Magic'] = {main="Marin Staff +1",sub="Niobid Strap",ammo="Pemphredo Tathlum",
        head="Arbatel Bonnet +2",neck="Sanctity Necklace",lear="Barkaro. Earring",rear="Arbatel Earring +1",
        body="Arbatel Gown +3",hands="Arbatel Bracers +2",ring1="Strendu Ring",ring2="Metamor. Ring +1",
        back="Lugh's Cape",waist="Eschan Stone",legs="Arbatel Pants +3",feet="Merlinic Crackows"}

    sets.midcast['Elemental Magic'].INT = set_combine(sets.midcast['Elemental Magic'], {main="Marin Staff +1",sub="Enki Strap",ammo="Pemphredo Tathlum",
        head="Acad. Mortar. +3",neck="Sibyl Scarf",lear="Barkaro. Earring",rear="Psystorm Earring",
        body="Arbatel Gown +3",hands="Mallquis Cuffs +1",ring1="Mallquis Ring",ring2="Metamor. Ring +1",
        back="Lugh's Cape",waist="Channeler's Stone",legs="Arbatel Pants +3",feet="Mallquis Clogs +2"})
    
	sets.midcast['Elemental Magic'].MAB = set_combine(sets.midcast['Elemental Magic'], {main="Marin Staff +1",sub="Elan Strap +1",ammo="Pemphredo Tathlum",
        head="Arbatel Bonnet +2",neck="Baetyl Pendant",lear="Barkaro. Earring",rear="Friomisi Earring",
        body="Arbatel Gown +3",hands="Arbatel Bracers +2",ring1="Strendu Ring",
        back="Lugh's Cape",waist="Eschan Stone",legs="Arbatel Pants +3",feet="Merlinic Crackows"})
 
    sets.midcast['Elemental Magic'].MB = set_combine(sets.midcast['Elemental Magic'], {main=gear.macc_staff,
		head="Peda. M.Board +1",neck="Mizu. Kubikazari",
        body="Acad. Gown +2",hands="Arbatel Bracers +2",
        back="Lugh's Cape",legs="Mallquis Trews +1",feet="Arbatel Loafers +2"})
  
	sets.midcast['Elemental Magic'].Macc = set_combine(sets.midcast['Elemental Magic'], {main="Musa",sub="Khonsu",ammo="Pemphredo Tathlum",
        head="Acad. Mortar. +3",neck="Erra Pendant",lear="Barkaro. Earring",rear="Arbatel Earring +1",
        body="Arbatel Gown +3",hands="Arbatel Bracers +2",ring1="Sangoma Ring",ring2="Metamor. Ring +1",
        back="Lugh's Cape",waist="Luminary Sash",legs="Arbatel Pants +3",feet="Arbatel Loafers +2"})
    
	sets.midcast['Elemental Magic'].Mcrit = set_combine(sets.midcast['Elemental Magic'], 
	   {body="Count's Garb",waist="Maniacus Sash"})

	sets.midcast['Elemental Magic'].MDmg = set_combine(sets.midcast['Elemental Magic'], {main="Musa",sub="Thrace Strap",ammo="Ghastly Tathlum +1",
        head="Mall. Chapeau +2",lear="Crematio Earring",rear="Arbatel Earring +1",
        body="Mallquis Saio +1",hands="Mallquis Cuffs +1",ring1="Mallquis Ring",
        back="Lugh's Cape",legs="Mallquis Trews +1",feet="Mallquis Clogs +2"})
    
	sets.midcast['Elemental Magic'].SB = set_combine(sets.midcast['Elemental Magic'], {main="Exemplar",sub="Khonsu",ammo="Savant's Treatise",
        neck="Incanter's Torque",lear="Strophadic Earring",
        hands="Amalric Gages",
        back="Bookworm's Cape",legs="Peda. Pants +1",feet="Arbatel Loafers +2"})

    -- Custom refinements for certain nuke tiers
    -- sets.midcast['Elemental Magic'].HighTierNuke = set_combine(sets.midcast['Elemental Magic'], {})

    sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'].Macc, {ammo="Pemphredo Tathlum",
        head=empty,neck="Eddy Necklace",
        body="Twilight Cloak",hands="Amalric Gages",
        back="Toro Cape",waist="Luminary Sash",legs="Merlinic Shalwar",feet="Merlinic Crackows"})

    -- sets.midcast.Helix = set_combine(sets.midcast['Elemental Magic'].MDmg, {back="Bookworm's Cape"})
    sets.midcast.Helix = set_combine(sets.midcast['Elemental Magic'], {back="Bookworm's Cape"})

	-- Custom spell classes 
    sets.midcast.MndEnfeebles = set_combine(sets.midcast['Elemental Magic'].Macc, {main="Marin Staff +1",sub="Mephitis Grip", ammo="Savant's Treatise",
        head="Befouled Crown",neck="Incanter's Torque",
        body="Acad. Gown +2",hands="Ayao's Gages",ring1="Kishar Ring",ring2="Globidonta Ring",
        legs="Arbatel Pants +3",feet="Uk'uxkaj Boots"})

    sets.midcast.IntEnfeebles = set_combine(sets.midcast.MndEnfeebles, {})

    sets.midcast.ElementalEnfeeble = set_combine(sets.midcast.IntEnfeebles, {})

    sets.midcast['Dark Magic'] = set_combine(sets.midcast['Elemental Magic'].Macc, {
        body="Acad. Gown +2",neck="Erra Pendant",ring1="Evanescence Ring",ring2="Kishar Ring",
        back="Bookworm's Cape",legs="Peda. Pants +1"})

    sets.midcast.Kaustra = set_combine(sets.midcast['Dark Magic'], {ammo="Pemphredo Tathlum",
        head="Pixie Hairpin +1",hands="Amalric Gages",
        back="Lugh's Cape",waist="Hachirin-no-Obi"})

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'],{head="Merlinic Hood",neck="Erra Pendant",ring2="Excelsis Ring",waist="Fucho-no-obi",feet="Merlinic Crackows"})

    sets.midcast.Aspir = set_combine(sets.midcast.Drain, {})

    sets.midcast.Stun = {ammo="Incantor Stone",
        neck="Sanctity Necklace",lear="Psystorm Earring",rear="Lifestorm Earring",
        back="Kumbira Cape",legs="Peda. Pants +1",feet="Acad. Loafers"}

    sets.midcast.Stun.Resistant = set_combine(sets.midcast.Stun, {})

    sets.midcast['Divine Magic'] = set_combine(sets.midcast['Elemental Magic'].Macc, { neck="Jokushu Chain",
        feet="Chironic Slippers"})
	
    -- Defense sets
    sets.defense.PDT = {
        head="Arbatel Bonnet +2",neck="Elite Royal Collar",
        body="Arbatel Gown +3",hands="Hagondes Cuffs +1",ring1="Defending Ring",ring2="Patricius Ring",
        back="Lugh's Cape",waist="Plat. Mog. Belt",legs="Arbatel Pants +3",feet="Battlecast Gaiters"}

    sets.defense.MDT = {
        head="Arbatel Bonnet +2",neck="Elite Royal Collar",lear="Etiolation Earring",rear="Eabani Earring",
        body="Arbatel Gown +3",hands="Chironic Gloves",ring1="Defending Ring",ring2="Vengeful Ring",
        back="Lugh's Cape",waist="Plat. Mog. Belt",legs="Arbatel Pants +3",feet="Merlinic Crackows"}
	
	sets.debuffed = set_combine(sets.defense.Evasion,sets.defense.PDT,sets.defense.MDT)
	sets.doom = set_combine(sets.debuffed,{waist="Gishdubar Sash"})
	
    sets.Kiting = {}

    sets.latent_refresh = {sub="Oneiros Grip",waist="Fucho-no-obi"}

    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    sets.buff['Altruism'] = {head="Peda. M.Board +1"}
    sets.buff['Focalization'] = {head="Peda. M.Board +1"}
    sets.buff['Ebullience'] = {head="Arbatel Bonnet +2"}
    sets.buff['Rapture'] = {head="Arbatel Bonnet +2"}
    sets.buff['Perpetuance'] = {hands="Arbatel Bracers +2"}
	-- sc or sb could be helpful here too
    sets.buff['Immanence'] = {hands="Arbatel Bracers +2",back="Lugh's Cape"}
    sets.buff['Penury'] = {legs="Arbatel Pants +3"}
    sets.buff['Parsimony'] = {legs="Arbatel Pants +3"}
    sets.buff['Celerity'] = {feet="Peda. Loafers"}
    sets.buff['Alacrity'] = {feet="Peda. Loafers"}
    sets.buff['Klimaform'] = {feet="Arbatel Loafers +2"}

    sets.buff.FullSublimation = {head="Acad. Mortar. +3",body="Pedagogy Gown",waist="Embla Sash"}
    sets.buff.PDTSublimation = set_combine(sets.buff.FullSublimation,{})
	sets.TreasureHunter = {ammo="Per. Lucky Egg", waist="Chaac Belt"}
    --sets.buff['Sandstorm'] = {feet="Desert Boots"}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------
function filtered_action(spell) 
    if find_degrade_table(spell) then
        degrade_spell(spell,find_degrade_table(spell))
    end
end

function job_pretarget(spell, action, spellMap, eventArgs)
	-- add_to_chat(1, 'pretarget Casting '..spell.name)
	if midaction() or pet_midaction() then
        cancel_spell()
        return
	end
end

function job_precast(spell, action, spellMap, eventArgs)
	if midaction() or pet_midaction() then
        cancel_spell()
        return
	end
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

-- Run after the general midcast() is done.
function job_post_midcast(spell, action, spellMap, eventArgs)
	if spell.skill == 'Elemental Magic' then
		if spell.skill == 'Elemental Magic' then
			-- add_to_chat(122,' elemental magic ')
			if spell.name:match('helix') then
				-- add_to_chat(122,' casting helix, post midcast ')
				equip(sets.midcast.Helix)
			end
			if is_magic_element_today(spell) then
				-- add_to_chat(122,' Element Day ')
				equip(sets.Day[spell.element])
			end
			if is_magic_element_weather(spell) then
				-- add_to_chat(122,' Element Weather ')
				equip(sets.Weather[spell.element])
			end
		end 
		if spell.action_type == 'Magic' then
			apply_grimoire_bonuses(spell, action, spellMap, eventArgs)
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
	handle_debuffs()
    if buff == "Sublimation: Activated" then
        handle_equipping_gear(player.status)
    end
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

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if default_spell_map == 'Cure' or default_spell_map == 'Curaga' then
            if world.weather_element == 'Light' then
                return 'CureWithLightWeather'
            end
        elseif spell.skill == 'Enfeebling Magic' then
            if spell.type == 'WhiteMagic' then
                return 'MndEnfeebles'
            else
                return 'IntEnfeebles'
            end
        elseif spell.skill == 'Elemental Magic' then
            if info.low_nukes:contains(spell.english) then
                return 'LowTierNuke'
            elseif info.mid_nukes:contains(spell.english) then
                return 'MidTierNuke'
            elseif info.high_nukes:contains(spell.english) then
                return 'HighTierNuke'
            end
        end
    end
end

function customize_idle_set(idleSet)
	-- add_to_chat(122,'idleset'..state.IdleMode.value)
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
    if cmdParams[1] == 'user' and not (buffactive['light arts']      or buffactive['dark arts'] or
                       buffactive['addendum: white'] or buffactive['addendum: black']) then
        if state.IdleMode.value == 'Stun' then
            send_command('@input /ja "Dark Arts" <me>')
        else
            send_command('@input /ja "Light Arts" <me>')
        end
    end

    update_active_strategems()
    update_sublimation()
	classes.CustomMeleeGroups:clear()
	if areas.Adoulin:contains(world.area) and buffactive.ionis then
			classes.CustomMeleeGroups:append('Adoulin')
	end
	pick_tp_weapon()
end

function job_handle_equipping_gear(status, eventArgs)
	-- add_to_chat(122,'handle equiping gear')
	check_tp_lock()
	pick_tp_weapon()
end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for direct player commands.
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'scholar' then
        handle_strategems(cmdParams)
        eventArgs.handled = true
    end
    if cmdParams[1]:lower() == 'useelement' then
        handle_useElement(cmdParams)
        eventArgs.handled = true
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Reset the state vars tracking strategems.
function update_active_strategems()
    state.Buff['Ebullience'] = buffactive['Ebullience'] or false
    state.Buff['Rapture'] = buffactive['Rapture'] or false
    state.Buff['Perpetuance'] = buffactive['Perpetuance'] or false
    state.Buff['Immanence'] = buffactive['Immanence'] or false
    state.Buff['Penury'] = buffactive['Penury'] or false
    state.Buff['Parsimony'] = buffactive['Parsimony'] or false
    state.Buff['Celerity'] = buffactive['Celerity'] or false
    state.Buff['Alacrity'] = buffactive['Alacrity'] or false
    state.Buff['Altruism'] = buffactive['Altruism'] or false
    state.Buff['Focalization'] = buffactive['Focalization'] or false
    state.Buff['Klimaform'] = buffactive['Klimaform'] or false
end

-- Equip sets appropriate to the active buffs, relative to the spell being cast.
function apply_grimoire_bonuses(spell, action, spellMap)
    if state.Buff.Perpetuance and spell.type =='WhiteMagic' and spell.skill == 'Enhancing Magic' then
        equip(sets.buff['Perpetuance'])
    end
    if state.Buff.Rapture and (spellMap == 'Cure' or spellMap == 'Curaga') then
        equip(sets.buff['Rapture'])
    end
    if spell.skill == 'Elemental Magic' and spellMap ~= 'ElementalEnfeeble' then
        if state.Buff.Focalization and spell.english ~= 'Impact' then
            equip(sets.buff['Focalization'])
        end
        if state.Buff.Ebullience and spell.english ~= 'Impact' then
            equip(sets.buff['Ebullience'])
        end
        if state.Buff.Immanence then
            equip(sets.buff['Immanence'])
        end
        if state.Buff.Klimaform and spell.element == world.weather_element then
            equip(sets.buff['Klimaform'])
        end
    end

    if state.Buff.Penury then equip(sets.buff['Penury']) end
    if state.Buff.Parsimony then equip(sets.buff['Parsimony']) end
    if state.Buff.Celerity then equip(sets.buff['Celerity']) end
    if state.Buff.Alacrity then equip(sets.buff['Alacrity']) end
    if state.Buff.Altruism then equip(sets.buff['Altruism']) end
end

-- General handling of strategems in an Arts-agnostic way.
-- Format: gs c scholar <strategem>
function handle_strategems(cmdParams)
    -- cmdParams[1] == 'scholar'
    -- cmdParams[2] == strategem to use

    if not cmdParams[2] then
        add_to_chat(123,'Error: No strategem command given.')
        return
    end
    local strategem = cmdParams[2]:lower()

    if strategem == 'light' then
        if buffactive['light arts'] then
            send_command('input /ja "Addendum: White" <me>')
        elseif buffactive['addendum: white'] then
            add_to_chat(122,'Error: Addendum: White is already active.')
        else
            send_command('input /ja "Light Arts" <me>')
        end
    elseif strategem == 'dark' then
        if buffactive['dark arts'] then
            send_command('input /ja "Addendum: Black" <me>')
        elseif buffactive['addendum: black'] then
            add_to_chat(122,'Error: Addendum: Black is already active.')
        else
            send_command('input /ja "Dark Arts" <me>')
        end
    elseif buffactive['light arts'] or buffactive['addendum: white'] then
        if strategem == 'cost' then
            send_command('input /ja Penury <me>')
        elseif strategem == 'speed' then
            send_command('input /ja Celerity <me>')
        elseif strategem == 'aoe' then
            send_command('input /ja Accession <me>')
        elseif strategem == 'power' then
            send_command('input /ja Rapture <me>')
        elseif strategem == 'duration' then
            send_command('input /ja Perpetuance <me>')
        elseif strategem == 'accuracy' then
            send_command('input /ja Altruism <me>')
        elseif strategem == 'enmity' then
            send_command('input /ja Tranquility <me>')
        elseif strategem == 'skillchain' then
            add_to_chat(122,'Error: Light Arts does not have a skillchain strategem.')
        elseif strategem == 'addendum' then
            send_command('input /ja "Addendum: White" <me>')
        else
            add_to_chat(123,'Error: Unknown strategem ['..strategem..']')
        end
    elseif buffactive['dark arts']  or buffactive['addendum: black'] then
        if strategem == 'cost' then
            send_command('input /ja Parsimony <me>')
        elseif strategem == 'speed' then
            send_command('input /ja Alacrity <me>')
        elseif strategem == 'aoe' then
            send_command('input /ja Manifestation <me>')
        elseif strategem == 'power' then
            send_command('input /ja Ebullience <me>')
        elseif strategem == 'duration' then
            add_to_chat(122,'Error: Dark Arts does not have a duration strategem.')
        elseif strategem == 'accuracy' then
            send_command('input /ja Focalization <me>')
        elseif strategem == 'enmity' then
            send_command('input /ja Equanimity <me>')
        elseif strategem == 'skillchain' then
            send_command('input /ja Immanence <me>')
        elseif strategem == 'addendum' then
            send_command('input /ja "Addendum: Black" <me>')
        else
            add_to_chat(123,'Error: Unknown strategem ['..strategem..']')
        end
    else
        add_to_chat(123,'No arts has been activated yet.')
    end
end


-- Gets the current number of available strategems based on the recast remaining
-- and the level of the sch.
function get_current_strategem_count()
    -- returns recast in seconds.
    local allRecasts = windower.ffxi.get_ability_recasts()
    local stratsRecast = allRecasts[231]

    local maxStrategems = (player.main_job_level + 10) / 20

    local fullRechargeTime = 4*60

    local currentCharges = math.floor(maxStrategems - maxStrategems * stratsRecast / fullRechargeTime)

    return currentCharges
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'DNC' then
		set_macro_page(1, 6)
	elseif player.sub_job == 'WAR' then
		set_macro_page(1, 6)
	elseif player.sub_job == 'NIN' then
		set_macro_page(1, 6)
	else
		set_macro_page(1, 6)
	end
	send_command('exec sch.txt')
end
