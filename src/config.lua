Config = {
    width = lg.getWidth(),
    height = lg.getHeight(),
    rig = {
        numReels = 10,
        showingRows = 5,
    },
    reel = {
        numTiles        = 7,
        spinEase        = "linear",
        spinDuration    = 0.01,
        spinDurationIn  = { 0.5, 0.2, 0.1, 0.05, 0.03 },
        spinDurationOut = { 0.5, 0.3, 0.2, 0.1, 0.08, 0.05, 0.03, 0.02 }
    },
    tile = {
        width = 100,
        height = 100,
    },
    color = {
        tile  = { 0, 0, 0, 0.25 },
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
        symbol = {
            apple  = lg.newImage('res/image/symbol/Apple.png'),
            bag    = lg.newImage('res/image/symbol/Bag.png'),
            beer   = lg.newImage('res/image/symbol/Beer.png'),
            belt   = lg.newImage('res/image/symbol/Belt.png'),
            bread  = lg.newImage('res/image/symbol/Bread.png'),
            cheese = lg.newImage('res/image/symbol/Cheese.png'),
            fish   = lg.newImage('res/image/symbol/Fish Steak.png'),
            helm   = lg.newImage('res/image/symbol/Helm.png'),
        }
    }
}
