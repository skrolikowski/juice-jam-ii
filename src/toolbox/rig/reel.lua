-- Reel
--
local M = Class {}

function M:init(data)
    local cx = (data.index - 1) * Config.tile.size + Config.tile.size * 0.5
    local cy = Config.rig.numRows * Config.tile.size * 0.5

    self.index = data.index
    self.pos   = Vec2(cx, cy)
    self.tiles = {}

    -- create tiles
    for i = 1, Config.rig.numRows do
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
    return Config.tile.size, Config.rig.numRows * Config.tile.size
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

function M:startSpin()
    self.isSpinning = true
    self.numSpins = 1
    self.remSpins = 0
    --
    self:spin()
end

function M:stopSpin()
    self.remSpins = #Config.reel.spinDurationOut
end

function M:spin()
    local duration = Config.reel.spinDuration
    local subject  = self.pos
    local target   = { y = self.pos.y + Config.tile.size }
    local ease     = Config.reel.spinEase

    -- number of spins..?
    if self.numSpins > 0 and self.numSpins <= #Config.reel.spinDurationIn then
        duration = Config.reel.spinDurationIn[self.numSpins]

        if self.numSpins == 1 then
            ease = "in-back"
        end
    end

    -- remaining spins..?
    if self.remSpins > 0 and self.remSpins <= #Config.reel.spinDurationOut then
        duration = Config.reel.spinDurationOut[self.remSpins]

        if self.remSpins == 1 then
            ease = "out-back"
            --
            self.isSpinning = false
        end
    end

    -- tween
    self.tween = Timer.tween(duration, subject, target, ease, function()
        --
        -- update spin counters..
        self.numSpins = self.numSpins + 1
        self.remSpins = self.remSpins - 1

        -- reset reel position..
        self.pos.y = self.pos.y - Config.tile.size

        -- adjust tiles..
        local last = table.remove(self.tiles)
        table.insert(self.tiles, 1, last)
        --
        for i, tile in pairs(self.tiles) do
            tile:setRow(i)
        end

        -- continue spinning..
        if self.isSpinning then
            self:spin()
        end
    end)
end

--
-- JUICE
--

function M:addJuice()
    for _, tile in pairs(self.tiles) do
        tile:addJuice()
    end
end

function M:removeJuice()
    for _, tile in pairs(self.tiles) do
        tile:removeJuice()
    end
end

return M
