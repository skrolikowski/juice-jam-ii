-- Rig
--
local M = Class {}

function M:init(data)
    local cx            = Config.width * 0.5 - Config.rig.numReels * 0.5 * Config.tile.width
    local cy            = Config.height * 0.5 - Config.reel.numTiles * 0.5 * Config.tile.height
    --
    self.pos            = Vec2(cx, cy)
    self.reels          = {}
    self.isSpinning     = false
    self.autoStopHandle = nil

    -- create reels
    for i = 1, Config.rig.numReels do
        table.insert(self.reels, Reel({ index = i }))
    end

    self.reelStencil = function()
        local x = 0
        local y = Config.tile.height * (Config.reel.numTiles - Config.rig.showingRows) * 0.5
        local w = Config.tile.width * Config.rig.numReels
        local h = Config.tile.width * Config.rig.showingRows

        lg.rectangle("fill", x, y, w, h)
    end
end

function M:update(dt)
    for _, reel in pairs(self.reels) do
        reel:update(dt)
    end
end

function M:draw()
    lg.push()
    lg.translate(self:center())
    --
    lg.stencil(self.reelStencil, "replace", 1)
    lg.setStencilTest("greater", 0)
    --
    for _, reel in pairs(self.reels) do
        reel:draw()
    end
    --
    lg.setStencilTest()
    --
    lg.pop()
end

--
-- PROPERTIES
--

function M:center()
    return self.pos:unpack()
end

--
-- METHODS
--

function M:trigger()
    local __stopSpin = function()
        Timer.cancel(self.autoStopHandle)
        --
        for i, reel in pairs(self.reels) do
            Timer.after(0.025 * (i - 1),
                function() reel:stopSpin() end)
            --
            -- finally mark as finished spinning
            if i == Config.rig.numReels then
                Timer.after(1, function()
                    self.isSpinning = false
                end)
            end
        end
    end

    local __startSpin = function()
        self.isSpinning = true
        --
        for i, reel in pairs(self.reels) do
            Timer.after(0.025 * (i - 1),
                function() reel:startSpin() end)
            --
            -- auto-stop spin after delay..
            if i == Config.rig.numReels then
                self.autoStopHandle = Timer.after(3, function()
                    __stopSpin()
                end)
            end
        end
    end

    --
    if self.isSpinning then
        __stopSpin()
    else
        __startSpin()
    end
end

function M:shake(duration, _fx, _fy)
    local ox, oy = self.pos:unpack()
    local fx, fy = _fx or 3, _fy or 3

    Timer.during(duration or 0.5,
        function()
            self.pos.x = ox + math.random(-fx, fy)
            self.pos.y = oy + math.random(-fx, fy)
        end,
        function()
            self.pos.x = ox
            self.pos.y = oy
        end)
end

return M
