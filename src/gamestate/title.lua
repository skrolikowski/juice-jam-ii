-- Title Gamestate
--
local M = Class { __includes = BaseGamestate }

function M:init(data)
    self:initUI()
    --
    if CanContinueGame() then
        self.options = { "New Game", "Continue Game" }
        self.selection = 2
    else
        self.options = { "New Game" }
        self.selection = 1
    end
end

function M:draw()
    --
    -- background..
    lg.setColor(Config.color.white)
    lg.draw(Config.image.bg[5])

    self:drawUI()

    -- -- ESC
    -- lg.setColor(Config.color.white)
    -- lg.setFont(Config.font.xs)
    -- lg.printf('[ESC]Quit', w * 0.03, h * 0.03, w * 0.1, 'left')

    -- -- volume
    -- Util:drawTriangle(w * 0.97, h * 0.03, _.__pi, 8, 8, Config.color.volume.up)
    -- Util:drawTriangle(w * 0.97, h * 0.06, 0, 8, 8, Config.color.volume.down)
    -- --
    -- lg.setColor(Config.color.white)
    -- lg.setFont(Config.ui.font.xs)
    -- lg.printf('Vol.', w * 0.85, h * 0.03, w * 0.08, 'left')
    -- lg.printf(_GAME.volume, w * 0.85, h * 0.03, w * 0.08, 'right')
    -- --

    -- -- difficulty
    -- Util:drawTriangle(w * 0.97, h * 0.10, -_.__pi / 2, 8, 8, Config.color.difficulty.up)
    -- Util:drawTriangle(w * 0.97, h * 0.12, _.__pi / 2, 8, 8, Config.color.difficulty.down)
    -- --
    -- lg.setColor(Config.color.white)
    -- lg.setFont(Config.ui.font.xs)
    -- lg.printf('Skill', w * 0.85, h * 0.1, w * 0.08, 'left')
    -- lg.printf(_GAME.difficulty, w * 0.85, h * 0.1, w * 0.08, 'right')
    -- --

    -- -- cover
    -- lg.setColor(Config.color.white)
    -- lg.draw(self.bgImage, w * 0.5, h * 0.4, 0, sx, sy, ox, oy)

    -- -- high score?
    -- if _GAME.highScore > 0 then
    --     lg.setColor(Config.color.white)
    --     lg.setFont(Config.ui.font.sm)
    --     lg.printf('HighScore: ' .. _GAME.highScore, 0, h * 0.08, w, 'center')
    -- end

    -- -- text
    -- lg.setColor(Config.color.white)
    -- lg.setFont(Config.font.lg)
    -- lg.printf('Press SPACE to Play', 0, h * 0.75, w, 'center')

    -- -- credits
    -- lg.setColor(1, 1, 1, 0.35)
    -- lg.setFont(Config.font.xs)
    -- lg.printf('Developer: Shane Krolikowski', w * 0.03, h * 0.95, w - w * 0.1, 'left')
    -- lg.printf('Audio & Fonts: KenneyNL', w * 0.03, h * 0.95, w - w * 0.1, 'right')
end

--
-- METHODS
--

function M:enter(from, ...)
    BaseGamestate.enter(self, from, ...)
    --
    self:showUI()

    -- sfx
    Config.audio.bgLoop:play()
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
    elseif key == "return" or key == "enter" or key == "space" then
        if self.selection == 2 then
            self:onContinueGame()
        else
            self:onNewGame()
        end
    elseif key == "up" or key == "a" then
        self.selection = self.selection - 1
        --
        if self.selection < 0 then
            self.selection = #self.options
        end
    elseif key == "down" or key == "d" then
        self.selection = self.selection + 1
        --
        if self.selection > #self.options then
            self.selection = 1
        end
    end
end

---
-- GO TO
---

function M:onNewGame()
    ResetGame()
    --
    Gamestate.push(Gamestates["game"])
end

function M:onContinueGame()
    LoadGame()
    --
    Gamestate.push(Gamestates["game"])
end

---
-- UI
---

function M:initUI()
    BaseGamestate.initUI(self)
    --

    local x1, y1 = Plan.relative(0.02), Plan.relative(0.01)
    local x2, y2 = Plan.center(), Plan.relative(0.25)
    local w1, h1 = Plan.relative(0.20), Plan.relative(0.10)
    local w2, h2 = Plan.relative(0.40), Plan.relative(0.50)
    -- local w3, h3 = Plan.relative(0.30), Plan.relative(0.15)
    -- local w4, h4 = Plan.relative(0.20), Plan.relative(0.15)

    local r1 = Rules.new():addX(x1):addY(y1):addWidth(w1):addHeight(h1)
    local r2 = Rules.new():addX(x2):addY(y2):addWidth(w2):addHeight(h2)
    -- local r3 = Rules.new():addX(x3):addY(y3):addWidth(w3):addHeight(h3)
    -- local r4 = Rules.new():addX(x4):addY(y4):addWidth(w4):addHeight(h4)

    self.panels = {
        Esc = Panel:new(r1, Config.color.clear),
        Center = Panel:new(r2, Config.color.clear),
        -- Bank   = Panel:new(r2),
        -- Store  = Panel:new(r3),
    }
end

function M:drawUI()
    BaseGamestate.drawUI(self)
    --
    for name, panel in pairs(self.panels) do
        local x, y, w, h = panel:Container()

        if name == "Esc" then
            lg.setColor(Config.color.white)
            lg.setFont(Config.font.sm)
            lg.printf("[Esc] to Quit", x, y + h * 0.1, w, "left")
        elseif name == "Center" then
            -- lg.setColor(Config.color.white)
            -- Sheet.Symbol:draw("Coin", x + w * 0.1, y + h * 0.1, 0, 1.5, 1.5)
            lg.setColor(Config.color.white)
            lg.setFont(Config.font.xl)
            lg.printf("SLOT RAIDERS", x, y + h * 0.33, w, "center")
            -- lg.printf(_GAME.gold .. "", x, y + h * 0.4, w * 0.9, "right")

            lg.setFont(Config.font.lg)
            lg.print("NEW GAME", x + w * 0.5, y + h * 0.65)
            if #self.options >= 2 then
                lg.print("CONTINUE GAME", x + w * 0.5, y + h * 0.8)
            end

            if self.selection == 2 then
                Sheet.Symbol:draw("Candle", x + w * 0.35, y + h * 0.80, 0, 1.5, 1.5)
            else
                Sheet.Symbol:draw("Candle", x + w * 0.35, y + h * 0.65, 0, 1.5, 1.5)
            end
        end
    end
end

return M
