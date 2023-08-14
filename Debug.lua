Debug = {}

local FILE_NAME = "C:/Users/lucas/PycharmProjects/tcc/data/"

tempoEspera = 2 -- Tempo entre capturas Em segundos
numeroPrintsMaximo = 10 -- Numero de capturas realizadas

tempoAcumulado = 0
numeroPrint = 0

TAKING_SAMPLE = false

--------------- Variaveis Para Armazenamento ---------------


variablePaths = {}
variableObject = {}


------------------ Variaveis Para Escrita ------------------


fonts_names = {}
fonts_paths = {}
fonts_sizes = {}

background_paths = {}
background_xs = {}
background_ys = {}

images_paths = {}
images_xs = {}
images_ys = {}
images_rotations = {}
images_scale_xs = {}
images_scale_ys = {}

print_texts = {}
print_fonts = {}
print_xs = {}
print_ys = {}
print_aligns = {}


--------------- Funcoes Para Guardar Variaveis ---------------


-- Função para atribuir um valor a uma variável e armazená-la na tabela
function Debug:setVariablePaths(name, value)
    variablePaths[name] = value
end

-- Função para obter o valor de uma variável pelo nome
function Debug:getVariablePaths(name)
    return variablePaths[name]
end

function Debug:setVariableObj(name, value)
    variableObject[name] = value
end

-- Função para obter o valor de uma variável pelo nome
function Debug:getVariableObj(name)
    return variableObject[name]
end


--------------- Funcoes Para Escrever Variaveis ---------------


function Debug:write_global()
    local path_file = FILE_NAME .. "global_variables.py"
    local file = io.open(path_file, "w")
    local content = "WINDOW_WIDTH = " .. tostring(WINDOW_WIDTH) .. "\nWINDOW_HEIGHT = " .. tostring(WINDOW_HEIGHT) .. "\nVIRTUAL_WIDTH = " .. tostring(VIRTUAL_WIDTH) .. "\nVIRTUAL_HEIGHT = " .. tostring(VIRTUAL_HEIGHT) .. "\nSAMPLES_NUM = " .. tostring(numeroPrintsMaximo) .."\n"
    if file then
        file:write(content)
        file:close()
    end
end

function Debug:write_fonts()
    local path_file = FILE_NAME .. "global_variables.py"
    local fonts = "fonts = ["
    for i=1,table.getn(fonts_names) do
        fonts = fonts .. "\n\t{\n\t\t'name': '" .. fonts_names[i] .. "',\n\t\t"
        fonts = fonts .. "'path': '" .. fonts_paths[i] .. "',\n\t\t"
        fonts = fonts .. "'size': " .. fonts_sizes[i] .. "\n\t},"
    end
    fonts = fonts .. "\n]\n"
    
    local file = io.open(path_file, "a")
    if file then
        file:write(fonts)
        file:close()
    end

    fonts_names = {}
    fonts_paths = {}
    fonts_sizes = {}
end

function Debug:write_background()
    if TAKING_SAMPLE then
        local path_file = FILE_NAME  .. tostring(numeroPrint) ..  "/images.py"
        local images = "background_images = ["

        for i=1,table.getn(background_paths) do
            images = images .. "\n\t{\n\t\t'path': '" .. background_paths[i] .. "',\n\t\t"
            images = images .. "'x': '" .. background_xs[i] .. "',\n\t\t"
            images = images .. "'y': '" .. background_ys[i] .. "'\n\t},"
        end
        images = images .. "\n]\n"
        
        local file = io.open(path_file, "w")
        if file then
            file:write(images)
            file:close()
        end

        background_paths = {}
        background_xs = {}
        background_ys = {}
    end
end

function Debug:write_images()
    if TAKING_SAMPLE then
        local path_file = FILE_NAME  .. tostring(numeroPrint) ..  "/images.py"
        local images = "images = ["

        for i=1,table.getn(images_paths) do
            images = images .. "\n\t{\n\t\t'path': '" .. images_paths[i] .. "',\n\t\t"
            images = images .. "'x': '" .. images_xs[i] .. "',\n\t\t"
            images = images .. "'y': '" .. images_ys[i] .. "',\n\t\t"
            images = images .. "'rotation': '" .. images_rotations[i] .. "',\n\t\t"
            images = images .. "'scale_x': '" .. images_scale_xs[i] .. "',\n\t\t"
            images = images .. "'scale_y': '" .. images_scale_ys[i] .. "'\n\t},"
        end
        images = images .. "\n]\n"
        
        local file = io.open(path_file, "a")
        if file then
            file:write(images)
            file:close()
        end

        images_paths = {}
        images_xs = {}
        images_ys = {}
        images_rotations = {}
        images_scale_xs = {}
        images_scale_ys = {}
    end
end

function Debug:write_prints()
    if TAKING_SAMPLE then
        local path_file = FILE_NAME .. tostring(numeroPrint) .. "/prints.py"
        local prints = "prints = ["
        for i=1,table.getn(print_texts) do
            prints = prints .. "\n\t{\n\t\t'text': '" .. print_texts[i] .. "',\n\t\t"
            prints = prints .. "'font': '" .. print_fonts[i] .. "',\n\t\t"
            prints = prints .. "'x': '" .. print_xs[i] .. "',\n\t\t"
            prints = prints .. "'y': '" .. print_ys[i] .. "',\n\t\t"
            prints = prints .. "'align': '" .. print_aligns[i] .. "'\n\t},"
        end
        prints = prints .. "\n]\n"
        
        local file = io.open(path_file, "w")
        if file then
            file:write(prints)
            file:close()
        end

        print_texts = {}
        print_fonts = {}
        print_xs = {}
        print_ys = {}
        print_aligns = {}
    end
end

function Debug:take_screenshot()
    if TAKING_SAMPLE then
        local filename = "imagem_original-" .. tostring(numeroPrint) .. ".png"
        love.graphics.captureScreenshot( filename )
    end
end


--------------- Funcoes Substituindo Love2D ---------------


----- Funcoes de Texto -----

function newFont(name, path, size)
    if DEBUGGING then
        table.insert(fonts_names, name)
        table.insert(fonts_paths, path)
        table.insert(fonts_sizes, size)
    end

    return love.graphics.newFont(path, size)
end

function setFont(variable, name)
    love.graphics.setFont(variable)

    Debug:setVariableObj(name, variable)
end

function printf(text, font, x, y, limit, align)
    limit = limit or 'none'
    align = align or 'none'

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
 
----- Funcoes de imagens -----

function newImage(name, path)
    local variable = love.graphics.newImage(path)

    Debug:setVariablePaths(name, path)
    Debug:setVariableObj(name, variable)
    
    return variable
end

function draw(image, x, y, rotation, scale_x, scale_y)
    rotation = rotation or 0
    scale_x = scale_x or 1
    scale_y = scale_y or 1

    if TAKING_SAMPLE then
        table.insert(images_paths, Debug:getVariablePaths(image))
        table.insert(images_xs, x)
        table.insert(images_ys, y)
        table.insert(images_rotations, rotation)
        table.insert(images_scale_xs, scale_x)
        table.insert(images_scale_ys, scale_y)
    end

    return love.graphics.draw(Debug:getVariableObj(image), x, y, rotation, scale_x, scale_y)
end

function draw_background(image, x, y)
    if TAKING_SAMPLE then
        table.insert(background_paths, Debug:getVariablePaths(image))
        table.insert(background_xs, x)
        table.insert(background_ys, y)
    end

    return love.graphics.draw(Debug:getVariableObj(image), x, y)
end