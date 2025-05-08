local jokerName = "returns"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = "j_threex_" .. jokerName, 
    config = {
      extra = {
      }
    }, 
    pos = {x = 9, y = 10}, 
    loc_txt = {
      name = "Tax Returns", 
      text = {
        "For every {C:money}$30{} spent,",
        "recieve a Hermit tarot card,",
        "{C:inactive}Currently: $#1# Spent{}"
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
          G.GAME.current_round.threex.taxReturnsSpent
        }
      }
    end, 
    calculate = function(self, card, context)
      if context.threex_purchase then
        local spent = G.GAME.current_round.threex.taxReturnsSpent or 0
        local purchases = math.floor(spent / 30)
        local space = G.consumeables.config.card_limit - #G.consumeables.cards
        local to_spawn = math.min(purchases, space)
    
        if to_spawn > 0 then
          for i = 1, to_spawn do
            local tarot = SMODS.add_card({set = "Tarot", area = G.consumeables, key = 'c_hermit'})
            --tarot:add_to_deck()
            --G.consumeables:emplace(tarot)
          end
    
          G.GAME.current_round.threex.taxReturnsSpent = spent % 30
        end
      end
    end    
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