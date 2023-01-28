-- Reel Tile
--
local M = Class {}

function M:init(data)
    self.reel = data.reel
    self.row  = data.row

    -- symbol
    local choice = Util.RandChoice("apple", "bag", "beer", "belt", "bread", "cheese", "fish", "helm")
    self.symbol = Config.image.symbol[choice]

    local x, y = self:center()
    local w, h = self.symbol:getDimensions()
    self.transform = lx.newTransform(x - w, y - h, 0, 2, 2)
end

function M:update(dt)

end

function M:draw()
    lg.setColor(Config.color.tile)
    lg.rectangle('fill', self:container())

    lg.setColor(Config.color.black)
    lg.rectangle('line', self:container())

    lg.setColor(Config.color.white)
    lg.draw(self.symbol, self.transform)
end

--
-- PROPERTIES
--

function M:center()
    return 0, (self.row - 1) * Config.tile.height
end

function M:size()
    return Config.tile.width, Config.tile.height
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

function M:incrementRow()
    self.row = self.row + 1

    if self.row > Config.reel.numTiles then
        self.row = 1
    end
end

return M
