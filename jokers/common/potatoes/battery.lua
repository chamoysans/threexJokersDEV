local jokerName = "battery"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    yes_pool_flag = 'notShowingOnShopAnymore',
    key = "" .. jokerName, 
    config = {
      extra = {
        xmult = 1.5
      }
    }, 
    pos = {x = 1, y = 4}, 
    loc_txt = {
      name = "Potato Battery", 
      text = {
        "{X:mult,C:white}X#1#{} Mult,",
      }
    }, 
    rarity = 1, 
    cost = 2, 
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, card)
      return {
        vars = {
          card.ability.extra.xmult
        }
      }
    end, 
    calculate = function(self, card, context)
      if context.joker_main then
        return {
          message = "X1.5 Mult",
          colour = G.C.MULT,
          Xmult_mod = card.ability.extra.xmult
        }
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