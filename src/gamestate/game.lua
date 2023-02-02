-- Game Gamestate
--
local M = Class { __includes = BaseGamestate }


function M:init(data)
    self.rig           = Rig()
    self.timer         = Timer.new()
    self.isPaused      = false
    self.potionBuying  = Animation(Sheet["Potion"]):at(64):offset(-12, -12):scale(3, 3):once()
    self.shieldBuying  = Animation(Sheet["Shield"]):at(64):offset(-12, -12):scale(3, 3):once()
    self.coinGain      = Animation(Sheet["Coin"]):at(64):offset(-12, -12):scale(2, 2):once()
    self.heartShielded = Animation(Sheet["Shield"]):at(64):offset(-12, -12):scale(2, 2):once()
    self.heartHealing  = Animation(Sheet["Heart_Heal"]):at(64):offset(-12, -12):scale(2, 2):once()
    self.heartHurting  = Animation(Sheet["Heart_Hurt"]):at(64):offset(-12, -12):scale(2, 2):once()
    --
    self:initUI()
end

function M:update(dt)
    if not self.isPaused then
        self.timer:update(dt)
        self.rig:update(dt)

        -- icon animations..
        if self.coinGain.isPlaying then
            self.coinGain:update(dt)
        end
        if self.shieldBuying.isPlaying then
            self.shieldBuying:update(dt)
        end
        if self.potionBuying.isPlaying then
            self.potionBuying:update(dt)
        end
        if self.heartShielded.isPlaying then
            self.heartShielded:update(dt)
        end
        if self.heartHealing.isPlaying then
            self.heartHealing:update(dt)
        end
        if self.heartHurting.isPlaying then
            self.heartHurting:update(dt)
        end

        -- particles..
        if Config.particles.RainingCoins.isActive then
            Config.particles.RainingCoins:update(dt)
        end
        if Config.particles.AwardingShield.isActive then
            Config.particles.AwardingShield:update(dt)
        end
    end
end

function M:draw()
    --
    -- background..
    lg.setColor(Config.color.white)
    lg.draw(Config.image.bg.game)

    self.rig:draw()
    --
    if not self.isPaused then
        self:drawUI()
    end

    -- raining coins..
    if Config.particles.RainingCoins.isActive then
        lg.setColor(Config.color.white)
        lg.draw(Config.particles.RainingCoins)
    end

    -- awarding shield particles..
    if Config.particles.AwardingShield.isActive then
        lg.setColor(Config.color.white)
        lg.draw(Config.particles.AwardingShield, Config.width * 0.5, Config.height * 0.5)
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
    self.isPaused = false
    --
    self:showUI()
end

function M:leave()
    self:hideUI()
end

function M:payout(value, amount)
    if value == "gold" then
        --
        -- raining coin..
        Config.particles.RainingCoins:start()
        self.timer:after(Config.rig.juiceDuration, function()
            Config.particles.RainingCoins:stop()
        end)

        -- award gold..
        self.coinGain:play()
        _GAME[value] = _GAME[value] + amount
        --
    elseif value == "hp" then
        --
        -- award hp..
        self.heartHealing:play()
        _GAME[value] = math.min(100, _GAME[value] + amount)
        --
    elseif value == "hit" then
        if _GAME["shield"] > 0 then
            --
            -- shield heart..
            self.heartShielded:play()
            _GAME["shield"] = _GAME["shield"] - 1
        else
            --
            -- remove hp..
            self.heartHurting:play()
            _GAME["hp"] = math.max(0, _GAME["hp"] - amount)
        end
    elseif value == "shield" then
        --
        -- Award Shield..
        Config.particles.AwardingShield:start()
        Timer.after(Config.rig.juiceDuration, function()
            Config.particles.AwardingShield:stop()
        end)

        -- award shield..
        _GAME[value] = math.min(3, _GAME[value] + 1)
    end

    --
    SaveGame()
end

function M:buyItem(key)
    local item = Config.store[key]

    if _GAME["gold"] - Config.rig.cost >= item.gold then
        if item.value == "hp" and _GAME["hp"] < 100 then
            -- award hp..
            self.heartHealing:play()
            self.potionBuying:play()
            _GAME["hp"] = math.min(100, _GAME["hp"] + item.payout)
            --
            -- take gold..
            self.coinGain:play()
            _GAME["gold"] = _GAME["gold"] - item.gold
        elseif item.value == "shield" and _GAME["shield"] < 3 then
            -- award shield..
            self.shieldBuying:play()
            _GAME["shield"] = math.min(3, _GAME["shield"] + 1)
            --
            -- take gold..
            self.coinGain:play()
            _GAME["gold"] = _GAME["gold"] - item.gold
        end
    end
end

---
-- CONTROLS
---

function M:keypressed(key)
    if key == "escape" then
        self:onPause()
    elseif key == "space" then
        self.rig:trigger()
    elseif key == "1" or key == "2" then
        self:buyItem(key)
        -- elseif key == "7" then
        --     self:payout("gold", 5)
        -- elseif key == "8" then
        --     self:payout("hp", 10)
        -- elseif key == "9" then
        --     self:payout("shield", 1)
        -- elseif key == "0" then
        --     self:payout("hit", 10)
    end
end

---
-- GO TO
---

function M:onPause()
    self.isPaused = true
    --
    Gamestate.push(Gamestates['pause'])
end

---
-- UI
---

function M:initUI()
    BaseGamestate.initUI(self)
    --

    local x1, y1 = Plan.relative(0.01), Plan.relative(0.01)
    local x2, y2 = Plan.relative(0.80 - 0.01), Plan.relative(0.01)
    local x3, y3 = Plan.relative(0.01), Plan.relative(0.85 - 0.01)
    -- local x4, y4 = Plan.relative(0.80 - 0.01), Plan.relative(0.85 - 0.01)
    local w1, h1 = Plan.relative(0.25), Plan.relative(0.15)
    local w2, h2 = Plan.relative(0.20), Plan.relative(0.10)
    local w3, h3 = Plan.relative(0.30), Plan.relative(0.15)
    -- local w4, h4 = Plan.relative(0.20), Plan.relative(0.15)

    local r1 = Rules.new():addX(x1):addY(y1):addWidth(w1):addHeight(h1)
    local r2 = Rules.new():addX(x2):addY(y2):addWidth(w2):addHeight(h2)
    local r3 = Rules.new():addX(x3):addY(y3):addWidth(w3):addHeight(h3)
    -- local r4 = Rules.new():addX(x4):addY(y4):addWidth(w4):addHeight(h4)

    self.panels = {
        Player = Panel:new(r1),
        Bank   = Panel:new(r2),
        Store  = Panel:new(r3),
    }
end

function M:drawUI()
    BaseGamestate.drawUI(self)
    --
    for name, panel in pairs(self.panels) do
        local x, y, w, h = panel:Container()
        local ox, oy     = 12, 8

        if name == "Player" then
            --
            -- title
            lg.setFont(Config.font.md)
            lg.setColor(Config.color.black)
            lg.printf("THE HERO", x + ox * 5 - 2, y + oy - 2, w, "left")
            lg.setColor(Config.color.header)
            lg.printf("THE HERO", x + ox * 5, y + oy, w, "left")

            -- hp
            local hpPct = math.max(0, _GAME["hp"] / 100 * 0.88)

            lg.setColor(Config.color.hp_bg)
            lg.rectangle('fill', x + ox * 2, y + oy * 5, w * 0.88, oy * 2, 5, 5)
            lg.setColor(Config.color.hp)
            lg.rectangle('fill', x + ox * 2, y + oy * 5, w * hpPct, oy * 2, 5, 5)
            lg.setColor(Config.color.hp_border)
            lg.rectangle('line', x + ox * 2, y + oy * 5, w * 0.88, oy * 2, 5, 5)
            lg.setColor(Config.color.white)
            --
            if self.heartHurting.isPlaying then
                self.heartHurting:draw(x + ox, y + oy * 3)
            elseif self.heartHealing.isPlaying then
                self.heartHealing:draw(x + ox, y + oy * 3)
            else
                Sheet.Symbol:draw("Heart", x + ox, y + oy * 3, 0, 1.5, 1.5)
            end
            if self.heartShielded.isPlaying then
                self.heartShielded:draw(x + ox, y + oy * 3)
            end

            -- shield power-ups..
            lg.setColor(Config.color.header)
            lg.rectangle('line', w * 0.4, y + h * 0.55, ox * 5, oy * 6, 5, 5)
            lg.rectangle('line', w * 0.6, y + h * 0.55, ox * 5, oy * 6, 5, 5)
            lg.rectangle('line', w * 0.8, y + h * 0.55, ox * 5, oy * 6, 5, 5)

            if _GAME.shield >= 3 then
                lg.setColor(Config.color.white)
                Sheet.Symbol:draw("Shield", w * 0.425, y + h * 0.575, 0, 1.25, 1.25)
            end
            if _GAME.shield >= 2 then
                lg.setColor(Config.color.white)
                Sheet.Symbol:draw("Shield", w * 0.625, y + h * 0.575, 0, 1.25, 1.25)
            end
            if _GAME.shield >= 1 then
                lg.setColor(Config.color.white)
                Sheet.Symbol:draw("Shield", w * 0.825, y + h * 0.575, 0, 1.25, 1.25)
            end
        elseif name == "Store" then
            --
            -- title
            lg.setFont(Config.font.md)
            lg.setColor(Config.color.black)
            lg.print("THE STORE", x + ox - 2, y + oy - 2)
            lg.setColor(Config.color.header)
            lg.print("THE STORE", x + ox, y + oy)
            lg.setFont(Config.font.xs)
            lg.print("NO REFUNDS!", w * 0.1, y + h * 0.5)

            -- item 1
            lg.setColor(Config.color.header)
            lg.setFont(Config.font.sm)
            lg.rectangle('line', x + w * 0.475, y + h * 0.1, ox * 8, oy * 10, 5, 5)
            lg.print("[1] - 100", x + w * 0.475, y + h * 0.775)
            lg.rectangle('line', x + w * 0.725, y + h * 0.1, ox * 8, oy * 10, 5, 5)
            lg.print("[2] - 500", x + w * 0.725, y + h * 0.775)

            -- Potion
            if self.potionBuying.isPlaying then
                lg.setColor(Config.color.white)
                self.potionBuying:draw(x + w * 0.51, y + h * 0.15)
            else
                if _GAME["gold"] - Config.rig.cost >= Config.store["1"].gold and _GAME["hp"] < 100 then
                    lg.setColor(Config.color.white)
                    Sheet.Symbol:draw("Potion", x + w * 0.51, y + h * 0.15, 0, 2, 2)
                else
                    lg.setColor(Config.color.overlay)
                    Sheet.Symbol:draw("Potion", x + w * 0.51, y + h * 0.15, 0, 2, 2)
                end
            end

            -- Shield
            if self.shieldBuying.isPlaying then
                lg.setColor(Config.color.white)
                self.shieldBuying:draw(x + w * 0.76, y + h * 0.15)
            else
                if _GAME["gold"] - Config.rig.cost >= Config.store["2"].gold and _GAME["shield"] < 3 then
                    lg.setColor(Config.color.white)
                    Sheet.Symbol:draw("Shield", x + w * 0.76, y + h * 0.15, 0, 2, 2)
                else
                    lg.setColor(Config.color.overlay)
                    Sheet.Symbol:draw("Shield", x + w * 0.76, y + h * 0.15, 0, 2, 2)
                end
            end
        elseif name == "Bank" then
            --
            -- title
            lg.setFont(Config.font.md)
            lg.setColor(Config.color.black)
            lg.printf("BANK", x + ox * 5 - 2, y + oy - 2, w, "left")
            lg.setColor(Config.color.header)
            lg.printf("BANK", x + ox * 5, y + oy, w, "left")

            -- gold
            lg.setColor(Config.color.white)
            if self.coinGain.isPlaying then
                self.coinGain:draw(x + ox, y + oy)
            else
                Sheet.Symbol:draw("Coin", x + ox, y + oy, 0, 1.5, 1.5)
            end
            lg.setFont(Config.font.lg)
            lg.setColor(Config.color.gold)
            lg.printf(_GAME.gold .. "", x, y + h * 0.4, w * 0.9, "right")
        end
    end
end

return M
