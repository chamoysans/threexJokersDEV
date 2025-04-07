local jokerName = "motivational"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = "j_threex_" .. jokerName, 
    config = {
      extra = {
        triggered = false
      }
    }, 
    pos = {x = 0, y = 7}, 
    loc_txt = {
      name = "Motivational Card", 
      text = {
        "Create a random {C:green}Uncommon{}",
        "Joker when a blind is beaten with", -- we do a little trolling
        "0 {C:blue}hands{} and {C:mult}discards{} remaining,",
      }
    }, 
    rarity = 1, 
    cost = 2, 
    order = 87,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, center)
      return {
        vars = {
          
        }
      }
    end, 
    calculate = function(self, card, context)

      if context.setting_blind then
        card.ability.extra.triggered = false
      end

      if context.end_of_round and card.ability.set == 'Joker' then
        if G.GAME.current_round.hands_left == 0 and G.GAME.current_round.discards_left == 0 then
          if G.jokers and #G.jokers.cards < G.jokers.config.card_limit then
            if not card.ability.extra.triggered then
              if not card.blueprint then
                card.ability.extra.triggered = true
              end
              local card = SMODS.create_card({ set = "Joker", area = G.jokers, rarity = 0.83, key_append = "threepointonefouronefiveninetwosixfivethreefiveeightninesevenninetwosix" })
              card:add_to_deck()
              G.jokers:emplace(card)
              return {
                message = '+1 Uncommon!',
                colour = G.C.MULT,
              }

            end
          end
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