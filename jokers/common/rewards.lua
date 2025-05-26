local jokerName = "rewards"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = jokerName, 
    config = {
      extra = {
        text = "O O O O O O",
        currentPurch = 0,
        purch = 6,
        previous = 0,
        previousInf = 0
      }
    }, 
    pos = {x = 9, y = 9}, 
    loc_txt = {
      name = "The Balatro Rewards Program", 
      text = {
        "Make a single free purchase",
        "after {C:attention}#2# purchases,{}", -- we do a little trolling
        "{C:inactive}#1#{}",
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
          card.ability.extra.text, card.ability.extra.purch
        }
      }
    end, 
    calculate = function(self, card, context)
      if not context.threex_purchase then return end
    
      card.ability.extra.currentPurch = math.min(card.ability.extra.currentPurch + 1, card.ability.extra.purch)
    
      if card.ability.extra.currentPurch == card.ability.extra.purch then
        card.ability.extra.text = "Active!"
        card.ability.extra.previous = G.GAME.discount_percent
        card.ability.extra.previousInf = G.GAME.inflation
        G.GAME.discount_percent = 200
        G.E_MANAGER:add_event(Event({func = function()
          for k, v in pairs(G.I.CARD) do
            if v.set_cost then
              v.ability.couponed = true
            end
          end
          return {
            message = "Active!",
            colour = G.C.MONEY
          }
        end 
        }))
      elseif card.ability.extra.currentPurch < 6 then
        local currentStr = ""
        for i = 1, card.ability.extra.purch * 2 - 1 do
          if i % 2 == 0 then
            currentStr = currentStr .. " "
          else
            local pos = math.ceil(i / 2)
            currentStr = currentStr .. (pos <= card.ability.extra.currentPurch and "X" or "O")
          end
        end
        card.ability.extra.text = currentStr
        return {
          message = card.ability.extra.currentPurch .. "/" .. card.ability.extra.purch,
          colour = G.C.MONEY
        }
      else
        card.ability.extra.text = "O O O O O O"
        card.ability.extra.currentPurch = 0
        G.GAME.discount_percent = card.ability.extra.previous
        G.GAME.inflation = card.ability.extra.previousInf
        G.E_MANAGER:add_event(Event({func = function()
          for k, v in pairs(G.I.CARD) do
           if v.set_cost then
              v.ability.couponed = false
              v:set_cost()
            end
          end
          return {
            message = "Reset!",
            colour = G.C.MONEY
          }
          end
        }))
        
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