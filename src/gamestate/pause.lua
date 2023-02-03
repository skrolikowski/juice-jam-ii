-- Pause Screen
--

local M = Class { __includes = BaseGamestate }

function M:init()
    self:initUI()
    self.offset = Vec2(self.panels.Center.x, self.panels.Center.y)
end

function M:enter(from, ...)
    BaseGamestate.enter(self, from, ...)
    --
    self:showUI()

    local ox, oy = self.offset:unpack()
    local fx, fy = 1, 1

    self.shake = Timer.every(0.005,
        function()
            self.offset.x = ox + math.random(-fx, fy)
            self.offset.y = oy + math.random(-fx, fy)
        end)

    -- sfx
    Config.audio.bgLoop:pause()
end

function M:leave()
    BaseGamestate.leave(self)
    --
    self:hideUI()
    --
    Timer.cancel(self.shake)
end

function M:draw()
    self.from:draw()
    --
    -- bg (dark overlay)
    lg.setColor(Config.color.overlay)
    lg.rectangle('fill', 0, 0, Config.width, Config.height)

    --
    self:drawUI()

    -- -- restart
    -- lg.setColor(Config.color.white)
    -- lg.setFont(Config.font.xs)
    -- lg.printf('[SPACE] - Restart', w * 0.05, h * 0.05, w * 0.5, 'left')

    -- -- -- volume
    -- -- Util:drawTriangle(w * 0.97, h * 0.03, math.pi, 8, 8, Config.color.volume.up)
    -- -- Util:drawTriangle(w * 0.97, h * 0.06, 0, 8, 8, Config.color.volume.down)
    -- --
    -- lg.setColor(Config.color.white)
    -- lg.setFont(Config.font.xs)
    -- lg.printf('Vol.', w * 0.85, h * 0.03, w * 0.08, 'left')
    -- lg.printf(_GAME.volume, w * 0.85, h * 0.03, w * 0.08, 'right')
    --

    -- -- text
    -- lg.setColor(Config.color.white)
    -- lg.setFont(Config.font.md)
    -- lg.printf('Pause', 0, Config.height * 0.4, Config.width, 'center')
end

---
-- CONTROLS
---

function M:keypressed(key)
    if key == "escape" then
        Gamestate.pop()
    elseif key == "q" then
        love.event.quit()
    end
end

---
-- UI
---

function M:initUI()
    BaseGamestate.initUI(self)
    --

    local x1, y1 = Plan.relative(0.025), Plan.relative(0.925)
    local x2, y2 = Plan.center(), Plan.center()
    local x3, y3 = Plan.relative(0.775), Plan.relative(0.90)
    local w1, h1 = Plan.relative(0.20), Plan.relative(0.10)
    local w2, h2 = Plan.relative(0.40), Plan.relative(0.20)
    local w3, h3 = Plan.relative(0.20), Plan.relative(0.10)

    local r1 = Rules.new():addX(x1):addY(y1):addWidth(w1):addHeight(h1)
    local r2 = Rules.new():addX(x2):addY(y2):addWidth(w2):addHeight(h2)
    local r3 = Rules.new():addX(x3):addY(y3):addWidth(w3):addHeight(h3)

    self.panels = {
        Q      = Panel:new(r1, Config.color.clear),
        Center = Panel:new(r2, Config.color.clear),
        Esc    = Panel:new(r3, Config.color.clear),
    }
end

function M:drawUI()
    BaseGamestate.drawUI(self)
    --
    for name, panel in pairs(self.panels) do
        local x, y, w, h = panel:Container()
        local ox, oy     = self.offset:unpack()

        if name == "Q" then
            lg.setColor(Config.color.white)
            lg.setFont(Config.font.sm)
            lg.printf("[Q] to Quit", x, y + h * 0.1, w, "left")
            lg.setFont(Config.font.xs)
            lg.printf("Progress is saved", x, y + h * 0.38, w, "left")
        elseif name == "Center" then
            lg.setColor(Config.color.white)
            lg.setFont(Config.font.xl)
            lg.printf("PAUSED", x + ox, y + h * 0.3 + oy, w, "center")
        elseif name == "Esc" then
            lg.setColor(Config.color.white)
            lg.setFont(Config.font.sm)
            lg.printf("[Esc] to Return", x, y + h * 0.25, w, "right")
        end
    end
end

return M
