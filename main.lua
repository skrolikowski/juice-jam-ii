-- #{PROJECT_NAME}
-- https://github.com/skrolikowski/
--
-- Configurations
--
la = love.audio
lf = love.filesystem
lg = love.graphics
li = love.image
lj = love.joystick
lm = love.mouse
lk = love.keyboard
ls = love.sound
lt = love.timer
lx = love.math
--
require 'src.config'
--
-- pixels please..
lg.setDefaultFilter('nearest', 'nearest')
-- random seed
math.randomseed(os.time())

-- lib packages..
pprint = require "lib.pprint.pprint"
Class  = require "lib.hump.class"
Timer  = require "lib.hump.timer"
-- Gamestate = require "lib.hump.gamestate"

-- local packages..
require 'src.toolbox'

local reels, reelStencil

-- Load Game
--
function love.load()
    _Event = Event()
    --
    reels = {
        Reel({ index = 1 }),
        Reel({ index = 2 }),
    }
    reelStencil = function()
        lg.push()
        --
        lg.translate(Config.width * 0.5, Config.height * 0.5)
        lg.rectangle("fill",
            -Config.tile.width * 2,
            -Config.tile.height * 2,
            Config.tile.width * 3,
            Config.tile.height * 3)
        --
        lg.pop()
    end
end

-- Update Timer
--
function love.update(dt)
    Timer.update(dt)
    --
    for _, reel in pairs(reels) do
        reel:update(dt)
    end
end

function love.draw()
    lg.setColor(Config.color.white)
    lg.draw(Config.image.bg)


    lg.stencil(reelStencil, "replace", 1)
    lg.setStencilTest("greater", 0)
    --
    --
    lg.push()
    lg.translate(Config.width * 0.5, Config.height * 0.5)
    --
    for _, reel in pairs(reels) do
        reel:draw()
    end
    --
    lg.pop()
    --
    --
    lg.setStencilTest()
end

function love.resize()
    -- _UI:refresh()
end

---- ---- ---- ----

-- Controls - Key Press
--
function love.keypressed(key)
    _Event:Dispatch('key_' .. key)
    --

    if key == 'escape' then
        love.event.quit()
    elseif key == 'space' then
        for _, reel in pairs(reels) do
            reel:triggerSpin()
        end
    end
end

-- -- Controls - Mouse Move
-- --
-- function love.mousemoved(x, y)
--     -- _World:OnHover(x, y)
-- end

-- -- Controls - Mouse Pressed
-- --
-- function love.mousepressed(x, y, button)
--     _World:OnClick(x, y, button)
--     -- _UI:emit("mousepressed", x, y, button)
-- end
