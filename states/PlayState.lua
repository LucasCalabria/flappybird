
--The PlayState class is the bulk of the game, where the player actually controls the bird and 
--avoids pipes. When the player collides with a pipe, we should go to the GameOver state, where
--we then go back to the main menu.

PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70 
PIPE_HEIGHT = 288
-- essas alturas e larguras sao as da imagem
BIRD_WIDTH = 38
BIRD_HEIGHT = 24 


function PlayState:init()
    self.bird = Bird{}
    self.pipePairs = {}
    self.timer = 0 -- contagem do periodo de tempo em que os canos aparecem

    self.score = 0 -- 

    self.lastY = -PIPE_HEIGHT + math.random(80) + 20 --aleatorizar as posiçoes de gap dos pares de acordo com o anterior
end

function PlayState:update(dt) 

    self.timer = self.timer + dt

    if self.timer > 2 then -- ele decidiu que a cada 2 segundo faz aparecer outro cano

        -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
        -- no higher than 10 pixels below the top edge of the screen,
        -- and no lower than a gap length (100 pixels) from the bottom
        local y = math.max(-PIPE_HEIGHT + 10, 
        math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 100 - PIPE_HEIGHT)) -- **
        self.lastY = y

        table.insert(self.pipePairs, PipePair(y)) -- adiciona o novo par de cano -- o y inverte um cano em cima de outro
        self.timer = 0 -- depois que chega no 2 volta pra 0 e só faz cano de novo depois que chegar no 2 
    end

    for k, pair in pairs(self.pipePairs) do -- verifica se o passaro passou pelo cano e atribui pontuaçao
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
                sounds['score']:play()
            end
        end
     
        pair:update(dt) -- para cada par de canos atualiza a posição do par 
    end

    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k) -- apaga os pares da lista quando necessario para nao ter infinitos
        end
    end

    self.bird:update(dt)

    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                sounds['explosion']:play()
                sounds['hurt']:play()
                gStateMachine:change('score', { -- quando colide o jogo para e vai para a area de pontuaçao 
                    score = self.score
                }) 
            end
        end
    end

    -- reset if we get to the ground
    if self.bird.y > VIRTUAL_HEIGHT - 15 then -- se a altura do passaro for maior que a da tela menos da imagem do chao entao para o jogo
        sounds['explosion']:play()
        sounds['hurt']:play()
        gStateMachine:change('score', { -- para o jogo e vai mostra a pontução que  jogador fez
            score = self.score
        })
    end
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do -- -- faz aparecer todos os pares de canos da lista em ordem
        pair:render()
    end
    
    setFont(flappyFont, 'flappyFont')
    print('Score: ' .. tostring(self.score), 'flappyFont', 8, 8)
    self.bird:render()
end
