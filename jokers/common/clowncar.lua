SMODS.Atlas({
	key = "a_threex_sheet",
	path = "sheetCommon.png",
	px = 71,
	py = 95
})

local clowncar = SMODS.Joker{
    name = "clowncar", 
    key = "clowncar",  
    config = {
      extra = {
        chips = 15,
        current = 0
      }
    }, 
    pos = {x = 6, y = 2}, 
    loc_txt = {
      name = "Clown Car", 
      text = {
        "{C:chips}+#2#{} Chips, Increases by",
        "{C:chips}#1#{} Chips for every Full House played,",
        "{C:inactive}Currently: +#2# Chips{}"
      }
    }, 
    rarity = 1, 
    cost = 5, 
    order = 6,
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

      if context.cardarea == G.jokers then
        if context.before then
          if next(context.poker_hands['Full House']) then
            card.ability.extra.current = card.ability.extra.current + card.ability.extra.chips
            return {
              delay = 0.2,
              message = "Upgrade!",
              colour = G.C.CHIPS
            }
          end
        elseif context.joker_main then
          return {  
            chip_mod = card.ability.extra.current,
            message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.current } }
          }
        end
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

G.P_CENTERS["j_threex_clowncar"] = clowncar