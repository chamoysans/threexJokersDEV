local jokerName = "easter"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = "j_threex_" .. jokerName, 
    config = {
      extra = {
      }
    }, 
    pos = {x = 2, y = 3}, 
    loc_txt = {
      name = "Easter Eggs", 
      text = {
        "{C:mult}+2{} Mult for each ",
        "unique joker you currently have,",
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
          
        }
      }
    end, 
    calculate = function(self, card, context)
      if context.cardarea == G.jokers and context.joker_main then

        local unique = {

        }

        for k, v in pairs(G.jokers.cards) do
          if not findItemFromList(v.ability.name, unique) then
            unique[#unique + 1] =  v.ability.name
          end
        end

        local mult = #unique * 2

        return {
          message = localize{type='variable',key='a_mult',vars={mult}},
          mult_mod = mult, 
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