-- Reel Tile
--
local M = Class {}

function M:init(data)
    self.reel = data.reel
    self.row  = data.row
    --
    self:setNewSymbol()
end

function M:draw()
    -- draw background
    lg.setColor(Config.color.tile)
    lg.rectangle('fill', self:container())

    lg.setColor(Config.color.black)
    lg.rectangle('line', self:container())

    -- draw symbol
    lg.push()
    lg.translate(self:center())
    --
    lg.setColor(Config.color.white)
    lg.draw(self.symbol,
        -self.symbolWidth * self.symbolScale.x * 0.5,
        -self.symbolHeight * self.symbolScale.y * 0.5,
        0,
        self.symbolScale.x,
        self.symbolScale.y)
    --
    lg.pop()
end

--
-- PROPERTIES
--

function M:center()
    return Config.tile.size * 0.5, (self.row - 1) * Config.tile.size + Config.tile.size * 0.5
end

function M:size()
    return Config.tile.size, Config.tile.size
end

function M:position()
    local cx, cy = self:center()
    local w, h   = self:size()
    local x      = cx - w * 0.5
    local y      = cy - h * 0.5

    return x, y
end

function M:bounds()
    local cx, cy   = self:center()
    local w, h     = self:size()
    local rotation = self.rotation or 0

    w = w * (self.bx or 1)
    h = h * (self.by or 1)

    return AABB:compute(cx, cy, w, h, rotation)
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

function M:setRow(row)
    self.row = row

    if self.row == 1 then
        self:setNewSymbol()
    end
end

function M:setNewSymbol()
    local weights
    if self.reel == 1 then
        weights = Config.rig.symbolWeightsReelOne
    else
        weights = Config.rig.symbolWeights
    end

    local _, randIndex = Util.WeightedChoice(weights)

    --
    self.symbolIndex  = randIndex
    self.symbol       = Config.image.symbol[self.symbolIndex]
    self.symbolWidth  = self.symbol:getWidth()
    self.symbolHeight = self.symbol:getHeight()
    self.symbolScale  = Vec2(Config.tile.scale, Config.tile.scale)
end

return M
