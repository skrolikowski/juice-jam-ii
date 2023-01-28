local PQueue = Class {}

function PQueue:init(...)
    self.items = {}

    for _, v in pairs({ ... }) do
        self:put(v)
    end
end

function PQueue:put(item, priority)
    self.items[#self.items + 1] = { item, priority or 1 }

    table.sort(self.items,
        function(a, b)
            return a[2] < b[2]
        end)
end

function PQueue:peek()
    return self.items[1][1]
end

function PQueue:get()
    if self:isEmpty() then
        return false
    end

    local item     = table.remove(self.item, 1)
    local obj      = item[1]
    local priority = item[2]

    return obj, priority
end

function PQueue:size()
    return #self.items
end

function PQueue:isEmpty()
    return #self.items == 0
end

function PQueue:debug()
    print('--------')

    for _, element in pairs(self.elements) do
        print(element[1], '=>', element[2])
    end

    print('--------')
end

return Queue
