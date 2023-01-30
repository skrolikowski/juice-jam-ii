-- Game Data
--

local M = Class {}

function M:init()
    self:reset()
    --
    self:initUI()
    self:showUI()
end

function M:reset()
    self.metadata = {
        gold   = 100,
        hp     = 100,
        sword  = 0,
        shield = 0,
    }
end

function M:updateValue(value, amount)
    self.metadata[value] = self.metadata[value] + amount
    --
    self:showUI()
end

--
-- UI
--

function M:initUI()
    local x1, y1 = Plan.relative(0.01), Plan.relative(0.01)
    local x2, y2 = Plan.relative(0.9 - 0.01), Plan.relative(0.01)
    local x3, y3 = Plan.relative(0.01), Plan.relative(0.80 - 0.01)
    local x4, y4 = Plan.relative(0.8 - 0.01), Plan.relative(0.8 - 0.01)
    local w1, h1 = Plan.relative(0.20), Plan.relative(0.20)
    local w2, h2 = Plan.relative(0.10), Plan.relative(0.20)
    local w3, h3 = Plan.relative(0.50), Plan.relative(0.20)
    local w4, h4 = Plan.relative(0.20), Plan.relative(0.20)
    -- local x3, y3 = Plan.center(), Plan.relative(0.9 - 0.005)
    -- local w2, h2 = Plan.relative(0.65), Plan.relative(0.1)

    local r1 = Rules.new():addX(x1):addY(y1):addWidth(w1):addHeight(h1)
    local r2 = Rules.new():addX(x2):addY(y2):addWidth(w2):addHeight(h2)
    local r3 = Rules.new():addX(x3):addY(y3):addWidth(w3):addHeight(h3)
    local r4 = Rules.new():addX(x4):addY(y4):addWidth(w4):addHeight(h4)

    self.panels = {
        Player = Panel:new(r1),
        Menu   = Panel:new(r2),
        Store  = Panel:new(r3),
        Purse  = Panel:new(r4),
    }

end

function M:UpdateUI()
    --
end

function M:showUI()
    for _, panel in pairs(self.panels) do
        _UI:addChild(panel)
    end
end

function M:hideUI()
    for _, panel in pairs(self.panels) do
        _UI:removeChild(panel)
    end
end

function M:draw()
    lg.setColor(Config.color.white)
    lg.setFont(Config.font.lg)

    for name, panel in pairs(self.panels) do
        local x, y, w, h = panel:Container()
        local ox, oy     = 8, 8

        if name == "Player" then
            lg.printf("HP: " .. self.metadata.hp, x, y + oy, w, "center")
            -- elseif name == "Wave" then
            --     lg.printf("Wave: " .. self.wave .. " / " .. #self.waves, x, y + oy, w, "center")
        end
    end
end

return M
