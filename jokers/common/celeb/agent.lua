local jokerThing = SMODS.Joker{
    name = "special",
    key = "j_threex_special",
    config = {
        extra = {
            mult = 4,
            suit = 'hearts',
            suitChecking = 'Hearts'
        }
    },
    pos = { x = 5, y = 8 },
    loc_txt = {
        name = "Special Agent Joker",
        text = {
            "{C:hearts}#2#{} held-in-hand give",
            "{C:mult}+#1#{} Mult,"
        }
    },
    rarity = 1,
    cost = 4,
    order = 94,
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
        print("Context Check:", context.cardarea == G.hand, context.individual, context.end_of_round)
        
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

G.P_CENTERS["j_threex_special"] = jokerThing

if testDecks then
    SMODS.Back{
        key = 'specDeck',
        loc_txt = {
            name = "Special",
            text = {
                "AT"
            }
        },
        name = "specDeck",
        pos = {x = 1, y = 2},
        
        apply = function(self)
            G.E_MANAGER:add_event(Event({
                func = function()
                    for index = #G.playing_cards, 1, -1 do
                        local suit = "H_"
                        local rank = "T"
                        G.playing_cards[index]:set_base(G.P_CARDS[suit .. rank])
                    end
                    add_joker("j_threex_special", nil, false, false)
                    return true
                end
            }))
        end,
        unlocked = true
    }
end