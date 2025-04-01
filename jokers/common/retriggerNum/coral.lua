SMODS.Atlas({
	key = "a_threex_sheet",
	path = "sheetCommon.png",
	px = 71,
	py = 95
})

local coral = SMODS.Joker{
    name = "coral", 
    key = "j_threex_coral", 
    config = {
      extra = {
        repetitions = 1
      }
    }, 
    pos = {x = 1, y = 1}, 
    loc_txt = {
      name = "Coral Joker", 
      text = {
        "Retriggers {C:attention}2s{}",
      }
    }, 
    rarity = 1, 
    cost = 4, 
    order = 16,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, center)
    end, 
    calculate = function(self, card, context)
      if context.cardarea == G.play and context.repetition and not context.repetition_only then
        if context.other_card:get_id() == 2 then
          return {
            message = 'Again!',
            repetitions = card.ability.extra.repetitions
          }
			end
		end
    end,
}

G.P_CENTERS["j_threex_coral"] = coral

SMODS.Back {
    key = 'AA',
    loc_txt = {
        name = "Twos",
        text = {
            "AT"
        }
    },
    name = "AA",
    pos = {x = 0, y = 0},
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                for index = #G.playing_cards, 1, -1 do
                    local suit = "S_"
                    local rank = "2"

                    G.playing_cards[index]:set_base(G.P_CARDS[suit .. rank])
                end

                add_joker("j_threex_coral", nil, false, false)
                return true
            end
        }))
    end,
    unlocked = true,
} 