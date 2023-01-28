package.path = package.path .. ";lib/?.lua;lib/?/init.lua"
--

function love.conf(t)
    io.stdout:setvbuf('no')

    t.identity = 'game'
    t.version  = '11.4'
    t.console  = false

    t.window.title      = "Juice Jam II"
    t.window.x          = 200
    t.window.y          = 50
    t.window.width      = 1400
    t.window.height     = 800
    t.window.resizable  = true
    t.window.fullscreen = false
    t.window.borderless = false
    t.window.highdpi    = true
    t.window.vsync      = true

    t.modules.touch  = false
    t.modules.thread = false
    t.modules.video  = false
end
