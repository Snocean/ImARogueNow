-- ImARogueNow.lua
--math.randomseed()

--Loot tables

local common = {
	5370,
	18227,
	18230,
	20030,
	5368,
	5431,
	5428,
	1520,
	5263,
	209041,
	6662,
	4582,
	17408,
	204905,
	209845,
	209849,
	12037,
	13523,
	939,
	9329,
	3317,
	12467,
	23215,
	1006,
	21037,
	23578,
	21830,
	20387,
	12814,
	22260,
	21823,
	13585,
	19943,
	7339,
	7338,
	210765,
	19483,
	23722,
	12924,
	15875,
	8243,
	7342,
	20604,
	23579,
	7337,
	23211,
	190307,
	18231,
	18229,
	18365,
	18233,
	18228,
	4499,
	6083,
	17035,
	6651
}

local rare = {
    9647,
	8350,
	11116,
	9648,
	3567,
	19814,
	11905,
	11902,
	14180,
	5611,
	6327,
	18358,
	11930,
	13139,
	10758,
	21103,
	18703,
	20383,
	19944,
	20644,
	19382,
	191481,
	19321
}

local legendary = {
    21103,
	18703,
	20383,
	19944,
	20644,
	19382,
	191481,
	19321,
	19019,
	17182,
	22589,
	21176,
	19017
}


-- Initialize the ImARogueNow table
ImARogueNow = {}
ImARogueNow.frame = CreateFrame("Frame")

-- Welcome message
local function OnAddonLoaded()
    print("|cff00ff00You're a Rogue Now! Type /ppcache to avoid failed pickpockets, then target a player and do /pp or /pickpocket to start!|r")
	PickPocketItemCache()
end

-- Pre Cache items
function PickPocketItemCache()
	print("Checking for cached items now:")
    for _, itemID in ipairs(common) do
            local itemLink = select(2, GetItemInfo(itemID))
            if not itemLink then
                print("|cffff0000Item ID " .. itemID .. " does not return a valid item link. Item not cached yet.|r")
			end
    end
	for _, itemID in ipairs(rare) do
            local itemLink = select(2, GetItemInfo(itemID))
            if not itemLink then
                print("|cffff0000Item ID " .. itemID .. " does not return a valid item link. Item not cached yet.|r")
			end
    end
	for _, itemID in ipairs(legendary) do
            local itemLink = select(2, GetItemInfo(itemID))
            if not itemLink then
                print("|cffff0000Item ID " .. itemID .. " does not return a valid item link. Item not cached yet.|r")
			end
    end
	print("Cache check complete, if any items did not return a valid item link please retry /ppcache in around 10 seconds")
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
		
        -- Perform random rolls
		local rarity = math.random(1,10)
        local rollcommon = math.random(1, #common) -- Roll based on the number of items in common
		local rollrare = math.random(1, #rare) -- Roll based on the number of items in common
		local rollLegendary = math.random(1, #legendary) -- Roll based on the number of items in common
		
		-- Disabled DnD roll style check, felt like it was bloating the chat window with too much text
		-- SendChatMessage("attempts to pickpocket " .. Target .. " and rolls a " .. roll .. " on their dexterity check.", "EMOTE", nil)
		-- Rarity rolls
		if rarity <= 5 then
			-- Get item link from the item ID
			local itemID = common[rollcommon]
			local itemLink = select(2, GetItemInfo(itemID))

			-- Check if item link is retrieved and send message
			if itemLink and itemID == 17035 then
					SendChatMessage("pickpockets " .. Target .. " and loots 11 " .. itemLink, "EMOTE")
			elseif itemLink then
					SendChatMessage("pickpockets " .. Target .. " and loots " .. itemLink, "EMOTE")
			else
            SendChatMessage("fails their pickpocket attempt!", "EMOTE", nil)
			end	
		elseif rarity >= 6 and rarity <= 9 then
			-- Get item link from the item ID
			local itemID = rare[rollrare]
			local itemLink = select(2, GetItemInfo(itemID))

			-- Check if item link is retrieved and send message
			if itemLink then
					SendChatMessage("pickpockets " .. Target .. " and loots " .. itemLink, "EMOTE")
			else
            SendChatMessage("fails their pickpocket attempt!", "EMOTE", nil)
			end
		elseif rarity == 10 then
			-- Get item link from the item ID
			local itemID = legendary[rollLegendary]
			local itemLink = select(2, GetItemInfo(itemID))

			-- Check if item link is retrieved and send message
			if itemLink then
					SendChatMessage("pickpockets " .. Target .. " and loots " .. itemLink, "EMOTE")
			else
            SendChatMessage("fails their pickpocket attempt!", "EMOTE", nil)
			end	
        end
    else
        SendChatMessage("has no pickpocket target...", "EMOTE", nil)		
    end
end
