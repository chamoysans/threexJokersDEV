local jokerName = "pure"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = "j_threex_" .. jokerName, 
    config = {
      extra = {
        gainMult = 10,
        mult = 10
      }
    }, 
    yes_pool_flag = 'threex_saba_eaten',
    pos = {x = 7, y = 7}, 
    loc_txt = {
      name = "Pure Potassium", 
      text = {
        "{C:mult}+#1#{} Mult, Gains",
        "{C:mult}+#2#{} Mult when a", -- we do a little trolling
        "Small blind is defeated,"
      }
    }, 
    rarity = 1, 
    cost = 2, 
    order = 14,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, center)
      return {
        vars = {
          center.ability.extra.mult, center.ability.extra.gainMult
        }
      }
    end, 
    calculate = function(self, card, context)
      if context.cardarea == G.jokers and context.joker_main then
        return {
          message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
          mult_mod = card.ability.extra.mult,
          colour = G.C.MULT
        }
      end

      if context.end_of_round and context.game_over == false and G.GAME.blind:get_type() == 'Small' then
        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gainMult
        return {
          message = "+" .. card.ability.extra.gainMult .. " Mult!"
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

              add_joker("j_threex_bread", nil, false, false)
                return true
            end
        }))
    end,
    unlocked = true,
  }  
end