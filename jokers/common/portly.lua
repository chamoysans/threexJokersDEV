


local portly = SMODS.Joker{
    name = "portly", 
    key = "portly", 
    config = {
      extra = {
        number = 8
      }
    }, 
    pos = {x = 6, y = 7},
    loc_txt = {
      name = "Portly Joker", 
      text = {
        "{C:mult}+#1#{} Mult"
      }
    }, 
    rarity = 1, 
    cost = 6, 
    order = 28,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, center)
      return {
        vars = {
          center.ability.extra.number
        }
      }
    end, 
    calculate = function(self, card, context)
      if context.joker_main then
        return {  
          mult_mod = card.ability.extra.number,
          message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.number } }
        }
      end
    end,
}

G.P_CENTERS["j_threex_portly"] = portly