SMODS.Atlas({
	key = "a_threex_sheet",
	path = "sheetCommon.png",
	px = 71,
	py = 95
})

local jokerThing = SMODS.Joker{
    name = "fifth",
    key = "j_threex_fifth", 
    config = {
      extra = {
        Xmult = 5,
        active = false
      }
    }, 
    pos = {x = 8, y = 10}, 
    loc_txt = {
      name = "To the Fifth Dimension", 
      text = {
        "{C:white,X:mult}x#1#{} Mult if hand",
        "contains {C:attention}Five 5's{}"
      }
    }, 
    rarity = 1, 
    cost = 4, 
    order = 20,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, center)
      return {
        vars = {
          center.ability.extra.Xmult
        }
      }
    end, 
    calculate = function(self, card, context)
      if context.cardarea == G.jokers then
        if context.before then
          local fives = 0
          for k, v in ipairs(context.full_hand) do
            if v:get_id() == 5 then
              fives = fives + 1
            end
          end
          if fives == 5 then
            card.ability.extra.active = true
          end
        elseif context.joker_main and card.ability.extra.active then
          if not context.blueprint_card then
            card.ability.extra.active = false
          end
          return {
            message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
            Xmult_mod = card.ability.extra.Xmult
          }
        end
      end
    end,
}

G.P_CENTERS["j_threex_fifth"] = jokerThing