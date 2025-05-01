local jokerName = 'mayan'

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = "j_threex_" .. jokerName, 
    config = {
      extra = {
        Xmult = 3,
        disCard = 42,
        currentDisCard = 0
      }
    }, 
    pos = {x = 7, y = 6}, 
    loc_txt = {
      name = "Mayan Calendar", 
      text = {
        "{C:white,X:mult}x#1#{} Mult once #2# cards",
        "have been discarded.",
        "{C:inactive}Currently: #3# Cards{}"
      }
    }, 
    rarity = 1, 
    cost = 4, 
    order = 43,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, center)
      return {
        vars = {
          center.ability.extra.Xmult, center.ability.extra.disCard, center.ability.extra.currentDisCard
        }
      }
    end, 
    calculate = function(self, card, context)
        if context.discard and not context.blueprint_card then
            if card.ability.extra.currentDisCard < card.ability.extra.disCard then
                card.ability.extra.currentDisCard = card.ability.extra.currentDisCard + 1
                
                if card.ability.extra.currentDisCard == card.ability.extra.disCard then
                    print("🔥 Mayan Calendar Activated!")
                    return {
                      delay = 0.2,
                      message = "Active.",
                      colour = G.C.RED
                    }
                else
    
                  local left = card.ability.extra.disCard - card.ability.extra.currentDisCard
                  return {
                      delay = 0.2,
                      message = left .. " cards left.",
                      colour = G.C.RED
                  }
                end
            end
        end
    
        if context.cardarea == G.jokers and context.joker_main and card.ability.extra.currentDisCard >= card.ability.extra.disCard then
            return {
                delay = 0.2,
                colour = G.C.MULT,
                message = "x" .. card.ability.extra.Xmult .. " Mult.",
                Xmult_mod = card.ability.extra.Xmult
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
      discards = 99
    },
    name = jokerName .. "Deck",
    pos = {x = 1, y = 2},
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()

              add_joker("j_threex_" .. jokerName, nil, false, false)
                return true
            end
        }))
    end,
    unlocked = true,
  }  
end