--
ConfigUtil = {
    round = function(num, precision)
        local factor = 10 ^ precision
        return math.floor(num * factor + 0.5) / factor
    end,

    hex2rgb = function(hex, alpha)
        hex = hex:gsub("#", "")
        alpha = alpha or 1
        return {
            ConfigUtil.round(tonumber("0x" .. hex:sub(1, 2)) / 255, 6),
            ConfigUtil.round(tonumber("0x" .. hex:sub(3, 4)) / 255, 6),
            ConfigUtil.round(tonumber("0x" .. hex:sub(5, 6)) / 255, 6),
            alpha
        }
    end,
}

Config = {
    width = lg.getWidth(),
    height = lg.getHeight(),
    store = {
        ["1"] = { gold = 100, payout = 100, value = "hp" },
        ["2"] = { gold = 500, payout = 001, value = "shield" },
    },
    rig = {
        cost           = 50,
        payoutDuration = 2.5,
        juiceDuration  = 2,
        spinLength     = 1.5,
        numReels       = 5,
        numRows        = 5,
        paylines       = {
            { 2, 2, 2, 2, 2 },
            { 3, 3, 3, 3, 3 },
            { 4, 4, 4, 4, 4 },
            { 2, 3, 4, 3, 2 },
            { 4, 3, 2, 3, 4 },
            { 2, 2, 3, 4, 4 },
            { 4, 4, 3, 2, 2 },
        },
        sequences      = {
            [1] = { min = 3, payout = 050, value = "gold" },
            [2] = { min = 3, payout = 100, value = "gold" },
        },
        scatters       = {
            [3] = { min = 3, payout = 250, value = "gold" },
            [4] = { min = 3, payout = 025, value = "hp" },
            [5] = { min = 3, payout = 001, value = "shield" },
            [6] = { min = 3, payout = 010, value = "hit" },
        },
        symbolWeights  = {
            {
                030, -- Coin
                010, -- Diamond
                003, -- Chest
                005, -- Apple
                003, -- Shield
                008, -- Skull
                002, -- Book
                002, -- Candle
                002, -- Feather
            },
            {
                030, -- Coin
                010, -- Diamond
                003, -- Chest
                005, -- Apple
                003, -- Shield
                008, -- Skull
                002, -- Book
                002, -- Candle
                002, -- Feather
            },
            {
                025, -- Coin
                010, -- Diamond
                005, -- Chest
                005, -- Apple
                003, -- Shield
                015, -- Skull
                002, -- Book
                002, -- Candle
                002, -- Feather
            },
            {
                015, -- Coin
                005, -- Diamond
                005, -- Chest
                005, -- Apple
                005, -- Shield
                015, -- Skull
                002, -- Book
                002, -- Candle
                002, -- Feather
            },
            {
                010, -- Coin
                005, -- Diamond
                005, -- Chest
                005, -- Apple
                005, -- Shield
                015, -- Skull
                002, -- Book
                002, -- Candle
                002, -- Feather
            }
        },
    },
    particles = {
        RainingCoins   = require "res.particles.RainingCoins",
        MouseCoins     = require "res.particles.MouseCoins",
        AwardingShield = require "res.particles.AwardingShield",
    },
    reel = {
        spinEase        = "linear",
        spinDuration    = 0.015,
        spinDurationIn  = { 0.5, 0.2, 0.1, 0.05, 0.03 },
        spinDurationOut = { 0.5, 0.3, 0.2, 0.1, 0.08, 0.05, 0.03, 0.02 }
    },
    tile = {
        size  = lg.getWidth() * 0.125,
        scale = 4
    },
    color = {
        panel     = ConfigUtil.hex2rgb("36454F", 0.85),
        panel2    = ConfigUtil.hex2rgb("8A9A5B", 0.75),
        tile      = ConfigUtil.hex2rgb("3a4a3d", 0.85),
        white     = { 1, 1, 1, 1 },
        black     = { 0, 0, 0, 1 },
        header    = ConfigUtil.hex2rgb("7393B3", 0.85),
        overlay   = { 0, 0, 0, 0.75 },
        clear     = { 0, 0, 0, 0 },
        hp        = ConfigUtil.hex2rgb("DC143C", 0.5),
        hp_bg     = ConfigUtil.hex2rgb("000000", 0.25),
        hp_border = ConfigUtil.hex2rgb("FF0000"),
        gold      = ConfigUtil.hex2rgb("FFD700"),
    },
    font = {
        xs  = lg.newFont('res/font/CarterOne-Regular.ttf', 12),
        sm  = lg.newFont('res/font/CarterOne-Regular.ttf', 18),
        md  = lg.newFont('res/font/CarterOne-Regular.ttf', 24),
        lg  = lg.newFont('res/font/CarterOne-Regular.ttf', 32),
        xl  = lg.newFont('res/font/CarterOne-Regular.ttf', 48),
        xxl = lg.newFont('res/font/CarterOne-Regular.ttf', 72)
    },
    image = {
        bg     = {
            game = lg.newImage('res/image/Bridge 1.png'),
            dead = lg.newImage('res/image/Bridge 3.png'),
            title = lg.newImage('res/image/Cavern 3.png'),
            -- game = lg.newImage('res/image/Crystals 1.png'),
            -- game = lg.newImage('res/image/Interior 2.png'),
        },
        rules  = lg.newImage('res/image/rules.png'),
        symbol = {
            "Coin",
            "Diamond",
            "Chest",
            "Apple",
            "Shield",
            "Skull",
            "Book",
            "Candle",
            "Feather",
        }
    },
    audio = {
        bgLoop     = la.newSource('res/audio/Ambience Dark Chamber Loop.wav', 'stream'),
        spinLoop   = la.newSource('res/audio/Energy Charge.wav', 'static'),
        spinStart  = la.newSource('res/audio/Activate Crystal.wav', "static"),
        spinStop   = la.newSource('res/audio/Arcane Reveal Transition.wav', "static"),
        spinReveal =
        {
            la.newSource('res/audio/Arcane Bright Light 01.wav', "static"),
            la.newSource('res/audio/Arcane Bright Light 01.wav', "static"),
            la.newSource('res/audio/Arcane Bright Light 01.wav', "static"),
            la.newSource('res/audio/Arcane Bright Light 01.wav', "static"),
            la.newSource('res/audio/Arcane Bright Light 01.wav', "static"),
        }
    }
}
