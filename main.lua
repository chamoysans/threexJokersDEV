----------------------------------------
--                                    --
--            Hey Viewer!             --
--                                    --
--   So uhhh the actual joker code    --
--      is in the jokers folder,      --
--                                    --
--        If you need anything        --
--        else or want to ask         --
--        questions, DM me in         --
--         Discord: @taco78           --
--                                    --
----------------------------------------

local common = {
    "seenoevil",
    "speaknoevil",
    "hearnoevil",
    "jimmy",
    "clowncar",
    "loot",
    "sharpshooter",
    "blank",
    "retriggerNum/firebrick",
    "retriggerNum/coral",
    "retriggerNum/golden",
    "retriggerNum/khaki",
    "retriggerNum/olive",
    "retriggerNum/seagreen",
    "retriggerNum/aqua",
    "retriggerNum/steel",
    "retriggerNum/slate",
    "retriggerNum/orchid",
    "skinny",
    "portly",
}


SMODS.Atlas({
	key = "a_threex_placeholder",
	path = "placeholders.png",
	px = 71,
	py = 95
})

local directory = "jokers/" -- Change this to your actual directory path

for _, filename in ipairs(common) do
    local filePath = directory .. "common/" .. filename .. ".lua"
    assert(SMODS.load_file(filePath))()

end
