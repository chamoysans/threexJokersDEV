local jokerName = "construction"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = jokerName, 
    config = {
      extra = {
        mult = 7,
      }
    }, 
    pos = {x = 8, y = 2}, 
    loc_txt = {
      name = "Construction Joker", 
      text = {
        "{C:mult}+#1#{} Mult when a {C:attention}Stone{}",
        "{C:attention}Card{} is Scored,"
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
          center.ability.extra.mult
        }
      }
    end, 
    calculate = function(self, card, context)
      if context.individual and context.cardarea == G.play then
        local thunk = context.other_card
        if thunk.ability.set == 'Enhanced' and SMODS.has_enhancement(thunk, "m_stone")then
          return {
            message = "+" .. card.ability.extra.mult .. " Mult!",
            mult_mod = card.ability.extra.mult,
            colour = G.C.MULT,
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
                G.playing_cards[index]:set_ability(G.P_CENTERS.m_stone)
              end

              add_joker("j_threex_" .. jokerName, nil, false, false)
                return true
            end
        }))
    end,
    unlocked = true,
  }  
end