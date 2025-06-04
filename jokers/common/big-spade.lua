local jokerName = "big_spade" -- CHANGE THISSSSSSSSSSSSSSSSS

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = jokerName, 
    config = {
      extra = {
        gain = 1,
        current = 1
      }
    }, 
    pos = {x = 0, y = 11}, 
    loc_txt = {
      name = "The Big Spade", 
      text = {
        "This joker gains {C:chips}+#1#{} chip",
        "when a {C:spades}Spade{} card is scored.",
        "{C:inactive}Currently: #2# Chip#3#{}",
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
          card.ability.extra.gain, card.ability.extra.current, (card.ability.extra.current <= 1 and card.ability.extra.current >= -1) and "" or "s"
        }
      }
    end, 
    calculate = function(self, card, context)
      if context.individual and context.cardarea == G.play then
        if context.other_card:is_suit('Spades') then
          card.ability.extra.current = card.ability.extra.current + card.ability.extra.gain
          return {
            message = localize('k_upgrade_ex'),
          }
        end
      end
      if context.joker_main then
        return {
          message = "+" .. card.ability.extra.current .. " Chips",
          chip_mod = card.ability.extra.current
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