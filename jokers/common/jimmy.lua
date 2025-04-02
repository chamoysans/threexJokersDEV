SMODS.Atlas({
	key = "a_threex_sheet",
	path = "sheetCommon.png",
	px = 71,
	py = 95
})

local jimmy = SMODS.Joker{
    name = "jimmy", 
    key = "j_threex_jimmy", 
    config = {
      extra = {
        chips = 5
      } 
    }, 
    pos = {x = 2, y = 5}, 
    loc_txt = {
      name = "Jimmy J. Joker", 
      text = {
        "{C:chips}+#1#{} chips per unenhanced",
        "card in your full deck,"
      }
    }, 
    rarity = 1, 
    cost = 5,
    order = 5,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    atlas = "a_threex_sheet", -- ADD AN ATLAS!!!
    loc_vars = function(self, info_queue, center)
      return {
        vars = {
          center.ability.extra.chips
        }
      }
    end, 
    calculate = function(self, card, context)
      if
        context.cardarea == G.jokers and
        context.joker_main
      then
        local thunk = 0

        for i, card in ipairs(G.playing_cards) do
          if card.ability.name == "Default Base" then
            thunk = thunk + 1
          end
        end

        local totalChips = thunk * card.ability.extra.chips

        return {
          message = localize {
            type = "variable",
            key = "a_chips",
            vars = { totalChips }
          },
          chip_mod = totalChips
        }
      end
    end,
}

G.P_CENTERS["j_threex_jimmy"] = jimmy