-- Pause Screen
--

local M = Class { __includes = BaseGamestate }

function M:init()
    self:initUI()
end

function M:enter(from, ...)
    BaseGamestate.enter(self, from, ...)
    --
    self:showUI()

    -- sfx
    Config.audio.bgLoop:pause()
end

function M:leave()
    BaseGamestate.leave(self)
    --
    self:hideUI()
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

    local x1, y1 = Plan.relative(0.05), Plan.relative(0.05)
    local x2, y2 = Plan.relative(0.30), Plan.relative(0.05)
    -- local x3, y3 = Plan.relative(0.65), Plan.relative(0.05)
    local w1, h1 = Plan.relative(0.40), Plan.relative(0.40)
    local w2, h2 = Plan.relative(0.25), Plan.relative(0.50)

    local r1 = Rules.new():addX(x1):addY(y1):addWidth(w1):addHeight(h1)
    local r2 = Rules.new():addX(x2):addY(y2):addWidth(w2):addHeight(h2)
    -- local r3 = Rules.new():addX(x3):addY(y3):addWidth(w1):addHeight(h1)

    self.panels = {
        Rules = Panel:new(r1, Config.color.panel2),
        Center = Panel:new(r2, Config.color.panel2),
        -- Scatter = Panel:new(r3, Config.color.panel2),
        -- Info = Panel:new(r4, Config.color.panel2),
    }
end

function M:drawUI()
    BaseGamestate.drawUI(self)
    --
    for name, panel in pairs(self.panels) do
        local x, y, w, h = panel:Container()

        if name == "Center" then
            lg.setColor(Config.color.white)
            lg.setFont(Config.font.xl)
            lg.printf("PAUSED", x, y + h * 0.3, w, "center")
            -- lg.draw(Config.image.rules, x, y * 0.25, 0, 1.5)
        end
    end
end

return M
