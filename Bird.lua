Bird = Class{}

local GRAVITY = 20 -- numero aleatorio ,,(se fosse negativa ele ia pra cima) (positivo desce)

function Bird:init()
    self.image = Bird:newImage('self.image', 'imagens/bird.png')
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
    Bird:draw('self.image', self.x, self.y) 
end

--------------- Classes de debug ---------------

function Bird:newImage(name, path)
    local variable = love.graphics.newImage(path)

    Debug:setVariablePaths(name, path)
    Debug:setVariableObj(name, variable)
    
    return variable
end

function Bird:draw(image, x, y)
    if TAKING_SAMPLE then
        table.insert(images_paths, Debug:getVariablePaths(image))
        table.insert(images_xs, x)
        table.insert(images_ys, y)
        table.insert(images_rotations, 0)
        table.insert(images_scale_xs, 1)
        table.insert(images_scale_ys, 1)
    end

    return love.graphics.draw(Debug:getVariableObj(image), x, y, rotation, scale_x, scale_y)
end