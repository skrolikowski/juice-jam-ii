-- "Hero Broke" Screen
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
end

function M:leave()
    BaseGamestate.leave(self)
    --
    self:hideUI()
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
    local w1, h1 = Plan.relative(0.40), Plan.relative(0.20)
    local r1     = Rules.new():addX(x1):addY(y1):addWidth(w1):addHeight(h1)

    self.panels = {
        Center = Panel:new(r1, Config.color.panel),
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
            lg.printf("YOU'RE BROKE!", x, y + h * 0.15, w, "center")
            lg.setFont(Config.font.sm)
            lg.printf("Press SPACE to Continue", x, y + h * 0.7, w, "center")

            lg.setColor(Config.color.white)
            Sheet.Symbol:draw("Coin", x + w * 0.025, y + h * 0.3, 0, 3, 3)
            Sheet.Symbol:draw("Coin", x + w * 0.825, y + h * 0.3, 0, 3, 3)
        end
    end
end

return M
