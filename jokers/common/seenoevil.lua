SMODS.Atlas({
	key = "a_threex_sheet",
	path = "sheetCommon.png",
	px = 71,
	py = 95
})

local seenoevil = SMODS.Joker{
    name = "seenoevil", 
    key = "j_threex_seenoevil", 
    config = {
      extra = {
        money = 2
      } 
    }, 
    pos = {x = 0, y = 8}, 
    loc_txt = {
      name = "See No Evil", 
      text = {
        "Gives {C:money}$#1#{} per empty joker slot", 
        "at the end of round,"
      }
    }, 
    rarity = 1, 
    cost = 4, 
    unlocked = true, 
    discovered = true, 
    order = 2,
    blueprint_compat = true, 
    atlas = "a_threex_sheet", -- ADD AN ATLAS!!!
    loc_vars = function(self, info_queue, center)
      return {
        vars = {
          center.ability.extra.money
        }
      }
    end, 
    calc_dollar_bonus = function(self, card)
		if (G.jokers.config.card_limit - #G.jokers.cards) > 0 then
			local emptySlots = G.jokers.config.card_limit - #G.jokers.cards
			local moneyBonus = emptySlots * card.ability.extra.money
            return moneyBonus
		end
	end,
}

G.P_CENTERS["j_threex_seenoevil"] = seenoevil

CardSleeves.Sleeve {
	key = "testDecl",
    prefix_config = {atlas=false},
    atlas = "casl_sleeve_atlas",
    pos = { x = 1, y = 3 },
    loc_txt = {
        name = "testDeck",
        text = { "testDeckkkkk" }
    },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                add_joker("j_threex_seenoevil", nil, false, false)
                return true
            end
        }))
    end,
	unlocked = true,
}