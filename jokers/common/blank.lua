SMODS.Atlas({
	key = "a_threex_sheet",
	path = "sheetCommon.png",
	px = 71,
	py = 95
})

local jokerThing = SMODS.Joker{
    name = "blank", 
    key = "j_threex_blank", 
    config = {
      extra = {
      }
    }, 
    pos = {x = 6, y = 0}, 
    loc_txt = {
      name = "Blank Joker", 
      text = {
        "{C:white}3.1415926535897926{}",
        "Does Nothing...?", -- we do a little trolling
        "{C:white}1.6180339887498948{}",
      }
    }, 
    rarity = 1, 
    cost = 2, 
    order = 14,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, center)
      return {
        vars = {
          
        }
      }
    end, 
    calculate = function(self, card, context)
      return true
    end,
}

G.P_CENTERS["j_threex_blank"] = jokerThing