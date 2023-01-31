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
    rig = {
        numReels             = 5,
        numRows              = 5,
        paylines             = {
            { 2, 2, 2, 2, 2 },
            { 3, 3, 3, 3, 3 },
            { 4, 4, 4, 4, 4 },
            { 2, 3, 4, 3, 2 },
            { 4, 3, 2, 3, 4 },
            { 2, 2, 3, 4, 4 },
            { 4, 4, 3, 2, 2 },
        },
        sequences            = {
            -- Coin (payout = gold)
            [1] = { min = 3, payout = 05, value = "gold" },
            -- Diamond (payout = gold)
            [2] = { min = 3, payout = 25, value = "gold" },
            -- Apple (payout = hp)
            [4] = { min = 3, payout = 10, value = "hp" },
            -- Slime(payout = -hp)
            [8] = { min = 3, payout = -10, value = "hp" },
        },
        scatters             = {
            [3] = { min = 3, payout = 10, value = "gold" }, -- Chest  (payout = + gold)
            [5] = { min = 3, payout = 10, value = "hp" }, -- Potion (payout = + hp)
            [6] = { min = 3, payout = 01, value = "sword" }, -- Sword  (payout = + sword)
            [7] = { min = 3, payout = 01, value = "shield" }, -- Shield (payout = + shield)
            [9] = { min = 3, payout = -10, value = "hp" }, -- Skull  (payout = - hp)
        },
        wildSymbolIndex      = 14,
        symbolWeights        = {
            -- money
            050, -- Coin    (sequence)
            025, -- Diamond (sequence)
            010, -- Chest   (scatter)
            -- health
            025, -- Apple   (sequence)
            010, -- Potion  (scatter)
            -- tools
            015, -- Sword   (scatter)
            015, -- Shield  (scatter)
            -- enemy
            025, -- Slime   (sequence)
            015, -- Skull   (scatter)
            -- misc
            005, -- Book
            005, -- Candle
            005, -- Feather
            -- wild
            010, -- Wild
        },
        symbolWeightsReelOne = {
            -- money
            033, -- Coin    (sequence)
            020, -- Diamond (sequence)
            000, -- Chest   (scatter)
            -- health
            020, -- Apple   (sequence)
            000, -- Potion  (scatter)
            -- tools
            000, -- Sword   (scatter)
            000, -- Shield  (scatter)
            -- enemy
            025, -- Slime   (sequence)
            000, -- Skull   (scatter)
            -- misc
            005, -- Book
            005, -- Candle
            005, -- Feather
            -- wild
            000, -- Wild
        },
    },
    reel = {
        spinEase        = "linear",
        spinDuration    = 0.01,
        spinDurationIn  = { 0.5, 0.2, 0.1, 0.05, 0.03 },
        spinDurationOut = { 0.5, 0.3, 0.2, 0.1, 0.08, 0.05, 0.03, 0.02 }
    },
    tile = {
        size  = lg.getWidth() * 0.1,
        scale = 3
    },
    color = {
        panel   = ConfigUtil.hex2rgb("3a4a3d", 0.85),
        tile    = ConfigUtil.hex2rgb("3a4a3d", 0.85),
        white   = { 1, 1, 1, 1 },
        black   = { 0, 0, 0, 1 },
        overlay = { 0, 0, 0, 0.75 },
    },
    font = {
        xs = lg.newFont('res/font/monogram.ttf', 16),
        sm = lg.newFont('res/font/monogram.ttf', 20),
        md = lg.newFont('res/font/monogram.ttf', 24),
        lg = lg.newFont('res/font/monogram.ttf', 32),
        xl = lg.newFont('res/font/monogram.ttf', 48)
    },
    image = {
        bg = lg.newImage('res/image/bg.png'),
        symbolName = {
            "Coin",
            "Diamond",
            "Chest",
            "Apple",
            "Potion",
            "Sword",
            "Shield",
            "Slime",
            "Skull",
            "Book",
            "Candle",
            "Feather",
            "Wild",
        },
        symbol = {
            -- money
            lg.newImage('res/image/symbol/Coin.png'),
            lg.newImage('res/image/symbol/Diamond.png'),
            lg.newImage('res/image/symbol/Chest.png'),
            -- health
            lg.newImage('res/image/symbol/Apple.png'),
            lg.newImage('res/image/symbol/Potion.png'),
            -- tools
            lg.newImage('res/image/symbol/Sword.png'),
            lg.newImage('res/image/symbol/Shield.png'),
            -- enemy
            lg.newImage('res/image/symbol/Slime.png'),
            lg.newImage('res/image/symbol/Skull.png'),
            -- misc
            lg.newImage('res/image/symbol/Book.png'),
            lg.newImage('res/image/symbol/Candle.png'),
            lg.newImage('res/image/symbol/Feather.png'),
            -- wild
            lg.newImage('res/image/symbol/Wild.png'),
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
