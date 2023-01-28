-- Reel
--
local M = Class {}

function M:init(data)
    self.index       = data.index
    self.pos         = Vec2((self.index - 1) * Config.tile.width, 0)
    self.tiles       = {}
    --
    self.isSpinning  = false
    self.requestSpin = false
    self.requestStop = false

    -- create tiles
    for i = 1, Config.reel.numTiles do
        table.insert(self.tiles, Tile({ reel = self.index, row = i }))
    end
end

function M:update(dt)
    for _, tile in pairs(self.tiles) do
        tile:update(dt)
    end
end

function M:draw()
    lg.push()
    lg.translate(self:position())
    --
    for _, tile in pairs(self.tiles) do
        tile:draw()
    end
    --
    lg.pop()
end

--
-- PROPERTIES
--

function M:center()
    return self.pos:unpack()
end

function M:size()
    return Config.tile.width, #self.tiles * Config.tile.height
end

function M:position()
    local cx, cy = self:center()
    local w, h   = self:size()
    local x      = cx - w * 0.5
    local y      = cy - h * 0.5

    return x, y
end

function M:container()
    local cx, cy = self:center()
    local w, h   = self:size()
    local x      = cx - w * 0.5
    local y      = cy - h * 0.5

    return x, y, w, h
end

--
-- METHODS
--

function M:triggerSpin()
    if self.isSpinning then
        self.requestStop = true
    else
        self.requestStop = false
        self:spin()
    end
end

function M:spin()
    local duration = 0.5
    local subject  = self.pos
    local target   = { y = self.pos.y + Config.tile.height }
    local ease     = "in-quad"

    self.isSpinning = true

    self.tween = Timer.tween(duration, subject, target, ease, function()
        self:postSpin()
    end)
end

function M:fullspin()
    local duration = 0.25
    local subject  = self.pos
    local target   = { y = self.pos.y + Config.tile.height }
    local ease     = "linear"

    self.tween = Timer.tween(duration, subject, target, ease, function()
        self:postSpin()
    end)
end

function M:stopSpin()
    local duration = 0.5
    local subject  = self.pos
    local target   = { y = self.pos.y + Config.tile.height }
    local ease     = "in-bounce"

    Timer.cancel(self.tween)
    --
    self.tween = Timer.tween(duration, subject, target, ease, function()
        --
        -- reset reel position..
        self.pos.y = self.pos.y - Config.tile.height

        -- adjust tiles..
        for _, tile in pairs(self.tiles) do
            tile:incrementRow()
        end

        -- stopped spinning..
        self.isSpinning = false
    end)
end

function M:postSpin()
    --
    -- reset reel position..
    self.pos.y = self.pos.y - Config.tile.height

    -- adjust tiles..
    for _, tile in pairs(self.tiles) do
        tile:incrementRow()
    end

    -- continue/stop spinning..
    if self.requestStop then
        self:stopSpin()
    else
        self:fullspin()
    end
end

return M
