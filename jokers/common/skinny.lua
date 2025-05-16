
local jokerThing = SMODS.Joker{
    name = "skinny", 
    key = "skinny", 
    config = {
      extra = {
        multTTT = 2
      }
    }, 
    pos = {x = 3, y = 8},
    loc_txt = {
      name = "Skinny Joker", 
      text = {
        "{C:mult}+#1#{} Mult"
      }
    }, 
    rarity = 1, 
    cost = 2, 
    order = 27,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, center)
      return {
        vars = {
          center.ability.extra.multTTT
        }
      }
    end, 
    calculate = function(self, card, context)
      if context.joker_main then
        return {
          mult_mod = card.ability.extra.multTTT,
          message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.multTTT } }
        }
      end
    end,
}

G.P_CENTERS["j_threex_skinny"] = jokerThing