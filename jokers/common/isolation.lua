

local jokerThing = SMODS.Joker{
    name = "isolation", 
    key = "isolation", 
    config = {
      extra = {
      }
    }, 
    pos = {x = 0, y = 5}, 
    loc_txt = {
      name = "Isolation", 
      text = {
        "Jacks, Queens & Kings are",
        "not considered {C:attention}Face Cards{}"
      }
    }, 
    rarity = 1, 
    cost = 5, 
    order = 14,
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
}

G.P_CENTERS["j_threex_isolation"] = jokerThing