local jokerName = "super"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = "j_threex_" .. jokerName, 
    config = {
      extra = {
      }
    }, 
    pos = {x = 9, y = 8}, 
    loc_txt = {
      name = "Super Joker", 
      text = {
        "If hand contains a {C:attention}5-card High Card,{}",
        "Permanently add {C:white,X:chips}X1.5{} the ", -- we do a little trolling
        "chip values of the unscored cards",
        "to the single scored card,",
      }
    }, 
    rarity = 1, 
    cost = 4, 
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, card)
      return {
        vars = {
          
        }
      }
    end, 
    calculate = function(self, card, context)
      if context.individual and context.cardarea == G.play and next(context.poker_hands['High Card']) and #context.full_hand > 4 then

        local gain = 0

        if next(context.poker_hands['High Card']) then
          for i, cardH in ipairs(context.full_hand) do
            if cardH:get_id() ~= context.scoring_hand[1]:get_id() then
              if cardH:get_id() < 11 then
                gain = gain + cardH:get_id() + (cardH.ability.perma_bonus or 0)
              elseif cardH:get_id() > 10 and cardH:get_id() < 14 then
                gain = gain + 10 + (cardH.ability.perma_bonus or 0)
              else
                gain = gain + 11 + (cardH.ability.perma_bonus or 0)
              end
            end
          end
        end

        gain = gain * 1.5

        context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus or 0
        context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus + gain
        return {
          message = "Upgrade!",
          colour = G.C.CHIPS,
          card = card
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

              add_joker("j_threex_" .. jokerName, nil, false, false)
                return true
            end
        }))
    end,
    unlocked = true,
  }  
end