local jokerName = "wingdings"

local jokerThing = SMODS.Joker{
    name = jokerName,
    key = jokerName,
    config = {
      extra = {
      }
    },
    pos = {x = 4, y = 10}, 
    loc_txt = {
      name = "Wingdings", 
      text = {
        "{C:attention}#1#s{} and {C:attention}#2#s{} count",
        "as the same rank,", -- we do a little trolling
        "rank changes each round"
      }
    }, 
    rarity = 1, 
    cost = 2, 
    order = 45,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, center)
      return {
        vars = {
          G.GAME.current_round.threex.wing.rankOne, G.GAME.current_round.threex.wing.rankTwo
        }
      }
    end,
}

G.P_CENTERS["j_threex_" .. jokerName] = jokerThing

if testDecks then
  SMODS.Back {
    key = jokerName .. 'Deck',
    loc_txt = {
        name = jokerName,
        text = {
            "AT"
        }
    },
    config = {
    },
    name = jokerName .. "Deck",
    atlas = 'a_threex_sheet',
    pos = jokerThing.pos,
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
              local thunk = false
              for index = #G.playing_cards, 1, -1 do
                local suit = "S_"
                local rank = "7"
                if thunk then
                  rank = "8"
                end

                thunk = not thunk

                G.playing_cards[index]:set_base(G.P_CARDS[suit .. rank])
              end

              add_joker("j_threex_" .. jokerName, nil, false, false)

              add_joker("j_idol", nil, false, false)
                return true
            end
        }))
    end,
    unlocked = true,
  }  
end

local calculate_joker_ref = Card.calculate_joker
function Card.calculate_joker(self, context)

  local joker = next(find_joker('wingdings'))

  G.GAME.current_round.threex.wing.active = false

  local ret = calculate_joker_ref(self, context)

  if ret == nil and joker then
    G.GAME.current_round.threex.wing.active = true
    ret = calculate_joker_ref(self, context)
  end
  return ret
end
