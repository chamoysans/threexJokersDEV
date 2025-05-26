local jokerName = "streamer"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = jokerName, 
    config = {
      extra = {
        mult = 1,
        currentHands = 0,
        currentDiscards = 0,
        blindSkipped = 0
      }
    }, 
    pos = {x = 7, y = 8}, 
    loc_txt = {
      name = "Streamer", 
      text = {
        "{C:mult}+#1#{} Mult per Played {C:blue}Hand,{}",
        "Unused {C:mult}Discard,{} and Blind Skipped.",
        "{C:inactive}Currently: #2#, #3#, and #4#{}"
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
          center.ability.extra.mult, center.ability.extra.currentHands, center.ability.extra.currentDiscards, G.GAME.skips
        }
      }
    end, 
    calculate = function(self, card, context)

      if context.before then
        card.ability.extra.currentHands = card.ability.extra.currentHands + card.ability.extra.mult
        return {
          message = localize{type = 'variable', key = 'k_upgrade_ex'},
          colour = G.C.MONEY
        }
      end

      if context.end_of_round and
        context.game_over == false and
        not context.repetition then
        card.ability.extra.currentDiscards = card.ability.extra.currentDiscards + (G.GAME.current_round.discards_left * card.ability.extra.mult)
        return {
          message = localize{type = 'variable', key = 'k_upgrade_ex'},
          colour = G.C.MONEY
        }
      end

      if context.cardarea == G.jokers and context.joker_main then
        local multCalc = 0

        multCalc = card.ability.extra.currentHands

        multCalc = multCalc + card.ability.extra.currentDiscards

        multCalc = multCalc + G.GAME.skips

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