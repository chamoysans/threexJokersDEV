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
  cost = 4, 
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
    if context.cardarea ~= G.jokers then return end

    -- Debug: Joker state
    print(string.format("Joker Calculate - Mult: %d, Rank: %s, Suit: %s", 
        card.ability.extra.currentMult, tostring(card.ability.extra.rank), tostring(card.ability.extra.suit)))


    if context.before and not context.blueprint and not context.blueprint_card then
        print("Before context triggered")

        local gain = 0
        for k, v in ipairs(context.scoring_hand) do
            print(string.format("Checking Card -> Rank: %s, Suit: %s", v:get_id(), tostring(v.base.suit)))

            if v:is_suit(capitalize(card.ability.extra.suit)) and v:get_id() == card.ability.extra.rank then
                gain = gain + card.ability.extra.mult
            end
        end

        print("Total Gain: " .. gain)

        if gain > 0 then
            card.ability.extra.currentMult = card.ability.extra.currentMult + gain
            print("New currentMult: " .. card.ability.extra.currentMult)

            return {
                message = "+" .. tostring(gain) .. "!",
                colour = G.C.MULT,
            }
        end
    end

    if context.joker_main and card.ability.extra.currentMult ~= 0 then
        return {
            message = "+" .. card.ability.extra.currentMult .. " Mult!",
            colour = G.C.MULT,
            mult_mod = card.ability.extra.currentMult,
        }
    end

    -- SETTING BLIND Context (incrementing rank & suit)
    if context.setting_blind then
        -- Rank Increment
        print("Incrementing rank")
        card.ability.extra.rank = (card.ability.extra.rank == 14) and 2 or card.ability.extra.rank + 1

        -- Update rank display
        local rankNames = { [11] = "Jack", [12] = "Queen", [13] = "King", [14] = "Ace" }
        card.ability.extra.rankDisp = rankNames[card.ability.extra.rank] or card.ability.extra.rank

        -- Suit Increment
        local suits = { 'spades', 'hearts', 'diamonds', 'clubs' }
        local index = findItemFromList(card.ability.extra.suit, suits) or 1

        print("Suit before increment: " .. tostring(card.ability.extra.suit))

        index = (index % #suits) + 1 -- Loop back after last suit
        card.ability.extra.suit = suits[index]

        print("Suit after increment: " .. tostring(card.ability.extra.suit))
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