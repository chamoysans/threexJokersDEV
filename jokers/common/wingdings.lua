local jokerName = "wingdings"

local jokerThing = SMODS.Joker{
    name = jokerName,
    key = "j_threex_" .. jokerName,
    config = {
      extra = {
        rank1 = 1,
        rank1Disp = 1,
        rank2 = 2,
        rank2Disp = 2,
        min = 2,
        max = 14
      }
    },
    pos = {x = 4, y = 10}, 
    loc_txt = {
      name = "Wingdings", 
      text = {
        "#1#s and #2#s count",
        "as the same rank,", -- we do a little trolling
        "rank changes each round,
      }
    }, 
    rarity = 1, 
    cost = 2, 
    order = 45,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    atlas = "a_threex_sheet",
    set_ability = function(self, card, initial, delay_sprites)
      local possibleRanks = {}
      for i = card.ability.extra.min, card.ability.extra.max do possibleRanks[i - (card.ability.extra.min - 1)] = i
      end
      local random1 = pseudorandom_element(possibleRanks, 6969696969) -- here was the crash
      card.ability.extra.rank1 = random1
      if (random1 <= 14) and (random1 >= 11) then
        if random1 == 11 then card.ability.extra.rank1Disp = "Jack"
        elseif random1 == 12 then
          card.ability.extra.rank1Disp = "Queen"
        elseif random1 == 13 then
          card.ability.extra.rank1Disp = "King"
        elseif random1 == 14 then
          card.ability.extra.rank1Disp = "Ace"
        end
      else
        card.ability.extra.rank1Disp = random1
      end

      local random2 = pseudorandom_element(possibleRanks, 420420420)

      card.ability.extra.rank2 = random2

      if (random2 <= 14) and (random2 >= 11) then
        if random2 == 11 then
          card.ability.extra.rank2Disp = "Jack"
        elseif random2 == 12 then
          card.ability.extra.rank2Disp = "Queen"
        elseif random2 == 13 then
          card.ability.extra.rank2Disp = "King"
        elseif random2 == 14 then
          card.ability.extra.rank2Disp = "Ace"
        end
      else
        card.ability.extra.rank2Disp = random2
      end
    end,
    loc_vars = function(self, info_queue, center)
      return {
        vars = {
          center.ability.extra.rank1Disp, center.ability.extra.rank2Disp
        }
      }
    end,
    calculate = function(self, card, context)
      if context.setting_blind and (not card.getting_sliced) then
        local possibleRanks = {}
        for i = card.ability.extra.min, card.ability.extra.max do possibleRanks[i - (card.ability.extra.min - 1)] = i
        end
        local random1 = pseudorandom_element(possibleRanks, 6969696969) -- here was the crash
        card.ability.extra.rank1 = random1
        if (random1 <= 14) and (random1 >= 11) then
          if random1 == 11 then card.ability.extra.rank1Disp = "Jack"
          elseif random1 == 12 then
            card.ability.extra.rank1Disp = "Queen"
          elseif random1 == 13 then
            card.ability.extra.rank1Disp = "King"
          elseif random1 == 14 then
            card.ability.extra.rank1Disp = "Ace"
          end
        else
          card.ability.extra.rank1Disp = random1
        end

        local random2 = pseudorandom_element(possibleRanks, 420420420)

        card.ability.extra.rank2 = random2

        if (random2 <= 14) and (random2 >= 11) then
          if random2 == 11 then
            card.ability.extra.rank2Disp = "Jack"
          elseif random2 == 12 then
            card.ability.extra.rank2Disp = "Queen"
          elseif random2 == 13 then
            card.ability.extra.rank2Disp = "King"
          elseif random2 == 14 then
            card.ability.extra.rank2Disp = "Ace"
          end
        else
          card.ability.extra.rank2Disp = random2
        end
      end
    end,
}

G.P_CENTERS["j_threex_" .. jokerName] = jokerThing

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