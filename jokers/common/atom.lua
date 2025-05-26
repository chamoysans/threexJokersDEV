local jokerName = "atom"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = jokerName, 
    config = {
      extra = {
      }
    }, 
    pos = {x = 3, y = 0}, 
    loc_txt = {
      name = "Atom Splitting", 
      text = {
        "If the {C:attention}first hand{} has only {C:attention}1{} numbered card,",
        "destroy it and create two same-suit", -- we do a little trolling
        "cards worth {C:attention}half{} its value.",
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
          
        }
      }
    end, 
    calculate = function(self, card, context)
      if G.GAME.current_round.hands_played == 0 
        and context.full_hand 
        and #context.full_hand == 1 
        and context.before
        and (not context.full_hand[1]:is_face()) then

          G.playing_card = (G.playing_card and G.playing_card + 1) or 1

          local _card = copy_card(context.full_hand[1], nil, nil, G.playing_card)
          local suit = string.upper(tostring(_card.base.suit):sub(1,1)) .. "_"
          local rank = _card:get_id()
          rank = math.floor(rank / 2)
          _card:set_base(G.P_CARDS[suit .. rank])
          local _newcard = copy_card(context.full_hand[1], nil, nil, G.playing_card)
          _newcard:set_base(G.P_CARDS[suit .. rank])

          _card:add_to_deck()
          G.deck.config.card_limit = G.deck.config.card_limit + 1
          table.insert(G.playing_cards, _card)
          G.deck:emplace(_card)
          _card.states.visible = nil

          _newcard:add_to_deck()
          G.deck.config.card_limit = G.deck.config.card_limit + 1
          table.insert(G.playing_cards, _newcard)
          G.deck:emplace(_newcard)
          _newcard.states.visible = nil

          G.E_MANAGER:add_event(Event({
              func = function()
                  _card:start_materialize()
                  _newcard:start_materialize()
                  return true
              end
          }))

          return {
              message = "Split!",
              colour = G.C.CHIPS,
              remove = true,
              playing_cards_created = {true}
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