StateMachine = Class{}

function StateMachine:init(states)
    self.empty = {
        render = function() end,
        update = function() end,
        enter = function() end,
        exit = function() end
    }
    self.states = states or {} -- se n tiver é a lista vazia
    self.current = self.empty
end

function StateMachine:change(stateName, enterParams) -- sai da que tava e troca para o proximo state
    assert(self.states[stateName])
    self.current:exit()
    self.current = self.states[stateName]()
    self.current:enter(enterParams)
end

function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:render()
    self.current:render()
end
