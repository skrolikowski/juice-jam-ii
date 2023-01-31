-- Panel
--
local M = Container:extend()

function M:new(rules, color)
    self.panel = Panel.super.new(self, rules)
    self.panel.colour = color or Config.color.panel
    self.panel.r = 10

    return self.panel
end

function M:refresh()
    Panel.super.refresh(self)
    --
    self.bounds = self:Bounds()
end

-- function M:keypressed(key)
--     print("keypressed", button)
-- end

-- function M:mousepressed(x, y, button)
--     print("mousepressed", x, y, button)
-- end

--
-- PROPERTIES
--

function M:Center()
    return self.x + self.w * 0.5, self.y + self.h * 0.5
end

function M:Position()
    return self.x, self.y
end

function M:Bounds()
    local cx, cy   = self:Center()
    local w, h     = self:Size()
    local rotation = self.rotation or 0

    return AABB:compute(cx, cy, w, h, rotation)
end

function M:Size()
    return self.w, self.h
end

function M:Container()
    return self.x, self.y, self.w, self.h
end

function M:draw()
    love.graphics.push("all")
    love.graphics.setColor(self.colour)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h, self.r, self.r)
    love.graphics.pop()
    -- then we want to draw our children containers:
    Panel.super.draw(self)
end

return M
