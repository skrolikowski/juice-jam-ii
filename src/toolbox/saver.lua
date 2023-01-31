-- Game Saver
--
local Binser = require "lib.binser.binser"
local Saver  = {}

function Saver:save(name, ...)
    lf.write(name .. '.txt', Binser.serialize(...))

    return ...
end

function Saver:load(name)
    if self:exists(name) then
        local data, size = lf.read(name .. '.txt')

        return Binser.deserialize(data)[1]
    end

    return false
end

function Saver:exists(name)
    return self:getInfo(name) ~= nil
end

function Saver:getInfo(name)
    return lf.getInfo(name .. '.txt', 'file')
end

return Saver
