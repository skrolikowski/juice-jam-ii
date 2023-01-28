-- Event Dispatcher
--

local M = Class{}

function M:init()
    self.events = {}
end

function M:On(name, ...)
    for k, v in pairs({...}) do
        if type(v) == 'function' then
            if not self.events[name] then
                self.events[name] = { v }
            else
                table.insert(self.events[name], v)
            end
        end
    end
end

function M:Off(...)
    for k, v in pairs({...}) do
        if type(v) == 'string' then
            self.events[v] = nil
        end
    end
end

function M:Dispatch(name, ...)
    for k, func in pairs(self.events[name] or {}) do
        func(...)
    end
end

return M