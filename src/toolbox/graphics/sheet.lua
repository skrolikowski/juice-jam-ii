local __getIndex = function(obj, row, col)
    return ((col - 1) + (row - 1) * obj.cols) + 1
end

local Sheet = Class {}

-- New
--
function Sheet:init(path)
    self.image = path and lg.newImage(path) or nil
    self.color = nil -- set static color
    self.quads = {}
end

-- Load image path
-- [Chain]
--
function Sheet:load(path)
    self.image = lg.newImage(path)
    return self
end

-- Set draw color
-- [Chain]
--
function Sheet:setColor(color)
    self.color = color
    return self
end

-- Split by width/height
-- [Chain]
--
function Sheet:split(width, height)
    self.width  = width
    self.height = height
    self.rows   = math.ceil(self.image:getHeight() / height)
    self.cols   = math.ceil(self.image:getWidth() / width)

    --
    for r = 1, self.rows do
        for c = 1, self.cols do
            local w = self.width
            local h = self.height
            local x = (c - 1) * w
            local y = (r - 1) * h

            table.insert(self.quads,
                lg.newQuad(x, y, w, h, self.image:getDimensions()))
        end
    end

    return self
end

-- Query quad by row x col.
--
function Sheet:query(row, col)
    local index = __getIndex(self, row, col)

    return self.quads[index]
end

return Sheet
