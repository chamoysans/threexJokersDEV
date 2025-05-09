local jokerName = "chips"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    yes_pool_flag = 'notShowingOnShopAnymore',
    key = "j_threex_" .. jokerName, 
    config = {
      extra = {
        mainThing = 15,
        bonusThing = 10
      }
    }, 
    pos = {x = 4, y = 4}, 
    loc_txt = {
      name = "Potato Chips", 
      text = {
        "{C:chips}+#1#{} Chips, Additional",
        "{C:chips}+#2#{} Chips per {C:chips}Bonus Card{}", -- we do a little trolling
        "scored,",
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
          card.ability.extra.mainThing, card.ability.extra.bonusThing
        }
      }
    end, 
    calculate = function(self, card, context)
      if context.individual and context.cardarea == G.play then
        if SMODS.has_enhancement(context.other_card, "m_bonus") then
          return {
            message = "+" .. card.ability.extra.bonusThing .. " Chips",
            card = card,
            chip_mod = card.ability.extra.bonusThing,
          }
        end
      end
      if context.joker_main then
        return {
          message = "+" .. card.ability.extra.mainThing .. " Chips",
          chip_mod = card.ability.extra.mainThing
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
                G.playing_cards[index]:set_ability(G.P_CENTERS.m_bonus)
              end

              add_joker("j_threex_" .. jokerName, nil, false, false)
                return true
            end
        }))
    end,
    unlocked = true,
  }  
end