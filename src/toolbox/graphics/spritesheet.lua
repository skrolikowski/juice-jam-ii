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
local Spritesheet = Class{}

function Spritesheet:init(filePath)
    local path, name, extn = __filenameSplit(filePath)
    local ok, message = pcall(lf.getInfo, filePath, "file")

    if not ok then
        print("Could not process spritesheet:", message)
    else
        contents = lf.read(filePath)
        json     = JSON.decode(contents)

        self.image = lg.newImage(path .. name .. '.png')
        self.quads = {}

        for _, frame in ipairs(json.frames) do
            local name = __basename(frame.filename)
            local x = frame.frame.x
            local y = frame.frame.y
            local w = frame.frame.w
            local h = frame.frame.h

            self.quads[name] = lg.newQuad(x, y, w, h, self.image:getDimensions())
        end
    end
end

function Spritesheet:subquad(name, coords)
    local parent = { self:container(name) }
    local w      = coords['w'] or parent[3]
    local h      = coords['h'] or parent[4]
    local x      = coords['x'] or 0
    local y      = coords['y'] or 0

    w = (w < 0 and (parent[3] + w) or w)
    h = (h < 0 and (parent[4] + h) or h)
    x = (x < 0 and (parent[3] + x) or x) + parent[1]
    y = (y < 0 and (parent[4] + y) or y) + parent[2]

    return lg.newQuad(x, y, w, h, self.image:getDimensions())
end

function Spritesheet:quad(name)
    -- print("quad",self.quads['CastleSpriteMale-Right (Frame 1)'])
    if self.quads[name] then
        return self.quads[name]
    end
end

function Spritesheet:getImage()
    return self.image
end

function Spritesheet:dimensions(name)
    local x, y, w, h = self:container(name)

    return w, h
end

function Spritesheet:width(name)
    local w, h = self:dimensions(name)

    return w
end

function Spritesheet:height(name)
    local w, h = self:dimensions(name)

    return h
end

function Spritesheet:container(name)
    return self.quads[name]:getViewport()
end

function Spritesheet:canvas(name, _w, _h)
    local x, y, w, h = self:container(name)
    _h = _h or _w
    sx,sy = _w/w,_h/h
    local canvas = lg.newCanvas(_w,_h)
    lg.setCanvas(canvas)
    lg.push()
    lg.scale(sx,sy)
    self:draw(name)
    lg.pop()
    lg.setCanvas()
    return lg.newImage(canvas:newImageData())
end
function Spritesheet:_canvas(path, _w, _h)
    local image = lg.newImage(path)
    local w, h = image:getDimensions()
    _h = _h or _w
    sx,sy = _w/w,_h/h
    local canvas = lg.newCanvas(_w,_h)
    lg.setCanvas(canvas)
    lg.push()
    lg.scale(sx,sy)
    lg.draw(image)
    lg.pop()
    lg.setCanvas()
    return lg.newImage(canvas:newImageData())
end

function Spritesheet:SlabFrame(name, scale)
    local x, y, w, h = self:container(name)
    return {
        Image = self:getImage(),
        SubX = x,
        SubY = y,
        SubW = w,
        SubH = h,
        W    = w * (scale or 1),
        H    = h * (scale or 1),
    }
end

function Spritesheet:draw(name, ...)
    -- if self.quads[name] then
        lg.draw(self.image, self.quads[name], ...)
    -- end
end

function Spritesheet:drawQuad(name, coords, ...)
    lg.draw(self.image, self:subquad(name, coords), ...)
end

return Spritesheet