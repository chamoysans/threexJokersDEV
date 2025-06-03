local jokerName = "earthly"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    yes_pool_flag = 'notShowingOnShopAnymore',
    key = "" .. jokerName, 
    config = {
      extra = {
        chips = 25
      }
    }, 
    isSpud = true,
    pos = {x = 6, y = 4}, 
    loc_txt = {
      name = "Earthly Potato", 
      text = {
        "{C:chips}+#1#{} Chips, Stone cards give",
        "an additional {C:chips}+#1#{} Chips",
      }
    }, 
    rarity = 1, 
    cost = 4, 
    unlocked = true, 
    discovered = true, 
    blueprint_compat = false, 
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, card)
      return {
        vars = {
          card.ability.extra.chips
        }
      }
    end, 
    calculate = function(self, card, context)
      if context.individual and context.cardarea == G.play then
        if SMODS.has_enhancement(context.other_card, "m_stone") then
          return {
            message = "+" .. card.ability.extra.chips .. " Chips",
            card = card,
            chip_mod = card.ability.extra.chips,
          }
        end
      end
      if context.joker_main then
        return {
          message = "+" .. card.ability.extra.chips .. " Chips",
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
                G.playing_cards[index]:set_ability(G.P_CENTERS.m_stone)
              end

              add_joker("j_threex_" .. jokerName, nil, false, false)
                return true
            end
        }))
    end,
    unlocked = true,
  }  
end