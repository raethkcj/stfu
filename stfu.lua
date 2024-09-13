local blocked_messages = {}

local AddMessage = DEFAULT_CHAT_FRAME.AddMessage

local print = function(...)
	AddMessage(DEFAULT_CHAT_FRAME, ...)
end

local DEBUG = false

DEFAULT_CHAT_FRAME.AddMessage = function(frame, message, ...)
	if not blocked_messages[message] then
		if DEBUG then
			AddMessage(frame, message:gsub("|", "||"), ...)
		else
			AddMessage(frame, message, ...)
		end
	end
end

setmetatable(blocked_messages, {
	__index = function(t, k)
		-- If the hash part of the table doesn't contain a message directly,
		-- then iterate the patterns in the array part of the table
		for i,v in ipairs(t) do
			if k:match(v) then
				return true
			end
		end
	end
})

local untokenize = function(s)
	return s:gsub("%-", "%%-"):gsub("%%%a", ".-"):gsub("([%(%)])", "%%%1")
end

local function IsAddOnLoadable(addonName)
	return select(4,GetAddOnInfo(addonName))
end

if IsAddOnLoadable("NovaWorldBuffs") then
	blocked_messages["|cffff6900Nova World Buffs is out of date, please update at https://www.curseforge.com/wow/addons/nova-world-buffs"] = true
end

if IsAddOnLoadable("Details") then
	blocked_messages["|cffffaeaeDetails!:|r " .. "a new version is available, download it from Curse Forge app or website."] = true
	blocked_messages["|cffffaeaeDetails!:|r a new version is available, download it from Curse Forge app or website.    "] = true
	blocked_messages["|CFFFFFF00[Details!]: To use Tiny Threat: right click the title bar and select Tiny Threat."] = true
end

if IsAddOnLoadable("aux-addon") then
	blocked_messages[LIGHTYELLOW_FONT_COLOR_CODE .. '<aux> ' .. 'loaded - /aux'] = true
end

if IsAddOnLoadable("WeakAuras") then
	local pattern = "|cff9900ffWeakAuras:|r " .. untokenize("There are %i updates to your auras ready to be installed!")
	tinsert(blocked_messages, pattern)
end

if IsAddOnLoadable("Gargul") then
	local pattern = "Gargul.-is available"
	tinsert(blocked_messages, pattern)
end

if IsAddOnLoadable("GlobalIgnoreList") then
	local prefix = "|cff33ff99Global Ignore: |cffffffff"
	blocked_messages[prefix .. "Type /gignore or /gi for help and options"] = true
	blocked_messages[prefix .. "Synchronizing Ignore list..."] = true
	blocked_messages[prefix .. "New character found: Importing ignored players"] = true
end

if IsAddOnLoadable("Questie") then
	blocked_messages["|cff33ff99Questie|r: |cffff0000 You have an outdated version of Questie! |r"] = true
	blocked_messages["|cff33ff99Questie|r: |cffff0000 Please consider updating! |r"] = true
	blocked_messages["|cff30fc96Questie|r: |cff00bc32Hiding drop-down menus on the World Map.|r This is currently necessary as a workaround for a bug in the default Blizzard UI related to drop-down menus."] = true
	blocked_messages["|cffffde7fWelcome to Season of Discovery! Questie is being continuously updated with the new quests from this season, but it will take time. Be sure to update frequently to minimize errors.|r"] = true
	blocked_messages["|cffffde7fWhile playing Season of Discovery, Questie will notify you if it encounters a quest it doesn't yet know about. Please share this info with us on Discord or GitHub!|r"] = true
end

if IsAddOnLoadable("DBM-Core") then
	local L = DBM_CORE_L

	local pattern1 = "|cffff7d0a<|r|cffffd200DBM|r|cffff7d0a>|r Your version of Deadly Boss Mods is out-of-date."
	blocked_messages[pattern1] = true

	local pattern2 = untokenize(" Version %s (%s) is available for download through Curse, WoWI, or from GitHub Releases page")
	local pattern3 = "|cffff7d0a<|r|cffffd200DBM|r|cffff7d0a>|r  Version .* is available for download through Curse, Wago, WoWI, or from GitHub Releases page"
	local pattern4 = "|cffff7d0a<|r|cffffd200DBM|r|cffff7d0a>|r Your version of Deadly Boss Mods is out-of-date.\Version .* is available for download through Curse, Wago, WoWI, or from GitHub Releases page"
	tinsert(blocked_messages, pattern2)
	tinsert(blocked_messages, pattern3)
	tinsert(blocked_messages, pattern4)
end

if IsAddOnLoadable("LFGBulletinBoard") then
	local pattern = "|cFFFF1C1C Loaded: LFG Bulletin Board 2.61 by Vyscî-Whitemane"
	blocked_messages[pattern] = true
end

if IsAddOnLoadable("M6") then
	blocked_messages["Unknown macro option: scri"] = true
end

if IsAddOnLoadable("RankSentinel") then
	local pattern = "|cFFFFFF00Rank Sentinel|r: |c0000FF00Loaded.-|r"
	tinsert(blocked_messages, pattern)
end

if IsAddOnLoadable("RCLootCouncil_Classic") then
	local pattern = "|cff33ff99RCLootCouncil_Classic|r: Your version .+ is outdated. Newer version is .+, please update RCLootCouncil."
	tinsert(blocked_messages, pattern)
end

if IsAddOnLoadable("+Wowhead_Looter") then
	local pattern = untokenize("|cffffff7fWowhead Looter|r loaded (%d) - %d-%d-%d")
	tinsert(blocked_messages, pattern)
end

if IsAddOnLoadable("WowSimsExporter") then
	local pattern = "|cff33ff99WowSimsExporter|r: WowSimsExporter .- Initialized. use /wse For Window."
	tinsert(blocked_messages, pattern)
end
