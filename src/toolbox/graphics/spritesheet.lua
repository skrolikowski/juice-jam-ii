local __basename = function(source)
    return source:gsub(".png", "")
    -- return string.match(source, "([%a|%-_ |%d| ]+)")
end

local __filenameSplit = function(source)
    return string.match(source, "(.+%/)([%a|%-_%(%)|%d|%s]+)%.(%a+)")
end
--
--

local JSON        = require 'lib.json4lua.json'
local Spritesheet = Class {}

function Spritesheet:init(filePath)
    local path, name, extn = __filenameSplit(filePath)
    local ok, message = pcall(lf.getInfo, filePath, "file")

    if not ok then
        print("Could not process spritesheet:", message)
    else
        local contents = lf.read(filePath)
        local json     = JSON.decode(contents)

        self.image = lg.newImage(path .. name .. '.png')
        self.quads = {}

        for _, frame in ipairs(json.frames) do
            local name = __basename(frame.filename)
            local x = frame.frame.x
            local y = frame.frame.y
            local w = frame.frame.w
            local h = frame.frame.h

            table.insert(self.quads, lg.newQuad(x, y, w, h, self.image:getDimensions()))
        end
    end
end

return Spritesheet
