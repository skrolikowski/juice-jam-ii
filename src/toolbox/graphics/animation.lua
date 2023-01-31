-- Animation API
-- Shane Krolikowski
--

-- Returns next frame index
--
local __nextFrame = function(obj)
	if obj.isReverse then
		return math.max((obj.index - 1), 1)
	else
		return math.min((obj.index + 1), #obj.quads)
	end
end

-- Is start of animation?
--
local __isStartOfAnim = function(obj)
	return obj.index == (obj.isReverse and #obj.quads or 1)
end

-- Is end of animation?
--
local __isEndOfAnim = function(obj)
	return obj.index == (obj.isReverse and 1 or #obj.quads)
end

-- Is end of sequence?
--
local __isEndOfSequence = function(obj)
	return obj.total and obj.total >= obj.count
end

-- Post animation loop
--
local __postAnim = function(obj)
	--
	-- animation count
	obj.count = obj.count + 1

	--
	if __isEndOfSequence(obj) then
		obj:onEndSequence()
	else
		obj:play()
	end
end

-- Advance to next frame in animation
--
local __advance = function(obj)
	obj.index = __nextFrame(obj)

	if __isEndOfAnim(obj) then
		__postAnim(obj)
		--
		obj:onEndAnimation()
	end
end

---- ---- ---- ----

local Animation = Class {}

-- New
--
function Animation:init(sheet)
	--
	-- properties
	self.sheet = sheet
	self.delta = 1 / 10
	self.index = 1

	-- flags
	self.isReverse = false
	self.isPlaying = false

	-- set quads..
	self.quads = {}
	for _, quad in pairs(sheet.quads) do
		table.insert(self.quads, quad)
	end
end

-- Container
--
function Animation:container()
	assert(self.index ~= nil, "frame index not set")
	return self.quads[self.index]:getViewport()
end

-- Get width/height
--
function Animation:dimensions()
	local x, y, w, h = self:container()

	return w, h
end

-- Update
--
function Animation:update(dt)
	if self.isPlaying then
		self.elapsed = (self.elapsed or 0) + dt

		if self.elapsed >= self.delta then
			self.elapsed = 0
			--
			__advance(self)
		end
	end
end

-- Draw
--
function Animation:draw(...)
	self:drawFrame(self.index, ...)
end

function Animation:drawFrame(index, _x, _y, _rot)
	local x, y, w, h = self:container()
	local image      = self.sheet.image
	local quad       = self.quads[index]
	local sx         = self.sx or 1
	local sy         = self.sy or 1
	local ox         = (self.ox or 0) + w * 0.5
	local oy         = (self.oy or 0) + h * 0.5

	lg.draw(image, quad, _x, _y, _rot, sx, sy, ox, oy)
end

---- ---- ---- ----

-- Event: onEndAnimation
--
function Animation:onEndAnimation()
	--
end

-- Event: onEndSequence
--
function Animation:onEndSequence()
	--
	-- callback?
	if self.cbAfter then
		self.cbAfter(self)
	end

	--
	self:stop()
end

---- ---- ---- ----

-- Add frames
--
function Animation:frames(...)
	for _, name in ipairs({ ... }) do
		table.insert(self.quads, self.sheet:quad(name))
	end

	return self
end

-- Play animation at fps
-- [Chain]
--
function Animation:at(fps)
	self.delta = 1 / fps
	return self
end

-- Animation offset
-- [Chain]
--
function Animation:offset(ox, oy)
	self.ox = ox or 0
	self.oy = oy or 0
	return self
end

-- Animation scale
-- [Chain]
--
function Animation:scale(sx, sy)
	self.sx = sx or 0
	self.sy = sy or 0
	return self
end

-- Toggle animation direction
-- [Chain]
--
function Animation:reverse()
	self.isReverse = not self.isReverse
	return self
end

-- After animation callback
-- [Chain]
--
function Animation:after(cb)
	self.cbAfter = cb
	return self
end

-- Play animation once
-- [Chain]
--
function Animation:once()
	self.total = 1
	return self
end

-- Play animation twice
-- [Chain]
--
function Animation:twice()
	self.total = 2
	return self
end

-- Run animation number of times
-- [Chain]
--
function Animation:times(total)
	self.total = total
	return self
end

-- Play number of times
-- [Chain][Default]
--
function Animation:loop()
	self.total = nil
	return self
end

---- ---- ---- ----
-- Controls

-- Run animation
--
function Animation:play()
	self.isPlaying = true
	self.count     = 0
	self.index     = self.isReverse and #self.index or 1
end

-- Run animation
-- [Alias]
--
function Animation:start()
	self:play()
end

-- Run animation
-- [Alias]
--
function Animation:run()
	self:play()
end

-- Stop animation
--
function Animation:stop()
	self.isPlaying = false
end

return Animation
