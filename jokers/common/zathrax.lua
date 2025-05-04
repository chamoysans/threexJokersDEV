local jokerName = "zathrax"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = "j_threex_" .. jokerName, 
    config = {
      extra = {
        hands = 3,
      }
    }, 
    pos = {x = 3, y = 10}, 
    loc_txt = {
      name = "Zathrax, the Hand God", 
      text = {
        "When sold, gain {C:blue}#1#{} hands",
        "and reshuffle the deck,",
      }
    }, 
    rarity = 1, 
    cost = 7, 
    order = 14,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, center)
      return {
        vars = {
          center.ability.extra.hands
        }
      }
    end, 
    calculate = function(self, card, context)
      if context.selling_self and not context.retrigger_joker and not context.blueprint_card then
        ease_hands_played(3, false)

        delay(0.3)

       
		    G.FUNCS.draw_from_discard_to_deck()
        
        for k, v in pairs(G.playing_cards) do
          v.ability.wheel_flipped = nil
        end
        G.E_MANAGER:add_event(Event({
          trigger = "immediate",
          func = function()
            local oldState = G.STATE
            G.STATE = G.STATES.DRAW_TO_HAND
            G.deck:shuffle("everydayamshuffling" .. G.GAME.round_resets.ante)
            G.deck:hard_set_T()
            G.STATE_COMPLETE = false
            G.STATE = oldState
            
            return true
          end,
        }))
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