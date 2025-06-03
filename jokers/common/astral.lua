local jokerName = "astral" -- CHANGE THISSSSSSSSSSSSSSSSS

local jokerThing = SMODS.Joker{
    name = jokerName, 
    key = jokerName, 
    config = {
      extra = {
        current = 1,
        inc = 0.25,
        oldkey = nil,
        oldkeydisp = nil
      }
    }, 
    pos = {x = 2, y = 0}, 
    loc_txt = {
      name = "Astral Alignment", 
      text = {
        "{X:mult,C:white}X#1#{} Mult, adds {X:mult,C:white}X#2#{}",
        "for each planet card used in",
        "{C:attention}sequential{} order,",
        "resets if used planet card",
        "is out-of-order.",
        "{C:inactive}Last Used: #3#, Next: #4#{}"
      }
    }, 
    rarity = 1, 
    cost = 4, -- CHANGE THISSSSSSSSSSS
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, -- CHANGE THISSSSSSSSSSSSSSSSSSSS
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, card)
      local thunk = TXJ.get_next_astral_seq(card.ability.extra.oldkey)
      return {
        vars = {
          card.ability.extra.current, card.ability.extra.inc, card.ability.extra.oldkeydisp or "None", thunk[2] or "Mercury"
        }
      }
    end, 
    calculate = function(self, card, context)
      if context.using_consumeable and
        not context.blueprint and 
        ((context.consumeable.ability.set == 'Planet') or (context.consumeable.ability.set == 'Spectral' and context.consumeable:gc().key == 'c_black_hole'))
      then

        local results = TXJ.next_astral_sequence(context.consumeable:gc().key, card.ability.extra.oldkey)

        if results[1] then
          if results[2] then card.ability.extra.current = card.ability.extra.current + card.ability.extra.inc end
          card.ability.extra.oldkey = context.consumeable:gc().key
          card.ability.extra.oldkeydisp = context.consumeable:gc().name
          return {
            message = localize('k_upgrade_ex'),
            colour = G.C.MULT
          }
        else
          card.ability.extra.current = 1
          card.ability.extra.oldkey = nil
          card.ability.extra.oldkeydisp = nil
          return {
            message = localize('k_reset'),
            colour = G.C.MULT
          }
        end
      end

      if context.joker_main then
        return {
          message = localize{type='variable',key='a_xmult',vars={card.ability.extra.current}},
          Xmult_mod = card.ability.extra.current
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