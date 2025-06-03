function Card:gc()
	return (self.config or {}).center or {}
end

-- keys for mods are c_[mod prefix]_[planet key]

TXJ = { 
    stuff = {
        astral_sequence = {
            buffer = {

            },
            planets = {
                vanilla = {
                    {key = "c_mercury",   order = 1, unlocked = true},
                    {key = "c_venus",   order = 2, unlocked = true},
                    {key = "c_earth",   order = 3, unlocked = true},
                    {key = "c_mars",   order = 4, unlocked = true},
                    {key = "c_jupiter",   order = 5, unlocked = true},
                    {key = "c_saturn",   order = 6, unlocked = true},
                    {key = "c_uranus",   order = 7, unlocked = true},
                    {key = "c_neptune",   order = 8, unlocked = true},
                    {key = "c_pluto",   order = 9, unlocked = true},
                    hidden = {
                        {key = "c_ceres", after = "c_mars", hand_type = 'Flush House'},
                        {key = "c_eris", after = "c_pluto", hand_type = 'Flush Five'},
                        {key = "c_planet_x", after = "c_pluto", hand_type = 'Five of a Kind'},
                    },
                    wildcards = {
                        {key = "c_black_hole", order = 10000, wildcard = true},
                    }
                },
                
                built_in = {
                    cryptid = { -- i am NOT doing all that poker hand checking unlocked sh#t man
                        modData = {
                            mod_id = "Cryptid",
                            prefix = "cry",
                        },
                        items = {
                            {key = "marsmoons", after = "c_mars"},
                            {key = "asteroidbelt", after = "c_mars"},
                            {key = "sunplanet", before = "c_mercury"}, 
                            wildcards = {
                                {key = "planetlua", wildcard = true},
                                {key = "nstar", wildcard = true},
                                {key = "void", wildcard = true},
                                {key = "universe", wildcard = true},
                            }
                        }
                    },
                    jen = {  -- same as this one, i am NOT adding support for gamemodes that arent madness i- whatever,
                        modData = {
                            mod_id = "jen",
                            prefix = "jen",
                        },
                        items = {
    
                            -- i feel very bad for the jens almanac users like how they gonna scale this
    
                            {key = "moon", after = "c_earth"},
                            {key = "deimos", after = "c_mars"},
                            {key = "phobos", after = "c_deimos"},
                            {key = "pallas", after = "c_mars"},
                            {key = "vesta", after = "pallas"},
                            {key = "hygiea", after = "vesta"},
                            {key = "io", after = "c_jupiter"},
                            {key = "europa", after = "io"},
                            {key = "ganymede", after = "europa"},
                            {key = "mimas", after = "c_saturn"},
                            {key = "enceladus", after = "mimas"},
                            {key = "tethys", after = "enceladus"},
                            {key = "dione", after = "tethys"},
                            {key = "rhea", after = "dione"},
                            {key = "titan", after = "rhea"},
                            {key = "hyperion", after = "titan"},
                            {key = "iapetus", after = "hyperion"},
                            {key = "phoebe", after = "iapetus"}, -- time where fingers started to hurt
                            {key = "miranda", after = "c_uranus"},
                            {key = "ariel", after = "miranda"},
                            {key = "umbriel", after = "ariel"},
                            {key = "titania", after = "umbriel"},
                            {key = "oberon", after = "titania"},
                            {key = "orcus", after = "c_neptune"},
                            {key = "haumea", after = "orcus"},
                            {key = "namaka", after = "haumea"},
                            {key = "dysnomia", after = "c_eris"},
                            {key = "charon", after = "c_pluto"},
                            {key = "vanth", after = "orcus"},

                            wildcards = {
                                {key = "blankplanet", wildcard = true},
                                {key = "debris", wildcard = true},
                                {key = "comet", wildcard = true},
                                {key = "meteor", wildcard = true},
                                {key = "asteroid", wildcard = true},
                                {key = "voy1", wildcard = true},
                                {key = "nebula", wildcard = true},
                                {key = "satelite", wildcard = true, increment = false},
                            }
                        }
                    }
                }
            },
        }
    }
}

function TXJ.insertAfter(list, insert, after_key)
    for i, v in ipairs(list) do
        if v.key == after_key or v.name == after_key then
            table.insert(list, i + 1, insert)
            return { error = false, index = i + 1 }
        end
    end
    return { error = true, message = "key not found: " .. tostring(after_key) }
end

function TXJ.insertBefore(list, insert, before_key)
    for i, v in ipairs(list) do
        if v.key == before_key or v.name == before_key then
            table.insert(list, i, insert)
            return { error = false, index = i }
        end
    end
    return { error = true, message = "key not found: " .. tostring(before_key) }
end


--[[

todo:
- add support for both "after" and "before"
- add support for both "keys" (for mods) and names (for both mods and vanilla)
- add support for both "after" and "afterk" (after, but instead of names its keys)
- AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
- talk to my mind on why i did this (im too deep now i can't stop)

]]

TXJ.findItemFromList = function(item, list)
    for i, v in ipairs(list) do
      if v == item then return i end
    end
    return nil -- Not found
end

TXJ.add_astral_sequence = function(modData, t)
    TXJ.stuff.astral_sequence.buffer[modData.name] = {
        modData = modData,
        items = t,
    }
end

TXJ.get_astral_sequence = function()


    local base = TXJ.stuff.astral_sequence.planets.vanilla

    local current = {wildcards = {}}
    for i, v in ipairs(base) do
        current[i] = { key = v.key, order = v.order,}
    end

    if base.hidden then
        for _, entry in ipairs(base.hidden) do
            if G.GAME and G.GAME.hands and G.GAME.hands[entry.hand_type] and G.GAME.hands[entry.hand_type].visible then
                local ref = entry.after or entry.before
                local clone = { key = entry.name or entry.key, order = 0, hand_type = entry.hand_type }

                local refIndex
                for idx, item in ipairs(current) do
                    if item.key == ref then
                        refIndex = idx
                        clone.order = item.order + 1
                        break
                    end
                end

                if not refIndex then
                    error("Reference not found: " .. tostring(ref))
                end

                if entry.after then
                    local ref = entry.after
                    local refIndex = nil
                    for idx, item in ipairs(current) do
                      if item.key == ref then
                        refIndex = idx
                        clone.order = item.order + 1  -- Offset after reference
                        break
                      end
                    end
                    if refIndex then
                      table.insert(current, refIndex + 1, clone)
                    else
                      table.insert(current, clone)
                    end                  

                elseif entry.before then
                    local ref = entry.before
                    local refIndex = nil
                    for idx, item in ipairs(current) do
                      if item.key == ref then
                        refIndex = idx
                        clone.order = item.order  -- Same order, will appear before
                        break
                      end
                    end
                    if refIndex then
                      table.insert(current, refIndex, clone)
                    else
                      table.insert(current, 1, clone)
                    end
                else
                    error("No 'before' or 'after' spotted in: " .. entry.key)                  
                end
            elseif G.GAME and G.GAME.hands and not G.GAME.hands[entry.hand_type] then
                error("Hand Type '" .. entry.hand_type .. "' Does not exist.")
            elseif G.GAME and not G.GAME.hands then
                error("Somehow, Someway, G.GAME Exists and yet G.GAME.hands doesn't, So either you somehow made the hand table nil OR you just wanted to see this message.")
            elseif not G.GAME then
                error("Mod '" .. SMODS.current_mod .. "' Has called TXJ.get_astral_sequence when it isnt even in a run yet.")
            end
        end
    end

    if base.wildcards then
        for _, entry in ipairs(base.wildcards) do
            table.insert(
                current.wildcards,
                { key = entry.name or entry.key, order = #current + 1, wildcard = true }
            )
        end
    end

    for k, v in pairs(TXJ.stuff.astral_sequence.buffer) do -- mods turn

        local mod = v.modData

        local modItems = v.items

        if modItems.hidden then
            for _, entry in ipairs(modItems.hidden) do
                if G.GAME and G.GAME.hands and G.GAME.hands[entry.hand_type] then

                    entry.key = entry.key:sub(1,2) ~= "c_" and ("c_" .. mod.prefix .. "_" .. entry.key) or entry.key

                    local ref = entry.after or entry.before
                    local clone = { key = entry.name or entry.key, order = 0, hand_type = entry.hand_type}
    
                    local refIndex
                    for idx, item in ipairs(current) do
                        if item.key == ref then
                            refIndex = idx
                            clone.order = item.order + 1
                            break
                        end
                    end
    
                    if not refIndex then
                        error("Reference not found: " .. tostring(ref))
                    end
    
                    if entry.after then
                        local res = TXJ.insertAfter(current, clone, ref)
                        if res.error then error(res.message) end
    
                        for j = res.index + 1, #current do
                            current[j].order = current[j].order + 1
                        end
    
                    else
                        local res = TXJ.insertBefore(current, clone, ref)
                        if res.error then error(res.message) end
    
                        for j = 1, res.index - 1 do
                            current[j].order = current[j].order - 1
                        end
                    end
                end
            end
        end
    
        if modItems.wildcards then
            for _, entry in ipairs(modItems.wildcards) do
                entry.key = entry.key:sub(1,2) ~= "c_" and ("c_" .. mod.prefix .. "_" .. entry.key) or entry.key

                table.insert(
                    current.wildcards,
                    { key = entry.key, order = #current + 1, wildcard = true, increment = entry.increment or true }
                )
            end
        end
    end

    table.sort(current, function (a, b) return a.order < b.order end)

    return current
end

TXJ.get_next_astral_seq = function(oldkey)

    local seq = TXJ.get_astral_sequence()
    local n   = #seq

    if n == 0 then
        return nil
    end

    if oldkey == nil then
        return seq[1].key
    end

    for i, entry in ipairs(seq) do
        if entry.key == oldkey then

            local nextIndex = (i % n) + 1
            return {seq[nextIndex].key, G.P_CENTERS[seq[nextIndex].key].name}
        end
    end

    return nil
end


TXJ.next_astral_sequence = function(newkey, oldkey)
    local sequence = TXJ.get_astral_sequence()

    local nextt = sequence[1]
    
    local found = false

    for i = 1, #sequence do
        local v = sequence[i]
        print("TXJ | utils.lua | Astral Sequence Stuff | Key: " .. v.key .. ", newkey: " .. newkey .. ", oldkey: " .. tostring(oldkey))
        if found or (oldkey == nil and newkey == "c_mercury") or (newkey == sequence[#sequence].key and oldkey == sequence[#sequence - 1].key) then
            print("TXJ | utils.lua | Astral Sequence Stuff | Next Found! Will break")
            nextt = v
            break
        end
        if (v.key == oldkey) then
            print("TXJ | utils.lua | Astral Sequence Stuff | Found! Will look for next one")
            found = true
        end
    end

    if newkey == nextt.key or nextt.wildcard then
        return {true, newkey.increment or true}
    end

    print("TXJ | utils.lua | Astral Sequence Stuff | Does not match, newkey: " .. newkey .. ", nextt.key: " .. nextt.key)

    return {false}
    
end