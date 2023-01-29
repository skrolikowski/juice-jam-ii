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
        numReels           = 3,
        numRows            = 5,
        paylines           = {
            -- { 2, 2, 2 },
            { 3, 3, 3 },
            -- { 4, 4, 4 },
        },
        winlines           = {
            [1] = { min = 3, mult = 1 }
        },
        scatterSymbolIndex = 3,
        wildSymbolIndex    = 2
    },
    reel = {
        spinEase        = "linear",
        spinDuration    = 0.01,
        spinDurationIn  = { 0.5, 0.2, 0.1, 0.05, 0.03 },
        spinDurationOut = { 0.5, 0.3, 0.2, 0.1, 0.08, 0.05, 0.03, 0.02 }
    },
    tile = {
        width       = 150,
        height      = 150,
        symbolScale = 3
    },
    color = {
        tile  = ConfigUtil.hex2rgb("3a4a3d", 0.85),
        white = { 1, 1, 1, 1 },
        black = { 0, 0, 0, 1 },
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
            "Apple",
            "Bag",
            -- "Beer",
            -- "Bow",
            -- "Chest",
            -- "Sword",
            -- "Helm",
            -- "Potion",
            -- "Skull",
            -- "Slime",
            -- "String",
        },
        symbol = {
            lg.newImage('res/image/symbol/Apple.png'),
            lg.newImage('res/image/symbol/Bag.png'),
            -- lg.newImage('res/image/symbol/Beer.png'),
            -- lg.newImage('res/image/symbol/Bow.png'),
            -- lg.newImage('res/image/symbol/Chest.png'),
            -- lg.newImage('res/image/symbol/Golden Sword.png'),
            -- lg.newImage('res/image/symbol/Helm.png'),
            -- lg.newImage('res/image/symbol/Red Potion 2.png'),
            -- lg.newImage('res/image/symbol/Skull.png'),
            -- lg.newImage('res/image/symbol/Slime Gel.png'),
            -- lg.newImage('res/image/symbol/String.png'),
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
