-- ImARogueNow.lua
--math.randomseed()
--search strings
local search = {
    5370,
	9647,
	4582,
	17408,
	18227,
	18230,
	20030,
	5368,
	5431,
	204905,
	209041,
	5263,
	6662,
	209845,
	209849,
	12037,
	8350,
	5428,
	13523,
	19019	
}

-- Initialize the ImARogueNow table
ImARogueNow = {}
ImARogueNow.frame = CreateFrame("Frame")

-- Welcome message
local function OnAddonLoaded()
    print("|cff00ff00You're a Rogue Now! Type /ppcache to avoid failed pickpockets, then target a player and do /pp or /pickpocket to start!|r")
end

-- Pre Cache items
function PickPocketItemCache()
	print("Checking for cached items now:")
    for _, itemID in ipairs(search) do
            local itemLink = select(2, GetItemInfo(itemID))
            if not itemLink then
                print("|cffff0000Item ID " .. itemID .. " does not return a valid item link. Item not cached yet.|r")
			else
            -- Green color: |cff00ff00
            print("|cff00ff00Item ID " .. itemID .. " cached.|r")
			end
    end
	print("Cache check complete, if any items did not return a valid item link please retry /ppcache in around 30 seconds")
end

-- Register for events
ImARogueNow.frame:RegisterEvent("ADDON_LOADED")

-- Event handler function
ImARogueNow.frame:SetScript("OnEvent", function(self, event, arg1, ...)
    if event == "ADDON_LOADED" and arg1 == "ImARogueNow" then
        OnAddonLoaded()
    end
end)

-- Slash Command Registration
SLASH_PICKPOCKET1 = "/pickpocket"
SLASH_PICKPOCKET2 = "/pp"
SLASH_PICKPOCKETCACHE1 = "/ppcache"
SLASH_PICKPOCKETCACHE2 = "/pickpocketcache"

SlashCmdList["PICKPOCKET"] = function(msg)
    PickPocket()
end

SlashCmdList["PICKPOCKETCACHE"] = function(msg)
    PickPocketItemCache()
end

function PickPocket()
    -- Check if the player has a target
    if UnitExists("target") then --and UnitIsPlayer("target") then
        local Target = UnitName("target")

        -- Perform a random roll
        local roll = math.random(1, 20) -- Roll based on the number of items in search
		local quantity = math.random(1,5)
		
		-- Disabled DnD roll style check, felt like it was bloating the chat window with too much text
		-- SendChatMessage("attempts to pickpocket " .. Target .. " and rolls a " .. roll .. " on their dexterity check.", "EMOTE", nil)
		
        -- Get item link from the item ID
        local itemID = search[roll]
        local itemLink = select(2, GetItemInfo(itemID))

        -- Check if item link is retrieved and send message
		if itemLink then
			if roll == 1 then
				SendChatMessage("pickpockets " .. Target .. " and loots a " .. itemLink, "EMOTE")
			elseif roll >= 2 and roll <= 7 then
				SendChatMessage("pickpockets " .. Target .. " and loots a " .. itemLink, "EMOTE")
			elseif roll >= 8 and roll <= 10 then
				SendChatMessage("pickpockets " .. Target .. " and loots an " .. itemLink, "EMOTE")
			elseif roll >= 11 and roll <= 13 then
				SendChatMessage("pickpockets " .. Target .. " and loots " .. quantity .. " " .. itemLink, "EMOTE")
			elseif roll >= 14 and roll <= 18 then
				SendChatMessage("pickpockets " .. Target .. " and loots " .. itemLink, "EMOTE")
			elseif roll == 19 then
				SendChatMessage("pickpockets " .. Target .. " and loots the " .. itemLink, "EMOTE")
			elseif roll == 20 then
				SendChatMessage("pickpockets " .. Target .. " and loots " .. itemLink, "EMOTE")
			end	
        else
            SendChatMessage("fails their pickpocket attempt!", "EMOTE", nil)
        end
    else
        SendChatMessage("has no pickpocket target...", "EMOTE", nil)		
    end
end