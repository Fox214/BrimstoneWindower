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
    state.Buff.Migawari = buffactive.migawari or false
    state.Buff.Doom = buffactive.doom or false
    state.Buff.Yonin = buffactive.Yonin or false
    state.Buff.Innin = buffactive.Innin or false
    state.Buff.Futae = buffactive.Futae or false
	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive', 'DmgTank'}
 
	state.WeaponMode = M{['description']='Weapon Mode', 'Katana', 'Dagger', 'Club', 'Sword', 'GreatKatana', 'Scythe', 'Polearm', 'Staff' }
	state.RWeaponMode = M{['description']='RWeapon Mode', 'Stats', 'Boomerrang', 'Shuriken'}
 
	set_combat_form()
	pick_tp_weapon()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'SB', 'sTP', 'STR')
    state.WeaponskillMode:options('Normal')
    state.CastingMode:options('Normal', 'Resistant')
	state.DefenseMode:options('None', 'Physical', 'Magical')
	state.PhysicalDefenseMode:options('PDT', 'Evasion')
	state.MagicalDefenseMode:options('MDT')
	state.WeaponMode:set('Katana')
	state.RWeaponMode:set('Shuriken') 
	state.Stance:set('None')
	
    gear.MovementFeet = {name="Danzo Sune-ate"}
    gear.DayFeet = "Danzo Sune-ate"
    gear.NightFeet = "Hachi. Kyahan +1"
	gear.NinAmmo = {name="Seeth. Bomblet +1"}
	gear.NinRanged = {name=""}
	gear.StatsAmmo = "Seeth. Bomblet +1"
	gear.MaccAmmo = "Pemphredo Tathlum"
	gear.WSAmmo = "Oshasha's Treatise"
	gear.useWSAmmo = {name="Oshasha's Treatise"}
	gear.empty = ""
	gear.BowAmmo = "Fang Arrow"
	gear.BowRanged = "Killer Shortbow"
	gear.GunAmmo = "Bronze Bullet"
	gear.GunRanged = "Shark Gun"
	gear.BoomerrangRanged = "Aliyat Chakram"
	gear.Shuriken = "Togakushi Shuriken"
    gear.hercTH = { name="Herculean Helm", augments={'Attack+13','"Snapshot"+3','"Treasure Hunter"+1','Accuracy+5 Attack+5',}}
    gear.hercAcc = { name="Herculean Helm", augments={'Accuracy+29','STR+6','Attack+3',}}
    
    select_movement_feet()
	select_ammo_type('melee')
    select_default_macro_book()
	
	-- send_command('bind ^` gs c cycle WeaponMode')
	-- send_command('bind !` gs c cycle SubMode')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    gear.critCape={ name="Andartia's Mantle", augments={'AGI+20','Accuracy+20 Attack+20','AGI+10','Crit.hit rate+10','Damage taken-5%'}}
    gear.wsdCape={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%'}}
    -- gear.daCape={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%'}}
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
		Food1="Squid Sushi",
		Food2="Red Curry Bun",
		Food3="Sublime Sushi",
		Food4="Grape Daifuku",
		StatsAmmo="Yamarang",
		MaccAmmo="Pemphredo Tathlum",
		BowAmmo="Fang Arrow",
		Bowrange="Killer Shortbow",
		GunAmmo="Bronze Bullet",
		Gunrange="Shark Gun",
		Boomerrangrange="Aliyat Chakram",
		Shuriken="Togakushi Shuriken",
		echos="Echo Drops",
		Chonofuda="Chonofuda",
		Furusumi="Furusumi",
		Hiraishin="Hiraishin",
		Inoshishinofuda="Inoshishinofuda",
		Jinko="Jinko",
		Jusatsu="Jusatsu",
		Kabenro="Kabenro",
		Kaginawa="Kaginawa",
		KawahoriOgi="Kawahori-Ogi",
		Kodoku="Kodoku",
		Makibishi="Makibishi",
		MizuDeppo="Mizu-Deppo",
		Mokujin="Mokujin",
		Ryuno="Ryuno",
		SairuiRan="Sairui-Ran",
		SanjakuTenugui="Sanjaku-Tenugui",
		Shihei="Shihei",
		Shikanofuda="Shikanofuda",
		ShinobiTabi="Shinobi-Tabi",
		Soshi="Soshi",
		Tsurara="Tsurara",
		Uchitake="Uchitake",
		orb="Macrocosmic Orb"
	}
    gear.MovementFeet = {name="Danzo Sune-ate"}
    gear.DayFeet = "Danzo Sune-ate"
    gear.NightFeet = "Hachi. Kyahan +1"
	gear.NinAmmo = {name="Yamarang"}
	gear.NinRanged = {name=""}
	gear.StatsAmmo = "Yamarang"
	gear.MaccAmmo = "Pemphredo Tathlum"
	gear.WSAmmo = "Oshasha's Treatise"
	gear.useWSAmmo = {name="Oshasha's Treatise"}
	gear.empty = ""
	gear.BowAmmo = "Fang Arrow"
	gear.BowRanged = "Killer Shortbow"
	gear.GunAmmo = "Bronze Bullet"
	gear.GunRanged = "Shark Gun"
	gear.BoomerrangRanged = "Aliyat Chakram"
	gear.Shuriken = "Togakushi Shuriken"
    gear.hercTH = { name="Herculean Helm", augments={'Attack+13','"Snapshot"+3','"Treasure Hunter"+1','Accuracy+5 Attack+5',}}
    gear.hercAcc = { name="Herculean Helm", augments={'Accuracy+29','STR+6','Attack+3',}}
	-- For closetCleaner
	sets.vars = { main=gear.MaccAmmo, sub=gear.BowAmmo, ranged=gear.BowRanged, ammo=gear.StatsAmmo,
		-- body=gear.GunAmmo, hands=gear.GunRanged, 
        ring1=gear.BoomerrangRanged, ring2=gear.Shuriken,
		legs=gear.NightFeet,feet=gear.DayFeet
		}
 
	-- Idle sets
    sets.idle = {
        head="Hattori Zukin +2",neck="Elite Royal Collar",lear="Infused Earring",rear="Etiolation Earring",
        body="Hiza. Haramaki +2",hands="Hizamaru Kote +2",ring1="Defending Ring",ring2="Vengeful Ring",
        back="Solemnity Cape",waist="Plat. Mog. Belt",legs="Hattori Hakama +2",feet=gear.MovementFeet}

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
        head="Hattori Zukin +2",neck="Combatant's Torque",lear="Odr Earring",rear="Hattori Earring +1",
        body="Tatena. Harama. +1",hands="Mummu Wrists +2",ring1="Epona's Ring",ring2="Hetairoi Ring",
        back=gear.critCape,waist="Sailfi Belt +1",legs="Mochi. Hakama +3",feet="Hattori Kyahan +2"}
 
	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {
        head="Hattori Zukin +2",neck="Combatant's Torque",lear="Zennaroi Earring",rear="Hattori Earring +1",
        body="Hachiya Chain. +3",hands="Herculean Gloves",ring1="Cacoethic Ring +1",ring2="Regal Ring",
        back=gear.critCape,waist="Olseni Belt",legs="Mummu Kecks +2",feet="Herculean Boots"})
	sets.Mode.Att= set_combine(sets.engaged, {
        head="Hattori Zukin +2",neck="Rep. Plat. Medal",lear="Bladeborn Earring",rear="Dudgeon Earring",
        body="Tatena. Harama. +1",hands="Count's Cuffs",ring1="Overbearing Ring",ring2="Regal Ring",
        back="Phalangite Mantle",waist="Sulla Belt",legs="Hiza. Hizayoroi +2",feet="Hiza. Sune-Ate +2"})
	-- Crit then dex
	sets.Mode.Crit = set_combine(sets.engaged, {
        head="Adhemar Bonnet",neck="Iga Erimaki",lear="Odr Earring",
        body="Hachiya Chain. +3",hands="Mummu Wrists +2",ring2="Mummu Ring",
        back=gear.critCape,waist="Chaac Belt",legs="Mummu Kecks +2",feet="Mummu Gamash. +2"})
	sets.Mode.DA = set_combine(sets.engaged, {
        head="Skormoth Mask",neck="Asperity Necklace",lear="Trux Earring",rear="Brutal Earring",
        body="Hattori Ningi +2",hands="Herculean Gloves",ring1="Epona's Ring",ring2="Hetairoi Ring",
        back="Atheling Mantle",waist="Sarissapho. Belt",legs="Zoar Subligar",feet="Loyalist Sabatons"})
	sets.Mode.SB = set_combine(sets.engaged, {})
	-- sTP then subtle blow
	sets.Mode.sTP = set_combine(sets.engaged, {
        head="Malignance Chapeau",neck="Combatant's Torque",lear="Tripudio Earring",rear="Enervating Earring",
        body="Tatena. Harama. +1",hands="Otronif Gloves +1",ring1="Rajas Ring",ring2="K'ayres Ring",
        back="Lupine Cape",waist="Olseni Belt",legs="Herculean Trousers",feet="Otronif Boots"})
	sets.Mode.STR = set_combine(sets.engaged, {
        head="Hachiya Hatsu. +3",neck="Rep. Plat. Medal",
        body="Hiza. Haramaki +2",hands="Herculean Gloves",ring1="Apate Ring",ring2="Regal Ring",
        back=gear.wsdCape,waist="Sailfi Belt +1",legs="Hiza. Hizayoroi +2",feet="Hiza. Sune-Ate +2"})

	-- other Sets    
	sets.macc = {head="Malignance Chapeau",lear="Gwati Earring",ring1="Sangoma Ring"}
	sets.PDL = {head="Malignance Chapeau"}
	sets.empy = {head="Hattori Zukin +2",
		body="Hattori Ningi +2",hands="Hattori Tekko",
		legs="Hattori Hakama +2",feet="Hattori Kyahan +2"}		

	-- Sets with weapons defined.
	sets.engaged.Katana = {}
	sets.engaged.Dagger = {}
	sets.engaged.Club = {}
	sets.engaged.Sword = {}
	sets.engaged.GreatKatana = {}
	sets.engaged.Scythe = {}
	sets.engaged.Polearm = {}
	sets.engaged.Staff = {}
	sets.engaged.Stats = set_combine(sets.engaged, {})
	sets.engaged.Boomerrang = set_combine(sets.engaged, {})
	sets.engaged.Shuriken = set_combine(sets.engaged, {})
	-- sets.engaged.Katana = set_combine(sets.engaged, {main="Kannagi", sub="Achiuchikapu"})
	sets.engaged.Katana = set_combine(sets.engaged, {main="Kannagi", sub="Yagyu Darkblade"})
	--Add in appropriate Ranged weapons
	sets.ranged = {}
	sets.ranged.Stats = {range=gear.NinRanged,ammo=gear.NinAmmo}
	sets.ranged.Boomerrang = {range=gear.NinRanged,ammo=gear.NinAmmo}
	sets.ranged.Shuriken = {range=gear.NinRanged,ammo=gear.NinAmmo}
	sets.ranged.Bow = {range=gear.NinRanged,ammo=gear.NinAmmo}
	sets.ranged.Gun = {range=gear.NinRanged,ammo=gear.NinAmmo}
	sets.engaged.Katana.Bow = set_combine(sets.engaged.Katana, sets.ranged.Bow)
	sets.engaged.Katana.Gun = set_combine(sets.engaged.Katana, sets.ranged.Gun)

	sets.engaged.Katana.Stats = set_combine(sets.engaged.Katana, sets.ranged.Stats)
	sets.engaged.Katana.Boomerrang = set_combine(sets.engaged.Katana, sets.ranged.Boomerrang)
	sets.engaged.Katana.Shuriken = set_combine(sets.engaged.Katana, sets.ranged.Shuriken)
	--Finalize the sets
	sets.engaged.Katana.Acc = set_combine(sets.engaged.Katana, sets.Mode.Acc)
	sets.engaged.Katana.Att = set_combine(sets.engaged.Katana, sets.Mode.Att)
	sets.engaged.Katana.Crit = set_combine(sets.engaged.Katana, sets.Mode.Crit)
	sets.engaged.Katana.DA = set_combine(sets.engaged.Katana, sets.Mode.DA)
	sets.engaged.Katana.SB = set_combine(sets.engaged.Katana, sets.Mode.SB)
	sets.engaged.Katana.sTP = set_combine(sets.engaged.Katana, sets.Mode.sTP)
	sets.engaged.Katana.STR = set_combine(sets.engaged.Katana, sets.Mode.STR)
	--Other weapons (should inherit most recent ranged, no need to explicitly set)
	sets.engaged.Staff = set_combine(sets.engaged, {main="Gozuki Mezuki",sub="Bloodrain Strap"})
	sets.engaged.Staff.Acc = set_combine(sets.engaged.Staff, sets.Mode.Acc, {})
	sets.engaged.Dagger = set_combine(sets.engaged, {main="Odium"})
	sets.engaged.Dagger.Acc = set_combine(sets.engaged.Dagger, sets.Mode.Acc)
	sets.engaged.Club = set_combine(sets.engaged, {main="Warp Cudgel"})
	sets.engaged.Club.Acc = set_combine(sets.engaged.Club, sets.Mode.Acc)
	sets.engaged.Sword = set_combine(sets.engaged, {main="Naegling"})
	sets.engaged.Sword.Acc = set_combine(sets.engaged.Sword, sets.Mode.Acc)
	sets.engaged.Polearm = set_combine(sets.engaged, {main="Pitchfork +1",sub="Bloodrain Strap"})
	sets.engaged.Polearm.Acc = set_combine(sets.engaged.Polearm, sets.Mode.Acc)
	sets.engaged.Scythe = set_combine(sets.engaged, {main="Ark Scythe",sub="Bloodrain Strap"})
	sets.engaged.Scythe.Acc = set_combine(sets.engaged.Scythe, sets.Mode.Acc)
	sets.engaged.GreatKatana = set_combine(sets.engaged, {main="Hardwood Katana",sub="Bloodrain Strap"})
	sets.engaged.GreatKatana.Bow = set_combine(sets.engaged.GreatKatana, sets.ranged.Bow)
	sets.engaged.GreatKatana.Gun = set_combine(sets.engaged.GreatKatana, sets.ranged.Gun)
	sets.engaged.GreatKatana.Stats = set_combine(sets.engaged.GreatKatana, sets.ranged.Stats)
	sets.engaged.GreatKatana.Boomerrang = set_combine(sets.engaged.GreatKatana, sets.ranged.Boomerrang)
	sets.engaged.GreatKatana.Shuriken = set_combine(sets.engaged.GreatKatana, sets.ranged.Shuriken)
	sets.engaged.GreatKatana.Acc = set_combine(sets.engaged.GreatKatana, sets.Mode.Acc)
	sets.engaged.GreatKatana.SB = set_combine(sets.engaged.GreatKatana, sets.Mode.SB)
	sets.engaged.GreatKatana.SB.Bow = set_combine(sets.engaged.GreatKatana, sets.Mode.SB, sets.ranged.Bow)
	sets.engaged.GreatKatana.SB.Gun = set_combine(sets.engaged.GreatKatana, sets.Mode.SB, sets.ranged.Gun)
	sets.engaged.GreatKatana.SB.Boomerrang = set_combine(sets.engaged.GreatKatana, sets.Mode.SB, sets.ranged.Boomerrang)

	-- Precast sets
    sets.precast.JA['Mijin Gakure'] = {legs="Mochi. Hakama +3"}
    sets.precast.JA['Futae'] = {legs="Hattori Tekko"}
    sets.precast.JA['Sange'] = {legs="Mochi. Chainmail +1"}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        head="Hachiya Hatsu. +3",
		body="Passion Jacket",hands="Hizamaru Kote +2",ring2="Metamor. Ring +1",
        legs="Feast Hose",feet="Hachi. Kyahan +1"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    -- Set for acc on steps, since Yonin drops acc a fair bit
    sets.precast.Step = set_combine(sets.Mode.Acc, {})

    sets.precast.Flourish1 = {waist="Chaac Belt"}

    -- Fast cast sets for spells
    sets.precast.FC = {head=gear.hercAcc,neck="Orunmila's Torque",lear="Etiolation Earring",
        hands="Leyline Gloves",ring1="Kishar Ring",ring2="Prolix Ring",
        legs="Gyve Trousers"}
    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads",body="Mochi. Chainmail +1",back="Andartia's Mantle",feet="Hattori Kyahan +2"})

    -- Snapshot for ranged
    sets.precast.RA = {head=gear.hercTH,waist="Yemaya Belt",legs="Nahtirah Trousers"}
       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	sets.precast.WS = set_combine(sets.Mode.STR, { ammo=gear.useWSAmmo,
		head="Hachiya Hatsu. +3",neck="Fotia Gorget",rear="Ishvara Earring",
		body="Herculean Vest",ring1="Cornelia's Ring",ring2="Epaminondas's Ring",
		back=gear.wsdCape,waist="Fotia Belt",legs="Mochi. Hakama +3",feet="Hattori Kyahan +2"})    
	sets.WSDayBonus = {} 

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	-- Light, STR 60% DEX 60%
	sets.precast.WS['Blade: Rin'] = set_combine(sets.precast.WS, sets.Mode.Crit, {})

 	-- Earth, STR 20% DEX 60%
	sets.precast.WS['Blade: Retsu'] = set_combine(sets.precast.WS, {})
	
	-- Water, STR 30% INT 30%
	sets.precast.WS['Blade: Teki'] = set_combine(sets.precast.WS, {})
	
	-- Ice/Wind, STR 40% INT 40%
	sets.precast.WS['Blade: To'] = set_combine(sets.precast.WS, {})
	
	-- Light/Thunder, STR 30% INT 30%
	sets.precast.WS['Blade: Chi'] = set_combine(sets.precast.WS, {})

 	-- Darkness, STR 40% INT 40%
	sets.precast.WS['Blade: Ei'] = set_combine(sets.precast.WS, {})
	
	-- Wind/Thunder, STR 30% DEX 30%
	sets.precast.WS['Blade: Jin'] = set_combine(sets.Mode.Crit, sets.precast.WS, {})
	
	-- Earth/Darkness, STR 30% INT 30%
	sets.precast.WS['Blade: Ten'] = set_combine(sets.precast.WS, {})

	-- Earth/Darkness/Light, STR 30% INT 30%
	sets.precast.WS['Blade: Ku'] = set_combine(sets.precast.WS, {})
	
	-- Earth/Water, DEX 40% INT 40%
	sets.precast.WS['Blade: Yu'] = set_combine(sets.precast.WS, {body="Lapidary Tunic"})

	-- Fire/Light/Thunder, DEX 73%
    sets.precast.WS['Blade: Shun'] = set_combine(sets.precast.WS, {
		head="Mummu Bonnet +2",
		body="Mummu Jacket +2",hands="Mummu Wrists +2",ring1="Rajas Ring",ring2="Apate Ring",
		back="Andartia's Mantle",legs="Jokushu Haidate",feet="Mummu Gamash. +2"})

	-- Water/Earth/Ice/Dark, AGI 80%
	sets.precast.WS['Blade: Hi'] = set_combine(sets.precast.WS, {
		lear="Odr Earring",
		body="Hattori Ningi +2",hands="Mummu Wrists +2",
		back=gear.critCape,waist="Sailfi Belt +1",legs="Mummu Kecks +2"})

 	-- Wind/Thunder/Dark, STR 60% INT 60%
	sets.precast.WS['Blade: Kamu'] = set_combine(sets.precast.WS, {})

	-- Wind/Thunder/Earth, DEX 40% INT 40%
    sets.precast.WS['Aeolian Edge'] = {
        lear="Friomisi Earring",rear="Moonshade Earring",
        body="Lapidary Tunic",ring2="Mummu Ring",
        back="Toro Cape"}

	-- Dark/Water, STR 40% MND 40% 
	sets.precast.WS['Sunburst'] = set_combine(sets.precast.WS, {})
		
	-- Midcast sets
    -- sets.midcast.FastRecast = {}
        
	-- skill > acc > INT 
    sets.midcast.NinjutsuDebuff = {range=gear.NinRanged,ammo=gear.NinAmmo,
        head="Hachiya Hatsu. +3",neck="Incanter's Torque",lear="Digni. Earring",rear="Gwati Earring",
        body="Mummu Jacket +2",hands="Mummu Wrists +2",ring1="Sangoma Ring",ring2="Metamor. Ring +1",
        back="Yokaze Mantle",waist="Eschan Stone",legs="Mummu Kecks +2",feet="Mummu Gamash. +2"}

	-- special > skill > mab > INT > acc
    sets.midcast.ElementalNinjutsu = set_combine(sets.midcast.NinjutsuDebuff, {
        head="Mochi. Hatsuburi",neck="Sibyl Scarf",lear="Friomisi Earring",rear="Crematio Earring",
        body="Lapidary Tunic",hands="Hattori Tekko",ring1="Sangoma Ring",ring2="Metamor. Ring +1",
        back="Toro Cape",waist="Eschan Stone",legs="Gyve Trousers",feet="Hachi. Kyahan +1"})

	-- acc 
    sets.midcast.ElementalNinjutsu.Resistant = set_combine(sets.midcast.NinjutsuDebuff, {})

    sets.midcast.NinjutsuBuff = {head="Hachiya Hatsu. +3",hands="Mochizuki Tekko +2",back="Yokaze Mantle"}
    sets.midcast.Utsusemi = set_combine(sets.midcast.NinjutsuBuff, {back="Andartia's Mantle",feet="Hattori Kyahan +2"})

	-- Racc, Ratt, AGI
    sets.midcast.RA = {
        head="Hattori Zukin +2",neck="Combatant's Torque",rear="Enervating Earring",
        body="Sayadio's Kaftan",hands="Hachiya Tekko",ring1="Paqichikaji Ring",ring2="Cacoethic Ring +1",
        back="Yokaze Mantle",waist="Eschan Stone",legs="Feast Hose",feet="Herculean Boots"}
 
    -- Defense sets
    sets.defense.Evasion = {
        head="Malignance Chapeau",neck="Iga Erimaki",lear="Infused Earring",rear="Eabani Earring",
        body="Hiza. Haramaki +2",hands="Hizamaru Kote +2",ring1="Vengeful Ring",ring2="Beeline Ring",
        back="Yokaze Mantle",waist="Koga Sarashi",legs="Hiza. Hizayoroi +2",feet="Hiza. Sune-Ate +2"}

    sets.defense.PDT = { 
        head="Hattori Zukin +2",neck="Elite Royal Collar",
        body="Otronif Harness",hands="Otronif Gloves +1",ring1="Defending Ring",ring2="Patricius Ring",
        back=gear.critCape,waist="Plat. Mog. Belt",legs="Mummu Kecks +2",feet="Ahosi Leggings"}

    sets.defense.MDT = { 
        head="Hattori Zukin +2",neck="Elite Royal Collar",lear="Etiolation Earring",rear="Eabani Earring",
        body="Hiza. Haramaki +2",hands="Otronif Gloves +1",ring1="Defending Ring",ring2="Vengeful Ring",
        back=gear.critCape,waist="Plat. Mog. Belt",legs="Mummu Kecks +2",feet="Amm Greaves"}
		
	sets.debuffed = set_combine(sets.defense.Evasion,sets.defense.PDT,sets.defense.MDT)
	sets.doom = set_combine(sets.debuffed,{waist="Gishdubar Sash"})

    sets.Kiting = {feet=gear.MovementFeet}

    --------------------------------------
    -- Custom buff sets
    --------------------------------------

    sets.buff.Migawari = {body="Hattori Ningi +2",back="Andartia's Mantle"}
    sets.buff.Doom = {} -- "Saida Ring"
    sets.buff.Yonin = {head="Mochi. Hatsuburi",legs="Hattori Hakama +2"}
    sets.buff.Innin = {head="Hattori Zukin +2"}
	
	-- These sets use a piece of gear in specific situations, need to customize_idle_set or customize_melee_set
	-- sets.Assault = {ring2="Ulthalam's Ring"}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------
function job_precast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Ninjutsu' then
		-- add_to_chat(1, 'Casting '..spell.name)
        handle_spells(spell)
	end
	-- cancel_conflicting_buffs(spell, action, spellMap, eventArgs)
	check_ws_dist(spell)
end

-- Run after the default precast() is done.
-- eventArgs is the same one used in job_precast, in case information needs to be persisted.
function job_post_precast(spell, action, spellMap, eventArgs)
	if spell.type == 'WeaponSkill' then
        if is_sc_element_today(spell) then
			-- add_to_chat(122,' WS Day ')
            equip(sets.WSDayBonus)
        end
	end 
end

-- Run after the general midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if state.Buff.Doom then
        equip(sets.buff.Doom)
    end
end


-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted and spell.english == "Migawari: Ichi" then
        state.Buff.Migawari = true
    end
end

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
	handle_nin_ja:schedule(delay)
	if player.sub_job == 'WAR' then
		handle_war_ja:schedule(delay+1)
	end
end

function handle_nin_ja() 
	if not areas.Cities:contains(world.area) and not (buffactive.Sneak or buffactive.Invisible) then
		local abil_recasts = windower.ffxi.get_ability_recasts()
		if state.Stance.value == 'Offensive' then
			-- add_to_chat(7,'Offensive stance')
			if not buffactive.Innin and player.status == "Engaged" and abil_recasts[147] == 0 then
				-- add_to_chat(7,'Innin')
				windower.send_command('@input /ja "Innin" <me>')
				return
			end
		end
		if state.Stance.value == 'Defensive' or state.Stance.value == 'DmgTank' then
			if not buffactive.Yonin and player.status == "Engaged" and abil_recasts[146] == 0 then
				windower.send_command('@input /ja "Yonin" <me>')
				return
			end
			if not buffactive.Issekigan and player.status == "Engaged" and abil_recasts[57] == 0 then
				windower.send_command('@input /ja "Issekigan" <me>')
				return
			end
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
	handle_equipping_gear(player.status)
end

function job_status_change(new_status, old_status)
    if new_status == 'Idle' then
        select_movement_feet()
    end
end

-- Handle notifications of user state values being changed.
function job_state_change(stateField, newValue, oldValue)
	-- add_to_chat(121,' job state change ')
	if stateField == 'Weapon Mode' then
		if newValue ~= 'Normal' then
			state.CombatWeapon:set(newValue)
		else
			state.CombatWeapon:reset()
		end
	end
	if stateField == 'Sub Mode' then
		if newValue ~= 'Normal' then
			state.CombatForm:set(newValue)
		else
			state.CombatForm:reset()
		end
	end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Get custom spell maps
function job_get_spell_map(spell, default_spell_map)
    if spell.skill == "Ninjutsu" then
        if not default_spell_map then
            if spell.target.type == 'SELF' then
                return 'NinjutsuBuff'
            else
				select_ammo_type('macc')
                return 'NinjutsuDebuff'
            end
        end
    end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if state.Buff.Migawari then
        idleSet = set_combine(idleSet, sets.buff.Migawari)
    end
    if state.Buff.Doom then
        idleSet = set_combine(idleSet, sets.buff.Doom)
    end
    return idleSet
end


-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
	if areas.Assault:contains(world.area) then
		meleeSet = set_combine(meleeSet, sets.Assault)
	end
	if state.Buff.Innin then
		meleeSet = set_combine(meleeSet, sets.buff.Innin)
	end
	if state.Buff.Yonin then
		meleeSet = set_combine(meleeSet, sets.buff.Yonin)
	end
    if state.Buff.Migawari then
        meleeSet = set_combine(meleeSet, sets.buff.Migawari)
    end
    if state.Buff.Doom then
        meleeSet = set_combine(meleeSet, sets.buff.Doom)
    end

    return meleeSet
end

-- Called by the default 'update' self-command.
function job_update(cmdParams, eventArgs)
	classes.CustomMeleeGroups:clear()
	if areas.Adoulin:contains(world.area) and buffactive.ionis then
			classes.CustomMeleeGroups:append('Adoulin')
	end
	pick_tp_weapon()
    select_movement_feet()
	select_ammo_type('melee')
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function job_handle_equipping_gear(status, eventArgs)
	-- add_to_chat(122,'handle equiping gear')
	check_tp_lock()
	set_combat_form()
	pick_tp_weapon()
	select_ammo_type('melee')
end

function select_movement_feet()
	if world.time >= 17*60 or world.time < 7*60 then
        gear.MovementFeet.name = gear.NightFeet
    else
        gear.MovementFeet.name = gear.DayFeet
    end
	-- add_to_chat(121,' select_movement_feet '..gear.MovementFeet.name)
end

function select_ammo_type(t)
	-- add_to_chat(121,' select ammo type '..state.RWeaponMode.value)
	-- add_to_chat(121,' ammo name '..gear.NinAmmo.name)
	-- add_to_chat(121,' ranged name '..gear.NinRanged.name)
	if state.RWeaponMode.value == "Stats" then
		if t == 'macc' then
			-- add_to_chat(121,' select ammo type '..t)
			gear.NinAmmo.name = gear.MaccAmmo
		else 
			-- add_to_chat(121,' select ammo type '..t)
			gear.NinAmmo.name = gear.StatsAmmo
		end
		gear.NinRanged.name = gear.empty
	elseif state.RWeaponMode.value == "Bow" then
		gear.NinAmmo.name = gear.BowAmmo
		gear.useWSAmmo.name = gear.BowAmmo
		gear.NinRanged.name = gear.BowRanged
	elseif state.RWeaponMode.value == "Gun" then
		gear.NinAmmo.name = gear.GunAmmo
		gear.useWSAmmo.name = gear.GunAmmo
		gear.NinRanged.name = gear.GunRanged
	elseif state.RWeaponMode.value == "Boomerrang" then
		gear.NinAmmo.name = gear.empty
		gear.useWSAmmo.name = gear.empty
		gear.NinRanged.name = gear.BoomerrangRanged
	elseif state.RWeaponMode.value == "Shuriken" then
		gear.NinAmmo.name = gear.Shuriken
		gear.useWSAmmo.name = gear.WSAmmo
		gear.NinRanged.name = gear.empty
	else
		gear.NinAmmo.name = gear.StatsAmmo
		gear.useWSAmmo.name = gear.WSAmmo
		gear.NinRanged.name = gear.empty
	end
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'DNC' then
		set_macro_page(3, 2)
	elseif player.sub_job == 'THF' then
		set_macro_page(5, 2)
	elseif player.sub_job == 'RUN' then
		set_macro_page(7, 2)
	else
		set_macro_page(1, 2)
	end
	send_command('exec nin.txt')
end

