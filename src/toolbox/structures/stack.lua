local Stack = Class{}

function Stack:init(...)
    self.items = {...}
end

function Stack:put(item)
    table.insert(self.items, 1, item)
end

function Stack:peek()
    return self.items[1]
end

function Stack:get()
    if self:isEmpty() then
        return false
    end

    return table.remove(self.items, 1)
end

function Stack:size()
    return #self.items
end

function Stack:isEmpty()
    return #self.items == 0
end

return Stack