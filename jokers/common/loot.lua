local loot = SMODS.Joker{
    name = "loot", 
    key = "loot", 
    config = {
      extra = {
      }
    }, 
    pos = {x = 2, y = 6}, 
    loc_txt = {
      name = "Loot Joker", 
      text = {
        "Gain a random {C:money}Consumable{}",
        "when Boss Blind is defeated,"
      }
    }, 
    rarity = 1, 
    cost = 5, 
    order = 10,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, center)
      return {
      }
    end, 
    calculate = function(self, card, context)
      if context.end_of_round and not context.individual and not context.repetition and G.GAME.blind.boss then
        local actualTypes = {
          "Tarot",
          "Planet",
          "Spectral",
        }

        if Cryptid then
          actualTypes[#actualTypes + 1] = "Code"
        end

        if MoreFluff then
          actualTypes[#actualTypes + 1] = "Colour"
        end

        local card_type = pseudorandom_element(actualTypes, pseudoseed('ThreeTimesMoreJokers'))
        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
        G.E_MANAGER:add_event(Event({
          trigger = 'after',
          delay = 0.0,
          func = (function()
              local card = create_card(card_type,G.consumeables, nil, nil, nil, nil, nil, 'AreYouSureAboutThat')
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

G.P_CENTERS["j_threex_loot"] = loot