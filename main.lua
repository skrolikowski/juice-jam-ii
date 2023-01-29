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

local reels = {}
local reelStencil
local cx = Config.width * 0.5 - Config.rig.numReels * 0.5 * Config.tile.width
local cy = Config.height * 0.5 - Config.reel.numTiles * 0.5 * Config.tile.height

-- Load Game
--
function love.load()
    _Event = Event()
    --
    -- create reels
    for i = 1, Config.rig.numReels do
        table.insert(reels, Reel({ index = i }))
    end


    reelStencil = function()
        local x = 0
        local y = Config.tile.height * (Config.reel.numTiles - Config.rig.showingRows) * 0.5
        local w = Config.tile.width * Config.rig.numReels
        local h = Config.tile.width * Config.rig.showingRows

        lg.rectangle("fill", x, y, w, h)
        -- -Config.tile.width * Config.rig.numReels * 0.5,
        -- -Config.tile.height * Config.rig.showingRows * 0.5,
        -- Config.tile.width * Config.rig.showingRows,
        -- Config.tile.height * Config.rig.showingRows)
        --
        -- lg.pop()
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


    lg.push()
    lg.translate(cx, cy)
    --
    lg.stencil(reelStencil, "replace", 1)
    lg.setStencilTest("greater", 0)
    --
    for _, reel in pairs(reels) do
        reel:draw()
    end
    --
    lg.setStencilTest()
    --
    lg.pop()
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
