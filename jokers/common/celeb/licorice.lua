local jokerThing = SMODS.Joker{
    name = "licorice",
    key = "j_threex_licorice",
    config = {
        extra = {
            mult = 4,
            suit = 'diamonds',
            suitChecking = 'Diamonds'
        }
    },
    pos = { x = 0, y = 6 },
    loc_txt = {
        name = "Licorice Joker",
        text = {
            "{C:diamonds}#2#{} held-in-hand give",
            "{C:mult}+#1#{} Mult,"
        }
    },
    rarity = 1,
    cost = 4,
    order = 93,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    atlas = "a_threex_sheet",
    
    loc_vars = function(self, info_queue, center)
        return {
            vars = {
                center.ability.extra.mult,
                center.ability.extra.suitChecking
            }
        }
    end,

    calculate = function(self, card, context)
        
        if not context.end_of_round and 
           context.individual and 
           context.cardarea == G.hand then
            
            if context.other_card:is_suit(card.ability.extra.suitChecking) then
                return {
                    message = localize{
                        type = 'variable',
                        key = 'a_mult',
                        vars = { card.ability.extra.mult }
                    },
                    card = card,
                    mult_mod = card.ability.extra.mult
                }
            end
        end
    end
}

G.P_CENTERS["j_threex_licorice"] = jokerThing

if testDecks then
    SMODS.Back{
        key = 'licorDeck',
        loc_txt = {
            name = "Licorice",
            text = {
                "AT"
            }
        },
        name = "licorDeck",
        pos = {x = 1, y = 2},
        
        apply = function(self)
            G.E_MANAGER:add_event(Event({
                func = function()
                    for index = #G.playing_cards, 1, -1 do
                        local suit = "D_"
                        local rank = "T"
                        G.playing_cards[index]:set_base(G.P_CARDS[suit .. rank])
                    end
                    add_joker("j_threex_licorice", nil, false, false)
                    return true
                end
            }))
        end,
        unlocked = true
    }
end