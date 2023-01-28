-- Dice Roller
--

local Modern = require 'vendor.modern'
local Dice   = Modern:extend()

function Dice:new(str)
	self.rolls = {}

	-- parse
	for __, roll in pairs(_:words(str, '([^%s]+)')) do
		table.insert(self.rolls, {
			_.__match(roll, "^(%d+)[dD](%d+)[%+|%-]?(%d*)$")
		})
	end
end

-- Roll!
--
function Dice:roll()
	local total = _:sumBy(self.rolls, function(roll)
		return Dice.Calculate(unpack(roll))
	end)

	return total
end

-- Higher-than-average roll!
-- Returns max roll value for `n` rolls.
--
function Dice:maxRoll(n)
	local rolls = {}

	for i = 1, n do
		table.insert(rolls, self:roll())
	end

	return math.max(unpack(rolls))
end

-- Lower-than-average roll!
-- Returns min roll value for `n` rolls.
--
function Dice:maxRoll(n)
	local rolls = {}

	for i = 1, n do
		table.insert(rolls, self:roll())
	end

	return math.min(unpack(rolls))
end

-- Util: calculate dice roll
--
function Dice.Calculate(n, sides, mod)
	local total = 0

	-- adjust
	n     = math.floor(n)
	sides = _:round(sides)

	for i = 1, n do
		total = total + math.random(1, sides)
	end

	return total + (tonumber(mod) or 0)
end

-- Util: weighted dice roll
--
function Dice.Weighted(tabl)
	local sum      = _:sumBy(tabl, function(item) return item.wt end)
	local index    = 0
	local selector = math.random() * sum

	while selector > 0 do
		index    = index + 1
		selector = selector - tabl[index].wt
	end

	return tabl[index], index
end

return Dice
