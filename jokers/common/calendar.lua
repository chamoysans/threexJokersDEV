local jokerName = "calendar"

local function capitalize(str)
  if str then
    return str:sub(1,1):upper() .. str:sub(2):lower()
  end
  return "" -- Default to empty string if str is nil
end

local jokerThing = SMODS.Joker{
  name = jokerName, 
  key = "j_threex_" .. jokerName, 
  config = {
    extra = {
      mult = 5,
      rank = 2,
      rankDisp = 2,
      suit = 'spades',
      currentMult = 0,  -- Start multiplier at 0
    }
  }, 
  pos = {x = 0, y = 2}, 
  loc_txt = {
    name = "Calendar", 
    text = {
      "If hand contains a {C:attention}#1# of #2#,{}",
      "Gain {C:mult}+#3#{}, Rank and Suit", -- we do a little trolling
      "changes sequentially each round.",
      "{C:inactive}Currently: #4# Mult{}"
    }
  }, 
  rarity = 1, 
  cost = 2, 
  order = 91,
  unlocked = true, 
  discovered = true, 
  blueprint_compat = true, 
  atlas = "a_threex_sheet",
  loc_vars = function(self, info_queue, center)
    return {
      vars = {
        center.ability.extra.rankDisp,
        capitalize(center.ability.extra.suit),
        center.ability.extra.mult,
        center.ability.extra.currentMult
      }
    }
  end, 
  calculate = function(self, card, context)
    if context.cardarea == G.jokers then
      -- Debug: Output Joker state at each calculation
      print("Joker Calculate - currentMult: " .. card.ability.extra.currentMult)
      print("Joker Calculate - rank: " .. card.ability.extra.rank)
      print("Joker Calculate - suit: " .. card.ability.extra.suit)
      
      -- Handling the "before" context
      if context.end_of_round and not context.blueprint then
        print("Before context triggered")
        if (not context.blueprint) or (not context.blueprint_card) then
          local gain = 0
          for k, v in ipairs(context.scoring_hand) do
            -- Debug: Check if suit and rank match
            print("Checking card with rank: " .. v:get_id())
            if v:is_suit(capitalize(card.ability.extra.suit), true) and v:get_id() == card.ability.extra.rank then
              gain = gain + 1
            end
          end
          local gainReal = gain * card.ability.extra.mult
          print("Gain: " .. gain .. ", GainReal: " .. gainReal)
          if gainReal ~= 0 then 
            card.ability.extra.currentMult = card.ability.extra.currentMult + gainReal
            print("New currentMult: " .. card.ability.extra.currentMult)
            return {
              message = '+' .. tostring(gainReal) .. "!" ,
              mult_mod = card.ability.extra.currentMult,
              colour = G.C.MULT,
            }
          end
        end
      end
      
      if context.joker_main then
        return {
          colour = G.C.MULT,
          mult = card.ability.extra.currentMult
        }
      end
      
      if context.setting_blind then
        if true then -- Rank Incremention
          print("Incrementing rank")
          if card.ability.extra.rank == 14 then
            card.ability.extra.rank = 2
          else
            card.ability.extra.rank = card.ability.extra.rank + 1
          end

          if (card.ability.extra.rank <= 14) and (card.ability.extra.rank >= 11) then
            if card.ability.extra.rank == 11 then
              card.ability.extra.rankDisp = "Jack"
            elseif card.ability.extra.rank == 12 then
              card.ability.extra.rankDisp = "Queen"
            elseif card.ability.extra.rank == 13 then
              card.ability.extra.rankDisp = "King"
            elseif card.ability.extra.rank == 14 then
              card.ability.extra.rankDisp = "Ace"
            end
          else
            card.ability.extra.rankDisp = card.ability.extra.rank
          end
        end

        if true then -- Suit Incremention
          local suits = { 'spades', 'hearts', 'diamonds', 'clubs' }
          
          -- Use findItemFromList to get the index, fallback to 1 if not found
          local index = findItemFromList(card.ability.extra.suit, suits) or 1 

          print("Suit before increment: " .. card.ability.extra.suit)
          if index == 4 then
            card.ability.extra.suit = suits[1] -- Reset to spades after clubs
          else
            card.ability.extra.suit = suits[index + 1] -- Cycle to next suit
          end
          print("Suit after increment: " .. card.ability.extra.suit)
        end
      end
    end
  end
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
      discards = 99,

    },
    name = jokerName .. "Deck",
    pos = {x = 1, y = 2},
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()

              ease_ante(-999)

              add_joker("j_threex_calendar", nil, false, false)

              --add_joker("cavendish", nil, false, false)
              --add_joker("cavendish", nil, false, false)
              --add_joker("cavendish", nil, false, false)
              --add_joker("cavendish", nil, false, false)
                return true
            end
        }))
    end,
    unlocked = true,
  }  
end