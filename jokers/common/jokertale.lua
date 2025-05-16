local jokerName = "jokertale"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = jokerName, 
    config = {
      extra = {
        gain = 2,
        current = 1,
        activated = false
      }
    }, 
    pos = {x = 7, y = 5}, 
    loc_txt = {
      name = "Jokertale", 
      text = {
        "This joker gains {X:mult,C:white}X#1#{} Mult",
        "per boss blind beaten in 1 hand,", -- we do a little trolling
        "{C:inactive}Currently: X#2#{}",
      }
    }, 
    rarity = 1, 
    cost = 7, 
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, card)
      return {
        vars = {
          card.ability.extra.gain, card.ability.extra.current
        }
      }
    end, 
    calculate = function(self, card, context)
      if context.end_of_round and G.GAME.current_round.hands_played == 1 and G.GAME.blind.boss and not context.individual and not context.repetition and not context.blueprint_card and not context.retrigger_joker and not card.ability.extra.activated then
        card.ability.extra.current = card.ability.extra.current + card.ability.extra.gain
        card.ability.extra.activated = true
        card_eval_status_text(card, "extra", nil, nil, nil, { message = "Upgrade!" })
        return true
      elseif context.joker_main and card.ability.extra.current ~= 1 then
        card.ability.extra.activated = false
        return {
          colour = G.C.MULT,
          x_mult = card.ability.extra.current
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