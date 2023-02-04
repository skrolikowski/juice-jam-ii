package.path = package.path .. ";lib/?.lua;lib/?/init.lua"
--

function love.conf(t)
    io.stdout:setvbuf('no')

    t.identity = 'juice-jam-ii'
    t.version  = '11.4'
    t.console  = false

    t.window.title      = "Slot Raider"
    t.window.x          = 100
    t.window.y          = 100
    t.window.width      = 1400
    t.window.height     = 800
    t.window.resizable  = false
    t.window.fullscreen = false
    t.window.borderless = true
    t.window.highdpi    = true
    t.window.vsync      = true

    t.modules.touch  = false
    t.modules.thread = false
    t.modules.video  = false
end
