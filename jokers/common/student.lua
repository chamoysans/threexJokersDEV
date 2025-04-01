SMODS.Atlas({
	key = "a_threex_sheet",
	path = "sheetCommon.png",
	px = 71,
	py = 95
})

local jokerThing = SMODS.Joker{
    name = "student", 
    key = "j_threex_student", 
    config = {
      extra = {
        discount = 10
      }
    }, 
    pos = {x = 8, y = 8}, 
    loc_txt = {
      name = "Student ID", 
      text = {
        "All items are {C:attention}#1#%{}",
        "discounted, Rounded up"
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
          center.ability.extra.discount
        }
      }
    end, 
    add_to_deck = function(self, card, from_debuff)
      G.GAME.discount_percent = G.GAME.discount_percent + card.ability.extra.discount
      G.E_MANAGER:add_event(Event({func = function()
        for k, v in pairs(G.I.CARD) do
          if v.set_cost then
            v:set_cost()
          end
        end
        return true end 
      }))
    end,
    remove_from_deck = function(self, card, from_debuff)
      G.GAME.discount_percent = G.GAME.discount_percent - card.ability.extra.discount
      G.E_MANAGER:add_event(Event({func = function()
        for k, v in pairs(G.I.CARD) do
          if v.set_cost then
            v:set_cost()
          end
        end
        return true end 
      }))
    end
}

G.P_CENTERS["j_threex_student"] = jokerThing