local jokerName = "dumplings"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    yes_pool_flag = 'notShowingOnShopAnymore',
    key = "" .. jokerName, 
    config = {
      extra = {
      }
    }, 
    isSpud = true,
    pos = {x = 8, y = 4}, 
    loc_txt = {
      name = "Potato Dumplings", 
      text = {
        "#1#s are considered {C:attention}Wild cards,{}",
        "Rank changes every round",
      }
    }, 
    rarity = 1, 
    cost = 4, 
    unlocked = true, 
    discovered = true, 
    blueprint_compat = false, 
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, card)
      return {
        vars = {
          G.GAME.current_round.threex.dumplings.rank
        }
      }
    end, 
    --calculate = function(self, card, context)
   -- end,
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
              for index = #G.playing_cards, 1, -1 do
                local suit = "S_"
                local rank = "7"

                G.playing_cards[index]:set_base(G.P_CARDS[suit .. rank])
              end

              add_joker("j_threex_" .. jokerName, nil, false, false)
                return true
            end
        }))
    end,
    unlocked = true,
  }  
end