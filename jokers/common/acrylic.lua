local jokerName = "acrylic"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = "j_threex_" .. jokerName, 
    config = {
      extra = {
        in_build = false
      }
    }, 
    pos = {x = 2, y = 10},
    soul_pos = {x = 2, y = 9},
    loc_txt = {
      name = "Acrylic Joker", 
      text = {
        "{C:inactive}Glass Cards{} do not break, and",
        "give {X:mult,C:white}X1.5{} mult instead of {X:mult,C:white}X2{}"
      }
    }, 
    rarity = 1, 
    cost = 7, 
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, center)
      return {
        vars = {
          
        }
      }
    end, 
    add_to_deck = function(self, card, from_debuff)
      card.ability.extra.in_build = true
      G.GAME.probabilities.glass = 0
    end,
    update = function(self, card, dt)
      if card.ability.extra.in_build then
        G.GAME.probabilities.glass = 0
      end
    end,
    calculate = function(self, card, context)
      if card.ability.extra.in_build then
        G.GAME.probabilities.glass = 0
      end
    end,
    remove_from_deck = function(self, card, from_debuff)
      card.ability.extra.in_build = false
      G.GAME.probabilities.glass = G.GAME.probabilities.normal
    end
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
                G.playing_cards[index]:set_ability(G.P_CENTERS.m_glass)
              end

              add_joker("j_threex_" .. jokerName, nil, false, false)
              add_joker("j_oops", nil, false, false)
                return true
            end
        }))
    end,
    unlocked = true,
  }  
end
