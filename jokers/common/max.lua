local jokerName = "max"

local jokerName = "max"

local jokerThing = SMODS.Joker{
    name = jokerName,
    key = jokerName,
    config = {
      extra = {
        oldHsizeCurrent = 0,
        hsize = 1,
        hsizeCurrent = 0, -- **Initialize hsizeCurrent to 0**
        hsizeMax = 100
      }
    },
    pos = {x = 6, y = 6},
    loc_txt = {
      name = "Max Efficiency",
      text = {
        "{C:attention}+1{} Hand Size per unused",
        "Joker & Consumable Slot,"
      }
    },
    rarity = 1,
    cost = 2,
    order = 14,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, center)
      return {
        vars = {
          center.ability.extra.hsize
        }
      }
    end,
    calculate = function(self, card, context)
      sendDebugMessage("Checking if card.ability.extra is nil: " .. tostring(card.ability.extra == nil), "MaxEfficiency") -- ADD THIS LINE
    
      if card.ability.extra then -- Only proceed if card.ability.extra exists
        if card.ability.extra.hsizeCurrent == nil then
          card.ability.extra.oldHsizeCurrent = 0
        else
          card.ability.extra.oldHsizeCurrent = card.ability.extra.hsizeCurrent
        end
    
        card.ability.extra.hsizeCurrent = G.jokers.config.card_limit - #G.jokers.cards
        card.ability.extra.hsizeCurrent = card.ability.extra.hsizeCurrent + (G.consumeables.config.card_limit - (#G.consumeables.cards + G.GAME.consumeable_buffer))
    
        if card.ability.extra.oldHsizeCurrent ~= card.ability.extra.hsizeCurrent then
          G.hand:change_size(-1 * card.ability.extra.oldHsizeCurrent) -- where it crashed
    
          sendDebugMessage("Attempting to increase hand size by: " ..  card.ability.extra.hsizeCurrent, "MaxEfficiency")
    
          G.hand:change_size(card.ability.extra.hsizeCurrent)
        end
      else
        sendDebugMessage("card.ability.extra was nil when calculate was called!", "MaxEfficiency")
      end
    end,
    add_to_deck = function(self, card, from_debuff)
      card.ability.extra.hsizeCurrent = G.jokers.config.card_limit - #G.jokers.cards
      card.ability.extra.hsizeCurrent = card.ability.extra.hsizeCurrent + (G.consumeables.config.card_limit - (#G.consumeables.cards + G.GAME.consumeable_buffer))

      local change = math.min(card.ability.extra.hsizeMax, card.ability.extra.hsizeCurrent)

      sendDebugMessage("Joker 'Max Efficiency' added. hsizeCurrent: " ..  card.ability.extra.hsizeCurrent)
      sendDebugMessage("Attempting to increase hand size by: " ..  change, "MaxEfficiency")
      G.hand:change_size(change)
    end,
    remove_from_deck = function(self, card, from_debuff)
      local change = math.min(card.ability.extra.hsizeMax, card.ability.extra.hsizeCurrent)
      sendDebugMessage("Joker 'Max Efficiency' removed. hsizeCurrent: " ..  card.ability.extra.hsizeCurrent)
      sendDebugMessage("Attempting to decrease hand size by: " ..  change, "MaxEfficiency")
      G.hand:change_size(-1 * change)
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

              add_joker("j_threex_" .. jokerName, nil, false, false)
                return true
            end
        }))
    end,
    unlocked = true,
  }  
end