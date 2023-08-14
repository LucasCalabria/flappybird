ScoreState = Class{__includes = BaseState}

local bronzeScore = Bird:newImage('bronzeScore', 'imagens/bronzetrophy.png')
local silverScore = Bird:newImage('silverScore', 'imagens/silvertrophy.png')
local goldScore = Bird:newImage('goldScore', 'imagens/goldtrophy.png')

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
    setFont(flappyFont, 'flappyFont')
    printf('Game Over!', 'flappyFont', 0, 64, VIRTUAL_WIDTH, 'center')

    setFont(mediumFont, 'mediumFont')
    printf('Score: ' .. tostring(self.score), 'mediumFont', 0, 100, VIRTUAL_WIDTH, 'center')

    if self.score >= goldTrophy then
        Bird:draw('goldScore', VIRTUAL_WIDTH / 2 - goldScore:getWidth() / 2, VIRTUAL_HEIGHT / 2 - goldScore:getHeight() / 2)
    elseif self.score >= silverTrophy and self.score < goldTrophy then
        Bird:draw('silverScore', VIRTUAL_WIDTH / 2 - silverScore:getWidth() / 2, VIRTUAL_HEIGHT / 2 - silverScore:getHeight() / 2)
    elseif self.score >= bronzeTrophy and self.score < silverTrophy then
        Bird:draw('bronzeScore', VIRTUAL_WIDTH / 2 - bronzeScore:getWidth() / 2, VIRTUAL_HEIGHT / 2 - bronzeScore:getHeight() / 2)
    end

    printf('Aperte Enter para tentar de novo!', 'mediumFont', 0, 180, VIRTUAL_WIDTH, 'center')
end
