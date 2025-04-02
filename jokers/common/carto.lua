local jokerName = "carto"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = "j_threex_" .. jokerName, 
    config = {
      extra = {
        Xmult = 2,
        levels = 2
      }
    }, 
    pos = {x = 6, y = 5}, 
    loc_txt = {
      name = "Cartographer Joker", 
      text = {
        "{C:mult}x#1#{} if every visible hand",
        "is level #2# or higher,"
      }
    }, 
    rarity = 1, 
    cost = 2, 
    order = 18,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, center)
      return {
        vars = {
          center.ability.extra.Xmult, center.ability.extra.levels
        }
      }
    end, 
    calculate = function(self, card, context)
      if context.cardarea == G.jokers and context.joker_main then -- where it crashed
        local function everyHandLevel()
          local thunk = {
            actualLevel = 0,
            minLevel = 0
          }
          for _, hand in ipairs(G.GAME.hands) do
            if hand.visible then
              thunk.actualLevel = thunk.actualLevel + hand.level
              thunk.minLevel = thunk.minLevel + 2
            end
          end
  
          return thunk
        end
  
        local think = everyHandLevel()
  
        if (think.actualLevel == think.minLevel) or (think.actualLevel > think.minLevel) then
          return {
            delay = 0.2,
            colour = G.C.MULT,
            message = "x" .. card.ability.extra.Xmult .. " Mult!",
            Xmult_mod = card.ability.extra.Xmult
          }
        end
      end

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
    pos = {x = 1, y = 2},
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
              for index = #G.playing_cards, 1, -1 do
                local suit = "S_"
                local rank = "7"

                G.playing_cards[index]:set_base(G.P_CARDS[suit .. rank])
              end

              for k, v in pairs(G.GAME.hands) do
                level_up_hand(self, k, true)
                level_up_hand(self, k, true)
              end

              add_joker("j_threex_" .. jokerName, nil, false, false)
                return true
            end
        }))
    end,
    unlocked = true,
  }  
end