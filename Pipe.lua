Pipe = Class{}

PIPE_SPEED = 60 -- velocidade que cano vai para a esquerda

-- altura e largura da imagem
PIPE_HEIGHT = 430
PIPE_WIDTH = 70

function Pipe:init(orientation, y) -- orientation descobre se o cano é upper ou lower
    self.x = VIRTUAL_WIDTH -- faz com que o cano va para alem do lado direito da tela (inicialmente escondido)

    self.y = y  

    self.width = PIPE_WIDTH
    self.height = PIPE_HEIGHT

    self.orientation = orientation

    PIPE_IMAGE = newImage('PIPE_IMAGE', 'imagens/pipe.png')
end

function Pipe:update(dt)
   
end

function Pipe:render()
    draw('PIPE_IMAGE', self.x,
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y), -- (coordenada y) (esse PIPE_HEIGHT faz aparecer o cano invertido)
        0, -- rotaçao é zero
        1, -- scale x (quando é 1 não altera)
        self.orientation == 'top' and -1 or 1) -- scale y -- (-1 faz com que a imagem inverta)
end