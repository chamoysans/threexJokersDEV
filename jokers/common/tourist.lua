local jokerName = "tourist"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = "j_threex_" .. jokerName, 
    config = {
      extra = {
        mult = 4,
        chips = 30
      }
    }, 
    pos = {x = 6, y = 0}, 
    loc_txt = {
      name = "Tourist", 
      text = {
        "{C:chips}Bonus Cards{} give {C:mult}+#1#{} Mult,",
        "{C:mult}Mult Cards{} give {C:chips}+#2#{} Chips",
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
          center.ability.extra.mult, center.ability.extra.chips
        }
      }
    end, 
    calculate = function(self, card, context)
      if not context.end_of_round and context.individual and context.cardarea == G.play then
        if context.other_card.ability.effect == "Bonus Card" then
          return {
            message = "+" .. card.ability.extra.mult .. " Mult!",
            mult_mod = card.ability.extra.mult,
            colour = G.C.MULT,
          }
        end
  
        if context.other_card.ability.effect == "Mult Card" then
          return {
            message = "+" .. card.ability.extra.chips .. " Chips!",
            chip_mod = card.ability.extra.chips,
            colour = G.C.CHIPS,
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
      consumables = {
        'c_heirophant',
        'c_empress'
      }
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