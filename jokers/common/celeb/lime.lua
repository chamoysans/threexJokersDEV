SMODS.Atlas({
	key = "a_threex_sheet",
	path = "sheetCommon.png",
	px = 71,
	py = 95
})

local function capitalize(str)
    return str:sub(1,1):upper() .. str:sub(2):lower()
end

local jokerThing = SMODS.Joker{
    name = "lime", 
    key = "j_threex_lime", 
    config = {
      extra = {
        mult = 4,
        suit = 'clubs',
        suitChecking = 'Clubs'
      }
    }, 
    pos = {x = 7, y = 3}, 
    loc_txt = {
      name = "Hint of Lime Joker", 
      text = {
        "{C:#2#}#3#{} held-in-hand give",
        "{C:mult}+#1#{} Mult,"
      }
    }, 
    rarity = 1, 
    cost = 4, 
    order = 92,
    unlocked = true, 
    discovered = true, 
    blueprint_compat = true, 
    atlas = "a_threex_sheet",
    loc_vars = function(self, info_queue, center)
      return {
        vars = {
          center.ability.extra.mult, center.ability.extra.suit, capitalize(center.ability.extra.suit)
        }
      }
    end, 
    calculate = function(self, card, context)
    
        if not context.end_of_round and context.individual and context.cardarea == G.hand then
            
            if context.other_card:is_suit(card.ability.extra.suitChecking) then
                print("Hint of Lime Activated!")
                return {
                    message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } },
                    card = card,
                    mult_mod = card.ability.extra.mult -- Change from h_mult
                }
            end
        end
    end,
    
}

G.P_CENTERS["j_threex_lime"] = jokerThing

if testDecks then
    SMODS.Back {
        key = 'limeDeck',
        loc_txt = {
            name = "Lime",
            text = {
                "AT"
            }
        },
        name = "limeDeck",
        pos = {x = 1, y = 2},
        apply = function(self)
            G.E_MANAGER:add_event(Event({
                func = function()
                    for index = #G.playing_cards, 1, -1 do
                        local suit = "C_"
                        local rank = "T"
      
                        G.playing_cards[index]:set_base(G.P_CARDS[suit .. rank])
                    end
      
                    add_joker("j_threex_lime", nil, false, false)
                    return true
                end
            }))
        end,
        unlocked = true,
      } 

end