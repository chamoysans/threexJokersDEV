SMODS.Atlas({
	key = "a_threex_sheet",
	path = "sheetCommon.png",
	px = 71,
	py = 95
})

local hearnoevil = SMODS.Joker{
    name = "hearnoevil", 
    key = "hearnoevil", 
    config = {
      extra = {
        chips = 10,
        current = 0
      } 
    }, 
    pos = {x = 6, y = 3}, 
    loc_txt = {
      name = "Hear No Evil", 
      text = {
        "Gains {C:chips}+#1#{} Chips per card",
        "played, resets each Ante",
        "{C:inactive}Currently: +#2# Chips{}"
      }
    }, 
    rarity = 1, 
    cost = 4, 
    order = 4,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    atlas = "a_threex_sheet", -- ADD AN ATLAS!!!
    loc_vars = function(self, info_queue, center)
      return {
        vars = {
          center.ability.extra.chips, center.ability.extra.current
        }
      }
    end, 
    calculate = function(self, card, context)
      if context.individual and context.cardarea == G.play and not context.blueprint_card and context.other_card then
        card.ability.extra.current = card.ability.extra.current + card.ability.extra.chips
        card_eval_status_text(card, "extra", nil, nil, nil, { message = "Upgrade!" })
        return true
      end
      
      if
        context.cardarea == G.jokers and
        context.joker_main
      then
        return {
          message = localize {
            type = "variable",
            key = "a_chips",
            vars = { card.ability.extra.current }
          },
          chip_mod = card.ability.extra.current
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

G.P_CENTERS["j_threex_hearnoevil"] = hearnoevil
