require('functions')
include('closetCleaner')
-- Assault equip.
areas.Assault = S{
	"Mamool Ja Training Grounds",
	"Periqia",
	"Lebros Cavern",
	"Ilrusi Atoll",
	"Leujaoam Sanctum",
	"Arrapago Remnants",
	"Silver Sea Remnants",
	"Zhayolm Remnants",
	"Bhaflau Remnants",
	"Nyzul Isle",
	"The Ashu Talif"
}

-- Job info
jobs = {}

jobs.MP = S{
	"WHM",
	"RDM",
	"BLM",
	"BLU",
	"SMN",
	"GEO",
	"PLD",
	"DRK",
	"SCH"
}

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
	classes.CustomMeleeGroups:clear()
	pick_tp_weapon()
end

state.WeaponMode = M{['description'] = 'Weapon Mode'}
state.RWeaponMode = M{['description'] = 'RWeapon Mode'}
state.SubMode = M{['description'] = 'Sub Mode'}
state.Stance = M{['description'] = 'Stance'}
state.holdtp = M{['description'] = 'holdtp'}
state.loyalty = M{['description'] = 'loyalty'}
state.ElementMode = M{['description'] = 'elementmode'}

function set_stance()
	if state.Stance.value == 'Off' then
		state.Stance:set('None')
	elseif state.Stance.value == 'None' then
		state.Stance:set('Offensive')
	elseif state.Stance.value == 'Offensive' then
		state.Stance:set('Defensive')
	elseif state.Stance.value == 'Defensive' then
		state.Stance:set('Off')
	else
		state.Stance:set('None')
	end
end

function set_combat_weapon()
	if state.WeaponMode.value == 'Axe' then
		state.CombatWeapon:set('Axe')
	elseif state.WeaponMode.value == 'Club' then
		state.CombatWeapon:set('Club')
	elseif state.WeaponMode.value == 'Dagger' then
		state.CombatWeapon:set('Dagger')
	elseif state.WeaponMode.value == 'GreatAxe' then
		state.CombatWeapon:set('GreatAxe')
	elseif state.WeaponMode.value == 'GreatKatana' then
		state.CombatWeapon:set('GreatKatana')
	elseif state.WeaponMode.value == 'GreatSword' then
		state.CombatWeapon:set('GreatSword')
	elseif state.WeaponMode.value == 'H2H' then
		state.CombatWeapon:set('H2H')
	elseif state.WeaponMode.value == 'Katana' then
		state.CombatWeapon:set('Katana')
	elseif state.WeaponMode.value == 'Polearm' then
		state.CombatWeapon:set('Polearm')
	elseif state.WeaponMode.value == 'Scythe' then
		state.CombatWeapon:set('Scythe')
	elseif state.WeaponMode.value == 'Staff' then
		state.CombatWeapon:set('Staff')
	elseif state.WeaponMode.value == 'Sword' then
		state.CombatWeapon:set('Sword')
	else
		state.CombatWeapon:set('None')
	end
	-- add_to_chat(123, 'combat weapon set to '..state.CombatWeapon.value)
end

function set_combat_form()
	-- add_to_chat(123, 'Sub Mode set to  '..state.SubMode.value)
	if state.SubMode.value == 'DW' then
		state.CombatForm:set('DW')
	elseif state.SubMode.value == 'DWpet' then
		state.CombatForm:set('DWpet')
	elseif state.SubMode.value == 'Grip' then
		state.CombatForm:set('Grip')
	elseif state.SubMode.value == 'Shield' then
		state.CombatForm:set('Shield')
	elseif state.SubMode.value == 'TH' then
		state.CombatForm:set('TH')
	else
		state.CombatForm:set('None')
	end
	-- add_to_chat(123, 'combat Form set to '..state.CombatForm.value)
end

function set_ranged_weapon()
	classes.CustomMeleeGroups:clear()
	if state.RWeaponMode.value == 'Stats' then
		classes.CustomMeleeGroups:append('Stats')
	elseif state.RWeaponMode.value == 'Boomerrang' then
		classes.CustomMeleeGroups:append('Boomerrang')
	elseif state.RWeaponMode.value == 'Bow' then
		classes.CustomMeleeGroups:append('Bow')
	elseif state.RWeaponMode.value == 'Gun' then
		classes.CustomMeleeGroups:append('Gun')
	elseif state.RWeaponMode.value == 'Xbow' then
		classes.CustomMeleeGroups:append('Xbow')
	elseif state.RWeaponMode.value == 'Shuriken' then
		classes.CustomMeleeGroups:append('Shuriken')
	else
		classes.CustomMeleeGroups:append('None')
	end
	-- add_to_chat(123, 'Ranged weapon set to '..state.RWeaponMode.value)
end

function is_sc_element_today(spell)
	if spell.type ~= 'WeaponSkill' then
		return
	end
	local weaponskill_elements = S{}:
	union(skillchain_elements[spell.skillchain_a]):
	union(skillchain_elements[spell.skillchain_b]):
	union(skillchain_elements[spell.skillchain_c])
	if weaponskill_elements:contains(world.day_element) then
		return true
	else
		return false
	end
end

function is_magic_element_today(spell)
	-- if spell.skill ~= 'Elemental Magic' then
		-- return
	-- end
	-- add_to_chat(103,'spell'..spell.element..'weather'..world.weather_element..'day'..world.day_element)
	if spell.element == world.day_element then
		-- add_to_chat(101,'true')
		return true
	else
		-- add_to_chat(102,'false')
		return false
	end
end

function is_magic_element_weather(spell)
	-- add_to_chat(103,'spell'..spell.element..'weather'..world.weather_element..'day'..world.day_element)
	if spell.element == world.weather_element then
		-- add_to_chat(101,'true')
		return true
	else
		-- add_to_chat(102,'false')
		return false
	end
end


-- avoid losing tp
function check_tp_lock()
	if state.holdtp.value == 'true' then
		disable('main','sub','range')
	else
		if player.tp > 1000 or (buffactive['Aftermath: Lv.3'] or buffactive['Aftermath: Lv.2'] or buffactive['Aftermath: Lv.1']) then
			disable('main','sub','range')
		else
			enable('main','sub','range')
		end
	end
end

-- job automation if stance is set correctly (outside of town)
function handle_war_ja() 
	if not areas.Cities:contains(world.area) and not (buffactive.Sneak or buffactive.Invisible) then
		local abil_recasts = windower.ffxi.get_ability_recasts()
		if state.Stance.value == 'Offensive' or state.Stance.value == 'DmgTank' then
			if not buffactive.Berserk and player.status == "Engaged" and abil_recasts[1] == 0 then
				windower.send_command('@input /ja "Berserk" <me>')
				return
			end
			if not buffactive.Warcry and abil_recasts[2] == 0 and player.status == "Engaged" and player.tp > 900 then
				windower.send_command('@input /ja "Warcry" <me>')
				return
			end
			if not buffactive.Aggressor and abil_recasts[4] == 0 and player.status == "Engaged" then
				windower.send_command('@input /ja "Aggressor" <me>')
				return
			end
			if player.main_job == 'WAR' then
				if not buffactive.Restraint and abil_recasts[9] == 0 and player.status == "Engaged" then
					windower.send_command('@input /ja "Restraint" <me>')
					return
				end
				if not buffactive.BloodRage and abil_recasts[11] == 0 and player.status == "Engaged" then
					windower.send_command('@input /ja "Blood Rage" <me>')
					return
				end
			end
		end
		if state.Stance.value == 'Defensive' then
			if not buffactive.Defender and player.status == "Engaged" and abil_recasts[3] == 0 then
				windower.send_command('@input /ja "Defender" <me>')
				return
			end
			if not buffactive.Warcry and abil_recasts[2] == 0 and player.status == "Engaged" and player.tp > 900 then
				windower.send_command('@input /ja "Warcry" <me>')
				return
			end
			if player.main_job == 'WAR' then
				if not buffactive.Retaliation and abil_recasts[8] == 0 and player.status == "Engaged" then
					windower.send_command('@input /ja "Retaliation" <me>')
					return
				end
			end
		end
	end
end

-- the id #s for each abil come from the index value in abils.xml
function handle_sam_ja() 
	if not areas.Cities:contains(world.area) and not (buffactive.Sneak or buffactive.Invisible) then
		local abil_recasts = windower.ffxi.get_ability_recasts()
		if state.Stance.value == 'Offensive' then
			if not buffactive.Hasso and player.status == "Engaged" and abil_recasts[138] == 0 then
				windower.send_command('@input /ja "Hasso" <me>')
				return
			end
			if player.tp < 400 and abil_recasts[134] == 0 then
				windower.send_command('@input /ja "Meditate" <me>')
				return
			end
			if player.tp > 2000 and abil_recasts[140] == 0 and player.status == "Engaged" then
				windower.send_command('@input /ja "Sekkanoki" <me>')
				return
			end
			if not buffactive.ThirdEye and abil_recasts[133] == 0 and player.status == "Engaged" then
				windower.send_command('@input /ja "Third Eye" <me>')
				return
			end
		end
		if state.Stance.value == 'Defensive' then
			if not buffactive.Seigan and abil_recasts[139] == 0 then
				windower.send_command('@input /ja "Seigan" <me>')
				return
			end
			if not buffactive.ThirdEye and abil_recasts[133] == 0 then
				windower.send_command('@input /ja "Third Eye" <me>')
				return
			end
		end
	end
end


-- override Mote's defaults
function global_on_load()
	send_command('bind f9 gs c cycle OffenseMode')
	send_command('bind @f9 gs c cycle HybridMode') 
	send_command('bind ^f9 gs c cycle WeaponskillMode') --ctrl
	send_command('bind !f9 gs c cycle RangedMode') --alt
	send_command('bind f10 gs c cycle WeaponMode')
	send_command('bind ^f10 gs c cycle PhysicalDefenseMode') --cntl
	send_command('bind !f10 gs c cycle MagicalDefenseMode') --alt
	send_command('bind f11 gs c cycle SubMode')
	send_command('bind ^f11 gs c cycle CastingMode') --ctrl
	send_command('bind !f11 gs c toggle Kiting') --alt
	send_command('bind f12 gs c cycle RWeaponMode')
	send_command('bind ^f12 gs c cycle IdleMode') --ctrl
	send_command('bind !f12 gs c cycle DefenseMode') -- alt

	send_command('bind ^- gs c toggle selectnpctargets')
	send_command('bind ^= gs c cycle pctargetmode')
end

function handle_twilight()
    if not buffactive.Reraise then
        if player.hpp <= 22 or buffactive['Weakness'] then
            if Twilight == false then
                add_to_chat(1,'equip rr')
            end
            equip(sets.defense.Reraise)
            if player.equipment.body == "Twilight Mail" and player.equipment.head == "Twilight Helm" then
                disable('head','body')
                Twilight = true
                add_to_chat(1,'head and body disabled')
            end 
        else
            if Twilight == true then
                add_to_chat(2,'rr off')
            end
            Twilight = false
            enable('head','body')
        end
    else    
        Twilight = false
    end
end

function pick_tp_weapon()
	-- add_to_chat(122,' pick tp weapon '..state.WeaponMode.value)
	set_combat_weapon()
	set_ranged_weapon()
	-- add_to_chat(123, 'combat weapon set to '..state.CombatWeapon.value)
end

function check_ws_dist(spell)
	if player.status == 'Engaged' then
		if spell.type == 'WeaponSkill' and spell.target.distance > 5.1 then
			cancel_spell()
			add_to_chat(123, 'WeaponSkill Canceled: [Out of Range]')
		end
	end
end

degrade_tables = {}
degrade_tables.Aspir = {"Aspir","Aspir II","Aspir III"}
degrade_tables.Aero = {"Aero","Aero II","Aero III","Aero IV","Aero V","Aero VI"}
degrade_tables.Blizzard = {"Blizzard","Blizzard II","Blizzard III","Blizzard IV","Blizzard V","Blizzard VI"}
degrade_tables.Fire = {"Fire","Fire II","Fire III","Fire IV","Fire V","Fire VI"}
degrade_tables.Stone = {"Stone","Stone II","Stone III","Stone IV","Stone V","Stone VI"}
degrade_tables.Thunder = {"Thunder","Thunder II","Thunder III","Thunder IV","Thunder V","Thunder VI"}
degrade_tables.Water = {"Water","Water II","Water III","Water IV","Water V","Water VI"}
degrade_tables.Cure = {"Cure","Cure II","Cure III","Cure IV","Cure V","Cure VI"}
degrade_tables.Curaga = {"Curaga","Curaga II","Curaga III","Curaga IV","Curaga V"}
degrade_tables.Raise = {"Raise","Raise II","Raise III","Arise"}
degrade_tables.Reraise = {"Reraise","Reraise II","Reraise III","Reraise IV"}
degrade_tables.Regen = {"Regen","Regen II","Regen III","Regen IV","Regen V"}
degrade_tables.Aeroga = {"Aeroga","Aeroga II","Aeroga III"}
degrade_tables.Aeroja = {"Aeroga","Aeroga II","Aeroga III","Aeroja"}
degrade_tables.Blizzaga = {"Blizzaga","Blizzaga II","Blizzaga III"}
degrade_tables.Blizzaja = {"Blizzaga","Blizzaga II","Blizzaga III","Blizzaja"}
degrade_tables.Firaga = {"Firaga","Firaga II","Firaga III"}
degrade_tables.Firaja = {"Firaga","Firaga II","Firaga III","Firaja"}
degrade_tables.Stonega = {"Stonega","Stonega II","Stonega III"}
degrade_tables.Stoneja = {"Stonega","Stonega II","Stonega III","Stoneja"}
degrade_tables.Thundaga = {"Thundaga","Thundaga II","Thundaga III"}
degrade_tables.Thundaja = {"Thundaga","Thundaga II","Thundaga III","Thundaja"}
degrade_tables.Waterga = {"Waterga","Waterga II","Waterga III"}
degrade_tables.Waterja = {"Waterga","Waterga II","Waterga III","Waterja"}
degrade_tables.Aera = {"Aera","Aera II","Aera III"}
degrade_tables.Blizzara = {"Blizzara","Blizzara II","Blizzara III"}
degrade_tables.Fira = {"Fira","Fira II","Fira III"}
degrade_tables.Stonera = {"Stonera","Stonera II","Stonera III"}
degrade_tables.Thundara = {"Thundara","Thundara II","Thundara III"}
degrade_tables.Watera = {"Watera","Watera II","Watera III"}
degrade_tables.Utsusemi = {"Utsusemi: Ichi","Utsusemi: Ni","Utsusemi: San"}
degrade_tables.Katon = {"Katon: Ichi","Katon: Ni","Katon: San"}
degrade_tables.Hyoton = {"Hyoton: Ichi","Hyoton: Ni","Hyoton: San"}
degrade_tables.Huton = {"Huton: Ichi","Huton: Ni","Huton: San"}
degrade_tables.Doton = {"Doton: Ichi","Doton: Ni","Doton: San"}
degrade_tables.Raiton = {"Raiton: Ichi","Raiton: Ni","Raiton: San"}
degrade_tables.Suiton = {"Suiton: Ichi","Suiton: Ni","Suiton: San"}

function handle_spells(spell)
	-- add_to_chat(2, 'Casting '..spell.name)
    local spell_recasts = windower.ffxi.get_spell_recasts()
    if (spell_recasts[spell.recast_id]>0 or player.mp<actual_cost(spell)) and find_degrade_table(spell) then      
        degrade_spell(spell,find_degrade_table(spell))
    end
end
 
function find_degrade_table(lookup_spell)
	-- add_to_chat(2, 'lookupspell '..lookup_spell.name)
    for __,spells in pairs(degrade_tables) do
        for ___,spell in pairs(spells) do
            if spell == lookup_spell.english then
                return spells
            end
        end
    end
    return false
end
 
function degrade_spell(spell,degrade_array)
	-- add_to_chat(3, 'Degrading '..spell.name)
    local spell_index = table.find(degrade_array,spell.english)
	if spell_index>1 then        
        local new_spell = degrade_array[spell_index - 1]
        change_spell(new_spell,spell.target.id)
        add_to_chat(140,spell.english..' has been canceled. Using '..new_spell..' instead.')
    end
end
 
function change_spell(spellName,target)
    cancel_spell()
	-- add_to_chat(3, 'Canceled sending '..spellName..' to '..target)
    -- send_command(@input /ma "'..spellName..'" '..target)
    send_command(spellName:gsub('%s','')..' '..target)
end
 
function actual_cost(spell)
    local cost = spell.mp_cost
    if spell.type=="WhiteMage" then
        if buffactive["Penury"] then
            return cost*.5
        elseif buffactive["Light Arts"] or buffactive["Addendum: White"] then
            return cost*.9
        elseif buffactive["Dark Arts"] or buffactive["Addendum: Black"] then
            return cost*1.1
        end
    elseif spell.type=="BlackMagic" then
        if buffactive["Parsimony"] then
            return cost*.5
        elseif buffactive["Dark Arts"] or buffactive["Addendum: Black"] then
            return cost*.9
        elseif buffactive["Light Arts"] or buffactive["Addendum: White"] then
            return cost*1.1
        end   
    end
    return cost
end

function handle_debuffs()
	if buffactive['terror'] or buffactive['stun'] or buffactive['sleep'] or buffactive['lullaby'] then
        equip(sets.debuffed)
    end
    if buffactive.Doom then
        equip(sets.doom)
    end
end

function handle_useElement(cmdParams)
    -- cmdParams[1] == 'useElement'
    -- cmdParams[2] == type of spell to cast (ie nuke, helix, storm..)

    if not cmdParams[2] then
        add_to_chat(123,'Error: No spell type given.')
        return
    end
    local spellType = cmdParams[2]:lower()

    if state.ElementMode.value == 'dark' then
        if spellType == 'helix' then
            send_command('input /ma "Noctohelix II" <t>')
        elseif spellType == 'nuke' then
            send_command('input /ma "Bio II" <t>')
		elseif spellType == 'storm' then
            send_command('input /ma "Voidstorm II" <me>')
        else
            add_to_chat(122,'Error: Unknown spellType '..spellType)
        end
    elseif state.ElementMode.value == 'earth' then
        if spellType == 'helix' then
            send_command('input /ma "Geohelix II" <t>')
        elseif spellType == 'nuke' then
            send_command('input /ma "Stone V" <t>')
		elseif spellType == 'storm' then
            send_command('input /ma "Sandstorm II" <me>')
        else
            add_to_chat(122,'Error: Unknown spellType '..spellType)
        end
    elseif state.ElementMode.value == 'fire' then
        if spellType == 'helix' then
            send_command('input /ma "Pyrohelix II" <t>')
        elseif spellType == 'nuke' then
            send_command('input /ma "Fire V" <t>')
		elseif spellType == 'storm' then
            send_command('input /ma "Firestorm II" <me>')
        else
            add_to_chat(122,'Error: Unknown spellType '..spellType)
        end
    elseif state.ElementMode.value == 'ice' then
        if spellType == 'helix' then
            send_command('input /ma "Cryohelix II" <t>')
        elseif spellType == 'nuke' then
            send_command('input /ma "Blizzard V" <t>')
		elseif spellType == 'storm' then
            send_command('input /ma "Hailstorm II" <me>')
        else
            add_to_chat(122,'Error: Unknown spellType '..spellType)
        end
    elseif state.ElementMode.value == 'light' then
        if spellType == 'helix' then
            send_command('input /ma "Luminohelix II" <t>')
        elseif spellType == 'nuke' then
            send_command('input /ma "Dia II" <t>')
		elseif spellType == 'storm' then
            send_command('input /ma "Aurorastorm II" <me>')
        else
            add_to_chat(122,'Error: Unknown spellType '..spellType)
        end
    elseif state.ElementMode.value == 'thunder' then
        if spellType == 'helix' then
            send_command('input /ma "Ionohelix II" <t>')
        elseif spellType == 'nuke' then
            send_command('input /ma "Thunder V" <t>')
		elseif spellType == 'storm' then
            send_command('input /ma "Thunderstorm II" <me>')
        else
            add_to_chat(122,'Error: Unknown spellType '..spellType)
        end
    elseif state.ElementMode.value == 'water' then
        if spellType == 'helix' then
            send_command('input /ma "Hydrohelix II" <t>')
        elseif spellType == 'nuke' then
            send_command('input /ma "Water V" <t>')
		elseif spellType == 'storm' then
            send_command('input /ma "Rainstorm II" <me>')
        else
            add_to_chat(122,'Error: Unknown spellType '..spellType)
        end
    elseif state.ElementMode.value == 'wind' then
        if spellType == 'helix' then
            send_command('input /ma "Anemohelix II" <t>')
        elseif spellType == 'nuke' then
            send_command('input /ma "Aero V" <t>')
		elseif spellType == 'storm' then
            send_command('input /ma "Windstorm II" <me>')
        else
            add_to_chat(122,'Error: Unknown spellType '..spellType)
        end
    else
        add_to_chat(123,'ElementMode not set to a valid value.')
    end
end


