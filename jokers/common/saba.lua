local jokerName = "saba"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = jokerName, 
    config = {
      extra = {
        mult = 60,
        odds = 16
      }
    }, 
    pos = {x = 9, y = 4}, 
    loc_txt = {
      name = "Saba", 
      text = {
        "{C:mult}+#1#{} Mult, {C:green}1 in #2#{}",
        "Chance to be eaten",
      }
    }, 
    yes_pool_flag = 'gros_michel_extinct',
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
          center.ability.extra.mult, center.ability.extra.odds,
        }
      }
    end, 
    calculate = function(self, card, context)
      if context.joker_main then
        return {
          message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } },
          mult_mod = card.ability.extra.mult
        }
      end
      if context.end_of_round and context.game_over == false and not context.repetition and not context.blueprint then
        if pseudorandom('sabathesigma') < G.GAME.probabilities.normal / card.ability.extra.odds then
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
          G.GAME.pool_flags.threex_saba_eaten = true
          G.GAME.pool_flags.threex_cavendish_or_saba_extinct = true
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