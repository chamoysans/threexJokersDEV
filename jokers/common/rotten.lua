local jokerName = "rotten"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = jokerName, 
    config = {
      extra = {
        sell = 5,
        odds = 6
      }
    }, 
    pos = {x = 9, y = 7}, 
    loc_txt = {
      name = "Rotten Egg", 
      text = {
        "Increase sell value by {C:money}$#1#{} each",
        "round, {C:green}1 in #2#{} chance of setting",
        "sell value to {C:money}0{}",
      }
    }, 
    rarity = 1, 
    cost = 4, 
    order = 44,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, center)
      return {
        vars = {
          center.ability.extra.sell, center.ability.extra.odds
        }
      }
    end, 
    calculate = function(self, card, context)
      if (context.end_of_round) and (context.cardarea == G.jokers) and (not context.blueprint_card) and (card.ability.set == "Joker" and not card.debuff) then  
        
        local odds = {}
        for i = 1, card.ability.extra.odds do
          if i == card.ability.extra.odds then
            odds[i] = true
          else
            odds[i] = false
          end
        end

        local reset = pseudorandom_element(odds, pseudoseed('itstimeforthe'))

        if reset then
          card.ability.extra_value = 0
          card:set_cost()
          return {
              message = "Reset!",
              colour = G.C.MONEY
          }
        else
          card.ability.extra_value = card.ability.extra_value + card.ability.extra.sell
          card:set_cost()
          return {
              message = "+" .. tostring(card.ability.extra.sell) .. " Sell Value!",
              colour = G.C.MONEY
          }
        end

      end
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
                local rank = "6"

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