

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = jokerName, 
    config = {
      extra = {
      }
    }, 
    isSpud = true,
    pos = {x = 0, y = 4}, 
    loc_txt = {
      name = "Spud", 
      text = {
        "You can add card enhancements to this joker,",
      }
    }, 
    rarity = 1, 
    cost = 4, 
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, card)
      return {
        vars = {
          
        }
      }
    end, 
    --calculate = function(self, card, context)
    --end,
}

G.P_CENTERS["j_threex_" .. jokerName] = jokerThing

if testDecks then
  SMODS.Back {
    key = jokerName .. 'Deck',
    loc_txt = {
        name = jokerName,
        text = {
            "AT"
        }
    },
    config = {
    },
    name = jokerName .. "Deck",
    atlas = 'a_threex_sheet',
    pos = jokerThing.pos,
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
              for index = #G.playing_cards, 1, -1 do
                local suit = "S_"
                local rank = "7"

                G.playing_cards[index]:set_base(G.P_CARDS[suit .. rank])
              end

              SMODS.add_card({set = "Tarot", area = G.consumeables, key = 'c_chariot'})
              SMODS.add_card({set = "Tarot", area = G.consumeables, key = 'c_devil'})
              SMODS.add_card({set = "Tarot", area = G.consumeables, key = 'c_tower'})
              SMODS.add_card({set = "Tarot", area = G.consumeables, key = 'c_justice'})
              SMODS.add_card({set = "Tarot", area = G.consumeables, key = 'c_lovers'})
              SMODS.add_card({set = "Tarot", area = G.consumeables, key = 'c_empress'})
              SMODS.add_card({set = "Tarot", area = G.consumeables, key = 'c_magician'})

              add_joker("j_threex_" .. jokerName, nil, false, false)
              add_joker("j_threex_" .. jokerName, nil, false, false)
              add_joker("j_threex_" .. jokerName, nil, false, false)
              add_joker("j_threex_" .. jokerName, nil, false, false)
              add_joker("j_threex_" .. jokerName, nil, false, false)
              add_joker("j_threex_" .. jokerName, nil, false, false)
              add_joker("j_threex_" .. jokerName, nil, false, false)
                return true
            end
        }))
    end,
    unlocked = true,
  }  
end
