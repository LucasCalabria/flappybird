TitleScreenState = Class{__includes = BaseState}

package.path = package.path .. ";../Debug.lua"
require 'Debug'

function TitleScreenState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown') -- começa a contagem regressiva para começar o jogo
    end
end

function TitleScreenState:render()

    setFont(flappyFont, 'flappyFont') -- escolhida para o titulo no main 
    printf('Flappy Bird da Leca!', 'flappyFont', 0, 64, VIRTUAL_WIDTH, 'center')

    setFont(mediumFont, 'mediumFont') 
    printf('Aperte Enter', 'mediumFont', 0, 120, VIRTUAL_WIDTH, 'center')

end