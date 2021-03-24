local blocked_messages = {}

local AddMessage = DEFAULT_CHAT_FRAME.AddMessage
DEFAULT_CHAT_FRAME.AddMessage = function(frame, message, ...)
	if not blocked_messages[message] then
		AddMessage(frame, message, ...)
	end
end

if IsAddOnLoaded("NovaWorldBuffs") then
	local L = LibStub("AceLocale-3.0"):GetLocale("NovaWorldBuffs", true)
	if L then
		blocked_messages["|cFFFF6900" .. L["versionOutOfDate"]] = true
	end
end

if IsAddOnLoaded("Details") then
	local L = LibStub("AceLocale-3.0"):GetLocale("Details")
	if L then
		blocked_messages[L["STRING_VERSION_AVAILABLE"]] = true
	end
end

if IsAddOnLoaded("aux-addon") then
	blocked_messages[LIGHTYELLOW_FONT_COLOR_CODE .. '<aux> ' .. 'loaded - /aux'] = true
end
