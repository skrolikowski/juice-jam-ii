local Vec2 = Class {}

-- Create new Vector 2D
--
function Vec2:init(x, y)
    self.x = x or 0
    self.y = y or 0
end

-- function Vec2:fromGridIndex(grid, idx)
--     local cell = grid:getCellByIndex(idx)
--     if (cell) then
--         return Vec2(cell.aabb:center())
--     end
-- end

function Vec2:fromPolar(angle, mag)
    return Vec2(
        self.x + math.cos(angle) * (mag or 1),
        self.y + math.sin(angle) * (mag or 1)
    )
end

-- Unpack
--
function Vec2:unpack()
    return self.x, self.y
end

-- Copy
--
function Vec2:copy()
    return Vec2(self.x, self.y)
end

-- Distance to another Vec2
--
function Vec2:distance(other)
    return math.sqrt((self.x - other.x) ^ 2 + (self.y - other.y) ^ 2)
end

-- Scale by factor
--
function Vec2:scale(factor)
    self.x = self.x * factor
    self.y = self.y * factor

    return self
end

-- Length of vector
--
function Vec2:magnitude()
    return math.sqrt(self.x ^ 2 + self.y ^ 2)
end

-- Length squared
--
function Vec2:magnitudeSq()
    return self.x ^ 2 + self.y ^ 2
end

-- Normalize
--
function Vec2:normalize()
    local mag = self:magnitude()

    if mag > 0 then
        return self:scale(1 / mag)
    end

    return self
end

-- Clamp length
--
function Vec2:clamp(min, max)
    local mag = self:magnitude()

    self:setMagnitude(
        math.max(min, math.min(mag, max))
    )

    return self
end

-- Limit length
--
function Vec2:limit(max)
    if self:magnitude() > max then
        return self:normalize():scale(max)
    end

    return self
end

-- Dot product
--
function Vec2:dot(other)
    return self.x * other.x + self.y * other.y
end

-- Cross product
--
function Vec2:cross(other)
    return self.x * other.y - self.y * other.x
end

-- Angle between the Vec2 and another
--
function Vec2:angleBetween(other)
    local dotmag2

    dotmag2 = self:dot(other) / (self:magnitude() * other:magnitude())
    dotmag2 = Util.clamp(dotmag2, -1, 1)

    return math.acos(dotmag2)
end

-- Current heading
--
function Vec2:heading()
    return math.atan2(self.y, self.x)
end

-- Heading to other Vec2
--
function Vec2:headingTo(other)
    return math.atan2(other.y - self.y, other.x - self.x)
end

-- Set length
--
function Vec2:setMagnitude(mag)
    local rotation = self:heading()

    self.x = math.cos(rotation) * mag
    self.y = math.sin(rotation) * mag
end

-- Rotate
--
function Vec2:rotate(rotation)
    local cos  = math.cos(rotation)
    local sin  = math.sin(rotation)
    local x, y = self:unpack()

    self.x = cos * x - sin * y
    self.y = sin * x + cos * y

    return self
end

-- Addition operator
--
function Vec2:__add(other)
    if type(other) == 'number' then
        return Vec2(
            self.x + other,
            self.y + other
        )
    end

    return Vec2(
        self.x + other.x,
        self.y + other.y
    )
end

-- Subtraction operator
--
function Vec2:__sub(other)
    if type(other) == 'number' then
        return Vec2(
            self.x - other,
            self.y - other
        )
    end

    return Vec2(
        self.x - other.x,
        self.y - other.y
    )
end

-- Multiplication operator
--
function Vec2:__mul(other)
    if type(other) == 'number' then
        return self:copy():scale(other)
    end

    return Vec2(
        self.x * other.x,
        self.y * other.y
    )
end

-- Division operator
--
function Vec2:__div(other)
    if type(other) == 'number' then
        return Vec2(
            self.x / other,
            self.y / other
        )
    end

    return Vec2(
        self.x / other.x,
        self.y / other.y
    )
end

-- Equals operator
--
function Vec2:__eq(other)
    return self.x == other.x and self.y == other.y
end

-- Unary minus operator
--
function Vec2:__unm()
    return self:copy():scale(-1)
end

-- __tostring operator
--
function Vec2:__tostring()
    return 'Vec2(' .. self.x .. ', ' .. self.y .. ')'
end

return Vec2
