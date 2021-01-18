local NovaWorldBuffsLocale = LibStub("AceLocale-3.0"):GetLocale("NovaWorldBuffs", true)
if NovaWorldBuffsLocale then
	NovaWorldBuffsLocale["versionOutOfDate"] = ""
end

local _detalhes = _G.detalhes
if _detalhes then
	local DetailsLocale = LibStub("AceLocale-3.0"):GetLocale("Details")
	local _detalhes_Msg_Original = _detalhes.Msg
	function _detalhes:Msg(_string, ...)
		if _string ~= DetailsLocale["STRING_VERSION_AVAILABLE"] then
			_detalhes_Msg_Original(_string, ...)
		end
	end
end
