-- Base GameState
--

local M = Class {}

---
-- UI
---

function M:refresh()
    self.ui:refresh()
end

function M:initUI()
    self.ui = Plan.new()
end

function M:showUI()
    for _, panel in pairs(self.panels) do
        self.ui:addChild(panel)
    end
end

function M:hideUI()
    for _, panel in pairs(self.panels) do
        self.ui:removeChild(panel)
    end
end

function M:drawUI()
    self.ui:draw()
end

---
-- METHODS
---

function M:enter(from, ...)
    self.from     = from -- previous screen
    self.settings = ...
end

function M:resume()

end

function M:leave()

end

---
-- GO TO
---

function M:onGameOver()
    Gamestate.switch(Gamestates['gameover'])
end

function M:onRestart()
    Gamestate.switch(Gamestates['title'])
end

---- ---- ---- ----

-- Event: on request
--
function M:on(name, ...)
    --
end

-- Event: off request
--
function M:off(name, ...)
    --
end

function M:onPressed(...)
    -- self.controls:onPressed(...)
end

function M:onReleased(...)
    -- self.controls:onReleased(...)
end

function M:onControl(name, ...)
    -- pcall(self.controls[name], ...)
end

function M:onMainMenu()
    -- Gamestate.switch(Gamestates['title'])
end

function M:onExit()
    love.event.quit()
end

return M
