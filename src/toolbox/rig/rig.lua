-- Rig
--
local M = Class {}

function M:init(data)
    local cx            = Config.width * 0.5 - Config.rig.numReels * 0.5 * Config.tile.size
    local cy            = Config.height * 0.5 - Config.rig.numRows * 0.5 * Config.tile.size
    --
    self.pos            = Vec2(cx, cy)
    self.reels          = {}
    self.timer          = Timer.new()
    self.isSpinning     = false
    self.autoStopHandle = nil

    -- create reels
    for i = 1, Config.rig.numReels do
        table.insert(self.reels, Reel({ index = i }))
    end

    self.reelStencil = function()
        local x = 0
        local y = Config.tile.size
        local w = Config.tile.size * Config.rig.numReels
        local h = Config.tile.size * (Config.rig.numRows - 2)

        lg.rectangle("fill", x, y, w, h, 10, 10)
    end
end

function M:update(dt)
    self.timer:update(dt)
    --
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
        self.timer:cancel(self.autoStopHandle)
        --
        Config.audio.spinLoop:stop()
        Config.audio.spinStop:play()
        --
        for i, reel in pairs(self.reels) do
            self.timer:after(0.05 * (i - 1),
                function()
                    reel:stopSpin()
                    Config.audio.spinReveal[i]:play()
                end)
            --
            -- finally mark as finished spinning
            if i == Config.rig.numReels then
                self:handlePostSpin()
            end
        end
    end

    local __startSpin = function()
        self.isSpinning = true
        --
        Config.audio.spinStart:play()
        --
        for i, reel in pairs(self.reels) do
            self.timer:after(0.05 * (i - 1),
                function() reel:startSpin() end)
            --
            -- auto-stop spin after delay..
            if i == Config.rig.numReels then
                Config.audio.spinLoop:play()
                Config.audio.spinLoop:setLooping(true)
                --
                self.autoStopHandle = self.timer:after(Config.rig.spinLength, function()
                    __stopSpin()
                end)
            end
        end
    end

    --
    if not self.isSpinning then
        --
        -- Pay for spin..
        _GAME.gold = _GAME.gold - math.min(Config.rig.cost, _GAME.gold)

        -- Spin!
        __startSpin()
    end
end

function M:handlePostSpin()
    --
    -- Delay for tiles to lock in place..
    self.timer:after(0.5 * Config.rig.numReels, function()
        self.results = {} -- reset
        --
        self:checkForScatters()
        self:checkForSequences()
        self:handlePayouts()
        --
        self.isSpinning = false
        self:checkForGameOver()
    end)
end

-- Check visible grid for scatter symbols..
-- --
-- {
--    {
--      metadata    = { min = Number, payout = Number, value = String },
--      tiles       = { Tile, Tile, ... }
--    },
--    ...
-- }
--
function M:checkForScatters()
    local scatters = {}
    for rowIndex = 2, Config.rig.numRows - 1 do
        for reelIndex = 1, Config.rig.numReels do
            local reel     = self.reels[reelIndex]
            local tile     = reel.tiles[rowIndex]
            local metadata = Config.rig.scatters[tile.symbolIndex]

            if metadata then
                if scatters[tile.symbolIndex] then
                    table.insert(scatters[tile.symbolIndex].tiles, tile)
                else
                    scatters[tile.symbolIndex] = {
                        metadata = metadata,
                        tiles    = { tile }
                    }
                end
            end
        end
    end

    --
    for _, data in pairs(scatters) do
        if #data.tiles >= data.metadata.min then
            table.insert(self.results, data)
        end
    end
end

-- Check each payline for winner..
-- --
-- {
--    {
--      metadata    = { min = Number, payout = Number, value = String },
--      tiles       = { Tile, Tile, ... }
--    },
--    ...
-- }
--
--
function M:checkForSequences()
    for _, payline in pairs(Config.rig.paylines) do
        local symbolIndex, tiles = self:checkPayline(payline)
        local metadata           = Config.rig.sequences[symbolIndex]

        if metadata and #tiles >= metadata.min then
            table.insert(self.results, {
                metadata = metadata,
                tiles    = tiles,
            })
        end
    end
end

-- Check individual payline for winner..
--
function M:checkPayline(payline)
    local symbolIndex
    local tiles = {}

    for reelIndex, tileIndex in pairs(payline) do
        local reel = self.reels[reelIndex]
        local tile = reel.tiles[tileIndex]

        if not symbolIndex or symbolIndex == tile.symbolIndex then
            --
            -- combo tally..
            symbolIndex = tile.symbolIndex
            table.insert(tiles, tile)
        else
            --
            -- combo broken.. exit early
            return symbolIndex, tiles
        end
    end

    return symbolIndex, tiles
end

function M:handlePayouts()
    if #self.results > 0 then
        local payout = table.remove(self.results, 1)

        self:highlightTiles(payout.tiles)
        self:handlePayout(payout.metadata, payout.tiles)

        self.timer:after(Config.rig.payoutDuration, function()
            self:unhighlightTiles(payout.tiles)
            self:handlePayouts()
        end)
    end
end

function M:handlePayout(metadata, tiles)
    local payoutAmount = metadata.payout
    local payoutValue  = metadata.value

    -- handle multiplier..
    if #tiles == metadata.min + 1 then
        -- 2x payout..?
        payoutAmount = metadata.payout * 2
    elseif #tiles >= metadata.min + 2 then
        -- 5x payout..?
        payoutAmount = metadata.payout * 5
    end

    --
    Gamestate.current():payout(payoutValue, payoutAmount)
end

function M:checkForGameOver()
    if _GAME.hp == 0 then
        Gamestate:current():onGameOver()
    elseif _GAME.gold < Config.rig.cost then
        Gamestate:current():onGameOver()
    end
end

--
-- JUICE
--

function M:shake(duration, _fx, _fy)
    local ox, oy = self.pos:unpack()
    local fx, fy = _fx or 3, _fy or 3

    self.timer:during(duration or 0.5,
        function()
            self.pos.x = ox + math.random(-fx, fy)
            self.pos.y = oy + math.random(-fx, fy)
        end,
        function()
            self.pos.x = ox
            self.pos.y = oy
        end)
end

function M:highlightTiles(tiles)
    for _, tile in pairs(tiles) do
        tile:highlight()
    end
end

function M:unhighlightTiles(tiles)
    for _, tile in pairs(tiles) do
        tile:unhighlight()
    end
end

return M
