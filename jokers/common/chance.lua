local jokerName = "chance"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = "j_threex_" .. jokerName, 
    config = {
      extra = {
        rounds = 2,
        currentRound = 0,
        consumables = 3
      }
    }, 
    pos = {x = 2, y = 2}, 
    loc_txt = {
      name = "Chance Card", 
      text = {
        "After #1# rounds, sell this card",
        "to gain #3# negative consumables,", -- we do a little trolling
        "{C:inactive}Currently: #2# Round(s){}",
      }
    }, 
    rarity = 1, 
    cost = 2, 
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, center)
      return {
        vars = {
          center.ability.extra.rounds, center.ability.extra.currentRound, center.ability.extra.consumables
        }
      }
    end, 
    calculate = function(self, card, context)
      if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
        if card.ability.extra.currentRound == card.ability.extra.rounds - 1 and context.end_of_round then
          return {
            message = "Active!"
          }
        elseif card.ability.extra.currentRound ~= card.ability.extra.rounds and context.end_of_round then
          card.ability.extra.currentRound = card.ability.extra.currentRound + 1
          return {
            message = tostring(card.ability.extra.rounds - card.ability.extra.currentRound) .. " Remaining"
          }
        end
      end
    end,
    remove_from_deck = function(self, card, from_debuff)
      if card.ability.extra.currentRound == card.ability.extra.rounds then
        local actualTypes = {
          "Tarot",
          "Planet",
          "Spectral",
        }

        if SMODS.Mods['Cryptid'] then
          actualTypes[#actualTypes + 1] = "Code"
        end

        if SMODS.Mods['MoreFluff'] then
          actualTypes[#actualTypes + 1] = "Colour"
        end

        local card_type = pseudorandom_element(actualTypes, pseudoseed('ThreeTimesMoreJokers'))
        local card_type2 = pseudorandom_element(actualTypes, pseudoseed('ThreeTimesLessJokers'))
        local card_type3 = pseudorandom_element(actualTypes, pseudoseed('IdkWhatElseToPutwasd'))
        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
        G.E_MANAGER:add_event(Event({
          trigger = 'after',
          delay = 0.0,
          func = (function()
            local card = create_card(card_type,G.consumeables, nil, nil, nil, nil, nil, 'skibidi', nil, "negative")
            card:add_to_deck()
            G.consumeables:emplace(card)
            G.GAME.consumeable_buffer = 0

            local card = create_card(card_type2,G.consumeables, nil, nil, nil, nil, nil, 'toilet', nil, "negative")
            card:add_to_deck()
            G.consumeables:emplace(card)
            G.GAME.consumeable_buffer = 0

            local card = create_card(card_type3,G.consumeables, nil, nil, nil, nil, nil, 'rizzler', nil, "negative")
            card:add_to_deck()
            G.consumeables:emplace(card)
            G.GAME.consumeable_buffer = 0
            
            return {
              delay = 0.2,
              message = "Created!",
              colour = G.C.RED
            }
        end)}))
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
