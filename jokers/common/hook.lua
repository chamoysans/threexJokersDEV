local jokerName = "hook" -- CHANGE THISSSSSSSSSSSSSSSSS

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = jokerName, 
    config = {
      extra = {
      }
    }, 
    pos = {x = 1, y = 5}, 
    loc_txt = {
      name = "J. Hook", 
      text = {
        "Two left-most cards held",
        "in hand are {C:attention}discarded{} per",
        "hand played.",
      }
    }, 
    rarity = 1, 
    cost = 6, -- CHANGE THISSSSSSSSSSS
    unlocked = true, 
    discovered = true, 
    blueprint_compat = false, -- CHANGE THISSSSSSSSSSSSSSSSSSSS
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, card)
      return {
        vars = {
          
        }
      }
    end, 
    calculate = function(self, card, context)
      if context.threex_before_before then
        G.E_MANAGER:add_event(Event({ func = function()
          local any_selected = nil
          local _cards = {}
          for k, v in ipairs(G.hand.cards) do
            if k <= 2 then
              _cards[#_cards+1] = v
            end
          end
          for i = 1, 2 do
            if G.hand.cards[i] then 
              local selected_card, card_key = pseudorandom_element(_cards, pseudoseed('hook'))
              G.hand:add_to_highlighted(selected_card, true)
              table.remove(_cards, card_key)
              any_selected = true
              play_sound('card1', 1)
            end
          end
          if any_selected then G.FUNCS.discard_cards_from_highlighted(nil, true) end
        return true end })) 
        self.triggered = true
        delay(0.7)
        return true
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