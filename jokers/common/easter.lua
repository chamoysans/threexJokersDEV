local jokerName = "easter"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = "j_threex_" .. jokerName, 
    config = {
      extra = {
        mult = 1,
        current = 0,
      }
    }, 
    pos = {x = 2, y = 3}, 
    loc_txt = {
      name = "Easter Eggs", 
      text = {
        "{C:mult}+#1#{} Mult for each ",
        "unique joker purchased this run,",
        "{C:inactive}Currently: +#2# Mult{}",
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
          center.ability.extra.mult, center.ability.extra.current
        }
      }
    end, 
    calculate = function(self, card, context)
      if context.cardarea == G.jokers and context.joker_main then
        return {
          message = localize{type='variable',key='a_mult',vars={card.ability.extra.current}},
          mult_mod = card.ability.extra.current, 
          colour = G.C.MULT
        }
      end

      if context.threex_adding_unique_card and not context.blueprint then
        card.ability.extra.current = card.ability.extra.current + card.ability.extra.mult
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
      vouchers = {
        "v_overstock_norm",
        "v_overstock_plus"
      },
      joker_slot = 999999
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

              ease_dollars(999999999999)

              add_joker("j_threex_" .. jokerName, nil, false, false)
              add_joker("j_ring_master", nil, false, false)
                return true
            end
        }))
    end,
    unlocked = true,
  }  
end
