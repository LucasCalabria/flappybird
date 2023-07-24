TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown') -- começa a contagem regressiva para começar o jogo
    end
end

function TitleScreenState:render()

    love.graphics.setFont(flappyFont) -- escolhida para o titulo no main 
    love.graphics.printf('Flappy Bird da Leca!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont) 
    love.graphics.printf('Aperte Enter', 0, 120, VIRTUAL_WIDTH, 'center')
end