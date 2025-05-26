local jokerName = "funnymoney"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = jokerName, 
    config = {
      extra = {
        multMin = 0.5,
        multMax = 1.5
      }
    }, 
    pos = {x = 4, y = 3}, 
    loc_txt = {
      name = "Funny Money", 
      text = {
        "At end of round, multiply",
        "cash-out value by a random",
        "number from {X:money,C:white}X0.5{} to {X:money,C:white}X1.5{},",
      }
    }, 
    rarity = 1, 
    cost = 2, 
    unlocked = true, 
    discovered = true, 
    blueprint_compat = false, 
    atlas = "a_threex_sheet",
    calc_dollar_bonus = function(self, card)

      local min_val = card.ability.extra.multMin
      local max_val = card.ability.extra.multMax

      local randomThing = round_number(min_val + (max_val - min_val) * math.random(), 2)
      print("3xJ | funnymoney.lua | " .. randomThing)
      return {randomThing, true}
    end,
    loc_vars = function(self, info_queue, card)
      return {
        vars = {
          card.ability.extra.multMin,
          card.ability.extra.multMax
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

              add_joker("j_threex_" .. jokerName, nil, false, false)
                return true
            end
        }))
    end,
    unlocked = true,
  }  
end