local parent, ns = ...
local private = ns.private
local _G = getfenv(0)

local DB_VERSION = 0

local defaults = {
	raids = {},
	players = {},
	items = {},
	grank_min = 2,
}

local dbUpgrade = function(db)
	-- Do some more stuff here
	db.version = DB_VERSION
end

-- Can only be called if we are in a guild
function private.initDB()
	local realm = GetRealmName()
	local guild, _, rank = GetGuildInfo("player")

	local db = _G.FeindishDB or {}
	db[realm] = db[realm] or {}
	db[realm][guild] = setmetatable(db[realm][guild] or { version = DB_VERSION }, { __index = defaults })
	_G.FeindishDB = db

	private.db = db[realm][guild]

	if(db[realm][guild].version < DB_VERSION) then
		dbUpdate(db[realm][guild])
	end

	return db[realm][guild]
end
