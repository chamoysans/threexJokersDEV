local jokerName = "pillar" -- CHANGE THISSSSSSSSSSSSSSSSS

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = jokerName, 
    config = {
      extra = {
        mult = 4
      }
    }, 
    pos = {x = 8, y = 5}, 
    loc_txt = {
      name = "J. Pillar", 
      text = {
        "Cards previously played {C:attention}this{}",
        "{C:attention}Ante{} give {C:mult}+#1#{} Mult,",
      }
    }, 
    rarity = 1, 
    cost = 6, -- CHANGE THISSSSSSSSSSS
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, -- CHANGE THISSSSSSSSSSSSSSSSSSSS
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, card)
      return {
        vars = {
          card.ability.extra.mult
        }
      }
    end, 
    calculate = function(self, card, context)
      if context.individual and context.cardarea == G.play then
        if context.other_card.ability.played_this_ante then
          return {
            message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}},
            card = card,
            mult_mod = card.ability.extra.mult,
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