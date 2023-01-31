--
--
require 'src.toolbox.graphics'
--
List   = require 'src.toolbox.structures.list'
Grid   = require 'src.toolbox.structures.grid'
Queue  = require 'src.toolbox.structures.queue'
PQueue = require 'src.toolbox.structures.pqueue'
Stack  = require 'src.toolbox.structures.stack'

--
AABB = require 'src.toolbox.math.AABB'
Vec2 = require 'src.toolbox.math.Vec2'
-- Dice = require 'src.toolbox.math.dice',

--
Event = require 'src.toolbox.behavior.event'
Saver = require 'src.toolbox.saver'

--
Rig  = require 'src.toolbox.rig.rig'
Reel = require 'src.toolbox.rig.reel'
Tile = require 'src.toolbox.rig.tile'

--
Util = {
    MapTo = function(value, minSource, maxSource, minDest, maxDest)
        local trueSourceMin = math.min(minSource, maxSource)
        local trueSourceMax = math.max(minSource, maxSource)
        local trueDestMin   = math.min(minDest, maxDest)
        local trueDestMax   = math.max(minDest, maxDest)
        local norm          = (value - trueSourceMin) / (trueSourceMax - trueSourceMin)

        return (trueDestMax - trueDestMin) * norm + trueDestMin
    end,

    RandChoice = function(...)
        return ({ ... })[math.random(1, #{ ... })]
    end,

    Merge = function(...)
        local out = {}
        for _, t in ipairs({ ... }) do
            if type(t) == "table" then
                for k, v in pairs(t) do
                    out[k] = v
                end
            end
        end
        return out
    end,

    Round = function(num, precision)
        local factor = 10 ^ precision
        return math.floor(num * factor + 0.5) / factor
    end,

    Clamp = function(val, min, max)
        return math.max(min, math.min(val, max))
    end,

    SumValues = function(tabl)
        local sum = 0

        for _, value in pairs(tabl) do
            sum = sum + value
        end

        return sum
    end,

    WeightedChoice = function(tabl)
        local sum      = Util.SumValues(tabl)
        local index    = 0
        local selector = math.random() * sum

        while selector > 0 do
            index    = index + 1
            selector = selector - tabl[index]
        end

        return tabl[index], index
    end
}
