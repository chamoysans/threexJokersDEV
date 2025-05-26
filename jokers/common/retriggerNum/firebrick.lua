SMODS.Atlas({
	key = "a_threex_sheet",
	path = "sheetCommon.png",
	px = 71,
	py = 95
})

local firebrick = SMODS.Joker{
    name = "firebrick", 
    key = "j_threex_firebrick", 
    config = {
      extra = {
        repetitions = 1
      }
    }, 
    pos = {x = 0, y = 1}, 
    loc_txt = {
      name = "Firebrick Joker", 
      text = {
        "Retriggers {C:attention}Aces,{}",
      }
    }, 
    rarity = 1, 
    cost = 4, 
    order = 15,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, center)
    end, 
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.repetition and not context.repetition_only then
			if context.other_card:get_id() == 14 then
				return {
					message = 'Again!',
					repetitions = card.ability.extra.repetitions
				}
			end
		end
    end,
}

G.P_CENTERS["j_threex_firebrick"] = firebrick

SMODS.Back {
    key = 'A',
    loc_txt = {
        name = "Aces",
        text = {
            "AT"
        }
    },
    name = "A",
    pos = {x = 0, y = 0},
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                for index = #G.playing_cards, 1, -1 do
                    local suit = "S_"
                    local rank = "A"

                    G.playing_cards[index]:set_base(G.P_CARDS[suit .. rank])
                end

                add_joker("j_threex_firebrick", nil, false, false)
                return true
            end
        }))
    end,
    unlocked = true,
} 