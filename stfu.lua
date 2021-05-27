local blocked_messages = {}

local AddMessage = DEFAULT_CHAT_FRAME.AddMessage
DEFAULT_CHAT_FRAME.AddMessage = function(frame, message, ...)
	if not blocked_messages[message] then
		AddMessage(frame, message, ...)
	end
end

local print = function(...)
	AddMessage(DEFAULT_CHAT_FRAME, ...)
end

setmetatable(blocked_messages, {
	__index = function(t, k)
		-- If the hash part of the table doesn't contain a message directly,
		-- then iterate the patterns in the array part of the table
		for i,v in ipairs(t) do
			if string.match(k, v) then
				return true
			end
		end
	end
})

local untokenize = function(s)
	return string.gsub(s, "%%%a", ".-")
end

if IsAddOnLoaded("NovaWorldBuffs") then
	local L = LibStub("AceLocale-3.0"):GetLocale("NovaWorldBuffs", true)
	if L then
		blocked_messages["|cffff6900" .. L["versionOutOfDate"]] = true
	end
end

if IsAddOnLoaded("Details") then
	local L = LibStub("AceLocale-3.0"):GetLocale("Details")
	if L then
		blocked_messages[L["STRING_VERSION_AVAILABLE"]] = true
	end
	blocked_messages["|CFFFFFF00[Details!]: To use Tiny Threat: right click the title bar and select Tiny Threat."] = true
end

if IsAddOnLoaded("aux-addon") then
	blocked_messages[LIGHTYELLOW_FONT_COLOR_CODE .. '<aux> ' .. 'loaded - /aux'] = true
end

if IsAddOnLoaded("WeakAuras") then
	local L = WeakAuras.L
	if L then
		local pattern = "|cff9900ffWeakAuras:|r " .. untokenize(L["There are %i updates to your auras ready to be installed!"])
		tinsert(blocked_messages, pattern)
	end
end

if IsAddOnLoaded("GlobalIgnoreList") then
	local prefix = "|cff33ff99Global Ignore: |cffffffff"
	blocked_messages[prefix .. "Type /gignore or /gi for help and options"] = true
	blocked_messages[prefix .. "Synchronizing Ignore list..."] = true
	blocked_messages[prefix .. "New character found: Importing ignored players"] = true
end

if IsAddOnLoaded("Questie") then
	blocked_messages["|cffff0000You have an outdated version of Questie!|r"] = true
	blocked_messages["|cffff0000Please consider updating!|r"] = true
end

if IsAddOnLoaded("DBM-Core") then
	local L = DBM_CORE_L

	local pattern1 = ("|cffff7d0a<|r|cffffd200%s|r|cffff7d0a>|r %s"):format(L.DBM, L.UPDATEREMINDER_HEADER:match("([^\n]*)"))
	blocked_messages[pattern1] = true

	local pattern2 = ("|cffff7d0a<|r|cffffd200%s|r|cffff7d0a>|r %s"):format(L.DBM, untokenize(L.UPDATEREMINDER_HEADER:match("\n(.*)")))
	tinsert(blocked_messages, pattern2)
end
