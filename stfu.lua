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
end

if IsAddOnLoadable("DBM-Core") then
	local L = DBM_CORE_L

	local pattern1 = ("|cffff7d0a<|r|cffffd200%s|r|cffff7d0a>|r %s"):format(L.DBM, L.UPDATEREMINDER_HEADER:match("([^\n]*)"))
	blocked_messages[pattern1] = true

	local pattern2 = ("|cffff7d0a<|r|cffffd200%s|r|cffff7d0a>|r %s"):format(L.DBM, untokenize(L.UPDATEREMINDER_HEADER:match("\n(.*)")))
	tinsert(blocked_messages, pattern2)
end
