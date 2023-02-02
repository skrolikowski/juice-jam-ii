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

-- Load Game
--
function love.load()
    -- LoadGame()
    --
    Config.particles.AwardingShield:stop()
    Config.particles.MouseCoins:stop()
    Config.particles.RainingCoins:stop()
    --
    Gamestate.registerEvents()
    Gamestate.switch(Gamestates['title'])
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
-- SAVE/LOAD GAME
---

function CanContinueGame()
    if Saver:exists('juice-jam-ii') then
        local data = Saver:load('juice-jam-ii')
        return data.hp > 0 and data.gold > 0
    end

    return false
end

function LoadGame()
    if Saver:exists('juice-jam-ii') then
        _GAME = Saver:load('juice-jam-ii')
    else
        ResetGame()
    end
    --
    ResetGame()
end

function ResetGame()
    _GAME = Saver:save('juice-jam-ii', {
        gold   = 500,
        hp     = 100,
        shield = 1,
        volume = _GAME and _GAME.volume or 1,
    })
end

function SaveGame(data)
    _GAME = Saver:save('juice-jam-ii', Util.Merge(_GAME, data or {}))
end
