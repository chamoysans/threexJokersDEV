local jokerName = "eyes"

local jokerThing = SMODS.Joker{
    name = jokerName, 
    yes_pool_flag = 'notShowingOnShopAnymore',
    key = "j_threex_" .. jokerName, 
    config = {
      extra = {
        mult = 20,
        oddsOne = 5,
        money = 5,
        oddsTwo = 15,
        active = false,
      }
    }, 
    pos = {x = 5, y = 4}, 
    loc_txt = {
      name = "Potato Eyes", 
      text = {
        "{C:green}#1# in #2# chance{} to give {C:mult}+#3#{} Mult,",
        "{C:green}#1# in #4# chance{} to earn {C:money}$#5#{}",
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
          G.GAME.probabilities.normal, card.ability.extra.oddsOne, card.ability.extra.mult, card.ability.extra.oddsTwo, card.ability.extra.money
        }
      }
    end, 
    calculate = function(self, card, context)
      if context.before then
        card.ability.extra.active = false
      end
      if context.joker_main and not card.ability.extra.active then
        if not context.blueprint then
          card.ability.extra.active = true
        end
        local multC = nil
        local moneyC = nil
        if pseudorandom('potatoEyesMult') < G.GAME.probabilities.normal / card.ability.extra.oddsOne then
          multC = true
        end
        if pseudorandom('potatoEyesMoney') < G.GAME.probabilities.normal / card.ability.extra.oddsTwo then
          moneyC = true
        end
        local messageMult = "+" .. card.ability.extra.mult .. " Mult"
        if moneyC or multC then
          return {
            message = multC and messageMult or ("$" .. card.ability.extra.money),
            mult_mod = multC and card.ability.extra.mult or nil,
            dollars = moneyC and card.ability.extra.money or nil
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
                G.playing_cards[index]:set_ability(G.P_CENTERS.m_lucky)
              end

              add_joker("j_threex_" .. jokerName, nil, false, false)
              add_joker("j_oops", nil, false, false)
              add_joker("j_oops", nil, false, false)
                return true
            end
        }))
    end,
    unlocked = true,
  }  
end