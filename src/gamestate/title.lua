-- Title Gamestate
--
local M = Class { __includes = BaseGamestate }

function M:init(data)
    self:initUI()
    self.offset = Vec2(self.panels.Center.x, self.panels.Center.y)
end

function M:update(dt)
    if Config.particles.MouseCoins.isActive then
        Config.particles.MouseCoins:update(dt)
    end
end

function M:draw()
    --
    -- background..
    lg.setColor(Config.color.white)
    lg.draw(Config.image.bg.title)


    -- particles..
    if Config.particles.MouseCoins.isActive then
        lg.draw(Config.particles.MouseCoins)
    end

    self:drawUI()
end

--
-- METHODS
--

function M:enter(from, ...)
    BaseGamestate.enter(self, from, ...)
    --
    if CanContinueGame() then
        self.options = { "New Game", "Continue Game" }
        self.selection = 2
        self.gameData = GetGameData()
    else
        self.options = { "New Game" }
        self.selection = 1
    end

    --
    self:showUI()
    Config.particles.MouseCoins:start()

    local ox, oy = self.offset:unpack()
    local fx, fy = 1, 1

    self.shake = Timer.every(0.005,
        function()
            self.offset.x = ox + math.random(-fx, fy)
            self.offset.y = oy + math.random(-fx, fy)
        end)
end

function M:leave()
    self:hideUI()
    --
    Config.particles.MouseCoins:stop()
    --
    Timer.cancel(self.shake)
end

---
-- CONTROLS
---

function M:keypressed(key)
    if key == "q" then
        love.event.quit()
    elseif key == "return" or key == "enter" or key == "space" then
        Config.audio.ui.pick:play()
        --
        if self.selection == 2 then
            self:onContinueGame()
        else
            self:onNewGame()
        end
    elseif key == "up" or key == "a" then
        Config.audio.ui.select:stop()
        Config.audio.ui.select:play()
        --
        self.selection = self.selection - 1
        --
        if self.selection < 0 then
            self.selection = #self.options
        end
    elseif key == "down" or key == "d" then
        Config.audio.ui.select:stop()
        Config.audio.ui.select:play()
        --
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

    local x1, y1 = Plan.relative(0.025), Plan.relative(0.925)
    local x2, y2 = Plan.center(), Plan.relative(0.25)
    local x3, y3 = Plan.relative(0.78), Plan.relative(0.78)
    local w1, h1 = Plan.relative(0.20), Plan.relative(0.10)
    local w2, h2 = Plan.relative(0.40), Plan.relative(0.50)
    local w3, h3 = Plan.relative(0.20), Plan.relative(0.20)

    local r1 = Rules.new():addX(x1):addY(y1):addWidth(w1):addHeight(h1)
    local r2 = Rules.new():addX(x2):addY(y2):addWidth(w2):addHeight(h2)
    local r3 = Rules.new():addX(x3):addY(y3):addWidth(w3):addHeight(h3)

    self.panels = {
        Esc    = Panel:new(r1, Config.color.clear),
        Center = Panel:new(r2, Config.color.panel),
        Credit = Panel:new(r3, Config.color.clear),
    }
end

function M:drawUI()
    BaseGamestate.drawUI(self)
    --
    for name, panel in pairs(self.panels) do
        local x, y, w, h = panel:Container()
        local ox, oy     = self.offset:unpack()

        if name == "Esc" then
            lg.setColor(Config.color.white)
            lg.setFont(Config.font.sm)
            lg.printf("[Q] to Quit", x, y + h * 0.1, w, "left")
        elseif name == "Center" then
            lg.setColor(Config.color.white)
            lg.setFont(Config.font.md)
            lg.printf("Juice Jam II Presents...", x, y + h * 0.05, w, "center")
            lg.setFont(Config.font.xxl)
            lg.printf("SLOT RAIDER", x + ox, y + h * 0.15 + ox, w, "center")

            lg.setFont(Config.font.lg)
            if self.selection == 1 then
                lg.print("NEW GAME", x + w * 0.5 + ox, y + h * 0.65 + oy)
            else
                lg.print("NEW GAME", x + w * 0.5, y + h * 0.65)
            end
            if #self.options >= 2 then
                if self.selection == 2 then
                    lg.print("CONTINUE GAME", x + w * 0.5 + ox, y + h * 0.75 + oy)
                else
                    lg.print("CONTINUE GAME", x + w * 0.5, y + h * 0.75)
                end
                lg.setFont(Config.font.xs)
                lg.printf(self.gameData.gold .. " G / " .. self.gameData.hp .. " HP", x, y + h * 0.85, w - 32,
                    "right")
            end

            if self.selection == 2 then
                Sheet.Symbol:draw("Candle", x + w * 0.35, y + h * 0.75, 0, 1.5, 1.5)
            else
                Sheet.Symbol:draw("Candle", x + w * 0.35, y + h * 0.65, 0, 1.5, 1.5)
            end
        elseif name == "Credit" then
            lg.setColor(Config.color.white)
            lg.setFont(Config.font.md)
            lg.printf("CREDITS", x, y + h * 0.15, w - 32, "right")
            lg.setFont(Config.font.sm)
            lg.printf("Art by Cainos", x, y + h * 0.4, w - 32, "right")
            lg.printf("Backgrounds by Lornn", x, y + h * 0.6, w - 32, "right")
            lg.printf("Audio by Shapeforms", x, y + h * 0.8, w - 32, "right")
        end
    end
end

return M
