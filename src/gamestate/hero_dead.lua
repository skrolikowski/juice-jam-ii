-- "Hero Dead" Screen
--

local M = Class { __includes = BaseGamestate }

-- Init
--
function M:init()
    self:initUI()
    --
    self.offset   = Vec2(self.panels.Center.x, self.panels.Center.y)
    self.juice_01 = Animation(Sheet["Skull_End"]):at(32):scale(3, 3)
    self.juice_02 = Animation(Sheet["Skull_End"]):at(32):scale(3, 3)
end

-- Enter
--
function M:enter(from, ...)
    BaseGamestate.enter(self, from, ...)
    --
    self.juice_01:play()
    self.juice_02:play()

    local ox, oy = self.offset:unpack()
    local fx, fy = 1, 1

    self.shake = Timer.every(0.005,
        function()
            self.offset.x = ox + math.random(-fx, fy)
            self.offset.y = oy + math.random(-fx, fy)
        end)
    --
    self:showUI()
end

function M:leave()
    BaseGamestate.leave(self)
    --
    self.juice_01:stop()
    self.juice_02:stop()
    --
    Timer.cancel(self.shake)
    --
    self:hideUI()
end

function M:update(dt)
    self.juice_01:update(dt)
    self.juice_02:update(dt)
end

function M:draw()
    -- self.from:draw()

    --
    -- bg (dark overlay)
    lg.setColor(Config.color.overlay)
    lg.rectangle('fill', 0, 0, Config.width, Config.height)

    --
    self:drawUI()
end

---
-- CONTROLS
---

function M:keypressed(key)
    if key == "escape" then
        -- Gamestate.pop()
        Gamestate.switch(Gamestates["title"])
    elseif key == "space" then
        -- Gamestate.pop()
        Gamestate.switch(Gamestates["title"])
    end
end

---
-- UI
---

function M:initUI()
    BaseGamestate.initUI(self)
    --

    local x1, y1 = Plan.center(), Plan.center()
    local w1, h1 = Plan.relative(0.50), Plan.relative(0.20)
    local r1     = Rules.new():addX(x1):addY(y1):addWidth(w1):addHeight(h1)

    self.panels = {
        Center = Panel:new(r1, Config.color.clear),
    }
end

function M:drawUI()
    BaseGamestate.drawUI(self)
    --
    for name, panel in pairs(self.panels) do
        local x, y, w, h = panel:Container()
        local ox, oy     = self.offset:unpack()

        if name == "Center" then
            lg.setColor(Config.color.white)
            lg.setFont(Config.font.xl)
            lg.printf("YOU DIED!", x + ox, y + h * 0.15 + oy, w, "center")
            lg.setFont(Config.font.sm)
            lg.printf("Press SPACE to Continue", x, y + h * 0.7, w, "center")

            lg.setColor(Config.color.white)
            self.juice_01:draw(x + w * 0.15, y + h * 0.5)
            self.juice_02:draw(x + w * 0.85, y + h * 0.5)
        end
    end
end

return M
