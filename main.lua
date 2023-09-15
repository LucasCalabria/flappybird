push = require 'push'

Class = require 'class'

require 'Bird'
require 'Pipe'
require 'PipePair'

require 'Debug'
require 'StateMachine'
require 'states/BaseState'
require 'states/CountdownState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local backgroundScroll = 0
local groundScroll = 0

-- velocidade que a imagem vai andando - o chão vai mais rapido pra fazer a ilusão da velocidade
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413 -- momento em que a imagem repete p/ ser infinito (vc escolhe o ponto)
local GROUND_LOOPING_POINT = 514 -- momento em que a imagem repete p/ ser infinito (vc escolhe o ponto)

-- scrolling variable to pause the game when we collide with a pipe
local scrolling = true


function love.load()
    Debug:setDebug(true)
    Debug:setNumSamples(30)
    Debug:setTimeBetweenSamples(1)

    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Flappy Bird')

    background = newImage('background','imagens/background.png')
    ground = newImage('ground', 'imagens/ground.png')

    smallFont = newFont('smallFont','fontes/font.ttf', 8)
    mediumFont = newFont('mediumFont','fontes/flappy.ttf', 14)
    flappyFont = newFont('flappyFont', 'fontes/flappy.ttf', 28) -- fonte do titulo
    hugeFont = newFont('hugeFont', 'fontes/flappy.ttf', 56)

    love.graphics.setFont(flappyFont)

    sounds = {
        ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('sounds/explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),

        ['music'] = love.audio.newSource('sounds/marios_way.mp3', 'static')
    }

    sounds['music']:setLooping(true)
    sounds['music']:play()

    math.randomseed(os.time()) --- aleatoriza numero numa escala de 00:00:00

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    gStateMachine = StateMachine { -- o g representa que é global 
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }
    gStateMachine:change('title') -- o change faz com que o que esteja dentro do parenteses sejam a funçao usada


    love.keyboard.keysPressed = {} -- cria uma lista de input

    Debug:debugGlobal()
end

function love.resize(w, h)
    push:resize(w,h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
    
end

function love.keyboard.wasPressed(key) -- ver se a tecla foi clicada
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)


    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) -- a imagem do fundo começa a se mover
        % BACKGROUND_LOOPING_POINT -- recomeça a imagem depois de passar do looping point

    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) -- a imagem do chão começa a se mover
        % GROUND_LOOPING_POINT -- recomeça a imagem depois de passar pelo looping point

    Debug:writeVariables(dt)

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    draw_background('background', -backgroundScroll, 0) -- posiciona a imagem de fundo com o x(-background) mudando e y = 0

    gStateMachine:render()

    draw_background('ground', -groundScroll, VIRTUAL_HEIGHT - 16) -- posiciona o chão com o x(-ground) mudando e y na altura do jogo - altura do chão(16)

    push:finish()
end

