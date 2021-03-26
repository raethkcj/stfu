local blocked_messages = {}

local AddMessage = DEFAULT_CHAT_FRAME.AddMessage
DEFAULT_CHAT_FRAME.AddMessage = function(frame, message, ...)
	if not blocked_messages[message] then
		AddMessage(frame, message, ...)
	end
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
	blocked_messages["|CFFFFFF00[Details!]: To use Tiny Threat: right click the title bar and select Tiny Threat."] = true
end

if IsAddOnLoaded("aux-addon") then
	blocked_messages[LIGHTYELLOW_FONT_COLOR_CODE .. '<aux> ' .. 'loaded - /aux'] = true
end

if IsAddOnLoaded("WeakAuras") then
	local L = WeakAuras.L
	if L then
		local pattern = "|cff9900ffWeakAuras:|r " .. string.gsub(L["There are %i updates to your auras ready to be installed!"], "%%i", "%%d+")
		tinsert(blocked_messages, pattern)
	end
end
