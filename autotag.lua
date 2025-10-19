
local cjson
local scriptFolder = getWorkingDirectory() .. "\\config\\MolodoyScripts\\"
local config_path = scriptFolder .. "configauto.json"
local settings = {
    r_tag = "",
    d_tag = "",
    r_enabled = false,
    d_enabled = false
}

-- === НАСТРОЙКИ АВТООБНОВЛЕНИЯ ===
local VERSION = "1.0"
local VERSION_URL = "https://raw.githubusercontent.com/Kotikdufhsjf/molodoyscripts/main/versionAutoTag.txt"
local SCRIPT_URL = "https://raw.githubusercontent.com/Kotikdufhsjf/molodoyscripts/main/autotag.lua"
local autoUpdateChecked = false
-- ================================

function checkForUpdates(isAutoCheck)
    lua_thread.create(function()
        if isAutoCheck and autoUpdateChecked then 
            return 
        end
        
        sampAddChatMessage("{00FF00}[Molodoy Helper] {FFFFFF}Проверка обновлений...", -1)
        
        local temp_file = os.tmpname()
        os.execute('start /min cmd /c "curl -s "' .. VERSION_URL .. '" > "' .. temp_file .. '"')
        wait(2000)
        
        local file = io.open(temp_file, "r")
        local online_version = ""
        if file then
            online_version = file:read("*a") or ""
            file:close()
            os.remove(temp_file)
        end

        online_version = online_version:gsub("%s+", "")

        if online_version and online_version ~= "" then
            if isAutoCheck then
                autoUpdateChecked = true
            end
            
            sampAddChatMessage("{00FF00}[Molodoy Helper] {FFFFFF}Локальная: {00FF00}" .. VERSION .. "{FFFFFF}, Удаленная: {00FF00}" .. online_version, -1)
            
            if online_version > VERSION then
                sampAddChatMessage("{00FF00}[Molodoy Helper] {00FF00}Найдено обновление! Используйте /rupdate", -1)
                return true, online_version
            else
                sampAddChatMessage("{00FF00}[Molodoy Helper] {FFFFFF}Версия актуальна", -1)
                return false
            end
        else
            sampAddChatMessage("{00FF00}[Molodoy Helper] {FFFF00}Не удалось проверить обновления", -1)
            if isAutoCheck then
                autoUpdateChecked = true
            end
            return false
        end
    end)
end

function updateScript()
    lua_thread.create(function()
        sampAddChatMessage("{00FF00}[Molodoy Helper] {FFFFFF}Начинаю обновление...", -1)
        
        -- Ждем завершения проверки
        wait(100)
        local updateAvailable, online_version = checkForUpdates(false)
        wait(3000) -- Ждем результат проверки
        
        if not updateAvailable then
            sampAddChatMessage("{00FF00}[Molodoy Helper] {FFFF00}Обновление не требуется", -1)
            return
        end
        
        sampAddChatMessage("{00FF00}[Molodoy Helper] {FFFFFF}Скачиваю версию " .. online_version .. "...", -1)
        
        -- Сохраняем конфиг
        local currentConfig = {}
        if doesFileExist(config_path) then
            local file = io.open(config_path, "r")
            if file then
                currentConfig.data = file:read("*a")
                file:close()
            end
        end
        
        -- Скачиваем новый скрипт
        local scriptPath = thisScript().path
        os.execute('start /min cmd /c "curl -s -o "' .. scriptPath .. '" "' .. SCRIPT_URL .. '"')
        wait(3000)
        
        if doesFileExist(scriptPath) then
            local file = io.open(scriptPath, "r")
            if file then
                local content = file:read("*a")
                file:close()
                
                if content and content ~= "" then
                    sampAddChatMessage("{00FF00}[Molodoy Helper] {00FF00}Скрипт обновлен до версии " .. online_version .. "!", -1)
                    sampAddChatMessage("{00FF00}[Molodoy Helper] {FFFFFF}Перезагрузите скрипт", -1)
                    
                    -- Восстанавливаем конфиг
                    if currentConfig.data then
                        local file = io.open(config_path, "w")
                        if file then
                            file:write(currentConfig.data)
                            file:close()
                        end
                    end
                else
                    sampAddChatMessage("{00FF00}[Molodoy Helper] {FF0000}Ошибка: файл пуст", -1)
                end
            else
                sampAddChatMessage("{00FF00}[Molodoy Helper] {FF0000}Ошибка чтения файла", -1)
            end
        else
            sampAddChatMessage("{00FF00}[Molodoy Helper] {FF0000}Ошибка скачивания", -1)
        end
    end)
end

function autoCheckUpdates()
    lua_thread.create(function()
        wait(15000)
        checkForUpdates(true)
    end)
end

-- Команды обновления
function cmd_rcheck()
    checkForUpdates(false)
end

function cmd_rupdate()
    updateScript()
end

function cmd_rversion()
    sampAddChatMessage("{00FF00}[Molodoy Helper] {FFFFFF}Версия: " .. VERSION, -1)
end

function createFolders()
    local configFolder = getWorkingDirectory() .. "\\config"
    local scriptsFolder = configFolder .. "\\MolodoyScripts"
    if not doesDirectoryExist(configFolder) then
        createDirectory(configFolder)
    end
    if not doesDirectoryExist(scriptsFolder) then
        createDirectory(scriptsFolder)
    end
end


function saveConfig()
    createFolders()
    lua_thread.create(function()
        wait(100)
        local file = io.open(config_path, "w")
        if file then
            file:write('{'..
                '"r_tag":"' .. settings.r_tag .. '",'..
                '"d_tag":"' .. settings.d_tag .. '",'..
                '"r_enabled":' .. tostring(settings.r_enabled) .. ','..
                '"d_enabled":' .. tostring(settings.d_enabled) ..
            '}')
            file:close()
        end
    end)
end


function loadConfig()
    createFolders()
    local file = io.open(config_path, "r")
    if file then
        local content = file:read("*a")
        file:close()
        if content and content ~= "" then
            
            local r_tag = content:match('"r_tag":"([^"]*)"')
            local d_tag = content:match('"d_tag":"([^"]*)"')
            local r_enabled = content:match('"r_enabled":(%a+)')
            local d_enabled = content:match('"d_enabled":(%a+)')
            
            if r_tag then settings.r_tag = r_tag end
            if d_tag then settings.d_tag = d_tag end
            if r_enabled then 
                settings.r_enabled = (r_enabled == "true") 
                print("[DEBUG] r_enabled parsed: " .. tostring(r_enabled) .. " -> " .. tostring(settings.r_enabled))
            end
            if d_enabled then 
                settings.d_enabled = (d_enabled == "true") 
                print("[DEBUG] d_enabled parsed: " .. tostring(d_enabled) .. " -> " .. tostring(settings.d_enabled))
            end
            return
        end
    end
    
    saveConfig()
end

function showMainMenu()
    local r_status = settings.r_enabled and "включен" or "выключен"
    local d_status = settings.d_enabled and "включен" or "выключен"
    
    local dialog_text = "Ваш тег /r: " .. settings.r_tag .. "\n"..
                       "Ваш тег /d: " .. settings.d_tag .. "\n\n"..
                       "Статус авто-тега /r - " .. r_status .. "\n"..
                       "Статус авто-тега /d - " .. d_status
    
    lua_thread.create(function()
        sampShowDialog(8000, "Настройки авто-тега", dialog_text, "Изменить /r\tИзменить /d\tВкл/Выкл", "Закрыть", 2)
        
        while sampIsDialogActive(8000) do wait(100) end
        
        local _, button, list, _ = sampHasDialogRespond(8000)
        if button == 1 then 
            if list == 0 then 
                showEditRMenu()
            elseif list == 1 then 
                showEditDMenu()
            elseif list == 2 then 
                showToggleMenu()
            elseif list == 3 then 
                showToggleMenu()
            end
        end
    end)
end


function showEditRMenu()
    lua_thread.create(function()
        sampShowDialog(8001, "Изменение тега /r", "Введите новое значение тега /r (без []):", "OK", "Назад", 1)
        
        while sampIsDialogActive(8001) do wait(100) end
        
        local _, button, _, inputText = sampHasDialogRespond(8001)
        if button == 1 then 
            if inputText and inputText ~= "" then
                settings.r_tag = inputText
                saveConfig()
                sampAddChatMessage("{00FF00}[Molodoy Helper /r] {FFFFFF}Тег /r установлен: " .. inputText, -1)
            end
            showMainMenu()
        elseif button == 0 then 
            showMainMenu()
        end
    end)
end


function showEditDMenu()
    lua_thread.create(function()
        sampShowDialog(8002, "Изменение тега /d", "Введите новое значение тега /d (без []):", "OK", "Назад", 1)
        
        while sampIsDialogActive(8002) do wait(100) end
        
        local _, button, _, inputText = sampHasDialogRespond(8002)
        if button == 1 then 
            if inputText and inputText ~= "" then
                settings.d_tag = inputText
                saveConfig()
                sampAddChatMessage("{00FF00}[Molodoy Helper /d] {FFFFFF}Тег /d установлен: " .. inputText, -1)
            end
            showMainMenu()
        elseif button == 0 then 
            showMainMenu()
        end
    end)
end


function showToggleMenu()
    local r_status = settings.r_enabled and "выключить" or "включить"
    local d_status = settings.d_enabled and "выключить" or "включить"
    
    local dialog_text = "/r - " .. r_status .. "\n"..
                       "/d - " .. d_status
    
    lua_thread.create(function()
        sampShowDialog(8003, "Управление авто-тегами", dialog_text, "/r\t/d", "Назад", 2)
        
        while sampIsDialogActive(8003) do wait(100) end
        
        local _, button, list, _ = sampHasDialogRespond(8003)
        if button == 1 then 
            if list == 0 then 
                settings.r_enabled = not settings.r_enabled
                saveConfig()
                local status = settings.r_enabled and "включен" or "выключен"
                sampAddChatMessage("{00FF00}[Molodoy Helper /r] {FFFFFF}Авто-тег /r " .. status, -1)
                showMainMenu()
            elseif list == 1 then 
                settings.d_enabled = not settings.d_enabled
                saveConfig()
                local status = settings.d_enabled and "включен" or "выключен"
                sampAddChatMessage("{00FF00}[Molodoy Helper /d] {FFFFFF}Авто-тег /d " .. status, -1)
                showMainMenu()
            end
        elseif button == 0 then 
            showMainMenu()
        end
    end)
end


function cmd_rhelp()
    showMainMenu()
end


function cmd_r(text)
    if settings.r_enabled and settings.r_tag ~= "" then
        if text and text ~= "" then
            sampSendChat("/r [" .. settings.r_tag .. "]: " .. text)
        else
            sampSendChat("/r [" .. settings.r_tag .. "]")
        end
    else
        
        if text and text ~= "" then
            sampSendChat("/r [Сотр. ЦА ФСБ]: " .. text)
        else
            sampSendChat("/r")
        end
    end
end


function cmd_d(text)
    if settings.d_enabled and settings.d_tag ~= "" then
        if text and text ~= "" then
            sampSendChat("/d [" .. settings.d_tag .. "] " .. text)
        else
            sampSendChat("/d")
        end
    else
        
        if text and text ~= "" then
            sampSendChat("/d [ЦА ФСБ] " .. text)
        else
            sampSendChat("/d")
        end
    end
end


sampRegisterChatCommand('r', cmd_r)
sampRegisterChatCommand('d', cmd_d)
sampRegisterChatCommand('rhelp', cmd_rhelp)
sampRegisterChatCommand('rcheck', cmd_rcheck)
sampRegisterChatCommand('rupdate', cmd_rupdate)
sampRegisterChatCommand('rversion', cmd_rversion)


function main()
    while not isSampAvailable() do wait(100) end
    wait(1000)
    
    loadConfig()
    sampAddChatMessage("{00FF00}[Molodoy Helper /r] {FFFFFF}Скрипт загружен! Настройки: /rhelp", -1)

    autoCheckUpdates()
    
    while true do
        wait(0)
    end
end