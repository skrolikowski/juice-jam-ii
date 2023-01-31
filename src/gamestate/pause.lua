-- Pause Screen
--

local M = Class { __includes = BaseGamestate }

-- Init
--
function M:init()
    self:initUI()
end

-- Enter
--
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
        love.event.quit()
    elseif key == "p" then
        Gamestate.pop()
    end
end

---
-- UI
---

function M:initUI()
    BaseGamestate.initUI(self)
    --

    local x1, y1 = Plan.center(), Plan.center()
    local w1, h1 = Plan.relative(0.20), Plan.relative(0.10)

    local r1 = Rules.new():addX(x1):addY(y1):addWidth(w1):addHeight(h1)

    self.panels = {
        Center = Panel:new(r1),
    }
end

function M:drawUI()
    BaseGamestate.drawUI(self)
    --
    lg.setColor(Config.color.white)
    lg.setFont(Config.font.lg)

    for name, panel in pairs(self.panels) do
        local x, y, w, h = panel:Container()

        if name == "Center" then
            lg.printf("PAUSED", x, y + h * 0.3, w, "center")
        end
    end
end

return M
