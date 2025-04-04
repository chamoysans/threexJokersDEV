local jokerName = "apple"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = "j_threex_" .. jokerName, 
    config = {
      extra = {
        mult = 8,
        hands = 16,
        currentHands = 16
      }
    }, 
    pos = {x = 1, y = 0}, 
    loc_txt = {
      name = "Apple Cider", 
      text = {
        "{C:mult}+#1#{} Mult for #2# Hands,",
        "{C:inactive}Currently: #3# Hands left{}",
      }
    }, 
    rarity = 1, 
    cost = 2, 
    order = 17,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, center)
      return {
        vars = {
          center.ability.extra.mult, center.ability.extra.hands, center.ability.extra.currentHands
        }
      }
    end, 
    calculate = function(self, card, context)
      if context.after and not context.blueprint then
        if card.ability.extra.currentHands - 1 <= 0 then 
          G.E_MANAGER:add_event(Event({
              func = function()
                  play_sound('tarot1')
                  card.T.r = -0.2
                  card:juice_up(0.3, 0.4)
                  card.states.drag.is = true
                  card.children.center.pinch.x = true
                  G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                      func = function()
                              G.jokers:remove_card(card)
                              card:remove()
                              card = nil
                          return true; end})) 
                  return true
              end
          })) 
          return {
              message = '',
              colour = G.C.CHIPS
          }
        else
            card.ability.extra.currentHands = card.ability.extra.currentHands - 1
            return {
                message = "-1 Hands", 
                colour = G.C.CHIPS
            }
        end
      end

      if context.cardarea == G.jokers and context.joker_main then
        return {
          message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
          mult_mod = card.ability.extra.mult, 
          colour = G.C.MULT
      }
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