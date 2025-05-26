local jokerName = "surf"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = jokerName, 
    config = {
      extra = {
        var = 2
      }
    }, 
    pos = {x = 8, y = 9}, 
    loc_txt = {
      name = "Surf the Bottom", 
      text = {
        "{C:white,X:mult}X#1#{} Mult if you have",
        "less than {C:money}$#1#{}",
      }
    }, 
    rarity = 1, 
    cost = 2, 
    order = 36,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, center)
      return {
        vars = {
          center.ability.extra.var
        }
      }
    end, 
    calculate = function(self, card, context)
      if context.joker_main then
        if G.GAME.dollars <= card.ability.extra.var then
          return {
            message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.var } },
            Xmult_mod = card.ability.extra.var
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

              ease_dollars(-2)

              add_joker("j_threex_" .. jokerName, nil, false, false)
                return true
            end
        }))
    end,
    unlocked = true,
  }  
end