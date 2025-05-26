local jokerName = "whip"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = jokerName, 
    config = {
      extra = {
        repetitions = 1
      }
    }, 
    pos = {x = 5, y = 10}, 
    loc_txt = {
      name = "Whiplash", 
      text = {
        "Retrigger last scored card",
      }
    }, 
    rarity = 1, 
    cost = 4, 
    order = 70,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, center)
      return {
        vars = {
        }
      }
    end, 
    calculate = function(self, card, context)
      if context.repetition and context.cardarea == G.play then
        if (context.other_card == context.scoring_hand[#context.scoring_hand]) then
          return {
              message = localize('k_again_ex'),
              repetitions = card.ability.extra.repetitions,
              card = card
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