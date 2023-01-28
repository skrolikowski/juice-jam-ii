local Grid = Class{}
local CellSize = 32

function Grid:init(cells, rows, cols)
    self.rows  = rows
    self.cols  = cols
    self.cells = {}

    for idx, typ in pairs(cells) do
        local row = math.ceil(idx / cols)
        local col = ((idx-1) % cols) + 1
        local px  = (col - 1) * CellSize
        local py  = (row - 1) * CellSize

        table.insert(self.cells, {
            idx   = idx,
            row   = row,
            col   = col,
            typ   = typ,
            aabb  = AABB():fromContainer(px, py, CellSize, CellSize),
            isPassible = true,
            fillColor = Config.color.fillDefault,
            lineColor = Config.color.lineDefault,
        })
    end
end

function Grid:getCellIndex(row, col)
    return ((col-1) + (row-1) * self.cols) + 1
end

function Grid:getCell(row, col)
    local idx = self:getCellIndex(row, col)
    if self:isValidIndex(idx) then
		return self.cells[idx]
	end
end

function Grid:getCellByIndex(idx)
    if self:isValidIndex(idx) then
		return self.cells[idx]
	end
end

function Grid:getCellByLocation(x, y)
    local row = math.ceil((y - Config.grid.yOffset) / Config.grid.cellSize)
    local col = math.ceil((x - Config.grid.xOffset) / Config.grid.cellSize)

    return self:getCell(row, col)
end

function Grid:getCellNeighbors(cell)
    return {
        top    = self:getCell(cell.row - 1, cell.col + 0),
		left   = self:getCell(cell.row + 0, cell.col - 1),
		right  = self:getCell(cell.row + 0, cell.col + 1),
		bottom = self:getCell(cell.row + 1, cell.col + 0),
    }
end

function Grid:getCellDistance(a, b)
    return math.abs(a.row - b.row) + math.abs(a.col - b.col)
end

function Grid:isValidIndex(idx)
	return idx > 0 and idx <= #self.cells
end

function Grid:draw()
    for _, cell in pairs(self.cells) do
		local x,y,w,h = cell.aabb:container()

        if (cell.fillColor) then
            lg.setColor(cell.fillColor)
            lg.rectangle('fill', x, y, w, h)
        end 

        if (cell.lineColor) then
            lg.setColor(cell.lineColor)
            lg.rectangle('line', x, y, w, h)
        end 
	end
end

return Grid