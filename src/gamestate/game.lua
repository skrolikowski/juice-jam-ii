-- Game Gamestate
--
local M = Class { __includes = BaseGamestate }


function M:init(data)
    self.rig      = Rig()
    self.isPaused = false
    --
    self:initUI()
end

function M:update(dt)
    if not self.isPaused then
        self.rig:update(dt)
    end
end

function M:draw()
    --
    -- background..
    lg.setColor(Config.color.white)
    lg.draw(Config.image.bg)

    self.rig:draw()
    --
    if not self.isPaused then
        self:drawUI()
    end
end

--
-- METHODS
--

function M:enter(from, ...)
    BaseGamestate.enter(self, from, ...)
    --
    -- play intro
    -- Gamestate.push(Gamestates['intro'])

    self:showUI()

    -- flags
    self.isPaused = false
end

function M:resume()
    self:showUI()
end

function M:leave()
    self:hideUI()
end

---
-- CONTROLS
---

function M:keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "space" then
        self.rig:trigger()
    elseif key == "p" then
        self:onPause()
    end
end

---
-- GO TO
---

function M:onPause()
    Gamestate.push(Gamestates['pause'])
end

function M:onRestart()
    Gamestate.switch(Gamestates['title'])
end

---
-- UI
---

function M:initUI()
    BaseGamestate.initUI(self)
    --

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

function M:drawUI()
    BaseGamestate.drawUI(self)
    --
    lg.setColor(Config.color.white)
    lg.setFont(Config.font.lg)

    for name, panel in pairs(self.panels) do
        local x, y, w, h = panel:Container()
        local ox, oy     = 8, 8

        if name == "Player" then
            lg.printf("HP: " .. _GAME.hp, x, y + oy, w, "center")
            -- elseif name == "Wave" then
            --     lg.printf("Wave: " .. self.wave .. " / " .. #self.waves, x, y + oy, w, "center")
        end
    end
end

return M
