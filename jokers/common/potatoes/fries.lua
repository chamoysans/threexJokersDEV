local jokerName = "fries"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    yes_pool_flag = 'notShowingOnShopAnymore',
    key = "j_threex_" .. jokerName, 
    config = {
      extra = {
        mainMoney = 3,
        extraMoney = 1
      }
    }, 
    pos = {x = 2, y = 4}, 
    loc_txt = {
      name = "Golden Fries", 
      text = {
        "{C:money}$#1#{} at end of round,",
        "Additional {C:money}$#2#{} per", -- we do a little trolling
        "{C:money}Gold Card{} held in hand,",
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
          card.ability.extra.mainMoney, card.ability.extra.extraMoney
        }
      }
    end, 
    calc_dollar_bonus = function(self, card)
      return card.ability.extra.mainMoney
    end,
    calculate = function(self, card, context)
      if context.end_of_round and context.cardarea == G.hand then
        if SMODS.has_enhancement(context.other_card, "m_gold") then
          return {
            card = card,
            dollars = card.ability.extra.extraMoney,
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
    atlas = 'a_threex_sheet',
    pos = jokerThing.pos,
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
              for index = #G.playing_cards, 1, -1 do
                local suit = "S_"
                local rank = "7"

                G.playing_cards[index]:set_base(G.P_CARDS[suit .. rank])
                G.playing_cards[index]:set_ability(G.P_CENTERS.m_gold)
              end

              add_joker("j_threex_" .. jokerName, nil, false, false)
                return true
            end
        }))
    end,
    unlocked = true,
  }  
end