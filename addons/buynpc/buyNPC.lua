require('tables')
require('chat')
require('logger')
require('functions')
packets = require('packets')
json  = require('json')
files = require('files')
config = require('config')
res = require('resources')
require('pack')
bit = require('bit')
res_items = require('resources').items

_addon.name = 'BuyNPC'
_addon.author = 'onedough83'
_addon.version = '1.0.6'
_addon.command = 'buynpc'
_addon.commands = {'buy'}

local inventory_file_path = windower.addon_path..'known_items.lua'
local known_items = T{}
local requested_item = T{}
local npc_target = nil
local busy = false;
local continue = false;
local co = nil


do
    if windower.file_exists(inventory_file_path) then
        known_items = dofile(inventory_file_path)
    end
end

function get_item_res(item)
    -- Same as in SellNPC.lua
    local item_lower = item:lower();
    
    -- convert all known_items to lower case before comparison
    for k,v in pairs(known_items) do
        known_items[k:lower()] = v
    end

    if(not known_items[item_lower]) then
        windower.add_to_chat('10','This item is not in your known items table, please update your inventory file and redo purchase.')
        return nil
    end

    return known_items[item_lower]

end

function valid_target(npc)
    if math.sqrt(npc.distance) < 10 and npc.valid_target and npc.is_npc and bit.band(npc.spawn_type, 0xDF) == 2 then
        return true
    end
    return false
end

function make_npc_packet(npc_name)
	local result = {}
    local target_index = nil
    local target_id = nil
    local valid_npc = nil

    for index, npc in pairs(windower.ffxi.get_mob_array()) do
        if npc and npc.name:ieq(npc_name) then
            
            found = 1
            valid_npc = valid_target(npc)
			target_index = index
			target_id = npc.id
			npc_name = npc.name
			-- windower.add_to_chat(8,npc_name..' Found! Distance:'..math.sqrt(distance))
        end
    end


    if found == 1 then 
		if valid_npc then
			result['target'] = target_id
			result['target_index'] = target_index
			result['Zone'] =  windower.ffxi.get_info()['zone'] 
		else
			windower.add_to_chat(10,"Not close enough to "..npc_name)
			result = nil
		end
	else
		windower.add_to_chat(8,npc_name.." Not Found!")
	end

    return result;
end

function select_npc(npc)
    if npc.target and npc.target_index then
        busy = true
        local packet = packets.new('outgoing', 0x01A, {
            ['Target'] = npc.target,
            ['Target Index'] = npc.target_index,
            ['Category'] = 0,
            ['Param'] = 0,
            ['_unknown1'] = 0
        })

        packets.inject(packet)
    end
end

function menu_selection(npc, item)
    -- Construct the 0x05B packet
    local packet_05b = packets.new('outgoing', 0x05B)
    packet_05b['Target'] = npc.target
    packet_05b['Target Index'] = npc.target_index
    packet_05b['Option Index'] = item['Option Index']
    packet_05b['_unknown1'] = item['_unknown1']
    packet_05b['_unknown2'] = item['_unknown2']
    packet_05b['Menu ID'] = item['Menu ID']
    packet_05b['Zone'] =  windower.ffxi.get_info()['zone']
    packet_05b['Automated Message'] = item['Automated Message']
    -- -- Inject the 0x05B packet
    packets.inject(packet_05b)

    local packet_05b = packets.new('outgoing', 0x05B)
    packet_05b['Target'] = npc.target
    packet_05b['Target Index'] = npc.target_index
    packet_05b['Option Index'] = 0
    packet_05b['unknown1'] = 16384
    packet_05b['unknown2'] = 0
    packet_05b['Automated Message'] = false
    packet_05b['Zone'] =  windower.ffxi.get_info()['zone']
    packet_05b['Menu ID'] = item['Menu ID']
    packets.inject(packet_05b)

    local packet_016 = packets.new('outgoing', 0x016, {
        ['Target Index'] = item.target_index
    })
    packets.inject(packet_016)
end

function submission_request()
    -- Construct the 0x03A packet
    local packet_03a = packets.new('outgoing', 0x03A, {
        -- No additional fields are necessary
    })
    -- Inject the 0x03A packet
    packets.inject(packet_03a)
    busy = false
end

function buy_npc(target, item)
    if not target then
        print('NPC not found')
        return
    end

    if item then
        select_npc(target)
    else
        print('Item not found')
    end
end

function determine_quantity(quantity)
    if quantity == 'full' then
        return count_inv()
    end
    
    return tonumber(quantity)
end


function count_inv()
	local playerinv = windower.ffxi.get_items().inventory
	local freeslots = playerinv.max - playerinv.count
	return freeslots
end

function buy_item_multiple_times(npc_name, item, count )
    local target = make_npc_packet(npc_name)
    npc_target = target
    continue = true
    co = coroutine.create(function()
        for i = 1, count do
            -- Make sure you havent moved too far from npc before each purchase
            for index, npc in pairs(windower.ffxi.get_mob_array()) do
                if npc and npc.name:ieq(npc_name) then
                    if not valid_target(npc) then
                        windower.add_to_chat(7, 'You have moved too far from npc, purchases have stopped...')
                        continue = false
                        break
                    end
                end
            end
            if(not continue) then
                break
            end

            buy_npc(target, item)
            windower.add_to_chat(10, 'Buying item ' .. i .. ' of ' .. count)
            coroutine.yield()
        end
        continue = false
       
    end)
end

windower.register_event('addon command', function(...)
    local args = {...}
    if #args < 1 then
        windower.add_to_chat(10, 'Usage: //buy npc_name item_name quantity')
        return
    end

    local cmd = args[1]:lower()

    if cmd == 'pause' then
        -- Stop the current operation
        pause_buying()
        return
    elseif cmd == 'resume' then
        -- Resume the current operation
        resume_buying()
        return
    elseif cmd == 'stop' then
        stop_buying()
        return
    elseif cmd == 'r' then
        -- Reload the script
        windower.send_command('lua r buynpc')
        return
    end

    if #args < 3 then
        windower.add_to_chat(10, 'Usage: //buy npc_name item_name quantity')
        return
    end

    if windower.ffxi.get_mob_by_target('me').status ~= 0 then return end
    
    local target_name = args[1]
    local item_name = args[2]
    local item = get_item_res(item_name)
    local qty = determine_quantity(args[3])
    requested_item = item

    buy_item_multiple_times(target_name, item, qty)
end)

-- Function to stop the current operation
function stop_buying()
    -- Stop the current operation
    continue = false
    -- Clean up any resources or states here
    -- For example, if you're using a coroutine:
    if co ~= nil then
        co = nil
    end
    windower.add_to_chat(7, 'Stopped buying. Please enter a new buy command to start buying again.')
end

function pause_buying()
    -- Set a flag to stop the buying process
    continue = false
    windower.add_to_chat(7, 'Buying process paused')
end

function resume_buying()
    -- Set a flag to stop the buying process
    continue = true
    windower.add_to_chat(7, 'Buying process resumed')
end


windower.register_event('incoming chunk',function(id,data,modified,injected,blocked)
    if id == 0x034 then -- fire on npc release (when you are able to move)
        if busy == true and requested_item then
            menu_selection(npc_target, requested_item)
            submission_request()

            return true
        end
    end
	
end)

-- Resume the coroutine after a delay
windower.register_event('time change', function(new, old)
    if new % 1 == 0 and continue then  -- Every second
        if co ~= nil and coroutine.status(co) ~= 'dead' then
            local success, message = coroutine.resume(co)
            if not success then
                print('Error resuming coroutine:', message)
            end
        else
            print('Coroutine has finished execution and cannot be resumed.')
            co = nil
        end
    end
end)
