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
	state.Buff.Barrage = buffactive.Barrage or false
	state.Buff.Camouflage = buffactive.Camouflage or false
	state.Buff['Unlimited Shot'] = buffactive['Unlimited Shot'] or false
	state.WeaponMode = M{['description']='Weapon Mode', 'Axe', 'Dagger', 'Staff', 'Club', 'Sword'}
	state.SubMode = M{['description']='Sub Mode', 'DW', 'Shield', 'Grip'}
	state.RWeaponMode = M{['description']='RWeapon Mode', 'Bow', 'Xbow', 'Gun'}
	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive'}
	state.holdtp = M{['description']='holdtp', 'false', 'true'}
	state.immuno = M{['description']='immuno', 'false', 'true'}
	set_combat_form()
	pick_tp_weapon()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'SB', 'sTP', 'STR', 'Eva', 'DT', 'Meva')
	state.DefenseMode:options('None', 'Physical', 'Magical')
	state.PhysicalDefenseMode:options('PDT', 'Evasion')
	state.MagicalDefenseMode:options('MDT')
	state.WeaponMode:set('Axe')
	state.Stance:set('Offensive')
	state.holdtp:set('false')
	state.immuno:set('false')
	state.SubMode:set('DW')
	state.RWeaponMode:set('Gun') 
	state.RangedMode:options('Normal', 'Acc')
	state.WeaponskillMode:options('Normal')
	
	gear.default.weaponskill_neck = "Ocachi Gorget"
    gear.hercTH = { name="Herculean Helm", augments={'Attack+13','"Snapshot"+3','"Treasure Hunter"+1','Accuracy+5 Attack+5',}}
    gear.hercAcc = { name="Herculean Helm", augments={'Accuracy+29','STR+6','Attack+3',}}
	
	DefaultAmmo = {['Yoichinoyumi'] = "Achiyalabopa arrow", ['Annihilator'] = "Achiyalabopa bullet"}
	U_Shot_Ammo = {['Yoichinoyumi'] = "Achiyalabopa arrow", ['Annihilator'] = "Achiyalabopa bullet"}

	set_combat_form()
	pick_tp_weapon()
	select_default_macro_book()

	send_command('bind f9 gs c cycle RangedMode')
	send_command('bind ^f9 gs c cycle OffenseMode')
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
	send_command('unbind f9')
	send_command('unbind ^f9')
end


-- Set up all gear sets.
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
		echos="Echo Drops",
		shihei="Shihei",
		orb="Macrocosmic Orb"
	}
	-- Idle sets
	sets.idle = {
		head="Null Masque",neck="Elite Royal Collar",lear="Alabaster Earring",rear="Infused Earring",
		body="Nyame Mail",hands="Nyame Gauntlets",ring1="Murky Ring",ring2="Patricius Ring",
		back="Solemnity Cape",waist="Null Belt",legs="Carmine Cuisses +1",feet="Orion Socks +2"}

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
        head="Malignance Chapeau",neck="Null Loop",lear="Sherida Earring",rear="Crep. Earring",
        body="Amini Caban +2",hands="Tatena. Gote +1",ring1="Epona's Ring",ring2="Hetairoi Ring",
        back="Null Shawl",waist="Sarissapho. Belt",legs="Carmine Cuisses +1",feet="Meg. Jam. +2"}
			
	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {
		head="Malignance Chapeau",neck="Null Loop",lear="Zennaroi Earring",rear="Amini Earring +1",
		body="Tatena. Harama. +1",hands="Tatena. Gote +1",ring1="Cacoethic Ring +1",ring2="Regal Ring",
		back="Null Shawl",waist="Null Belt",legs="Carmine Cuisses +1",feet="Meg. Jam. +2"})
	sets.Mode.Att= set_combine(sets.engaged, {
		head="Meghanada Visor +2",neck="Rep. Plat. Medal",lear="Bladeborn Earring",rear="Dudgeon Earring",
		body="Meg. Cuirie +2",hands="Meg. Gloves +2",ring1="Ilabrat Ring",ring2="Regal Ring",
		back="Phalangite Mantle",waist="Sulla Belt",legs="Carmine Cuisses +1",feet="Meg. Jam. +2"})
	sets.Mode.Crit = set_combine(sets.engaged, {head="Adhemar Bonnet",lear="Odr Earring",rear="Amini Earring +1",
		body="Mummu Jacket +2",hands="Mummu Wrists +2",ring1="Hetairoi Ring",ring2="Mummu Ring",
		legs="Mummu Kecks +2",feet="Thereoid Greaves"})
	sets.Mode.DA = set_combine(sets.engaged, {neck="Asperity Necklace",lear="Sherida Earring",rear="Brutal Earring",
		hands="Tatena. Gote +1",ring1="Epona's Ring",ring2="Hetairoi Ring",
		back="Null Shawl",waist="Sarissapho. Belt",legs="Meg. Chausses +2"})
	sets.Mode.SB = set_combine(sets.engaged, {head="Amini Gapette +1"})
	sets.Mode.sTP = set_combine(sets.engaged, {
		head="Malignance Chapeau",neck="Iskur Gorget",lear="Sherida Earring",rear="Crep. Earring",
        body="Tatena. Harama. +1",ring1="Ilabrat Ring",
		back="Null Shawl"})
	sets.Mode.STR = set_combine(sets.engaged, {
		head="Orion Beret +2",neck="Rep. Plat. Medal",lear="Sherida Earring",
		body="Amini Caban +2",hands="Meg. Gloves +2",ring1="Apate Ring",ring2="Regal Ring",
		back="Buquwik Cape",waist="Sailfi Belt +1",legs="Herculean Trousers",feet="Amini Bottillons +2"})
	sets.Mode.Eva = set_combine(sets.engaged, {
		head="Nyame Helm",lear="Infused Earring",rear="Eabani Earring",
		body="Nyame Mail",hands="Nyame Gauntlets",ring1="Vengeful Ring",ring2="Beeline Ring",
		back="Lupine Cape",waist="Null Belt",legs="Nyame Flanchard",feet="Nyame Sollerets"})
	sets.Mode.DT = set_combine(sets.engaged, {
		head="Nyame Helm",neck="Elite Royal Collar",lear="Alabaster Earring",
		body="Nyame Mail",hands="Nyame Gauntlets",ring1="Murky Ring",ring2="Patricius Ring",
		back="Belenus's Cape",waist="Plat. Mog. Belt",legs="Nyame Flanchard",feet="Nyame Sollerets"})
	sets.Mode.Meva = set_combine(sets.engaged, {
		head="Nyame Helm",neck="Elite Royal Collar",lear="Etiolation Earring",rear="Eabani Earring",
		body="Nyame Mail",hands="Nyame Gauntlets",ring1="Murky Ring",ring2="Vengeful Ring",
		back="Null Shawl",waist="Null Belt",legs="Nyame Flanchard",feet="Nyame Sollerets"})
		
	-- other Sets    
	sets.macc = {
		head="Malignance Chapeau",neck="Null Loop",lear="Crep. Earring",rear="Amini Earring +1",
		body="Amini Caban +2",hands="Nyame Gauntlets",ring1="Sangoma Ring",ring2="Mummu Ring",
		back="Null Shawl",waist="Null Belt",legs="Nyame Flanchard",feet="Amini Bottillons +2"}
	sets.PDL = {head="Malignance Chapeau",neck="Scout's Gorget +1",rear="Amini Earring +1",
		body="Amini Caban +2"}
	sets.empy = {head="Amini Gapette +1",
		body="Amini Caban +2",hands="Amini Glove. +1",
		legs="Amini Bragues +1",feet="Amini Bottillons +2"}

	-- Sets with weapons defined.
	sets.engaged.Axe = {}
	sets.engaged.Sword = {}
	sets.engaged.Staff = {}
	sets.engaged.Club = {}
	sets.engaged.Dagger = {}
	sets.engaged.DW = set_combine(sets.engaged, {})
	sets.engaged.Shield = set_combine(sets.engaged, {})
	sets.engaged.Grip = set_combine(sets.engaged, {})
	sets.engaged.DW.Axe = set_combine(sets.engaged, {main="Perun +1",sub="Kustawi +1"})
	sets.engaged.Shield.Axe = set_combine(sets.engaged, {main="Perun +1",sub="Nusku Shield"})
	sets.engaged.DW.Sword = set_combine(sets.engaged, {main="Naegling",sub="Kustawi +1"})
	sets.engaged.Shield.Sword = set_combine(sets.engaged, {main="Naegling",sub="Nusku Shield"})
	sets.engaged.DW.Club = set_combine(sets.engaged, {main="Warp Cudgel",sub="Kustawi +1"})
	sets.engaged.Shield.Club = set_combine(sets.engaged, {main="Warp Cudgel",sub="Nusku Shield"})
	sets.engaged.DW.Dagger = set_combine(sets.engaged, {main="Kustawi +1",sub="Perun +1"})
	sets.engaged.Shield.Dagger = set_combine(sets.engaged, {main="Kustawi +1",sub="Nusku Shield"})
	sets.engaged.Grip.Staff = set_combine(sets.engaged, {main="Gozuki Mezuki", sub="Bloodrain Strap"})
	--Add in appropriate Ranged weapons
	sets.ranged = {}
	sets.ranged.Bow = {range="Fail-Not",ammo="Chrono Arrow"}
	sets.ranged.Xbow = {range="Tsoa. Crossbow",ammo="Sleep Bolt"}
	sets.ranged.Gun = {range="Fomalhaut",ammo="Chrono Bullet"}
	
	sets.engaged.DW.Axe.Xbow = set_combine(sets.engaged.DW.Axe, sets.ranged.Xbow)
	sets.engaged.DW.Axe.Bow = set_combine(sets.engaged.DW.Axe, sets.ranged.Bow)
	sets.engaged.DW.Axe.Gun = set_combine(sets.engaged.DW.Axe, sets.ranged.Gun)
	sets.engaged.Shield.Axe.Xbow = set_combine(sets.engaged.Shield.Axe, sets.ranged.Xbow)
	sets.engaged.Shield.Axe.Bow = set_combine(sets.engaged.Shield.Axe, sets.ranged.Bow)
	sets.engaged.Shield.Axe.Gun = set_combine(sets.engaged.Shield.Axe, sets.ranged.Gun)
	sets.engaged.DW.Sword.Xbow = set_combine(sets.engaged.DW.Sword, sets.ranged.Xbow)
	sets.engaged.DW.Sword.Bow = set_combine(sets.engaged.DW.Sword, sets.ranged.Bow)
	sets.engaged.DW.Sword.Gun = set_combine(sets.engaged.DW.Sword, sets.ranged.Gun)
	sets.engaged.Shield.Sword.Xbow = set_combine(sets.engaged.Shield.Sword, sets.ranged.Xbow)
	sets.engaged.Shield.Sword.Bow = set_combine(sets.engaged.Shield.Sword, sets.ranged.Bow)
	sets.engaged.Shield.Sword.Gun = set_combine(sets.engaged.Shield.Sword, sets.ranged.Gun)
	sets.engaged.DW.Club.Xbow = set_combine(sets.engaged.DW.Club, sets.ranged.Xbow)
	sets.engaged.DW.Club.Bow = set_combine(sets.engaged.DW.Club, sets.ranged.Bow)
	sets.engaged.DW.Club.Gun = set_combine(sets.engaged.DW.Club, sets.ranged.Gun)
	sets.engaged.Shield.Club.Xbow = set_combine(sets.engaged.Shield.Club, sets.ranged.Xbow)
	sets.engaged.Shield.Club.Bow = set_combine(sets.engaged.Shield.Club, sets.ranged.Bow)
	sets.engaged.Shield.Club.Gun = set_combine(sets.engaged.Shield.Club, sets.ranged.Gun)
	sets.engaged.DW.Dagger.Xbow = set_combine(sets.engaged.DW.Dagger, sets.ranged.Xbow)
	sets.engaged.DW.Dagger.Bow = set_combine(sets.engaged.DW.Dagger, sets.ranged.Bow)
	sets.engaged.DW.Dagger.Gun = set_combine(sets.engaged.DW.Dagger, sets.ranged.Gun)
	sets.engaged.Shield.Dagger.Xbow = set_combine(sets.engaged.Shield.Dagger, sets.ranged.Xbow)
	sets.engaged.Shield.Dagger.Bow = set_combine(sets.engaged.Shield.Dagger, sets.ranged.Bow)
	sets.engaged.Shield.Dagger.Gun = set_combine(sets.engaged.Shield.Dagger, sets.ranged.Gun)
	
	sets.engaged.DW.Axe.Acc = set_combine(sets.engaged.DW.Axe, sets.Mode.Acc)
	sets.engaged.DW.Axe.Att = set_combine(sets.engaged.DW.Axe, sets.Mode.Att)
	sets.engaged.DW.Axe.Crit = set_combine(sets.engaged.DW.Axe, sets.Mode.Crit)
	sets.engaged.DW.Axe.DA = set_combine(sets.engaged.DW.Axe, sets.Mode.DA)
	sets.engaged.DW.Axe.SB = set_combine(sets.engaged.DW.Axe, sets.Mode.SB)
	sets.engaged.DW.Axe.sTP = set_combine(sets.engaged.DW.Axe, sets.Mode.sTP)
	sets.engaged.DW.Axe.STR = set_combine(sets.engaged.DW.Axe, sets.Mode.STR)
	sets.engaged.DW.Axe.Eva = set_combine(sets.engaged.DW.Axe, sets.Mode.Eva)
	sets.engaged.DW.Axe.DT = set_combine(sets.engaged.DW.Axe, sets.Mode.DT)
	sets.engaged.DW.Axe.Meva = set_combine(sets.engaged.DW.Axe, sets.Mode.Meva)
	sets.engaged.Shield.Axe.Acc = set_combine(sets.engaged.Shield.Axe, sets.Mode.Acc)
	sets.engaged.Shield.Axe.Att = set_combine(sets.engaged.Shield.Axe, sets.Mode.Att)
	sets.engaged.Shield.Axe.Crit = set_combine(sets.engaged.Shield.Axe, sets.Mode.Crit)
	sets.engaged.Shield.Axe.DA = set_combine(sets.engaged.Shield.Axe, sets.Mode.DA)
	sets.engaged.Shield.Axe.SB = set_combine(sets.engaged.Shield.Axe, sets.Mode.SB)
	sets.engaged.Shield.Axe.sTP = set_combine(sets.engaged.Shield.Axe, sets.Mode.sTP)
	sets.engaged.Shield.Axe.STR = set_combine(sets.engaged.Shield.Axe, sets.Mode.STR)
	sets.engaged.Shield.Axe.Eva = set_combine(sets.engaged.Shield.Axe, sets.Mode.Eva)
	sets.engaged.Shield.Axe.DT = set_combine(sets.engaged.Shield.Axe, sets.Mode.DT)
	sets.engaged.Shield.Axe.Meva = set_combine(sets.engaged.Shield.Axe, sets.Mode.Meva)
	
	sets.engaged.DW.Club.Acc = set_combine(sets.engaged.DW.Club, sets.Mode.Acc)
	sets.engaged.DW.Club.Att = set_combine(sets.engaged.DW.Club, sets.Mode.Att)
	sets.engaged.DW.Club.Crit = set_combine(sets.engaged.DW.Club, sets.Mode.Crit)
	sets.engaged.DW.Club.DA = set_combine(sets.engaged.DW.Club, sets.Mode.DA)
	sets.engaged.DW.Club.SB = set_combine(sets.engaged.DW.Club, sets.Mode.SB)
	sets.engaged.DW.Club.sTP = set_combine(sets.engaged.DW.Club, sets.Mode.sTP)
	sets.engaged.DW.Club.STR = set_combine(sets.engaged.DW.Club, sets.Mode.STR)
	sets.engaged.DW.Club.Eva = set_combine(sets.engaged.DW.Club, sets.Mode.Eva)
	sets.engaged.DW.Club.DT = set_combine(sets.engaged.DW.Club, sets.Mode.DT)
	sets.engaged.DW.Club.Meva = set_combine(sets.engaged.DW.Club, sets.Mode.Meva)
	sets.engaged.Shield.Club.Acc = set_combine(sets.engaged.Shield.Club, sets.Mode.Acc)
	sets.engaged.Shield.Club.Att = set_combine(sets.engaged.Shield.Club, sets.Mode.Att)
	sets.engaged.Shield.Club.Crit = set_combine(sets.engaged.Shield.Club, sets.Mode.Crit)
	sets.engaged.Shield.Club.DA = set_combine(sets.engaged.Shield.Club, sets.Mode.DA)
	sets.engaged.Shield.Club.SB = set_combine(sets.engaged.Shield.Club, sets.Mode.SB)
	sets.engaged.Shield.Club.sTP = set_combine(sets.engaged.Shield.Club, sets.Mode.sTP)
	sets.engaged.Shield.Club.STR = set_combine(sets.engaged.Shield.Club, sets.Mode.STR)
	sets.engaged.Shield.Club.Eva = set_combine(sets.engaged.Shield.Club, sets.Mode.Eva)
	sets.engaged.Shield.Club.DT = set_combine(sets.engaged.Shield.Club, sets.Mode.DT)
	sets.engaged.Shield.Club.Meva = set_combine(sets.engaged.Shield.Club, sets.Mode.Meva)

	sets.engaged.DW.Dagger.Acc = set_combine(sets.engaged.DW.Dagger, sets.Mode.Acc)
	sets.engaged.DW.Dagger.Att = set_combine(sets.engaged.DW.Dagger, sets.Mode.Att)
	sets.engaged.DW.Dagger.Crit = set_combine(sets.engaged.DW.Dagger, sets.Mode.Crit)
	sets.engaged.DW.Dagger.DA = set_combine(sets.engaged.DW.Dagger, sets.Mode.DA)
	sets.engaged.DW.Dagger.SB = set_combine(sets.engaged.DW.Dagger, sets.Mode.SB)
	sets.engaged.DW.Dagger.sTP = set_combine(sets.engaged.DW.Dagger, sets.Mode.sTP)
	sets.engaged.DW.Dagger.STR = set_combine(sets.engaged.DW.Dagger, sets.Mode.STR)
	sets.engaged.DW.Dagger.Eva = set_combine(sets.engaged.DW.Dagger, sets.Mode.Eva)
	sets.engaged.DW.Dagger.DT = set_combine(sets.engaged.DW.Dagger, sets.Mode.DT)
	sets.engaged.DW.Dagger.Meva = set_combine(sets.engaged.DW.Dagger, sets.Mode.Meva)
	sets.engaged.Shield.Dagger.Acc = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Acc)
	sets.engaged.Shield.Dagger.Att = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Att)
	sets.engaged.Shield.Dagger.Crit = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Crit)
	sets.engaged.Shield.Dagger.DA = set_combine(sets.engaged.Shield.Dagger, sets.Mode.DA)
	sets.engaged.Shield.Dagger.SB = set_combine(sets.engaged.Shield.Dagger, sets.Mode.SB)
	sets.engaged.Shield.Dagger.sTP = set_combine(sets.engaged.Shield.Dagger, sets.Mode.sTP)
	sets.engaged.Shield.Dagger.STR = set_combine(sets.engaged.Shield.Dagger, sets.Mode.STR)
	sets.engaged.Shield.Dagger.Eva = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Eva)
	sets.engaged.Shield.Dagger.DT = set_combine(sets.engaged.Shield.Dagger, sets.Mode.DT)
	sets.engaged.Shield.Dagger.Meva = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Meva)
	
	sets.engaged.DW.Sword.Acc = set_combine(sets.engaged.DW.Sword, sets.Mode.Acc)
	sets.engaged.DW.Sword.Att = set_combine(sets.engaged.DW.Sword, sets.Mode.Att)
	sets.engaged.DW.Sword.Crit = set_combine(sets.engaged.DW.Sword, sets.Mode.Crit)
	sets.engaged.DW.Sword.DA = set_combine(sets.engaged.DW.Sword, sets.Mode.DA)
	sets.engaged.DW.Sword.SB = set_combine(sets.engaged.DW.Sword, sets.Mode.SB, {})
	sets.engaged.DW.Sword.sTP = set_combine(sets.engaged.DW.Sword, sets.Mode.sTP)
	sets.engaged.DW.Sword.STR = set_combine(sets.engaged.DW.Sword, sets.Mode.STR)
	sets.engaged.DW.Sword.Eva = set_combine(sets.engaged.DW.Sword, sets.Mode.Eva)
	sets.engaged.DW.Sword.DT = set_combine(sets.engaged.DW.Sword, sets.Mode.DT)
	sets.engaged.DW.Sword.Meva = set_combine(sets.engaged.DW.Sword, sets.Mode.Meva)
	sets.engaged.Shield.Sword.Acc = set_combine(sets.engaged.Shield.Sword, sets.Mode.Acc)
	sets.engaged.Shield.Sword.Att = set_combine(sets.engaged.Shield.Sword, sets.Mode.Att)
	sets.engaged.Shield.Sword.Crit = set_combine(sets.engaged.Shield.Sword, sets.Mode.Crit)
	sets.engaged.Shield.Sword.DA = set_combine(sets.engaged.Shield.Sword, sets.Mode.DA)
	sets.engaged.Shield.Sword.SB = set_combine(sets.engaged.Shield.Sword, sets.Mode.SB, {})
	sets.engaged.Shield.Sword.sTP = set_combine(sets.engaged.Shield.Sword, sets.Mode.sTP)
	sets.engaged.Shield.Sword.STR = set_combine(sets.engaged.Shield.Sword, sets.Mode.STR)
	sets.engaged.Shield.Sword.Eva = set_combine(sets.engaged.Shield.Sword, sets.Mode.Eva)
	sets.engaged.Shield.Sword.DT = set_combine(sets.engaged.Shield.Sword, sets.Mode.DT)
	sets.engaged.Shield.Sword.Meva = set_combine(sets.engaged.Shield.Sword, sets.Mode.Meva)
	
	sets.engaged.Grip.Staff.Acc = set_combine(sets.engaged.Grip.Staff, sets.Mode.Acc)
			
	-- Weaponskill sets
	-- Default set for any weaponskill that isn't any more specifically defined
	sets.WSDayBonus = {} 
	sets.precast.WS = set_combine(sets.Mode.STR, {
        head="Orion Beret +2",neck="Fotia Gorget",lear="Ishvara Earring",
		hands="Meg. Gloves +2",ring1="Cornelia's Ring",ring2="Epaminondas's Ring",
        back="Belenus's Cape",waist="Fotia Belt",legs="Arc. Braccae +3",feet="Amini Bottillons +2"})    

	sets.precast.WS['Last Stand'] = set_combine(sets.precast.WS, {rear="Amini Earring +1",
		body="Amini Caban +2",ring2="Regal Ring"})
		
	sets.precast.WS['Apex Arrow'] = set_combine(sets.precast.WS, {rear="Amini Earring +1",
		body="Amini Caban +2",ring2="Regal Ring"})

	-- Precast sets to enhance JAs
	sets.precast.JA['Bounty Shot'] = {hands="Amini Glove. +1"}
	sets.precast.JA['Double Shot'] = {head="Amini Gapette +1",body="Arc. Jerkin +2",back="Belenus's Cape"}
	sets.precast.JA['Camouflage'] = {body="Hunter's Jerkin"}
	sets.precast.JA['Scavenge'] = {feet="Orion Socks +2"}
	sets.precast.JA['Shadowbind'] = {hands="Orion Bracers +1"}
	sets.precast.JA['Sharpshot'] = {legs="Orion Braccae +2"}
	sets.precast.JA['Eagle Eye Shot'] = {legs="Arc. Braccae +3"}
	sets.precast.JA['Unlimited Shot'] = {feet="Amini Bottillons +2"}

	-- Fast cast sets for spells
	sets.precast.FC = {
		head="Herculean Helm",neck="Orunmila's Torque",lear="Etiolation Earring",
		hands="Leyline Gloves",ring2="Prolix Ring",
        legs="Gyve Trousers"}

	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads",body="Passion Jacket"})

	-- Ranged sets (snapshot)
	sets.precast.RA = {
		head="Orion Beret +2",neck="Scout's Gorget +1",
		body="Arc. Jerkin +2",hands="Iuitl Wristbands",
		back="Lutian Cape",waist="Yemaya Belt",legs="Orion Braccae +2",feet="Meg. Jam. +2"}

	--------------------------------------
	-- Midcast sets
	--------------------------------------
	sets.midcast.Utsusemi = {}

	-- Ranged sets, use Ratt by default and can switch Racc as needed
	sets.midcast.RA = {
		head="Arcadian Beret +2",neck="Iskur Gorget",lear="Enervating Earring",rear="Crep. Earring",
		body="Amini Caban +2",hands="Meg. Gloves +2",ring1="Paqichikaji Ring",ring2="Cacoethic Ring +1",
		back="Belenus's Cape",waist="Eschan Stone",legs="Meg. Chausses +2",feet="Amini Bottillons +2"}
	
	sets.midcast.RA.Acc = set_combine(sets.midcast.RA,
		{head="Malignance Chapeau",neck="Null Loop",
		body="Amini Caban +2",hands="Meg. Gloves +2",ring1="Paqichikaji Ring",ring2="Cacoethic Ring +1",
		back="Null Shawl",waist="Null Belt",legs="Meg. Chausses +2"})

	-- Defense sets
	sets.defense = {}
	sets.defense.Evasion = set_combine(sets.Mode.Eva, {})
	sets.defense.PDT = set_combine(sets.Mode.DT, {})
	sets.defense.MDT = set_combine(sets.Mode.Meva, {})
	sets.debuffed = set_combine(sets.Mode.DT,sets.Mode.Meva)
	sets.doom = set_combine(sets.debuffed,{waist="Gishdubar Sash"})

	sets.Kiting = {legs="Carmine Cuisses +1",feet="Skd. Jambeaux +1"}

	--------------------------------------
	-- Custom buff sets
	--------------------------------------

	sets.buff.Barrage = set_combine(sets.midcast.RA.Acc, {hands="Orion Bracers +1"})
	sets.buff.Camouflage = {body="Hunter's Jerkin"}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
	if spell.action_type == 'Ranged Attack' then
		state.CombatWeapon:set(player.equipment.range)
	end

	if spell.action_type == 'Ranged Attack' or
	  (spell.type == 'WeaponSkill' and (spell.skill == 'Marksmanship' or spell.skill == 'Archery')) then
		check_ammo(spell, action, spellMap, eventArgs)
	end
	
	if state.DefenseMode.value ~= 'None' and spell.type == 'WeaponSkill' then
		-- Don't gearswap for weaponskills when Defense is active.
		eventArgs.handled = true
	end
end


-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
	if spell.action_type == 'Ranged Attack' and state.Buff.Barrage then
		equip(sets.buff.Barrage)
		eventArgs.handled = true
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
	if buff == "Camouflage" then
		if gain then
			equip(sets.buff.Camouflage)
			disable('body')
		else
			enable('body')
		end
	end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)

end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Check for proper ammo when shooting or weaponskilling
function check_ammo(spell, action, spellMap, eventArgs)
	-- Filter ammo checks depending on Unlimited Shot
	if state.Buff['Unlimited Shot'] then
		if player.equipment.ammo ~= U_Shot_Ammo[player.equipment.range] then
			if player.inventory[U_Shot_Ammo[player.equipment.range]] or player.wardrobe[U_Shot_Ammo[player.equipment.range]] then
				add_to_chat(122,"Unlimited Shot active. Using custom ammo.")
				equip({ammo=U_Shot_Ammo[player.equipment.range]})
			elseif player.inventory[DefaultAmmo[player.equipment.range]] or player.wardrobe[DefaultAmmo[player.equipment.range]] then
				add_to_chat(122,"Unlimited Shot active but no custom ammo available. Using default ammo.")
				equip({ammo=DefaultAmmo[player.equipment.range]})
			else
				add_to_chat(122,"Unlimited Shot active but unable to find any custom or default ammo.")
			end
		end
		equip(sets.precast.JA['Unlimited Shot'])
	else
		if player.equipment.ammo == U_Shot_Ammo[player.equipment.range] and player.equipment.ammo ~= DefaultAmmo[player.equipment.range] then
			if DefaultAmmo[player.equipment.range] then
				if player.inventory[DefaultAmmo[player.equipment.range]] then
					add_to_chat(122,"Unlimited Shot not active. Using Default Ammo")
					equip({ammo=DefaultAmmo[player.equipment.range]})
				else
					add_to_chat(122,"Default ammo unavailable.  Removing Unlimited Shot ammo.")
					equip({ammo=empty})
				end
			else
				add_to_chat(122,"Unable to determine default ammo for current weapon.  Removing Unlimited Shot ammo.")
				equip({ammo=empty})
			end
		elseif player.equipment.ammo == 'empty' then
			if DefaultAmmo[player.equipment.range] then
				if player.inventory[DefaultAmmo[player.equipment.range]] then
					add_to_chat(122,"Using Default Ammo")
					equip({ammo=DefaultAmmo[player.equipment.range]})
				else
					add_to_chat(122,"Default ammo unavailable.  Leaving empty.")
				end
			else
				add_to_chat(122,"Unable to determine default ammo for current weapon.  Leaving empty.")
			end
		-- elseif player.inventory[player.equipment.ammo].count < 15 then
			-- add_to_chat(122,"Ammo '"..player.inventory[player.equipment.ammo].shortname.."' running low ("..player.inventory[player.equipment.ammo].count..")")
		end
	end
end

function job_handle_equipping_gear(playerStatus, eventArgs)
	-- add_to_chat(122,'handle equiping gear')
	check_tp_lock()
	set_combat_form()
	pick_tp_weapon()
end

function job_update(cmdParams, eventArgs)
	classes.CustomMeleeGroups:clear()
	if areas.Adoulin:contains(world.area) and buffactive.ionis then
			classes.CustomMeleeGroups:append('Adoulin')
	end
	pick_tp_weapon()
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	set_macro_page(1, 16)
end
