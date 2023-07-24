CountdownState = Class{__includes = BaseState}

COUNTDOWN_TIME = 0.75 -- um segundo ia ser meio longo

function CountdownState:init()
    self.count = 3 -- conta até tres
    self.timer = 0
end

function CountdownState:update(dt) -- conta o tempo em ordem regressiva 
    self.timer = self.timer + dt

    if self.timer > COUNTDOWN_TIME then
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1 -- ordem regressiva (3, 2, 1)

        if self.count == 0 then -- quando chega em zero começa o jogo
            gStateMachine:change('play')
        end
    end
end

function CountdownState:render()
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end