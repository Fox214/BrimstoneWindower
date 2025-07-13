include('organizer-lib.lua')
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Also, you'll need the Shortcuts addon to handle the auto-targetting of the custom pact commands.

--[[
    Custom commands:
    
    gs c petweather
        Automatically casts the storm appropriate for the current avatar, if possible.
    
    gs c siphon
        Automatically run the process to: dismiss the current avatar; cast appropriate
        weather; summon the appropriate spirit; Elemental Siphon; release the spirit;
        and re-summon the avatar.
        
        Will not cast weather you do not have access to.
        Will not re-summon the avatar if one was not out in the first place.
        Will not release the spirit if it was out before the command was issued.
        
    gs c pact [PactType]
        Attempts to use the indicated pact type for the current avatar.
        PactType can be one of:
            cure
            curaga
            buffOffense
            buffDefense
            buffSpecial
            debuff1
            debuff2
            sleep
            nuke2
            nuke4
            bp70
            bp75 (merits and lvl 75-80 pacts)
            astralflow

--]]

-- For astral conduit:
-- //gs equip sets.midcast.Pet.PhysicalBloodPactRage
-- //gs disable all

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff["Avatar's Favor"] = buffactive["Avatar's Favor"] or false
    state.Buff["Astral Conduit"] = buffactive["Astral Conduit"] or false
	state.holdtp = M{['description']='holdtp', 'false', 'true'}
    spirits = S{"LightSpirit", "DarkSpirit", "FireSpirit", "EarthSpirit", "WaterSpirit", "AirSpirit", "IceSpirit", "ThunderSpirit"}
    avatars = S{"Carbuncle", "Fenrir", "Diabolos", "Ifrit", "Titan", "Leviathan", "Garuda", "Shiva", "Ramuh", "Odin", "Alexander", "Cait Sith"}

    magicalRagePacts = S{
        'Inferno','Earthen Fury','Tidal Wave','Aerial Blast','Diamond Dust','Judgment Bolt','Searing Light','Howling Moon','Ruinous Omen',
        'Fire II','Stone II','Water II','Aero II','Blizzard II','Thunder II',
        'Fire IV','Stone IV','Water IV','Aero IV','Blizzard IV','Thunder IV',
        'Thunderspark','Burning Strike','Meteorite','Nether Blast','Flaming Crush',
        'Meteor Strike','Heavenly Strike','Wind Blade','Geocrush','Grand Fall','Thunderstorm',
        'Holy Mist','Lunar Bay','Night Terror','Level ? Holy'}

    pacts = {}
    pacts.cure = {['Carbuncle']='Healing Ruby'}
    pacts.curaga = {['Carbuncle']='Healing Ruby II', ['Garuda']='Whispering Wind', ['Leviathan']='Spring Water'}
    pacts.buffoffense = {['Carbuncle']='Glittering Ruby', ['Ifrit']='Crimson Howl', ['Garuda']='Hastega', ['Ramuh']='Rolling Thunder',
        ['Fenrir']='Ecliptic Growl'}
    pacts.buffdefense = {['Carbuncle']='Shining Ruby', ['Shiva']='Frost Armor', ['Garuda']='Aerial Armor', ['Titan']='Earthen Ward',
        ['Ramuh']='Lightning Armor', ['Fenrir']='Ecliptic Howl', ['Diabolos']='Noctoshield', ['Cait Sith']='Reraise II'}
    pacts.buffspecial = {['Ifrit']='Inferno Howl', ['Garuda']='Fleet Wind', ['Titan']='Earthen Armor', ['Diabolos']='Dream Shroud',
        ['Carbuncle']='Soothing Ruby', ['Fenrir']='Heavenward Howl', ['Cait Sith']='Raise II'}
    pacts.debuff1 = {['Shiva']='Diamond Storm', ['Ramuh']='Shock Squall', ['Leviathan']='Tidal Roar', ['Fenrir']='Lunar Cry',
        ['Diabolos']='Pavor Nocturnus', ['Cait Sith']='Eerie Eye'}
    pacts.debuff2 = {['Shiva']='Sleepga', ['Leviathan']='Slowga', ['Fenrir']='Lunar Roar', ['Diabolos']='Somnolence'}
    pacts.sleep = {['Shiva']='Sleepga', ['Diabolos']='Nightmare', ['Cait Sith']='Mewing Lullaby'}
    pacts.nuke2 = {['Ifrit']='Fire II', ['Shiva']='Blizzard II', ['Garuda']='Aero II', ['Titan']='Stone II',
        ['Ramuh']='Thunder II', ['Leviathan']='Water II'}
    pacts.nuke4 = {['Ifrit']='Fire IV', ['Shiva']='Blizzard IV', ['Garuda']='Aero IV', ['Titan']='Stone IV',
        ['Ramuh']='Thunder IV', ['Leviathan']='Water IV'}
    pacts.bp70 = {['Ifrit']='Flaming Crush', ['Shiva']='Rush', ['Garuda']='Predator Claws', ['Titan']='Mountain Buster',
        ['Ramuh']='Chaotic Strike', ['Leviathan']='Spinning Dive', ['Carbuncle']='Meteorite', ['Fenrir']='Eclipse Bite',
        ['Diabolos']='Nether Blast',['Cait Sith']='Regal Scratch'}
    pacts.bp75 = {['Ifrit']='Meteor Strike', ['Shiva']='Heavenly Strike', ['Garuda']='Wind Blade', ['Titan']='Geocrush',
        ['Ramuh']='Thunderstorm', ['Leviathan']='Grand Fall', ['Carbuncle']='Holy Mist', ['Fenrir']='Lunar Bay',
        ['Diabolos']='Night Terror', ['Cait Sith']='Level ? Holy'}
    pacts.astralflow = {['Ifrit']='Inferno', ['Shiva']='Diamond Dust', ['Garuda']='Aerial Blast', ['Titan']='Earthen Fury',
        ['Ramuh']='Judgment Bolt', ['Leviathan']='Tidal Wave', ['Carbuncle']='Searing Light', ['Fenrir']='Howling Moon',
        ['Diabolos']='Ruinous Omen', ['Cait Sith']="Altana's Favor"}

    -- Wards table for creating custom timers   
    wards = {}
    -- Base duration for ward pacts.
    wards.durations = {
        ['Crimson Howl'] = 60, ['Earthen Armor'] = 60, ['Inferno Howl'] = 60, ['Heavenward Howl'] = 60,
        ['Rolling Thunder'] = 120, ['Fleet Wind'] = 120,
        ['Shining Ruby'] = 180, ['Frost Armor'] = 180, ['Lightning Armor'] = 180, ['Ecliptic Growl'] = 180,
        ['Glittering Ruby'] = 180, ['Hastega'] = 180, ['Noctoshield'] = 180, ['Ecliptic Howl'] = 180,
        ['Dream Shroud'] = 180,
        ['Reraise II'] = 3600
    }
    -- Icons to use when creating the custom timer.
    wards.icons = {
        ['Earthen Armor']   = 'spells/00299.png', -- 00299 for Titan
        ['Shining Ruby']    = 'spells/00043.png', -- 00043 for Protect
        ['Dream Shroud']    = 'spells/00304.png', -- 00304 for Diabolos
        ['Noctoshield']     = 'spells/00106.png', -- 00106 for Phalanx
        ['Inferno Howl']    = 'spells/00298.png', -- 00298 for Ifrit
        ['Hastega']         = 'spells/00358.png', -- 00358 for Hastega
        ['Rolling Thunder'] = 'spells/00104.png', -- 00358 for Enthunder
        ['Frost Armor']     = 'spells/00250.png', -- 00250 for Ice Spikes
        ['Lightning Armor'] = 'spells/00251.png', -- 00251 for Shock Spikes
        ['Reraise II']      = 'spells/00135.png', -- 00135 for Reraise
        ['Fleet Wind']      = 'abilities/00074.png', -- 
    }
    -- Flags for code to get around the issue of slow skill updates.
    wards.flag = false
    wards.spell = ''
    
	state.WeaponMode = M{['description']='Weapon Mode', 'Staff', 'Club'}
  	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive'}
 
	pick_tp_weapon()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'SB', 'sTP', 'STR')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT')
	state.WeaponMode:set('Staff')
	state.Stance:set('None')
	state.holdtp:set('false')
	send_command('bind ^` gs c cycle WeaponMode')
	
    select_default_macro_book()
end

-- Define sets and vars used by this job file.
function init_gear_sets()
	gear.pet_staff = { name="Grioavolr", augments={'Blood Pact Dmg.+9','Pet: VIT+11','Pet: Mag. Acc.+17','Pet: "Mag.Atk.Bns."+21',}}
    --------------------------------------
    -- Idle/resting/defense/etc sets
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
        food1="Akamochi",
		food2="Grape Daifuku",
		echos="Echo Drops",
		-- shihei="Shihei",
		orb="Macrocosmic Orb"
	}    
    -- Idle sets
    sets.idle = {ammo="Sancus Sachet +1",
        head="Convoker's Horn +3",neck="Elite Royal Collar",lear="Moonshade Earring",rear="Beck. Earring",
        body="Apogee Dalmatica",hands="Telchine Gloves",ring1="Defending Ring",ring2="Renaye Ring +1",
        back="Solemnity Cape",waist="Fucho-no-Obi",legs="Assid. Pants +1",feet="Herald's Gaiters"}

    sets.idle.PDT = set_combine(sets.idle, {})

	-- perp costs:
    -- spirits: 7
    -- carby: 11 (5 with mitts)
    -- fenrir: 13
    -- others: 15
    -- avatar's favor: -4/tick
    
    -- Max useful -perp gear is 1 less than the perp cost (can't be reduced below 1)
    -- Aim for -14 perp, and refresh in other slots.
    
    -- -perp gear:
    -- staff Uffrat +1: -5
    -- Glyphic Horn +1: -4
    -- Caller's Doublet +2/Glyphic Doublet: -4
    -- Evoker's Ring: -1
    -- Convoker's Pigaches: -4
    -- total: -18
    
    -- Can make due without either the head or the body, and use +refresh items in those slots.

    sets.perp = {}
	sets.perp.base = {main="Nirvana",sub="Oneiros Grip",
		head="Glyphic Horn +1",lear="Evans Earring",rear="Beck. Earring",
		body="Glyphic Doublet",ring1="Evoker's Ring",
		back="Campestres's Cape",legs="Assid. Pants +1",feet="Apogee Pumps +1"}
    -- Caller's Bracer's halve the perp cost after other costs are accounted for.
    -- Using -10 (Gridavor, ring, Conv.feet), standard avatars would then cost 5, halved to 2.
    -- We can then use Hagondes Coat and end up with the same net MP cost, but significantly better defense.
    -- Weather is the same, but we can also use the latent on the pendant to negate the last point lost.
    sets.perp.Day = set_combine(sets.perp.base, {
			body="Beckoner's Doublet",hands="Beckoner's Bracers"
		})
    sets.perp.Weather = set_combine(sets.perp.base, {
			neck="Caller's Pendant",body="Beckoner's Doublet",hands="Beckoner's Bracers"
		})
    -- Carby: Mitts+Conv.feet = 1/tick perp.  Everything else should be +refresh
    sets.perp.Carbuncle = set_combine(sets.perp.base, {main="Bolelabunga",sub="Genmei Shield",
        hands="Asteria Mitts",feet="Con. Pigaches +1"})
    -- Diabolos's Rope doesn't gain us anything at this time
    -- sets.perp.Diabolos = {waist="Diabolos's Rope"}
    sets.perp.Diabolos = set_combine(sets.perp.base, {})
    sets.perp.Alexander = set_combine(sets.midcast.Pet.BloodPactWard, {})

    sets.idle.Avatar = set_combine(sets.idle, sets.perp.base)

	-- smn skill
	sets.skill = {}
    -- examplar 15, vox grip 3
	sets.skill.smn = {main="Exemplar",sub="Vox Grip",
        head="Convoker's Horn +3",neck="Incanter's Torque",lear="Andoaa Earring",rear="Beck. Earring",
        body="Beckoner's Doublet",hands="Glyphic Bracers +1",ring1="Evoker's Ring",ring2="Globidonta Ring",
        back="Conveyance Cape",waist="Summoning Belt",legs="Beck. Spats +1",feet="Rubeus Boots"}
 
	-- Favor uses Caller's Horn instead of Convoker's Horn +3 for refresh
    sets.idle.Avatar.Favor = set_combine(sets.skill.smn, sets.perp.base, {head="Beckoner's Horn +1"})
    sets.idle.Avatar.Melee = {head="Apogee Crown",neck="Shulmanu Collar",lear="Enmerkar Earring",rear="Beck. Earring",
		hands="Regimen Mittens",ring2="Tali'ah Ring",
		back="Campestres's Cape",waist="Incarnation Sash",legs="Tali'ah Sera. +2",feet="Tali'ah Crackows +2"}
 
    -- Resting sets
    sets.resting = set_combine(sets.idle, {})

    --------------------------------------
    -- Engaged sets
    --------------------------------------
    
    -- Normal melee group
    sets.engaged = {ammo="Sancus Sachet +1",
        head="Tali'ah Turban +2",neck="Shulmanu Collar",lear="Bladeborn Earring",rear="Steelflash Earring",
        body="Con. Doublet +3",hands="Tali'ah Gages +2",ring1="Evoker's Ring",ring2="Renaye Ring +1",
        back="Samanisi Cape",waist="Olseni Belt",legs="Tali'ah Sera. +2",feet="Tali'ah Crackows +2"}
	
	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {
		head="Convoker's Horn +3",neck="Shulmanu Collar",lear="Zennaroi Earring",rear="Digni. Earring",
		body="Con. Doublet +3",hands="Tali'ah Gages +2",ring1="Mars's Ring",ring2="Cacoethic Ring +1",
		waist="Olseni Belt",legs="Tali'ah Sera. +2",feet="Tali'ah Crackows +2"})
	sets.Mode.Att= set_combine(sets.engaged, {
		neck="Rep. Plat. Medal",lear="Bladeborn Earring",rear="Dudgeon Earring",
		ring1="Overbearing Ring",ring2="Cho'j Band",
		waist="Eschan Stone",legs="Querkening Brais"})
	sets.Mode.Crit = set_combine(sets.engaged, {hands="Tali'ah Gages +2",ring2="Hetairoi Ring"
		})
	sets.Mode.DA = set_combine(sets.engaged, {
		neck="Shulmanu Collar",lear="Trux Earring",rear="Brutal Earring",
		body="Tali'ah Manteel +2",ring2="Hetairoi Ring",
		legs="Querkening Brais"})
	sets.Mode.SB = set_combine(sets.engaged, {})
	sets.Mode.sTP = set_combine(sets.engaged, {
		neck="Combatant's Torque",lear="Enervating Earring",rear="Digni. Earring",
		ring1="Rajas Ring",ring2="K'ayres Ring",waist="Olseni Belt"})
	sets.Mode.STR = set_combine(sets.engaged, {
		head="Convoker's Horn +3",neck="Rep. Plat. Medal",
		body="Con. Doublet +3",hands="Tali'ah Gages +2",ring1="Rajas Ring",ring2="Apate Ring",
		back="Buquwik Cape",waist="Cornelia's Belt",legs="Tali'ah Sera. +2",feet="Tali'ah Crackows +2"})
	
	-- other Sets    
	sets.macc = {main="Marin Staff +1",
		lear="Gwati Earring",ring1="Sangoma Ring",
		feet="Medium's Sabots"}
	sets.PDL = {}
	sets.empy = {head="Beckoner's Horn +1",
		body="Beckoner's Doublet",hands="Beckoner's Bracers",
		legs="Beck. Spats +1",feet="Beck. Pigaches"}

	-- Sets with weapons defined.
	sets.engaged.Club = {}
	sets.engaged.Staff = {}
	sets.engaged.Staff = set_combine(sets.engaged, {main="Nirvana", sub="Oneiros Grip"})
	sets.engaged.Staff.Acc = set_combine(sets.engaged.Staff, sets.Mode.Acc)
	sets.engaged.Staff.Att = set_combine(sets.engaged.Staff, sets.Mode.Att)
	sets.engaged.Staff.Crit = set_combine(sets.engaged.Staff, sets.Mode.Crit)
	sets.engaged.Staff.DA = set_combine(sets.engaged.Staff, sets.Mode.DA)
	sets.engaged.Staff.SB = set_combine(sets.engaged.Staff, sets.Mode.SB)
	sets.engaged.Staff.sTP = set_combine(sets.engaged.Staff, sets.Mode.sTP)
	sets.engaged.Staff.STR = set_combine(sets.engaged.Staff, sets.Mode.STR)

	sets.engaged.Club = set_combine(sets.engaged, {main="Bolelabunga",sub="Genmei Shield"})
	sets.engaged.Club.Acc = set_combine(sets.engaged.Club, sets.Mode.Acc)
	sets.engaged.Club.Att = set_combine(sets.engaged.Club, sets.Mode.Att)
	sets.engaged.Club.Crit = set_combine(sets.engaged.Club, sets.Mode.Crit)
	sets.engaged.Club.DA = set_combine(sets.engaged.Club, sets.Mode.DA)
	sets.engaged.Club.SB = set_combine(sets.engaged.Club, sets.Mode.SB)
	sets.engaged.Club.sTP = set_combine(sets.engaged.Club, sets.Mode.sTP)
	sets.engaged.Club.STR = set_combine(sets.engaged.Club, sets.Mode.STR)

    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
	sets.precast.WS = set_combine(sets.Mode.STR, {ammo="Oshasha's Treatise",
		neck="Fotia Gorget",rear="Ishvara Earring",
        ring1="Cornelia's Ring",ring2="Epaminondas's Ring",waist="Fotia Belt"})    

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Myrkr'] = {
        body="Con. Doublet +3",hands="Beckoner's Bracers",ring1="Evoker's Ring",
        back="Pahtli Cape",waist="Fucho-no-Obi"}

	-- none, INT 50% MND 50%
	sets.precast.WS['Spirit Taker'] = set_combine(sets.precast.WS, {})
	
	-- Fire/Light/Water, STR 30% MND 70%
	sets.precast.WS['Garland of Bliss'] = set_combine(sets.precast.WS, {})

	--------------------------------------
    -- Precast Sets
    --------------------------------------
  
    -- Precast sets to enhance JAs
    sets.precast.JA['Astral Flow'] = {head="Glyphic Horn +1"}
    
    sets.precast.JA['Elemental Siphon'] = set_combine(sets.skill.smn, { body="Telchine Chas.",
        back="Conveyance Cape",feet="Beck. Pigaches"})

    sets.precast.JA['Mana Cede'] = {hands="Beckoner's Bracers"}

    -- Pact delay reduction gear
    sets.precast.BloodPactWard = set_combine(sets.skill.smn, {main="Nirvana",sub="Vox Grip",ammo="Sancus Sachet +1",
		head="Beckoner's Horn +1",lear="Evans Earring",rear="Beck. Earring",
		body="Apogee Dalmatica",hands="Glyphic Bracers +1",ring2="Tali'ah Ring",
        back="Conveyance Cape",legs="Glyphic Spats +1",feet="Apogee Pumps +1"})

    sets.precast.BloodPactRage = set_combine(sets.precast.BloodPactWard, {})

    -- Fast cast sets for spells
    
    sets.precast.FC = {
        head="Vanya Hood",neck="Orunmila's Torque",lear="Etiolation Earring",
        body="Inyanga Jubbah +2",ring1="Kishar Ring",ring2="Prolix Ring",
        back="Perimede Cape",waist="Embla Sash",legs="Psycloth Lappas",feet="Merlinic Crackows"}

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {head="Befouled Crown",waist="Siegel Sash"})

       
    --------------------------------------
    -- Midcast sets
    --------------------------------------
    -- sets.midcast.FastRecast = {}

	-- healing skill
    sets.midcast.StatusRemoval = {neck="Incanter's Torque",hands="Inyan. Dastanas +2",ring1="Ephedra Ring",legs="Mdk. Shalwar +1"}

	-- Cure %+ > healing skill > MND
    sets.midcast.Cure = {main="Tamaxchi",sub="Genmei Shield",
        head="Marduk's Tiara +1",neck="Phalaina Locket",lear="Roundel Earring",
        body="Heka's Kalasiris",hands="Telchine Gloves",ring1="Naji's Loop",ring2="Lebeche Ring",
        back="Solemnity Cape",legs="Gyve Trousers",feet="Medium's Sabots"}
	
	sets.midcast.Regen = {main="Bolelabunga",sub="Genmei Shield",
		head="Inyanga Tiara +1",lear="Pratik Earring",
		body="Telchine Chas.",feet="Telchine Pigaches"}
	
	sets.midcast.Stoneskin = {waist="Siegel Sash"}
	sets.midcast['Enhancing Magic'] = {neck="Incanter's Torque",lear="Andoaa Earring",body="Telchine Chas.",hands="Telchine Gloves",
		back="Perimede Cape",waist="Embla Sash",legs="Telchine Braconi",feet="Telchine Pigaches"}
	sets.midcast['Enhancing Magic']['Refresh'] = set_combine(sets.midcast['Enhancing Magic'],{
		back="Grapevine Cape",waist="Gishdubar Sash"})
	
    -- Avatar pact sets.  All pacts are Ability type.
    sets.midcast.Pet.BloodPactWard = set_combine(sets.skill.smn, {ammo="Sancus Sachet +1",
        head="Convoker's Horn +3",
        body="Beckoner's Doublet",hands="Glyphic Bracers +1"})

    sets.midcast.Pet.DebuffBloodPactWard = set_combine(sets.skill.smn, {ammo="Sancus Sachet +1",
        head="Convoker's Horn +3",neck="Caller's Pendant",
        body="Beckoner's Doublet",hands="Glyphic Bracers +1"})

    sets.midcast.Pet.DebuffBloodPactWard.Acc = set_combine(sets.midcast.Pet.DebuffBloodPactWard, {})

    sets.midcast.Pet.PhysicalBloodPactRage = set_combine(sets.skill.smn, {main="Nirvana",sub="Elan Strap +1",ammo="Sancus Sachet +1",
        head="Apogee Crown",neck="Shulmanu Collar",lear="Gelos Earring",rear="Domes. Earring",
        body="Con. Doublet +3",hands="Glyphic Bracers +1",ring2="Tali'ah Ring",
        back="Campestres's Cape",waist="Incarnation Sash",legs="Apogee Slacks",feet="Apogee Pumps +1"})
    
	sets.midcast.Pet.Merit = set_combine(sets.midcast.Pet.PhysicalBloodPactRage, {main=gear.pet_staff})

    sets.midcast.Pet.PhysicalBloodPactRage.Acc = set_combine(sets.midcast.Pet.PhysicalBloodPactRage, {})

	-- aka merit
    sets.midcast.Pet.MagicalBloodPactRage = set_combine(sets.skill.smn, {main=gear.pet_staff,ammo="Sancus Sachet +1",
        head="Apogee Crown",neck="Adad Amulet",rear="Enmerkar Earring",
        body="Apogee Dalmatica",hands="Merlinic Dastanas",
        back="Scintillating Cape",waist="Incarnation Sash",legs="Apogee Slacks",feet="Apogee Pumps +1"})

    sets.midcast.Pet.MagicalBloodPactRage.Acc = set_combine(sets.midcast.Pet.MagicalBloodPactRage, {back="Samanisi Cape",legs="Glyphic Spats +1"})

    -- Spirits cast magic spells, which can be identified in standard ways.
    sets.midcast.Pet.WhiteMagic = {legs="Glyphic Spats +1"}
    
    sets.midcast.Pet['Elemental Magic'] = set_combine(sets.midcast.Pet.MagicalBloodPactRage, {back="Scintillating Cape",legs="Glyphic Spats +1"})

    sets.midcast.Pet['Elemental Magic'].Resistant = {back="Samanisi Cape"}
 
    -- Defense sets
    sets.defense.PDT = {
        head="Hagondes Hat",neck="Elite Royal Collar",
        body="Vrikodara Jupon",hands="Regimen Mittens",ring1="Defending Ring",ring2="Patricius Ring",
        back="Solemnity Cape",waist="Plat. Mog. Belt",legs="Hagondes Pants +1",feet="Battlecast Gaiters"}

    sets.defense.MDT = {
        head="Inyanga Tiara +1",neck="Elite Royal Collar",lear="Etiolation Earring",rear="Eabani Earring",
        body="Inyanga Jubbah +2",hands="Inyan. Dastanas +2",ring1="Defending Ring",ring2="Vengeful Ring",
        back="Solemnity Cape",waist="Plat. Mog. Belt",legs="Inyanga Shalwar +1",feet="Hag. Sabots +1"}
		
	sets.debuffed = set_combine(sets.defense.Evasion,sets.defense.PDT,sets.defense.MDT)
	sets.doom = set_combine(sets.debuffed,{waist="Gishdubar Sash"})

    sets.Kiting = {}
    
    sets.latent_refresh = {sub="Oneiros Grip",waist="Fucho-no-obi"}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if pet_midaction() then
        return
    end
	check_ws_dist(spell)
end

function job_midcast(spell, action, spellMap, eventArgs)
    if pet_midaction() then
        return
    end
end

function job_aftercast(spell)
    if pet_midaction() then
        return
    end
end

-- Runs when pet completes an action.
function job_pet_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted and spell.type == 'BloodPactWard' and spellMap ~= 'DebuffBloodPactWard' then
        wards.flag = true
        wards.spell = spell.english
        send_command('wait 4; gs c reset_ward_flag')
    end
	equip(customize_idle_set())
end

function job_handle_equipping_gear(status, eventArgs)
	-- add_to_chat(122,'handle equiping gear')
	if player.status == 'Engaged' then
		check_tp_lock()
	end
	pick_tp_weapon()
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
	handle_debuffs()
    if state.Buff[buff] ~= nil then
        handle_equipping_gear(player.status)
    elseif storms:contains(buff) then
        handle_equipping_gear(player.status)
    end
end


-- Called when the player's pet's status changes.
-- This is also called after pet_change after a pet is released.  Check for pet validity.
function job_pet_status_change(newStatus, oldStatus, eventArgs)
    if pet.isvalid and not midaction() and not pet_midaction() and (newStatus == 'Engaged' or oldStatus == 'Engaged') then
        handle_equipping_gear(player.status, newStatus)
    end
	if player.status == "Idle" then
		-- add_to_chat(122,'idle midcast')
		equip(customize_idle_set())
	end
end


-- Called when a player gains or loses a pet.
-- pet == pet structure
-- gain == true if the pet was gained, false if it was lost.
function job_pet_change(petparam, gain)
    classes.CustomIdleGroups:clear()
    if gain then
        if avatars:contains(pet.name) then
            classes.CustomIdleGroups:append('Avatar')
        elseif spirits:contains(pet.name) then
            classes.CustomIdleGroups:append('Spirit')
        end
    else
        select_default_macro_book('reset')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Custom spell mapping.
function job_get_spell_map(spell)
    if spell.type == 'BloodPactRage' then
        if magicalRagePacts:contains(spell.english) then
            return 'MagicalBloodPactRage'
        else
            return 'PhysicalBloodPactRage'
        end
    elseif spell.type == 'BloodPactWard' and spell.target.type == 'MONSTER' then
        return 'DebuffBloodPactWard'
    end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if pet.isvalid then
		idleSet = set_combine(idleSet, sets.perp.base)
        if pet.element == world.day_element then
            idleSet = set_combine(idleSet, sets.perp.Day)
        end
        if pet.element == world.weather_element then
            idleSet = set_combine(idleSet, sets.perp.Weather)
        end
        if sets.perp[pet.name] then
            idleSet = set_combine(idleSet, sets.perp[pet.name])
        end
        if state.Buff["Avatar's Favor"] and avatars:contains(pet.name) then
            idleSet = set_combine(idleSet, sets.idle.Avatar.Favor)
        end
        if pet.status == 'Engaged' then
            idleSet = set_combine(idleSet, sets.idle.Avatar.Melee)
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

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    classes.CustomIdleGroups:clear()
    if pet.isvalid then
        if avatars:contains(pet.name) then
            classes.CustomIdleGroups:append('Avatar')
        elseif spirits:contains(pet.name) then
            classes.CustomIdleGroups:append('Spirit')
        end
    end
	pick_tp_weapon()
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)

end


-------------------------------------------------------------------------------------------------------------------
-- User self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for custom player commands.
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'petweather' then
        handle_petweather()
        eventArgs.handled = true
    elseif cmdParams[1]:lower() == 'siphon' then
        handle_siphoning()
        eventArgs.handled = true
    elseif cmdParams[1]:lower() == 'pact' then
        handle_pacts(cmdParams)
        eventArgs.handled = true
    elseif cmdParams[1] == 'reset_ward_flag' then
        wards.flag = false
        wards.spell = ''
        eventArgs.handled = true
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Cast the appopriate storm for the currently summoned avatar, if possible.
function handle_petweather()
    if player.sub_job ~= 'SCH' then
        add_to_chat(122, "You can not cast storm spells")
        return
    end
        
    if not pet.isvalid then
        add_to_chat(122, "You do not have an active avatar.")
        return
    end
    
    local element = pet.element
    if element == 'Thunder' then
        element = 'Lightning'
    end
    
    if S{'Light','Dark','Lightning'}:contains(element) then
        add_to_chat(122, 'You do not have access to '..elements.storm_of[element]..'.')
        return
    end 
    
    local storm = elements.storm_of[element]
    
    if storm then
        send_command('@input /ma "'..elements.storm_of[element]..'" <me>')
    else
        add_to_chat(123, 'Error: Unknown element ('..tostring(element)..')')
    end
end


-- Custom uber-handling of Elemental Siphon
function handle_siphoning()
    if areas.Cities:contains(world.area) then
        add_to_chat(122, 'Cannot use Elemental Siphon in a city area.')
        return
    end

    local siphonElement
    local stormElementToUse
    local releasedAvatar
    local dontRelease
    
    -- If we already have a spirit out, just use that.
    if pet.isvalid and spirits:contains(pet.name) then
        siphonElement = pet.element
        dontRelease = true
        -- If current weather doesn't match the spirit, but the spirit matches the day, try to cast the storm.
        if player.sub_job == 'SCH' and pet.element == world.day_element and pet.element ~= world.weather_element then
            if not S{'Light','Dark','Lightning'}:contains(pet.element) then
                stormElementToUse = pet.element
            end
        end
    -- If we're subbing /sch, there are some conditions where we want to make sure specific weather is up.
    -- If current (single) weather is opposed by the current day, we want to change the weather to match
    -- the current day, if possible.
    elseif player.sub_job == 'SCH' and world.weather_element ~= 'None' then
        -- We can override single-intensity weather; leave double weather alone, since even if
        -- it's partially countered by the day, it's not worth changing.
        if get_weather_intensity() == 1 then
            -- If current weather is weak to the current day, it cancels the benefits for
            -- siphon.  Change it to the day's weather if possible (+0 to +20%), or any non-weak
            -- weather if not.
            -- If the current weather matches the current avatar's element (being used to reduce
            -- perpetuation), don't change it; just accept the penalty on Siphon.
            if world.weather_element == elements.weak_to[world.day_element] and
                (not pet.isvalid or world.weather_element ~= pet.element) then
                -- We can't cast lightning/dark/light weather, so use a neutral element
                if S{'Light','Dark','Lightning'}:contains(world.day_element) then
                    stormElementToUse = 'Wind'
                else
                    stormElementToUse = world.day_element
                end
            end
        end
    end
    
    -- If we decided to use a storm, set that as the spirit element to cast.
    if stormElementToUse then
        siphonElement = stormElementToUse
    elseif world.weather_element ~= 'None' and (get_weather_intensity() == 2 or world.weather_element ~= elements.weak_to[world.day_element]) then
        siphonElement = world.weather_element
    else
        siphonElement = world.day_element
    end
    
    local command = ''
    local releaseWait = 0
    
    if pet.isvalid and avatars:contains(pet.name) then
        command = command..'input /pet "Release" <me>;wait 1.1;'
        releasedAvatar = pet.name
        releaseWait = 10
    end
    
    if stormElementToUse then
        command = command..'input /ma "'..elements.storm_of[stormElementToUse]..'" <me>;wait 5;'
        releaseWait = releaseWait - 4
    end
    
    if not (pet.isvalid and spirits:contains(pet.name)) then
        command = command..'input /ma "'..elements.spirit_of[siphonElement]..'" <me>;wait 5;'
        releaseWait = releaseWait - 4
    end
    
    command = command..'input /ja "Elemental Siphon" <me>;'
    releaseWait = releaseWait - 1
    releaseWait = releaseWait + 0.1
    
    if not dontRelease then
        if releaseWait > 0 then
            command = command..'wait '..tostring(releaseWait)..';'
        else
            command = command..'wait 1.1;'
        end
        
        command = command..'input /pet "Release" <me>;'
    end
    
    if releasedAvatar then
        command = command..'wait 1.1;input /ma "'..releasedAvatar..'" <me>'
    end
    
    send_command(command)
end


-- Handles executing blood pacts in a generic, avatar-agnostic way.
-- cmdParams is the split of the self-command.
-- gs c [pact] [pacttype]
function handle_pacts(cmdParams)
    if areas.Cities:contains(world.area) then
        add_to_chat(122, 'You cannot use pacts in town.')
        return
    end

    if not pet.isvalid then
        add_to_chat(122,'No avatar currently available. Returning to default macro set.')
        select_default_macro_book('reset')
        return
    end

    if spirits:contains(pet.name) then
        add_to_chat(122,'Cannot use pacts with spirits.')
        return
    end

    if not cmdParams[2] then
        add_to_chat(123,'No pact type given.')
        return
    end
    
    local pact = cmdParams[2]:lower()
    
    if not pacts[pact] then
        add_to_chat(123,'Unknown pact type: '..tostring(pact))
        return
    end
    
    if pacts[pact][pet.name] then
        if pact == 'astralflow' and not buffactive['astral flow'] then
            add_to_chat(122,'Cannot use Astral Flow pacts at this time.')
            return
        end
        
        -- Leave out target; let Shortcuts auto-determine it.
        send_command('@input /pet "'..pacts[pact][pet.name]..'"')
    else
        add_to_chat(122,pet.name..' does not have a pact of type ['..pact..'].')
    end
end


-- Event handler for updates to player skill, since we can't rely on skill being
-- correct at pet_aftercast for the creation of custom timers.
windower.raw_register_event('incoming chunk',
    function (id)
        if id == 0x62 then
            if wards.flag then
                create_pact_timer(wards.spell)
                wards.flag = false
                wards.spell = ''
            end
        end
    end)

-- Function to create custom timers using the Timers addon.  Calculates ward duration
-- based on player skill and base pact duration (defined in job_setup).
function create_pact_timer(spell_name)
    -- Create custom timers for ward pacts.
    if wards.durations[spell_name] then
        local ward_duration = wards.durations[spell_name]
        if ward_duration < 181 then
            local skill = player.skills.summoning_magic
            if skill > 300 then
                skill = skill - 300
                if skill > 200 then skill = 200 end
                ward_duration = ward_duration + skill
            end
        end
        
        local timer_cmd = 'timers c "'..spell_name..'" '..tostring(ward_duration)..' down'
        
        if wards.icons[spell_name] then
            timer_cmd = timer_cmd..' '..wards.icons[spell_name]
        end

        send_command(timer_cmd)
    end
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book(reset)
    if reset == 'reset' then
        -- lost pet, or tried to use pact when pet is gone
    end
    
    -- Default macro set/book
    set_macro_page(1, 17)
	send_command('exec smn.txt')
end
