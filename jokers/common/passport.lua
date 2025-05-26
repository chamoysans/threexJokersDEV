local jokerName = "passport"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = jokerName, 
    config = {
      extra = {
        money = 10
      }
    }, 
    pos = {x = 4, y = 7}, 
    loc_txt = {
      name = "Passport", 
      text = {
        "All {V:1}#1#{} cards are debuffed,",
        "{C:money}$#2#{} at end of round,",
        "Suit changes each round",
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
          G.GAME.current_round.threex.passport.suit:sub(1,(#G.GAME.current_round.threex.passport.suit - 1)),
          card.ability.extra.money,
          colours = { 
            G.C.SUITS[G.GAME.current_round.threex.passport.suit],
          }
        }
      }
    end, 
    calc_dollar_bonus = function(self, card)
      return card.ability.extra.money
    end,
    update = function(self, card, dt)
      if G.deck and card.added_to_deck then
        for i, v in pairs(G.deck.cards) do
          v:set_debuff(false)
          if v:is_suit(G.GAME.current_round.threex.passport.suit) then
            v:set_debuff(true)
          end
        end
      end
      if G.hand and card.added_to_deck then
        for i, v in pairs(G.hand.cards) do
          v:set_debuff(false)
          if v:is_suit(G.GAME.current_round.threex.passport.suit) then
            v:set_debuff(true)
          end
        end
      end
    end,
    --calculate = function(self, card, context)
    --end,
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
              local thunk = 1
              local table = {
                'S_',
                'D_',
                'H_',
                'C_'
              }
              for index = #G.playing_cards, 1, -1 do

                thunk = thunk + 1
                if thunk == 5 then
                  thunk = 1
                end
                local suit = table[thunk]

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