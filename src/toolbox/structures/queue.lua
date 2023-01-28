local Queue = Class{}

function Queue:init(...)
    self.items = {...}
end

function Queue:put(item)
    table.insert(self.items, item)
end

function Queue:peek()
    return self.items[1]
end

function Queue:get()
    if self:isEmpty() then
        return false
    end

    return table.remove(self.items, 1)
end

function Queue:size()
    return #self.items
end

function Queue:isEmpty()
    return #self.items == 0
end

return Queue