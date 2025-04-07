local jokerName = "fruit"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = "j_threex_" .. jokerName, 
    config = {
      extra = {
        gainMult = 2,
        current = 0,
        lastHand = '',
        currentHand = '',
      }
    }, 
    pos = {x = 3, y = 3}, 
    loc_txt = {
      name = "Fruit & Cheese Platter", 
      text = {
        "Gain {C:mult}+#1#{} Mult if hand is",
        "different from the last,", -- we do a little trolling
        "{C:inactive}Currently: +#2# Mult{}",
      }
    }, 
    rarity = 1, 
    cost = 2, 
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, center)
      return {
        vars = {
          center.ability.extra.gainMult, center.ability.extra.current
        }
      }
    end, 
    calculate = function(self, card, context)
      if context.joker_main then
        return {
          message = "+" .. card.ability.extra.current .. " Mult!",
          mult_mod = card.ability.extra.current,
          colour = G.C.MULT
        }
      end
      if context.before and not context.blueprint then
        card.ability.extra.lastHand = card.ability.extra.currentHand
        card.ability.extra.currentHand, _ = G.FUNCS.get_poker_hand_info(G.hand.highlighted)

        if card.ability.extra.lastHand == card.ability.extra.currentHand then
          card.ability.extra.current = card.ability.extra.current + card.ability.extra.gainMult

          return {
            message = "+" .. card.ability.extra.gainMult .. " Mult!",
            colour = G.C.MULT
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