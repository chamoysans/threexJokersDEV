SMODS.Atlas({
	key = "a_threex_sheet",
	path = "sheetCommon.png",
	px = 71,
	py = 95
})

local function capitalize(str)
  return str:sub(1,1):upper() .. str:sub(2):lower()
end

local jokerName = "orchid"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = "j_threex_" .. jokerName, 
    config = {
      extra = {
        repetitions = 1,
        card = 10
      }
    }, 
    pos = {x = 9, y = 1}, 
    loc_txt = {
      name = capitalize(jokerName) .. " Joker", 
      text = {
        "Retriggers {C:attention}#1#s{}",
      }
    }, 
    rarity = 1, 
    cost = 4, 
    order = 24,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, center)
      return {
        vars = {
          center.ability.extra.card
        }
      }
    end, 
    calculate = function(self, card, context)
      if context.cardarea == G.play and context.repetition and not context.repetition_only then
        if context.other_card:get_id() == card.ability.extra.card then
          return {
            message = 'Again!',
            repetitions = card.ability.extra.repetitions
          }
			end
		end
    end,
}

G.P_CENTERS["j_threex_" .. jokerName] = jokerThing

SMODS.Back {
  key = 'AAAAA',
  loc_txt = {
      name = "Tens",
      text = {
          "AT"
      }
  },
  name = "AAAAA",
  pos = {x = 0, y = 0},
  apply = function(self)
      G.E_MANAGER:add_event(Event({
          func = function()
              for index = #G.playing_cards, 1, -1 do
                  local suit = "S_"
                  local rank = "10"

                  G.playing_cards[index]:set_base(G.P_CARDS[suit .. rank])
              end

              add_joker("j_threex_" .. jokerName, nil, false, false)
              return true
          end
      }))
  end,
  unlocked = true,
}
