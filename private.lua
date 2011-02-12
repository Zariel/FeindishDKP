local parent, ns = ...
local private = ns.private

private.token = math.random(0, 127)

local prefix = ""
for i = 1, 16 do
	prefix = prefix .. string.char(math.random(0, 127))
end

private.prefix = prefix
