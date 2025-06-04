local jokerName = "red_joker" -- CHANGE THISSSSSSSSSSSSSSSSS

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = jokerName, 
    config = {
      extra = {
        mult = 1,
        per = 4
      }
    }, 
    pos = {x = 1, y = 10}, 
    loc_txt = {
      name = "Red Joker", 
      text = {
        "{C:mult}+#1#{} Mult per #2# cards",
        "in {C:attention}remaining deck,{}",
        "{C:inactive}Currently: #3#{}",
      }
    }, 
    rarity = 1, 
    cost = 2, -- CHANGE THISSSSSSSSSSS
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, -- CHANGE THISSSSSSSSSSSSSSSSSSSS
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, card)
      info_queue[#info_queue+1] = {key = 'threex_noart', set = 'Other',}
      return {
        vars = {
          card.ability.extra.mult, card.ability.extra.per, math.floor((((G.deck and G.deck.cards) and #G.deck.cards or 52)/card.ability.extra.per)*card.ability.extra.mult)
        }
      }
    end, 
    calculate = function(self, card, context)
      local multStuff = math.floor((((G.deck and G.deck.cards) and #G.deck.cards or 52)/card.ability.extra.per)*card.ability.extra.mult)
      if context.cardarea == G.jokers and context.joker_main then
        return {
          message = localize{type='variable',key='a_mult',vars={multStuff}},
          mult_mod = multStuff, 
          colour = G.C.MULT
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