PipePair = Class{}

local GAP_HEIGHT = 100 -- tamanho do gap entre canos

function PipePair:init(y)

    self.x = VIRTUAL_WIDTH + 32 -- lado direito, fora da tela 

    self.y = y -- ** y value is for the topmost pipe; gap is a vertical shift of the second lower pipe

    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }

    self.remove = false -- whether this pipe pair is ready to be removed from the scene

    self.score = false -- vai ser true se o passaro passar pelo par de canos
end

function PipePair:update(dt)

    if self.x > -PIPE_WIDTH then -- se o par de canos ainda estiver dentro da tela, leva eles para esquerda
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['lower'].x = self.x 
        self.pipes['upper'].x = self.x 
    else -- se ja tiver passado para o lado esquerdo da tela, apaga
        self.remove = true
    end
end

function PipePair:render() -- mostrar os pares de canos
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end

