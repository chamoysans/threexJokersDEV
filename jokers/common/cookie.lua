local jokerName = "cookie"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = "j_threex_" .. jokerName, 
    config = {
      extra = {
        chips = 20,
        chip_mod = 20,
        rounds = 6,
        currentR = 0,
        triggered = false,
      }
    }, 
    pos = {x = 9, y = 2}, 
    loc_txt = {
      name = "Cookie Sandwich", 
      text = {
        "{C:chips}+#1#{} chips, additional {C:chips}+#2#{}",
        "per round, Lasts #3# rounds,",
        "{C:inactive}Currently: #4# rounds left,{}"
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
          card.ability.extra.chips, card.ability.extra.chip_mod, card.ability.extra.rounds, card.ability.extra.rounds - card.ability.extra.currentR
        }
      }
    end, 
    calculate = function(self, card, context)
      if context.end_of_round and not context.blueprint and not card.ability.extra.triggered then
        card.ability.extra.triggered = true
        if card.ability.extra.currentR + 1 == card.ability.extra.rounds then 
          G.E_MANAGER:add_event(Event({
            func = function()
              play_sound('tarot1')
              card.T.r = -0.2
              card:juice_up(0.3, 0.4)
              card.states.drag.is = true
              card.children.center.pinch.x = true
              G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                func = function()
                  G.jokers:remove_card(self)
                  card:remove()
                  card = nil
                return true; end})) 
              return true
            end
          })) 
          return {
              message = "Expired!",
              colour = G.C.CHIPS
          }
        else
          card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
          card.ability.extra.currentR = card.ability.extra.currentR + 1
          return {
            message = "Upgrade?",
            colour = G.C.CHIPS
          }
        end
      elseif context.joker_main then
        card.ability.extra.triggered = false
        return {
          message = "+" .. card.ability.extra.chips .. " Chips!",
          colour = G.C.CHIPS,
          chip_mod = card.ability.extra.chips
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