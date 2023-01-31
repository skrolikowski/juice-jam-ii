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
--
Config.audio.bgLoop:play()
Config.audio.bgLoop:setLooping(true)

-- lib packages..
pprint = require "lib.pprint.pprint"
-- Camera = require "lib.hump.camera"
Class  = require "lib.hump.class"
Timer  = require "lib.hump.timer"
-- Gamestate = require "lib.hump.gamestate"

-- local packages..
require "src.toolbox"
require "src.ui"

local rig

-- Load Game
--
function love.load()
    _Event = Event()
    _UI    = Plan.new()
    _Game  = require 'src.Game' ()
    --
    rig    = Rig()
end

-- Update Timer
--
function love.update(dt)
    Timer.update(dt)
    --
    rig:update(dt)
end

function love.draw()
    --
    -- draw background..
    lg.setColor(Config.color.white)
    lg.draw(Config.image.bg)

    -- draw rig..
    rig:draw()

    -- draw ui..
    _UI:draw()
    _Game:draw()
end

function love.resize()
    _UI:refresh()
end

---- ---- ---- ----

-- Controls - Key Press
--
function love.keypressed(key)
    _Event:Dispatch('key_' .. key)
    --

    if key == "escape" then
        love.event.quit()
    elseif key == "space" then
        rig:trigger()
    elseif key == "1" then
        rig:shake()
    elseif key == "2" then
        rig:addJuice()
    end
end

-- -- Controls - Mouse Move
-- --
-- function love.mousemoved(x, y)
--     -- _World:OnHover(x, y)
-- end

-- Controls - Mouse Pressed
--
function love.mousepressed(x, y, button)
    -- _World:OnClick(x, y, button)
    _UI:emit("mousepressed", x, y, button)
end
