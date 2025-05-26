local jokerName = "chess"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = jokerName, 
    config = {
      extra = {
        current = 0,
        gain = 5
      }
    }, 
    pos = {x = 1, y = 3}, 
    loc_txt = {
      name = "Dimensional Chess", 
      text = {
        "{C:mult}+#1#{} Mult, Gains +#2# per",
        "Five-card hand you discard,"
      }
    }, 
    rarity = 1, 
    cost = 5, 
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, card)
      return {
        vars = {
          card.ability.extra.current, card.ability.extra.gain
        }
      }
    end, 
    calculate = function(self, card, context)
      if context.pre_discard and not context.hook then 
        local text,disp_text = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        
        local hands = {
          "Straight",
          "Flush",
          "Straight Flush",
          "Full House",
          "Royal Flush",
          "Five of a Kind",
          "Flush House",
          "Flush Five"
        }

        local cryptid = {
          "Bulwark",
          "Clusterfuck",
          "Ultimate Pair",
          "The Entire Fucking Deck"
        }

        if SMODS.Mods['Cryptid'] then
          for _, item in ipairs(cryptid) do
            table.insert(hands, item)
          end
        end

        for _, hand in ipairs(hands) do
          if hand == text then
            card.ability.extra.current = card.ability.extra.current + card.ability.extra.gain
            return {
              message = "Upgrade!",
              colour = G.C.MULT
            }
          end
        end        
      end

      if context.joker_main then
        return {
          message = "+" .. card.ability.extra.current .. " Mult!",
          colour = G.C.MULT,
          mult_mod = card.ability.extra.current
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