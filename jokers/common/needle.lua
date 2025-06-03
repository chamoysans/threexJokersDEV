local jokerName = "needle" -- CHANGE THISSSSSSSSSSSSSSSSS

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = jokerName, 
    config = {
      extra = {
        cardLost = 1,
      }
    }, 
    pos = {x = 4, y = 5}, 
    loc_txt = {
      name = "J. Needle", 
      text = {
        "Reduces hand size to 1,",
        "{X:mult,C:white}X#1#{} Mult per card lost,",
        "{C:inactive}Currently: X#2#{}",
      }
    }, 
    rarity = 1, 
    cost = 2, -- CHANGE THISSSSSSSSSSS
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, -- CHANGE THISSSSSSSSSSSSSSSSSSSS
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, card)
      return {
        vars = {
          card.ability.extra.cardLost, ( G.hand and ((G.hand.config.card_limit - #G.hand.cards) * card.ability.extra.cardLost) or 0)
        }
      }
    end, 
    calculate = function(self, card, context)
      if context.joker_main then
        return {
          message = localize { type = 'variable', key = 'a_xmult', vars = { (G.hand.config.card_limit - #G.hand.cards) * card.ability.extra.cardLost } },
          Xmult_mod = (G.hand.config.card_limit - #G.hand.cards) * card.ability.extra.cardLost
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