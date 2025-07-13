include('organizer-lib.lua')
include('closetCleaner.lua')

-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    gs c toggle LuzafRing -- Toggles use of Luzaf Ring on and off
    
    Offense mode is melee or ranged.  Used ranged offense mode if you are engaged
    for ranged weaponskills, but not actually meleeing.
    
    Weaponskill mode, if set to 'Normal', is handled separately for melee and ranged weaponskills.
--]]


-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    -- Whether to use Luzaf's Ring
    state.LuzafRing = M(false, "Luzaf's Ring")
    -- Whether a warning has been given for low ammo
    state.warned = M(false)
	state.WeaponMode = M{['description']='Weapon Mode', 'Dagger', 'Sword', 'Staff'}
	state.SubMode = M{['description']='Sub Mode', 'DW', 'Shield', 'Grip'}
	state.RWeaponMode = M{['description']='RWeapon Mode', 'Gun'}
	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive'}
 
	get_combat_form()
	pick_tp_weapon()

    define_roll_values()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'SB', 'sTP', 'STR')
	state.DefenseMode:options('None', 'Physical', 'Magical')
	state.PhysicalDefenseMode:options('PDT', 'Evasion')
	state.MagicalDefenseMode:options('MDT')
	state.CastingMode:options('Normal', 'Resistant')
	state.WeaponMode:set('Dagger')
	state.Stance:set('Offensive')
	state.SubMode:set('DW')
	state.RWeaponMode:set('Gun') 
	state.RangedMode:options('Normal', 'Acc')
	state.WeaponskillMode:options('Normal')

    gear.RAbullet = "Chrono Bullet"
    gear.WSbullet = "Chrono Bullet"
    gear.MAbullet = "Chrono Bullet"
    gear.QDbullet = "Chrono Bullet"
    options.ammo_warning_limit = 15

    -- Additional local binds
    send_command('bind ^` input /ja "Double-up" <me>')
    send_command('bind !` input /ja "Bolter\'s Roll" <me>')

    select_default_macro_book()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
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
		new8="",
		echos="Echo Drops",
		food="Squid Sushi",
		fcard="Fire Card",
		ecard="Earth Card",
		tcard="Thunder Card",
		icard="Ice Card",
		lcard="Light Card",
		dcard="Dark Card",
		wcard="Wind Card",
		trcard="Trump Card",
		wacard="Water Card",
		shihei="Shihei",
		orb="Macrocosmic Orb"
	}
    -- Sets to return to when not performing an action.
    -- Idle sets
    sets.idle = {ammo=gear.RAbullet,
        head="Malignance Chapeau",neck="Elite Royal Collar",lear="Infused Earring",rear="Etiolation Earring",
        body="Meg. Cuirie +2",hands="Meg. Gloves +2",ring1="Defending Ring",ring2="Patricius Ring",
        back="Solemnity Cape",waist="Plat. Mog. Belt",legs="Carmine Cuisses +1",feet="Ahosi Leggings"}

	-- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
	sets.idle.Town = set_combine(sets.idle, {})
	sets.idle.Field = set_combine(sets.idle, {})
	sets.idle.Weak = set_combine(sets.idle, {})

	-- Resting sets
	sets.resting = set_combine(sets.idle, {})

	-- Engaged sets
	-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion

	-- Normal melee group
	sets.engaged = {
        head="Malignance Chapeau",neck="Combatant's Torque",lear="Odr Earring",rear="Suppanomimi",
        body="Meg. Cuirie +2",hands="Herculean Gloves",ring1="Epona's Ring",ring2="Hetairoi Ring",
        back="Ground. Mantle +1",waist="Sarissapho. Belt",legs="Carmine Cuisses +1",feet="Meg. Jam. +2"}
			
	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {
        head="Malignance Chapeau",neck="Combatant's Torque",lear="Odr Earring",rear="Chas. Earring",
        body="Meg. Cuirie +2",hands="Meg. Gloves +2",ring1="Cacoethic Ring +1",ring2="Regal Ring",
        back="Lupine Cape",legs="Carmine Cuisses +1",feet="Meg. Jam. +2"})
	sets.Mode.Att= set_combine(sets.engaged, {
        head="Meghanada Visor +2",neck="Rep. Plat. Medal",
        body="Meg. Cuirie +2",hands="Meg. Gloves +2",ring1="Overbearing Ring",ring2="Regal Ring",
        legs="Carmine Cuisses +1",feet="Meg. Jam. +2"})
	sets.Mode.Crit = set_combine(sets.engaged, { lear="Odr Earring",
		body="Meg. Cuirie +2",hands="Mummu Wrists +2",ring1="Mummu Ring",legs="Mummu Kecks +2"})
	sets.Mode.DA = set_combine(sets.engaged, {lear="Trux Earring",rear="Brutal Earring",
		hands="Mummu Wrists +2",
        legs="Meg. Chausses +2"})
	sets.Mode.SB = set_combine(sets.engaged, {head="Adhemar Bonnet",body="Lapidary Tunic"})
	sets.Mode.sTP = set_combine(sets.engaged, {
		head="Malignance Chapeau",neck="Combatant's Torque",rear="Enervating Earring",
		body="Pursuer's Doublet",
		back="Lupine Cape"})
	sets.Mode.STR = set_combine(sets.engaged, {
		head="Meghanada Visor +2",neck="Rep. Plat. Medal",
		body="Meg. Cuirie +2",hands="Meg. Gloves +2",ring1="Apate Ring",ring2="Regal Ring",
		back="Buquwik Cape",waist="Sailfi Belt +1",legs="Herculean Trousers",feet="Meg. Jam. +2"})
			
	-- other Sets    
	sets.macc = {head="Malignance Chapeau",lear="Gwati Earring",ring1="Sangoma Ring"}
	sets.PDL = {head="Malignance Chapeau"}
	sets.empy = {head="Chasseur's Tricorne",
		body="Chasseur's Frac",hands="Chasseur's Gants",
		legs="Chasseur's Culottes",feet="Chasseur's Bottes"}

	-- Sets with weapons defined.
	sets.engaged.Sword = {}
	sets.engaged.Staff = {}
	sets.engaged.Club = {}
	sets.engaged.Dagger = {}
	sets.engaged.DW = set_combine(sets.engaged, {})
	sets.engaged.Shield = set_combine(sets.engaged, {})
	sets.engaged.Grip = set_combine(sets.engaged, {})
	sets.engaged.DW.Sword = set_combine(sets.engaged, {main="Naegling",sub="Apaisante"})
	sets.engaged.Shield.Sword = set_combine(sets.engaged, {main="Naegling",sub="Nusku Shield"})
	sets.engaged.DW.Club = set_combine(sets.engaged, {main="Warp Cudgel",sub="Kumbhakarna"})
	sets.engaged.Shield.Club = set_combine(sets.engaged, {main="Warp Cudgel",sub="Nusku Shield"})
	sets.engaged.DW.Dagger = set_combine(sets.engaged, {main="Kustawi +1",sub="Odium"})
	sets.engaged.Shield.Dagger = set_combine(sets.engaged, {main="Kustawi +1",sub="Nusku Shield"})
	sets.engaged.Grip.Staff = set_combine(sets.engaged, {main="Gozuki Mezuki", sub="Pole Grip"})
	--Add in appropriate Ranged weapons
	sets.ranged = {}
	sets.ranged.Gun = {ranged="Fomalhaut",ammo="Chrono Bullet"}
	
	sets.engaged.DW.Sword.Gun = set_combine(sets.engaged.DW.Sword, sets.ranged.Gun)
	sets.engaged.Shield.Sword.Gun = set_combine(sets.engaged.Shield.Sword, sets.ranged.Gun)
	sets.engaged.DW.Club.Gun = set_combine(sets.engaged.DW.Club, sets.ranged.Gun)
	sets.engaged.Shield.Club.Gun = set_combine(sets.engaged.Shield.Club, sets.ranged.Gun)
	sets.engaged.DW.Dagger.Gun = set_combine(sets.engaged.DW.Dagger, sets.ranged.Gun)
	sets.engaged.Shield.Dagger.Gun = set_combine(sets.engaged.Shield.Dagger, sets.ranged.Gun)
	
	sets.engaged.DW.Sword.Acc = set_combine(sets.engaged.DW.Sword, sets.Mode.Acc)
	sets.engaged.DW.Sword.Att = set_combine(sets.engaged.DW.Sword, sets.Mode.Att)
	sets.engaged.DW.Sword.Crit = set_combine(sets.engaged.DW.Sword, sets.Mode.Crit)
	sets.engaged.DW.Sword.DA = set_combine(sets.engaged.DW.Sword, sets.Mode.DA)
	sets.engaged.DW.Sword.sTP = set_combine(sets.engaged.DW.Sword, sets.Mode.sTP)
	sets.engaged.DW.Sword.STR = set_combine(sets.engaged.DW.Sword, sets.Mode.STR)
	sets.engaged.Shield.Sword.Acc = set_combine(sets.engaged.Shield.Sword, sets.Mode.Acc)
	sets.engaged.Shield.Sword.Att = set_combine(sets.engaged.Shield.Sword, sets.Mode.Att)
	sets.engaged.Shield.Sword.Crit = set_combine(sets.engaged.Shield.Sword, sets.Mode.Crit)
	sets.engaged.Shield.Sword.DA = set_combine(sets.engaged.Shield.Sword, sets.Mode.DA)
	sets.engaged.Shield.Sword.SB = set_combine(sets.engaged.Shield.Sword, sets.Mode.SB)
	sets.engaged.Shield.Sword.sTP = set_combine(sets.engaged.Shield.Sword, sets.Mode.sTP)
	sets.engaged.Shield.Sword.STR = set_combine(sets.engaged.Shield.Sword, sets.Mode.STR)
	
	sets.engaged.DW.Club.Acc = set_combine(sets.engaged.DW.Club, sets.Mode.Acc)
	sets.engaged.DW.Club.Att = set_combine(sets.engaged.DW.Club, sets.Mode.Att)
	sets.engaged.DW.Club.Crit = set_combine(sets.engaged.DW.Club, sets.Mode.Crit)
	sets.engaged.DW.Club.DA = set_combine(sets.engaged.DW.Club, sets.Mode.DA)
	sets.engaged.DW.Club.SB = set_combine(sets.engaged.DW.Club, sets.Mode.SB)
	sets.engaged.DW.Club.sTP = set_combine(sets.engaged.DW.Club, sets.Mode.sTP)
	sets.engaged.DW.Club.STR = set_combine(sets.engaged.DW.Club, sets.Mode.STR)
	sets.engaged.Shield.Club.Acc = set_combine(sets.engaged.Shield.Club, sets.Mode.Acc)
	sets.engaged.Shield.Club.Att = set_combine(sets.engaged.Shield.Club, sets.Mode.Att)
	sets.engaged.Shield.Club.Crit = set_combine(sets.engaged.Shield.Club, sets.Mode.Crit)
	sets.engaged.Shield.Club.DA = set_combine(sets.engaged.Shield.Club, sets.Mode.DA)
	sets.engaged.Shield.Club.SB = set_combine(sets.engaged.Shield.Club, sets.Mode.SB)
	sets.engaged.Shield.Club.sTP = set_combine(sets.engaged.Shield.Club, sets.Mode.sTP)
	sets.engaged.Shield.Club.STR = set_combine(sets.engaged.Shield.Club, sets.Mode.STR)

	sets.engaged.DW.Dagger.Acc = set_combine(sets.engaged.DW.Dagger, sets.Mode.Acc)
	sets.engaged.DW.Dagger.Att = set_combine(sets.engaged.DW.Dagger, sets.Mode.Att)
	sets.engaged.DW.Dagger.Crit = set_combine(sets.engaged.DW.Dagger, sets.Mode.Crit)
	sets.engaged.DW.Dagger.DA = set_combine(sets.engaged.DW.Dagger, sets.Mode.DA)
	sets.engaged.DW.Dagger.SB = set_combine(sets.engaged.DW.Dagger, sets.Mode.SB)
	sets.engaged.DW.Dagger.sTP = set_combine(sets.engaged.DW.Dagger, sets.Mode.sTP)
	sets.engaged.DW.Dagger.STR = set_combine(sets.engaged.DW.Dagger, sets.Mode.STR)
	sets.engaged.Shield.Dagger.Acc = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Acc)
	sets.engaged.Shield.Dagger.Att = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Att)
	sets.engaged.Shield.Dagger.Crit = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Crit)
	sets.engaged.Shield.Dagger.DA = set_combine(sets.engaged.Shield.Dagger, sets.Mode.DA)
	sets.engaged.Shield.Dagger.SB = set_combine(sets.engaged.Shield.Dagger, sets.Mode.SB)
	sets.engaged.Shield.Dagger.sTP = set_combine(sets.engaged.Shield.Dagger, sets.Mode.sTP)
	sets.engaged.Shield.Dagger.STR = set_combine(sets.engaged.Shield.Dagger, sets.Mode.STR)

	sets.engaged.Grip.Staff.Acc = set_combine(sets.engaged.Grip.Staff, sets.Mode.Acc)
			
	-- Weaponskill sets
	-- Default set for any weaponskill that isn't any more specifically defined
	sets.WSDayBonus = {} 
	sets.precast.WS = set_combine(sets.Mode.STR, {neck="Fotia Gorget",rear="Ishvara Earring",
		hands="Meg. Gloves +2",ring1="Cornelia's Ring",ring2="Epaminondas's Ring",waist="Fotia Belt"})    
 
	-- Light/Dark/Earth, DEX 50%
    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, sets.Mode.Crit, {})
 
	-- Wind/Thunder/Earth, DEX 40% AGI 40%
    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS, {
        lear="Friomisi Earring",rear="Moonshade Earring",
        body="Lapidary Tunic",
        back="Toro Cape",feet="Wayfarer Clogs"})
 
	-- Wind/Thunder/Earth, AGI 73%
	sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {})
 
	-- Dark/Earth, MND 73%
	sets.precast.WS['Rquiescat'] = set_combine(sets.precast.WS, {})

    sets.precast.WS['Last Stand'] = set_combine(sets.precast.WS, {})

    sets.precast.WS['Wildfire'] = set_combine(sets.precast.WS, {ammo=gear.MAbullet,
        lear="Friomisi Earring",
        body="Lapidary Tunic",
        back="Toro Cape",legs="Iuitl Tights"})

    sets.precast.WS['Wildfire'].Brew = set_combine(sets.precast.WS, {ammo=gear.MAbullet})
    
    sets.precast.WS['Leaden Salute'] = sets.precast.WS['Wildfire']

	-- Water/Light/Wind, AGI 70%
	sets.precast.WS['Slug Shot'] = set_combine(sets.precast.WS, {})
    
    -- Precast Sets
    sets.precast.JA['Triple Shot'] = {body="Navarch's Frac +2"}
    sets.precast.JA['Snake Eye'] = {}
    sets.precast.JA['Wild Card'] = {feet="Lanun Bottes"}
    sets.precast.JA['Random Deal'] = {body="Lanun Frac"}

    
    sets.precast.CorsairRoll = {head="Lanun Tricorne",hands="Navarch's Gants",ring1="Barataria Ring"}
    
    sets.precast.CorsairRoll["Caster's Roll"] = set_combine(sets.precast.CorsairRoll, {legs="Navarch's Culottes +2"})
    sets.precast.CorsairRoll["Courser's Roll"] = set_combine(sets.precast.CorsairRoll, {feet="Navarch's Bottes +2"})
    sets.precast.CorsairRoll["Blitzer's Roll"] = set_combine(sets.precast.CorsairRoll, {head="Navarch's Tricorne +2"})
    sets.precast.CorsairRoll["Tactician's Roll"] = set_combine(sets.precast.CorsairRoll, {body="Navarch's Frac +2"})
    sets.precast.CorsairRoll["Allies' Roll"] = set_combine(sets.precast.CorsairRoll, {hands="Navarch's Gants"})
    
    sets.precast.LuzafRing = {ring2="Luzaf's Ring"}
    sets.precast.FoldDoubleBust = {hands="Lanun Gants"}
    
    sets.precast.CorsairShot = {head="Corsair's Tricorne"}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        head="Meghanada Visor +2",
        body="Passion Jacket",hands="Meg. Gloves +2",ring1="Metamor. Ring +1",
        legs="Nahtirah Trousers"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    -- Fast cast sets for spells
    sets.precast.FC = {neck="Orunmila's Torque",ring1="Kishar Ring",ring2="Prolix Ring"}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})

    sets.precast.RA = {ammo=gear.RAbullet,
        head="Meghanada Visor +2",neck="Comm. Charm +1",
        body="Laksamana's Frac",hands="Lanun Gants",
        back="Navarch's Mantle",waist="Commodore Belt",legs="Nahtirah Trousers",feet="Meg. Jam. +2"}
    
    sets.midcast.CorsairShot = {ammo=gear.QDbullet,
        lear="Friomisi Earring",
        body="Lanun Frac",
        back="Toro Cape",legs="Iuitl Tights",feet="Lanun Bottes"}

    sets.midcast.CorsairShot.Acc = {ammo=gear.QDbullet,
        head="Laksa. Tricorne",lear="Lifestorm Earring",rear="Psystorm Earring",
        body="Lanun Frac",
        back="Navarch's Mantle",legs="Iuitl Tights"}

    sets.midcast.CorsairShot['Light Shot'] = {ammo=gear.QDbullet,
        head="Laksa. Tricorne",lear="Lifestorm Earring",rear="Psystorm Earring",
        body="Lanun Frac",
        back="Navarch's Mantle",legs="Iuitl Tights"}

    sets.midcast.CorsairShot['Dark Shot'] = sets.midcast.CorsairShot['Light Shot']


    -- Ranged gear
	sets.midcast.RA = {
		head="Meghanada Visor +2",neck="Comm. Charm +1",lear="Infused Earring",rear="Enervating Earring",
		body="Meg. Cuirie +2",hands="Meg. Gloves +2",ring1="Paqichikaji Ring",ring2="Cacoethic Ring +1",
		waist="Eschan Stone",legs="Meg. Chausses +2",feet="Meg. Jam. +2"}

	sets.midcast.RA.Acc = set_combine(sets.midcast.RA,
		{head="Malignance Chapeau",neck="Comm. Charm +1",
		body="Meg. Cuirie +2",hands="Meg. Gloves +2",ring1="Paqichikaji Ring",ring2="Cacoethic Ring +1",
		waist="Eschan Stone",legs="Meg. Chausses +2",feet="Meg. Jam. +2"})
    
    -- Defense sets
    sets.defense.PDT = {
        head="Malignance Chapeau",neck="Elite Royal Collar",
        body="Meg. Cuirie +2",hands="Meg. Gloves +2",ring1="Defending Ring",
        back="Solemnity Cape",waist="Plat. Mog. Belt",legs="Meg. Chausses +2",feet="Ahosi Leggings"}

    sets.defense.MDT = {
        head="Malignance Chapeau",neck="Elite Royal Collar",lear="Etiolation Earring",rear="Eabani Earring",
        body="Passion Jacket",hands="Kurys Gloves",ring1="Defending Ring",
        back=="Reiki Cloak",waist="Plat. Mog. Belt",legs="Mummu Kecks +2",feet="Ahosi Leggings"}
	sets.debuffed = set_combine(sets.defense.Evasion,sets.defense.PDT,sets.defense.MDT)
	sets.doom = set_combine(sets.debuffed,{waist="Gishdubar Sash"})

    sets.Kiting = {feet="Skadi's Jambeaux +1"}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    -- Check that proper ammo is available if we're using ranged attacks or similar.
    if spell.action_type == 'Ranged Attack' or spell.type == 'WeaponSkill' or spell.type == 'CorsairShot' then
        do_bullet_checks(spell, spellMap, eventArgs)
    end

    -- gear sets
    if (spell.type == 'CorsairRoll' or spell.english == "Double-Up") and state.LuzafRing.value then
        equip(sets.precast.LuzafRing)
    elseif spell.type == 'CorsairShot' and state.CastingMode.value == 'Resistant' then
        classes.CustomClass = 'Acc'
    elseif spell.english == 'Fold' and buffactive['Bust'] == 2 then
        if sets.precast.FoldDoubleBust then
            equip(sets.precast.FoldDoubleBust)
            eventArgs.handled = true
        end
    end
end


-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    if spell.type == 'CorsairRoll' and not spell.interrupted then
        display_roll_info(spell)
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

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Return a customized weaponskill mode to use for weaponskill sets.
-- Don't return anything if you're not overriding the default value.
function get_custom_wsmode(spell, spellMap, default_wsmode)
    if buffactive['Transcendancy'] then
        return 'Brew'
    end
end


-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    if newStatus == 'Engaged' and player.equipment.main == 'Chatoyant Staff' then
        state.OffenseMode:set('Ranged')
    end
end


-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    local msg = ''
    
    msg = msg .. 'Off.: '..state.OffenseMode.current
    msg = msg .. ', Rng.: '..state.RangedMode.current
    msg = msg .. ', WS.: '..state.WeaponskillMode.current
    msg = msg .. ', QD.: '..state.CastingMode.current

    if state.DefenseMode.value ~= 'None' then
        local defMode = state[state.DefenseMode.value ..'DefenseMode'].current
        msg = msg .. ', Defense: '..state.DefenseMode.value..' '..defMode
    end
    
    if state.Kiting.value then
        msg = msg .. ', Kiting'
    end
    
    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: '..state.PCTargetMode.value
    end

    if state.SelectNPCTargets.value then
        msg = msg .. ', Target NPCs'
    end

    msg = msg .. ', Roll Size: ' .. ((state.LuzafRing.value and 'Large') or 'Small')
    
    add_to_chat(122, msg)

    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function define_roll_values()
    rolls = {
        ["Corsair's Roll"]   = {lucky=5, unlucky=9, bonus="Experience Points"},
        ["Ninja Roll"]       = {lucky=4, unlucky=8, bonus="Evasion"},
        ["Hunter's Roll"]    = {lucky=4, unlucky=8, bonus="Accuracy"},
        ["Chaos Roll"]       = {lucky=4, unlucky=8, bonus="Attack"},
        ["Magus's Roll"]     = {lucky=2, unlucky=6, bonus="Magic Defense"},
        ["Healer's Roll"]    = {lucky=3, unlucky=7, bonus="Cure Potency Received"},
        ["Puppet Roll"]      = {lucky=4, unlucky=8, bonus="Pet Magic Accuracy/Attack"},
        ["Choral Roll"]      = {lucky=2, unlucky=6, bonus="Spell Interruption Rate"},
        ["Monk's Roll"]      = {lucky=3, unlucky=7, bonus="Subtle Blow"},
        ["Beast Roll"]       = {lucky=4, unlucky=8, bonus="Pet Attack"},
        ["Samurai Roll"]     = {lucky=2, unlucky=6, bonus="Store TP"},
        ["Evoker's Roll"]    = {lucky=5, unlucky=9, bonus="Refresh"},
        ["Rogue's Roll"]     = {lucky=5, unlucky=9, bonus="Critical Hit Rate"},
        ["Warlock's Roll"]   = {lucky=4, unlucky=8, bonus="Magic Accuracy"},
        ["Fighter's Roll"]   = {lucky=5, unlucky=9, bonus="Double Attack Rate"},
        ["Drachen Roll"]     = {lucky=3, unlucky=7, bonus="Pet Accuracy"},
        ["Gallant's Roll"]   = {lucky=3, unlucky=7, bonus="Defense"},
        ["Wizard's Roll"]    = {lucky=5, unlucky=9, bonus="Magic Attack"},
        ["Dancer's Roll"]    = {lucky=3, unlucky=7, bonus="Regen"},
        ["Scholar's Roll"]   = {lucky=2, unlucky=6, bonus="Conserve MP"},
        ["Bolter's Roll"]    = {lucky=3, unlucky=9, bonus="Movement Speed"},
        ["Caster's Roll"]    = {lucky=2, unlucky=7, bonus="Fast Cast"},
        ["Courser's Roll"]   = {lucky=3, unlucky=9, bonus="Snapshot"},
        ["Blitzer's Roll"]   = {lucky=4, unlucky=9, bonus="Attack Delay"},
        ["Tactician's Roll"] = {lucky=5, unlucky=8, bonus="Regain"},
        ["Allies's Roll"]    = {lucky=3, unlucky=10, bonus="Skillchain Damage"},
        ["Miser's Roll"]     = {lucky=5, unlucky=7, bonus="Save TP"},
        ["Companion's Roll"] = {lucky=2, unlucky=10, bonus="Pet Regain and Regen"},
        ["Avenger's Roll"]   = {lucky=4, unlucky=8, bonus="Counter Rate"},
    }
end

function display_roll_info(spell)
    rollinfo = rolls[spell.english]
    local rollsize = (state.LuzafRing.value and 'Large') or 'Small'

    if rollinfo then
        add_to_chat(104, spell.english..' provides a bonus to '..rollinfo.bonus..'.  Roll size: '..rollsize)
        add_to_chat(104, 'Lucky roll is '..tostring(rollinfo.lucky)..', Unlucky roll is '..tostring(rollinfo.unlucky)..'.')
    end
end


-- Determine whether we have sufficient ammo for the action being attempted.
function do_bullet_checks(spell, spellMap, eventArgs)
    local bullet_name
    local bullet_min_count = 1
    
    if spell.type == 'WeaponSkill' then
        if spell.skill == "Marksmanship" then
            if spell.element == 'None' then
                -- physical weaponskills
                bullet_name = gear.WSbullet
            else
                -- magical weaponskills
                bullet_name = gear.MAbullet
            end
        else
            -- Ignore non-ranged weaponskills
            return
        end
    elseif spell.type == 'CorsairShot' then
        bullet_name = gear.QDbullet
    elseif spell.action_type == 'Ranged Attack' then
        bullet_name = gear.RAbullet
        if buffactive['Triple Shot'] then
            bullet_min_count = 3
        end
    end
    
    local available_bullets = player.inventory[bullet_name] or player.wardrobe[bullet_name]
    
    -- If no ammo is available, give appropriate warning and end.
    if not available_bullets then
        if spell.type == 'CorsairShot' and player.equipment.ammo ~= 'empty' then
            add_to_chat(104, 'No Quick Draw ammo left.  Using what\'s currently equipped ('..player.equipment.ammo..').')
            return
        elseif spell.type == 'WeaponSkill' and player.equipment.ammo == gear.RAbullet then
            add_to_chat(104, 'No weaponskill ammo left.  Using what\'s currently equipped (standard ranged bullets: '..player.equipment.ammo..').')
            return
        else
            add_to_chat(104, 'No ammo ('..tostring(bullet_name)..') available for that action.')
            eventArgs.cancel = true
            return
        end
    end
    
    -- Don't allow shooting or weaponskilling with ammo reserved for quick draw.
    if spell.type ~= 'CorsairShot' and bullet_name == gear.QDbullet and available_bullets.count <= bullet_min_count then
        add_to_chat(104, 'No ammo will be left for Quick Draw.  Cancelling.')
        eventArgs.cancel = true
        return
    end
    
    -- Low ammo warning.
    if spell.type ~= 'CorsairShot' and state.warned.value == false
        and available_bullets.count > 1 and available_bullets.count <= options.ammo_warning_limit then
        local msg = '*****  LOW AMMO WARNING: '..bullet_name..' *****'
        --local border = string.repeat("*", #msg)
        local border = ""
        for i = 1, #msg do
            border = border .. "*"
        end
        
        add_to_chat(104, border)
        add_to_chat(104, msg)
        add_to_chat(104, border)

        state.warned:set()
    elseif available_bullets.count > options.ammo_warning_limit and state.warned then
        state.warned:reset()
    end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 18)
end

function get_combat_form()
	set_combat_form()
end

function pick_tp_weapon()
	-- add_to_chat(122,' pick tp weapon '..state.WeaponMode.value)
	set_combat_weapon()
	set_ranged_weapon()
	-- add_to_chat(123, 'combat weapon set to '..state.CombatWeapon.value)
end