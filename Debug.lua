Debug = {}

local FILE_NAME = "C:/Users/lucas/PycharmProjects/tcc/data"

TAKING_SAMPLE = false

tempoEspera = 2 -- Em segundos
tempoAcumulado = 0

numeroPrints = 1
numeroPrintsMaximo = 1

variablePaths = {} -- Tabela para armazenar variáveis
variableObject = {}

fonts_names = {}
fonts_paths = {}
fonts_sizes = {}

background_paths = {}
background_xs = {}
background_ys = {}

print_texts = {}
print_fonts = {}
print_xs = {}
print_ys = {}
print_aligns = {}

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

function Debug:write_global()
    local path_file = FILE_NAME .. "/global_variables.py"
    local file = io.open(path_file, "w")
    local content = "WINDOW_WIDTH = " .. tostring(WINDOW_WIDTH) .. "\nWINDOW_HEIGHT = " .. tostring(WINDOW_HEIGHT) .. "\nVIRTUAL_WIDTH = " .. tostring(VIRTUAL_WIDTH) .. "\nVIRTUAL_HEIGHT = " .. tostring(VIRTUAL_HEIGHT) .. "\n"
    if file then
        file:write(content)
        file:close()
    end
end

function Debug:write_fonts()
    local path_file = FILE_NAME .. "/global_variables.py"
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
        local path_file = FILE_NAME .. "/images.py"
        local images = "background_images = ["

        for i=1,table.getn(background_paths) do
            images = images .. "\n\t{\n\t\t'path': '" .. background_paths[i] .. "',\n\t\t"
            images = images .. "'x': '" .. background_xs[i] .. "',\n\t\t"
            images = images .. "'y': " .. background_ys[i] .. "\n\t},"
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

function Debug:write_prints()
    if TAKING_SAMPLE then
        local path_file = FILE_NAME .. "/prints.py"
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
        local filename = "imagem_original.png"
        love.graphics.captureScreenshot( filename )

        local src_path = love.filesystem.getSaveDirectory() .. '/' .. filename
        local dst_path = FILE_NAME .. '/' .. filename
        os.rename(src_path, dst_path)
    end
end