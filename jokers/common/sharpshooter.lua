local sharp = SMODS.Joker{
    name = "sharp", 
    key = "sharp", 
    config = {
      extra = {
        mult = 7
      }
    }, 
    pos = {x = 1, y = 8}, 
    loc_txt = {
      name = "Sharpshooter", 
      text = {
        "Wild Cards give",
        "{C:mult}+#1#{} Mult when scored,"
      }
    }, 
    rarity = 1, 
    cost = 4, 
    order = 12,
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
        if thunk.ability.set == 'Enhanced' and thunk.ability.name ~= "Wild" then
          return {
            message = "+" .. card.ability.extra.mult .. " Mult!",
            mult_mod = card.ability.extra.mult,
            colour = G.C.MULT,
          }
        end
      end
    end,
}

G.P_CENTERS["j_threex_sharp"] = sharp