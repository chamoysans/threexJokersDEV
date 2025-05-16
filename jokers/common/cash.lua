local jokerName = "cash"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = jokerName, 
    config = {
      extra = {
        min = 2,
        max = 10
      }
    }, 
    pos = {x = 1, y = 2}, 
    loc_txt = {
      name = "Cash Joker", 
      text = {
        "Gives a random amount of ",
        "cash from {C:money}$#1#{} to {C:money}$#2#{},"
      }
    }, 
    rarity = 1, 
    cost = 2, 
    order = 55,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, center)
      return {
        vars = {
          center.ability.extra.min, center.ability.extra.max
        }
      }
    end, 
    calc_dollar_bonus = function(self, card)
      local possibleMoney = {}
      for i = card.ability.extra.min, card.ability.extra.max do
        possibleMoney[i - (card.ability.extra.min - 1)] = i
      end
      local money = pseudorandom_element(possibleMoney, pseudoseed('ilikeembigilikeemchunkey'))
      return money
    end,
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
    pos = {x = 1, y = 2},
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