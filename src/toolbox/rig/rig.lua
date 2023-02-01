-- Rig
--
local M = Class {}

function M:init(data)
    local cx            = Config.width * 0.5 - Config.rig.numReels * 0.5 * Config.tile.size
    local cy            = Config.height * 0.5 - Config.rig.numRows * 0.5 * Config.tile.size
    --
    self.pos            = Vec2(cx, cy)
    self.reels          = {}
    self.isBusy         = false
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
        Config.audio.spinLoop:stop()
        Config.audio.spinStop:play()
        --
        for i, reel in pairs(self.reels) do
            Timer.after(0.05 * (i - 1),
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
            Timer.after(0.05 * (i - 1),
                function() reel:startSpin() end)
            --
            -- auto-stop spin after delay..
            if i == Config.rig.numReels then
                Config.audio.spinLoop:play()
                Config.audio.spinLoop:setLooping(true)
                --
                self.autoStopHandle = Timer.after(3, function()
                    __stopSpin()
                end)
            end
        end
    end

    --
    if not self.isBusy then
        if self.isSpinning then
            __stopSpin()
        else
            __startSpin()
        end
    end
end

function M:handlePostSpin()
    --
    -- Delay for tiles to lock in place..
    Timer.after(0.5 * Config.rig.numReels, function()
        self.isSpinning = false
        -- self.isBusy     = true
        self.results    = {} -- reset
        --
        self:checkForScatters()
        self:handleScatterPayouts()
        --
        self:checkForSequences()
        self:handleSequencePayouts()
    end)
end

-- Check visible grid for scatter symbols..
-- --
-- {
--    {
--      symbolIndex = symbolIndex,
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
                        symbolIndex = tile.symbolIndex,
                        metadata    = metadata,
                        tiles       = { tile }
                    }
                end
            end
        end
    end

    --
    self.results['scatters'] = {}
    for _, data in pairs(scatters) do
        if #data.tiles >= data.metadata.min then
            table.insert(self.results['scatters'], data)
        end
    end
end

-- Check each payline for winner..
-- --
-- {
--    {
--      payline     = { 3, 3, 3, 3, 3 },
--      metadata    = { min = Number, payout = Number, value = String },
--      symbolCount = Number,
--    },
--    ...
-- }
--
--
function M:checkForSequences()
    self.results['sequences'] = {}
    --
    for _, payline in pairs(Config.rig.paylines) do
        local symbolIndex, symbolCount = self:checkPayline(payline)
        local metadata                 = Config.rig.sequences[symbolIndex]

        if metadata and symbolCount >= metadata.min then
            table.insert(self.results['sequences'], {
                payline     = payline,
                metadata    = metadata,
                symbolCount = symbolCount,
            })
        end
    end
end

-- Check individual payline for winner..
--
function M:checkPayline(payline)
    local symbolCount = 0
    local symbolIndex

    for reelIndex, tileIndex in pairs(payline) do
        local reel = self.reels[reelIndex]
        local tile = reel.tiles[tileIndex]

        if not symbolIndex or symbolIndex == tile.symbolIndex then
            --
            -- combo tally..
            symbolIndex = tile.symbolIndex
            symbolCount = symbolCount + 1
        else
            --
            -- combo broken.. exit early
            return symbolIndex, symbolCount
        end
    end

    return symbolIndex, symbolCount
end

function M:handleScatterPayouts()
    for _, data in pairs(self.results['scatters']) do
        --
        -- highlight symbols..
        for _, tile in pairs(data.tiles) do
            -- tile:highlight()
        end

        -- deal payout..
        self:handlePayout(data.metadata, #data.tiles)
    end

end

function M:handleSequencePayouts()
    for _, data in pairs(self.results['sequences']) do
        --
        -- highlight payline..
        for reelIndex, rowIndex in pairs(data.payline) do
            local reel = self.reels[reelIndex]
            local tile = reel.tiles[rowIndex]
            -- tile:highlight()
        end

        -- deal payout..
        self:handlePayout(data.metadata, data.symbolCount)
    end
end

function M:handlePayout(metadata, symbolCount)
    local payoutAmount = metadata.payout
    local payoutValue  = metadata.value

    -- handle multiplier..
    if symbolCount == metadata.min + 1 then
        -- 2x payout..?
        payoutAmount = metadata.payout * 2
    elseif symbolCount >= metadata.min + 2 then
        -- 5x payout..?
        payoutAmount = metadata.payout * 5
    end

    print("Payout", payoutValue, payoutAmount)
    -- _Game:updateValue(payoutValue, payoutAmount)
end

-- function M:debugResults()
--     local results = {}
--     for rowIndex = 2, Config.rig.numRows - 1 do
--         local line = {}
--         for reelIndex = 1, Config.rig.numReels do
--             local reel = self.reels[reelIndex]
--             local tile = reel.tiles[rowIndex]
--             table.insert(line, Config.image.symbolName[tile.symbolIndex])
--         end
--         table.insert(results, table.concat(line, "\t"))
--     end
--     print(table.concat(results, "\n"))
-- end

--
-- JUICE
--

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

function M:addJuice()
    for _, reel in pairs(self.reels) do
        reel:addJuice()
    end
end

function M:removeJuice()
    for _, reel in pairs(self.reels) do
        reel:removeJuice()
    end
end

return M
