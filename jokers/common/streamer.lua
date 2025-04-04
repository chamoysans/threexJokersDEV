local jokerName = "streamer"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = "j_threex_" .. jokerName, 
    config = {
      extra = {
        mult = 1,
        maxHands = 4,
        blindSkipped = 0
      }
    }, 
    pos = {x = 7, y = 8}, 
    loc_txt = {
      name = "Streamer", 
      text = {
        "{C:mult}+#1#{} Mult per Played {C:blue}Hand,{}",
        " Unused {C:mult}Discard,{} and Blind Skipped." -- look for throwback code
      }
    }, 
    rarity = 1, 
    cost = 6, 
    order = 60,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, center)
      return {
        vars = {
          center.ability.extra.mult
        }
      }
    end, 
    calculate = function(self, card, context)
      if context.setting_blind then
        card.ability.extra.maxHands = G.GAME.current_round.hands_left
      end

      if context.cardarea == G.jokers and context.joker_main then
        local multCalc = 0

        multCalc = card.ability.extra.maxHands - G.GAME.current_round.hands_left

        print("3x LOG: MultCalc (Hands) = " .. multCalc)

        multCalc = multCalc + G.GAME.current_round.discards_left

        print("3x LOG: MultCalc (Hands then Discards) = " .. multCalc)

        multCalc = multCalc + G.GAME.skips

        print("3x LOG: MultCalc (Discards then Blinds) = " .. multCalc)

        multCalc = multCalc * card.ability.extra.mult

        if multCalc ~= 0 then
          return {
            message = localize{type='variable',key='a_mult',vars={multCalc}},
            mult_mod = multCalc, 
            colour = G.C.MULT
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