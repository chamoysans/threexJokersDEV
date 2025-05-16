local jokerName = "mana"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = jokerName, 
    config = {
      extra = {
        Xmult = 7,
        odds = 250
      }
    }, 
    pos = {x = 4, y = 6}, 
    loc_txt = {
      name = "Mana Banana", 
      text = {
        "{C:white,X:mult}x#1#{} Mult, {C:green}1 in #2#{}",
        "Chance to be eaten",
      }
    }, 
    yes_pool_flag = 'cavendish_or_saba_extinct',
    rarity = 1, 
    cost = 2, 
    order = 72,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, center)
      return {
        vars = {
          center.ability.extra.Xmult, center.ability.extra.odds,
        }
      }
    end, 
    calculate = function(self, card, context)
      if context.joker_main then
        return {
          message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
          Xmult_mod = card.ability.extra.Xmult
        }
      end
      if context.end_of_round and context.game_over == false and not context.repetition and not context.blueprint then
        if pseudorandom('manadabanana') < G.GAME.probabilities.normal / card.ability.extra.odds then
          G.E_MANAGER:add_event(Event({
            func = function()
              play_sound('tarot1')
              card.T.r = -0.2
              card:juice_up(0.3, 0.4)
              card.states.drag.is = true
              card.children.center.pinch.x = true
              G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.3,
                blockable = false,
                func = function()
                  G.jokers:remove_card(card)
                  card:remove()
                  card = nil
                  return true;
                end
              }))
              return true
            end
          }))
          return {
            message = 'Eaten!'
          }
        else
          return {
            message = 'Safe!'
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