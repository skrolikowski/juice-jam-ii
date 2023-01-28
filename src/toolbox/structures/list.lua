-- List
local M = Class{}

function M:init(...)
    self.items = {}

    self:push(...)
end

function M:length()
    return #self.items
end

function M:isEmpty()
    return self:length() == 0
end

function M:copy()
    local copy = Array()

    for _, item in pairs(self.items) do
        table.insert(copy.items, {
            index = item.index,
            value = item.value
        })
    end

    return copy
end

function M:push(...)
    for _, value in pairs({...}) do
        table.insert(self.items, {
            index = self:length() + 1,
            value = value
        })
    end

    return #self.items
end

function M:unshift(value)
    local values   = self:values()
    local items = {}

    table.insert(values, 1, value)

    for idx, value in pairs(values) do
        table.insert(items, {
            index = idx,
            value = value
        })
    end

    self.items = items
end

function M:shift()
    local item

    if not self:isEmpty() then
        item = table.remove(self.items, 1)

        return item.value
    end

    return nil
end

function M:pop()
    local item

    if not self:isEmpty() then
        item = table.remove(self.items, self:length())

        return item.value
    end

    return nil
end

function M:first()
    local item = self.items[1]

    if item then
        return item
    end

    return nil
end

function M:last()
    local item = self.items[#self.items]

    if item then
        return item
    end

    return nil
end

function M:slice(index, length, preserveKeys)
    local items    = UTable:copy(self.items)
    local found    = false
    local removed  = {}

    length       = length or 1
    preserveKeys = preserveKeys or false

    for idx, item in pairs(items) do
        if found == false and item.index == index then
            found = true
        end

        if found and length > 0 then
            table.insert(removed, item)
            table.remove(self.items, idx)

            length = length - 1
        end
    end

    if preserveKeys == false then
        self:reIndex()
    end

    return removed
end

function M:replace(value, index)
    for idx, item in pairs(self.items) do
        if item.index == index then
            self.items[idx] = {
                index = index,
                value = value
            }

            return true
        end
    end

    return false
end

function M:keys()
    local keys = {}

    for _, item in pairs(self.items) do
        table.insert(keys, item.index)
    end

    return keys
end

function M:values()
    local values = {}

    for _, item in pairs(self.items) do
        table.insert(values, item.value)
    end

    return values
end

function M:toTable()
    local table = {}

    for _, item in pairs(self.items) do
        table[item.index] = item.value
    end

    return table
end

function M:reIndex()
    local values = self:values()
    local items  = {}

    for idx, item in pairs(self.items) do
        table.insert(items, {
            index = idx,
            value = item.value
        })
    end

    self.items = items
end

function M:exists(index)
    -- print("M:exists", index, #self.items)
    return self:get(index) ~= nil
end

function M:set(value, index)
-- print("set",index,#self.items)
    if index == nil then
        self:push(value)
    else
        if self:exists(index) then
-- print("set(3)", index)
            self:replace(value, index)
        else
-- print("set(4)", index)
            table.insert(self.items, {
                index = index,
                value = value
            })
        end
    end
end

function M:get(index)
    local match = nil

    for _, item in pairs(self.items) do
        if item.index == index then
            match = item.value
        end
    end

    return match
end

function M:sort()
    table.sort(self.items, function(a, b) return a.value < b.value end)

    return self.items
end

function M:debug()
    print('--------')

    for _, item in pairs(self.items) do
        print(item.index, '=>', item.value)
    end

    print('--------')
end

return M