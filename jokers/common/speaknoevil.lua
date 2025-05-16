

local speaknoevil = SMODS.Joker{
    name = "speaknoevil", 
    key = "speaknoevil", 
    config = {
      extra = {
        mult = 1,
        current = 0
      } 
    }, 
    pos = {x = 4, y = 8}, 
    loc_txt = {
      name = "Speak No Evil", 
      text = {
        "Gains {C:mult}+#1#{} Mult per card", 
        "discarded, resets each Ante",
        "{C:inactive}Currently: +#2# Mult{}"
      }
    }, 
    rarity = 1, 
    cost = 4, 
    order = 3,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    atlas = "a_threex_sheet", -- ADD AN ATLAS!!!
    loc_vars = function(self, info_queue, center)
      return {
        vars = {
          center.ability.extra.mult, center.ability.extra.current
        }
      }
    end, 
    calculate = function(self, card, context)
      if context.discard and not context.blueprint_card and not context.blueprint_card then
        card.ability.extra.current = card.ability.extra.current + card.ability.extra.mult
        return {
          delay = 0.2,
          message = "+" .. card.ability.extra.mult .. " Mult!",
          colour = G.C.RED
        }
      elseif context.cardarea == G.jokers and context.joker_main then
        return {
          colour = G.C.MULT,
          mult = card.ability.extra.current
      }
      end

      if context.end_of_round
			and not context.individual
			and not context.repetition
			and G.GAME.blind.boss
			and not context.blueprint_card
			and not context.retrigger_joker then
        card.ability.extra.current = 0
        return {
          delay = 0.2,
          message = "Reset!",
          colour = G.C.RED
        }
      end
    end,
}

G.P_CENTERS["j_threex_speaknoevil"] = speaknoevil