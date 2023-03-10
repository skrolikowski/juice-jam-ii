-- Reel Tile
--
local M = Class {}

function M:init(data)
    self.reel = data.reel
    self.row  = data.row
    --
    self:setNewSymbol()
end

function M:update(dt)
    if self.symbolAnim and self.symbolAnim.isPlaying then
        self.symbolAnim:update(dt)
    end
end

function M:draw()
    --
    -- draw symbol
    lg.push()
    lg.translate(self:center())
    lg.scale(self.symbolScale.x, self.symbolScale.y)
    lg.setColor(Config.color.white)

    --
    if self.symbolAnim and self.symbolAnim.isPlaying then
        self.symbolAnim:draw(0, 0, 0, 2, 2)
    else
        Sheet.Symbol:draw(self.symbol, -16, -16)
    end
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
    local weights      = Config.rig.symbolWeights[1]
    local _, randIndex = Util.WeightedChoice(weights)

    --
    self.symbolIndex = randIndex
    self.symbol      = Config.image.symbol[self.symbolIndex]
    self.symbolAnim  = nil
    self.symbolScale = Vec2(Config.tile.scale, Config.tile.scale)

    -- set juice animation.. (if applicable)
    if Sheet[self.symbol] then
        self.symbolAnim = Animation(Sheet[self.symbol]):at(32):once()
    end
end

--
-- JUICE
--

function M:highlight()
    if self.symbolAnim then
        self.symbolAnim:play()
    end
end

function M:unhighlight()
    if self.symbolAnim then
        self.symbolAnim:stop()
    end
end

return M
