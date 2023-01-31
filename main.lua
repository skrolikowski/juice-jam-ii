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
pprint    = require "lib.pprint.pprint"
Class     = require "lib.hump.class"
Timer     = require "lib.hump.timer"
Gamestate = require "lib.hump.gamestate"

-- local packages..
require "src.toolbox"
require "src.gamestate"
require "src.ui"

local rig

-- Load Game
--
function love.load()
    LoadGame()
    --
    -- _UI = Plan.new()
    --
    Gamestate.registerEvents()
    Gamestate.switch(Gamestates['game'])
end

-- Update Timer
--
function love.update(dt)
    Timer.update(dt)
end

function love.resize()
    Gamestate:current():refresh()
end

---
-- CONTROLS
---
-- function love.keypressed(key)
--     -- _Event:Dispatch('key_' .. key)
--     --

--     if key == "escape" then
--         love.event.quit()
--     elseif key == "space" then
--         rig:trigger()
--     elseif key == "1" then
--         rig:shake()
--     elseif key == "2" then
--         rig:addJuice()
--     end
-- end

-- function love.mousepressed(x, y, button)
--     -- _UI:emit("mousepressed", x, y, button)
-- end

---
-- SAVE/LOAD GAME
---

function LoadGame()
    if Saver:exists('juice-jam-ii') then
        _GAME = Saver:load('juice-jam-ii')
    end
    --
    ResetGame()
end

function ResetGame()
    _GAME = Saver:save('juice-jam-ii', {
        gold   = 100,
        hp     = 100,
        sword  = 0,
        shield = 0,
        volume = _GAME and _GAME.volume or 1,
    })
end

function SaveGame(data)
    _GAME = Saver:save('juice-jam-ii', Util.Merge(_GAME, data))
end
