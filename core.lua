local parent, ns = ...
local addon = ns.feindishdkp
local private = ns.private

addon:SetScript("OnEvent", function(self, event, ...)
	return self[event](self, event, ...)
end)

addon:RegisterEvent("ADDON_LOADED")
addon:RegisterEvent("PLAYER_ENTERING_WORLD")

function addon:ADDON_LOADED(event, addon)
	if(addon ~= "FeindishDKP") then return end

	self:RegisterEvent("CHAT_MSG_ADDON")

	self:UnregisterEvent(event)
end

function addon:PLAYER_ENTERING_WORLD(event)
	local db = private.initDB()

	-- Get our guild and rank, then check our auth token, then setup
	-- permisions.

	local gname, _, grank = GetGuildInfo("player")
	-- Todo update this to enable custom permisons
	self.permision = grank <= db.grank_min

	if(self.permision) then
		-- Try to get a new token
		SendAddonMessage(private.prefix, "GetToken", "GUILD")
	end

	self:UnregisterEvent(event)
end

function addon:CHAT_MSG_ADDON(prefix, msg, scope, sender)
	if(prefix ~= private.prefix) then return end

	if(msg == "GetToken") then
		if(self.permision) then
			SendAddonMessage(private.prefix, "AuthToken", "WHISPER", sender)
		end
	elseif(msg == "AuthToken") then
		private.token = tonumber(msg)
	end
end

