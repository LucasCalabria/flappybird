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

DEBUGGING = true

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

    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Flappy Bird')

    newImage(background,'background','imagens/background.png')
    newImage(ground, 'ground', 'imagens/ground.png')

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

    if DEBUGGING then
        Debug:write_global()
        Debug:write_fonts()
    end
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


    if DEBUGGING then
        tempoAcumulado = tempoAcumulado + dt

        if TAKING_SAMPLE then
            Debug:take_screenshot()
            Debug:write_background()
            Debug:write_images()
            Debug:write_prints()

            TAKING_SAMPLE = false
        end

        if (tempoAcumulado >= tempoEspera and numeroPrint < numeroPrintsMaximo) then
            TAKING_SAMPLE = true
            numeroPrint = numeroPrint + 1

            --print_fonts = {'flappyFont', 'mediumFont'}

            tempoAcumulado = tempoAcumulado - tempoEspera
        end
    end

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

function newFont(name, path, size)
    if DEBUGGING then
        table.insert(fonts_names, name)
        table.insert(fonts_paths, path)
        table.insert(fonts_sizes, size)
    end

    return love.graphics.newFont(path, size)
end

function newImage(variable, name, path)
    variable = love.graphics.newImage(path)

    Debug:setVariablePaths(name, path)
    Debug:setVariableObj(name, variable)
end

function draw_background(image, x, y)
    if TAKING_SAMPLE then
        table.insert(background_paths, Debug:getVariablePaths(image))
        table.insert(background_xs, x)
        table.insert(background_ys, y)
    end

    return love.graphics.draw(Debug:getVariableObj(image), x, y)
end