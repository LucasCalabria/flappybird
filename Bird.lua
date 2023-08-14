Bird = Class{}

local GRAVITY = 20 -- numero aleatorio ,,(se fosse negativa ele ia pra cima) (positivo desce)

function Bird:init()
    self.image = newImage('self.image', 'imagens/bird.png')
    self.width = self.image:getWidth()  -- mostra a largura da imagem do passaro
    self.height = self.image:getHeight()-- mostra a altura da imagem do passaro

    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2) -- coordenada x no meio da tela
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2) -- coordenada y no meio da tela

    self.dy = 0
end

function Bird:collides(pipe) -- testa se o passaro colide como cano de acrodo com as coordendas de cada
    -- o 2 e o -4 é para dar uma margem de erro ao jogador e não ficar muito dificil, deixanod colidir um pouquinho

    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end
            
    return false
        
end
    


function Bird:update(dt)

    self.dy = self.dy + GRAVITY * dt -- adiciona gravidade a velocidade

    if love.keyboard.wasPressed('space') then
        self.dy = -5 -- valor negativo para o passaro pular contra a gravidade (negativo sobe)
        sounds['jump']:play()
    end

    self.y = self.y + self.dy  -- muda a posição y 
end

function Bird:render()
    draw('self.image', self.x, self.y) 
end