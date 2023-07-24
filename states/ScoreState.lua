ScoreState = Class{__includes = BaseState}

local bronzeScore = love.graphics.newImage('imagens/bronzetrophy.png')
local silverScore = love.graphics.newImage('imagens/silvertrophy.png')
local goldScore = love.graphics.newImage('imagens/goldtrophy.png')

local bronzeTrophy = 5
local silverTrophy = 10
local goldTrophy = 15


function ScoreState:enter(params) -- passa os parametros
    self.score = params.score
end

function ScoreState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
    end
end

function ScoreState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Game Over!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    if self.score >= goldTrophy then
        love.graphics.draw(goldScore, VIRTUAL_WIDTH / 2 - goldScore:getWidth() / 2, VIRTUAL_HEIGHT / 2 - goldScore:getHeight() / 2)
    elseif self.score >= silverTrophy and self.score < goldTrophy then
        love.graphics.draw(silverScore, VIRTUAL_WIDTH / 2 - silverScore:getWidth() / 2, VIRTUAL_HEIGHT / 2 - silverScore:getHeight() / 2)
    elseif self.score >= bronzeTrophy and self.score < silverTrophy then
        love.graphics.draw(bronzeScore, VIRTUAL_WIDTH / 2 - bronzeScore:getWidth() / 2, VIRTUAL_HEIGHT / 2 - bronzeScore:getHeight() / 2)
    end

    love.graphics.printf('Aperte Enter para tentar de novo!', 0, 180, VIRTUAL_WIDTH, 'center')
end
