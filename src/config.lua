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
        ["1"] = { gold = 50, payout = 100, value = "hp" },
        ["2"] = { gold = 100, payout = 001, value = "shield" },
    },
    rig = {
        cost           = 5,
        payoutDuration = 2.5,
        juiceDuration  = 2,
        spinLength     = 1.5,
        numReels       = 5,
        numRows        = 5,
        payout         = {
            ["Coin"]    = { min = 3, payout = 003, value = "gold" },
            ["Ingot"]   = { min = 3, payout = 005, value = "gold" },
            ["Diamond"] = { min = 3, payout = 010, value = "gold" },
            ["Chest"]   = { min = 3, payout = 020, value = "gold" },
            ["Apple"]   = { min = 3, payout = 020, value = "hp" },
            ["Shield"]  = { min = 3, payout = 001, value = "shield" },
            ["Skull"]   = { min = 3, payout = 100, value = "hit" },
            ["Slime"]   = { min = 3, payout = 100, value = "hit" },
        },
        symbolWeights  = {
            {
                015, -- Coin
                008, -- Ingot
                005, -- Diamond
                003, -- Chest
                005, -- Apple
                003, -- Shield
                010, -- Skull
                015, -- Slime
                003, -- Book
                003, -- Candle
                003, -- Feather
            },
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
        xs  = lg.newFont('res/font/CarterOne-Regular.ttf', 14),
        sm  = lg.newFont('res/font/CarterOne-Regular.ttf', 18),
        md  = lg.newFont('res/font/CarterOne-Regular.ttf', 24),
        lg  = lg.newFont('res/font/CarterOne-Regular.ttf', 32),
        xl  = lg.newFont('res/font/CarterOne-Regular.ttf', 48),
        xxl = lg.newFont('res/font/CarterOne-Regular.ttf', 72)
    },
    image = {
        bg     = {
            game  = lg.newImage('res/image/Bridge 1.png'),
            dead  = lg.newImage('res/image/Bridge 3.png'),
            title = lg.newImage('res/image/Cavern 3.png'),
        },
        symbol = {
            "Coin",
            "Ingot",
            "Diamond",
            "Chest",
            "Apple",
            "Shield",
            "Skull",
            "Slime",
            "Book",
            "Candle",
            "Feather",
        }
    },
    audio = {
        bgLoop     = la.newSource('res/audio/Ambience Dark Chamber Loop.wav', 'stream'),
        spinLoop   = la.newSource('res/audio/Energy Charge.wav', 'static'),
        spinStart  = la.newSource('res/audio/Activate Crystal.wav', "static"),
        spinReveal =
        {
            la.newSource('res/audio/Activation Short 3rd.wav', "static"),
            la.newSource('res/audio/Activation Short 3rd.wav', "static"),
            la.newSource('res/audio/Activation Short 5th.wav', "static"),
            la.newSource('res/audio/Activation Short 5th.wav', "static"),
            la.newSource('res/audio/Activate Octave Delay.wav', "static"),
        },
        ui         = {
            select = la.newSource('res/audio/UI Select Dark.wav', "static"),
            pick   = la.newSource('res/audio/UI Short Chime.wav', "static"),
        },
        payout     = {
            shield_lose = la.newSource('res/audio/Activate Stasis Field.wav', "static"),
            shield_gain = la.newSource('res/audio/Collect Item.wav', "static"),
            coin_gain   = la.newSource('res/audio/Coin_Counter_10_loop.wav', "static"),
            hp_gain     = la.newSource('res/audio/Bright Noise Echo.wav', "static"),
            hp_lose     = la.newSource('res/audio/Dark Activation Distorted.wav', "static"),
        }
    }
}
