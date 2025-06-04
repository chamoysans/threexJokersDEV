----------------------------------------
--                                    --
--            Hey Viewer!             --
--                                    --
--   So uhhh the actual joker code    --
--      is in the jokers folder,      --
--                                    --
--        If you need anything        --
--        else or want to ask         --
--        questions, DM me in         --
--         Discord: @taco78           --
--                                    --
----------------------------------------


local common = {
    "astral",
    "seenoevil",
    "speaknoevil",
    "hearnoevil",
    "jimmy",
    "clowncar",
    "funnymoney",
    "loot",
    "sharpshooter",
    "blank",
    "easter",
    "apple",
    "carto",
    "student",
    "fifth",
    "retriggerNum/firebrick",
    "retriggerNum/coral",
    "retriggerNum/golden",
    "retriggerNum/khaki",
    "retriggerNum/olive",
    "retriggerNum/seagreen",
    "retriggerNum/aqua",
    "retriggerNum/steel",
    "retriggerNum/slate",
    "retriggerNum/orchid",
    "skinny",
    "portly",
    "living",
    "surf",
    "atom",
    "chance",
    "mayan",
    "rotten",
    "wingdings",
    "acrylic",
    "nametag",
    "max",
    "tourist",
    "mardi",
    "construction",
    -- "rewards", developer note: why the heck is this more harder than wingdings and spud
    "chess",
    "cookie",
    "cash",
    "passport",
    "streamer",
    "potatoes/spud",
    "potatoes/battery",
    "potatoes/fries",
    "potatoes/skin",
    "potatoes/chips",
    "potatoes/eyes",
    "potatoes/earthly",
    "potatoes/glass",
    "potatoes/dumplings",
    "isolation",
    "whip",
    "bread",
    "saba",
    "pure",
    "mana",
    "returns",
    "love",
    "money",
    "jokertale",
    "fruit",
    "zathrax",
    "super",
    "motivational",
    "calendar",
    "celeb/lime",
    "celeb/licorice",
    "celeb/agent",
    "celeb/actor",
    "hook",
    "serpent",
    "pillar",
    "needle",
    "incognito",
    "red-joker",
    "big-spade",
    "big-club",
    "big-heart",
    "big-diamond",
}

SMODS.Atlas({
    key = "a_threex_placeholder",
    path = "placeholders.png",
    px = 71,
    py = 95
})

assert(SMODS.load_file("utils.lua"))()

local directory = "jokers/"

testDecks = true

debugLog = true

for _, filename in ipairs(common) do
    local filePath = directory .. "common/" .. filename .. ".lua"
    assert(SMODS.load_file(filePath))()

end

local oldIsFace = Card.is_face

function Card:is_face(from_boss)

    local ret = oldIsFace(self, from_boss)
    local id = self:get_id()

    if id == 11 or id == 12 or id == 13 then
        if next(SMODS.find_card('j_threex_isolation')) then
            return false
        end
        return ret
    end
    return ret
end

local oldGetXMult = Card.get_chip_x_mult

function Card:get_chip_x_mult(context)

    local ret = oldGetXMult(self, context)
    

    if next(SMODS.find_card('j_threex_acrylic')) and SMODS.has_enhancement(self, "m_glass") then
        return 1.5
    end

    return ret
end

local oldGetChipBonus = Card.get_chip_bonus

function Card:get_chip_bonus()
    local ret = oldGetChipBonus(self)

    if next(SMODS.find_card('j_threex_nametag')) and self:is_face() then
        return ret - self.base.nominal
    end
    return ret
end

local oldGetChipMult = Card.get_chip_mult

function Card:get_chip_mult()
    local ret = oldGetChipMult(self)

    if next(SMODS.find_card('j_threex_nametag')) and self:is_face() then
        return ret + 3
    end
    return ret
end

local old = Card.add_to_deck

function Card:add_to_deck(from_debuff)
    old(self, from_debuff)

    if not from_debuff then

        if self.ability.set == 'Joker' then
            if not from_debuff and G.jokers and #G.jokers.cards > 0 then
                for i = 1, #G.jokers.cards do
                    G.jokers.cards[i]:calculate_joker({threex_adding_unique_card = true, card = self})
                end
            end
        end
    end
end



if testDecks then
    SMODS.Back {
        key = 'studentDeck',
        loc_txt = {
            name = "Student",
            text = {
                "AT"
            }
        },
        name = "studentDeck",
        pos = {x = 1, y = 2},
        apply = function(self)
            G.E_MANAGER:add_event(Event({
                func = function()
      
                    add_joker("j_threex_student", nil, false, false)
                    return true
                end
            }))
        end,
        unlocked = true,
    } 
    
    SMODS.Back {
        key = 'sharpDeck',
        loc_txt = {
            name = "Sharpshooter",
            text = {
                "AT"
            }
        },
        name = "sharpDeck",
        pos = {x = 1, y = 2},
        apply = function(self)
            G.E_MANAGER:add_event(Event({
                func = function()
    
                    for index = #G.playing_cards, 1, -1 do
                    G.playing_cards[index]:set_ability(G.P_CENTERS.m_wild)
                    end
    
                    add_joker("j_threex_sharp", nil, false, false)
                    return true
                end
            }))
        end,
        unlocked = true,
    } 


    SMODS.Back {
        key = 'portlyDeck',
        loc_txt = {
            name = "Portly",
            text = {
                "AT"
            }
        },
        name = "portlyDeck",
        pos = {x = 1, y = 2},
        apply = function(self)
            G.E_MANAGER:add_event(Event({
                func = function()
      
                    add_joker("j_threex_portly", nil, false, false)
                    return true
                end
            }))
        end,
        unlocked = true,
      } 

      SMODS.Back {
        key = 'SkinnyDeck',
        loc_txt = {
            name = "Skinny",
            text = {
                "AT"
            }
        },
        name = "SkinnyDeck",
        pos = {x = 1, y = 2},
        apply = function(self)
            G.E_MANAGER:add_event(Event({
                func = function()
      
                    add_joker("j_threex_skinny", nil, false, false)
                    return true
                end
            }))
        end,
        unlocked = true,
      } 

      SMODS.Back {
        key = 'lootDeck',
        loc_txt = {
            name = "Loot",
            text = {
                "AT"
            }
        },
        name = "lootDeck",
        pos = {x = 1, y = 2},
        apply = function(self)
            G.E_MANAGER:add_event(Event({
                func = function()
      
                    add_joker("j_threex_loot", nil, false, false)
                    return true
                end
            }))
        end,
        unlocked = true,
      } 

      

      SMODS.Back {
        key = 'jimmyDeck',
        loc_txt = {
            name = "Jimmy",
            text = {
                "AT"
            }
        },
        name = "Jimmy",
        pos = {x = 1, y = 2},
        apply = function(self)
            G.E_MANAGER:add_event(Event({
                func = function()
      
                    add_joker("j_threex_jimmy", nil, false, false)
                    return true
                end
            }))
        end,
        unlocked = true,
      } 

      SMODS.Back {
        key = 'clownDeck',
        loc_txt = {
            name = "Clown Car",
            text = {
                "AT"
            }
        },
        name = "clownDeck",
        pos = {x = 1, y = 2},
        apply = function(self)
            G.E_MANAGER:add_event(Event({
                func = function()
      
                    add_joker("j_threex_clowncar", nil, false, false)
                    return true
                end
            }))
        end,
        unlocked = true,
      } 

      SMODS.Back {
        key = 'isolationDeck',
        loc_txt = {
            name = "Isolation",
            text = {
                "AT"
            }
        },
        name = "isolationDeck",
        pos = {x = 1, y = 2},
        apply = function(self)
            G.E_MANAGER:add_event(Event({
                func = function()

                    for index = #G.playing_cards, 1, -1 do
                        local suit = "S_"
                        local rank = "J"
    
                        G.playing_cards[index]:set_base(G.P_CARDS[suit .. rank])
                    end
      
                    add_joker("j_threex_isolation", "negative", false, false)
                    add_joker("j_ride_the_bus", "negative", false, false)
                    return true
                end
            }))
        end,
        unlocked = true,
      } 

      SMODS.Back {
        key = 'limeDeck',
        loc_txt = {
            name = "Lime",
            text = {
                "AT"
            }
        },
        name = "limeDeck",
        pos = {x = 1, y = 2},
        apply = function(self)
            G.E_MANAGER:add_event(Event({
                func = function()
                    for index = #G.playing_cards, 1, -1 do
                        local suit = "C_"
                        local rank = "T"
      
                        G.playing_cards[index]:set_base(G.P_CARDS[suit .. rank])
                    end
      
                    add_joker("j_threex_lime", nil, false, false)
                    return true
                end
            }))
        end,
        unlocked = true,
      } 

end
