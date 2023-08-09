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

function printf(text, font, x, y, limit, align)
    if TAKING_SAMPLE then
        table.insert(print_texts, text)
        table.insert(print_fonts, font)
        table.insert(print_xs, x)
        table.insert(print_ys, y)
        table.insert(print_aligns, align)
    end

    love.graphics.setFont(Debug:getVariableObj(font))

    return love.graphics.printf(text, x, y, limit, align)
end

function setFont(variable, name)
    love.graphics.setFont(variable)

    Debug:setVariableObj(name, variable)
end
