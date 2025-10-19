

local scriptFolder = getWorkingDirectory() .. "\\config\\MolodoyScripts\\"
local koapData = {}
local koapFile = scriptFolder .. "koap.json"
local ykData = {}
local ykFile = scriptFolder .. "yk.json"
local dialogData = {}
local script_initialized = false

-- === НАСТРОЙКИ АВТООБНОВЛЕНИЯ ===
local VERSION = "1.0" -- Текущая версия скрипта
local VERSION_URL = "https://raw.githubusercontent.com/Kotikdufhsjf/molodoyscripts/main/versionAutoSu.txt"
local SCRIPT_URL = "https://raw.githubusercontent.com/Kotikdufhsjf/molodoyscripts/main/autosu.lua"
local CHECK_UPDATE_ON_START = true -- Проверять обновление при запуске
local autoUpdateChecked = false -- Флаг что авто-проверка уже была
-- ================================


local defaultKoap = {
    ["Для водителей"] = {
        ["1.13"] = {summa = 8000, text = "Выезд за пределы линии остановки перед светофором или пешеходным переходом"},
        ["1.14"] = {summa = 10000, text = "Управление ТС с неработающим освещением"},
        ["1.15"] = {summa = 20000, text = "Отсутствие страховки или техосмотра"},
        ["1.16"] = {summa = 30000, text = "Использование ТС с несанкционированными изменениями в конструкции"}
    },
    ["Для пешеходов"] = {
        ["2.6"] = {summa = 5000, text = "Нарушение правил поведения на пешеходных переходах"},
        ["2.7"] = {summa = 10000, text = "Переход через железнодорожные пути в неположенном месте"},
        ["2.8"] = {summa = 7000, text = "Использование электросамокатов и скейтбордов в запрещенных местах"},
        ["2.9"] = {summa = 15000, text = "Отказ от выполнения законных требований сотрудника полиции"}
    },
    ["Особая часть"] = {
        ["3.10"] = {summa = 50000, text = "Создание угрозы жизни или здоровью людей при управлении ТС"},
        ["3.11"] = {summa = 100000, text = "Создание опасности на железнодорожных путях"},
        ["3.12"] = {summa = 25000, text = "Нарушение правил эксплуатации дронов в населённых пунктах"},
        ["3.13"] = {summa = 40000, text = "Подделка документов для ТС"}
    },
    ["Нарушение общественного порядка"] = {
        ["4.11"] = {summa = 20000, text = "Использование пиротехнических средств в общественных местах без разрешения"},
        ["4.12"] = {summa = 10000, text = "Размещение несанкционированных объявлений или рекламы"},
        ["4.13"] = {summa = 30000, text = "Попытка скрыть личность при совершении правонарушения"},
        ["4.14"] = {summa = 50000, text = "Участие в незаконных уличных гонках"}
    },
    ["Парковка и движение ТС в неположенном месте"] = {
        ["5.11"] = {summa = 15000, text = "Парковка на местах для электромобилей без разрешения"},
        ["5.12"] = {summa = 10000, text = "Движение по парковке с превышением скорости (более 20 км/ч)"},
        ["5.13"] = {summa = 30000, text = "Парковка на месте для сотрудников государственных учреждений"},
        ["5.14"] = {summa = 25000, text = "Использование выделенной полосы для общественного транспорта"}
    }
}


local defaultYk = {
    ["Глава 1. Нападение"] = {
        ["1.1"] = {srok = 5, text = "Нападение на гражданское лицо"},
        ["1.2"] = {srok = 6, text = "Нападение на сотрудника правоохранительных органов"}
    },
    ["Глава 2. Наркотические вещества"] = {
        ["2.1"] = {srok = 4, text = "Хранение и/или перевозка наркотических веществ"},
        ["2.2"] = {srok = 6, text = "Сбыт наркотических веществ"},
        ["2.3"] = {srok = 6, text = "Употребление наркотических веществ"}
    },
    ["Глава 3. Оружие"] = {
        ["3.1"] = {srok = 2, text = "Ношение оружия в открытом виде"},
        ["3.2"] = {srok = 4, text = "Нелегальная продажа/покупка оружия"}
    },
    ["Глава 4. Взяточничество"] = {
        ["4.1"] = {srok = 3, text = "Попытка подкупа должностного лица"},
        ["4.2"] = {srok = 4, text = "Дача взятки должностному лицу"},
        ["4.3"] = {srok = 4, text = "Принятие взятки должностным лицом"}
    },
    ["Глава 5. Неподчинение"] = {
        ["5.1"] = {srok = 4, text = "Неподчинение сотруднику правоохранительных органов"},
        ["5.2"] = {srok = 4, text = "Отказ от выплаты штрафа"},
        ["5.3"] = {srok = 4, text = "Несоблюдение приказов Правительства"}
    },
    ["Глава 6. Проникновение"] = {
        ["6.1"] = {srok = 4, text = "Проникновение на охраняемую территорию"},
        ["6.2"] = {srok = 6, text = "Проникновение на территорию военной базы"}
    },
    ["Глава 7. Угон"] = {
        ["7.1"] = {srok = 5, text = "Попытка угона/угон государственного т/с"},
        ["7.2"] = {srok = 3, text = "Попытка угона/угон гражданского т/с"}
    },
    ["Глава 8. Оскорбления"] = {
        ["8.1"] = {srok = 2, text = "Оскорбление граждан/государственных служащих"},
        ["8.2"] = {srok = 3, text = "Проявление расизма/национализма"}
    },
    ["Глава 9. Соучастие в преступлении"] = {
        ["9.1"] = {srok = 4, text = "Соучастие в преступлении"},
        ["9.2"] = {srok = 3, text = "Укрывательство преступников/улик"}
    },
    ["Глава 10. Бандитизм"] = {
        ["10.1"] = {srok = 6, text = "Ограбление"},
        ["10.2"] = {srok = 4, text = "Вымогательство"},
        ["10.3"] = {srok = 4, text = "Угрозы"},
        ["10.4"] = {srok = 3, text = "Хулиганство/порча имущества"},
        ["10.5"] = {srok = 5, text = "Запугивание"}
    },
    ["Глава 11. Терроризм"] = {
        ["11.1"] = {srok = 6, text = "Планирование/организация теракта"},
        ["11.2"] = {srok = 6, text = "Взятие заложников"},
        ["11.3"] = {srok = 6, text = "Похищение граждан и/или должностных лиц"}
    },
    ["Глава 12. Преступления в сфере служебной деятельности"] = {
        ["12.1"] = {srok = 5, text = "Злоупотребление властью или служебным положением"},
        ["12.2"] = {srok = 4, text = "Служебная халатность"}
    },
    ["Глава 13. Обман"] = {
        ["13.1"] = {srok = 3, text = "Клевета на гражданина"},
        ["13.2"] = {srok = 5, text = "Клевета на должностное лицо"},
        ["13.3"] = {srok = 4, text = "Ввод в заблуждение сотрудников правоохранительных органов"}
    },
    ["Глава 14. Использование предметов государственного назначения"] = {
        ["14.1"] = {srok = 4, text = "Подделка документов"},
        ["14.2"] = {srok = 4, text = "Ношение формы государственных структур"}
    },
    ["Глава 15. Митинги и мятежи"] = {
        ["15.1"] = {srok = 3, text = "Организация/участие в несанкционированных митингах"},
        ["15.2"] = {srok = 6, text = "Организация/участие в вооруженном мятеже"}
    },
    ["Глава 16. Проституция"] = {
        ["16.1"] = {srok = 4, text = "Участие в проституции"},
        ["16.2"] = {srok = 3, text = "Вовлечение в занятие проституцией"},
        ["16.3"] = {srok = 5, text = "Изнасилование"}
    },
    ["Глава 17. Телесные повреждения"] = {
        ["17.1"] = {srok = 4, text = "Умышленное причинение лёгкого вреда здоровью"},
        ["17.2"] = {srok = 5, text = "Умышленное причинение средней тяжести вреда здоровью"},
        ["17.3"] = {srok = 6, text = "Умышленное причинение тяжкого вреда здоровью"}
    },
    ["Глава 18. Государственные преступления"] = {
        ["18.1"] = {srok = 6, text = "Подготовка к государственной измене"},
        ["18.2"] = {srok = 5, text = "Преступления против государственной безопасности"},
        ["18.3"] = {srok = 6, text = "Шпионаж в пользу иностранного государства"},
        ["18.4"] = {srok = 4, text = "Незаконное распространение государственных секретов"},
        ["18.5"] = {srok = 4, text = "Умышленное уничтожение государственного имущества"}
    }
}


function msg(text)
    if script_initialized then
        sampAddChatMessage(text, 0xFFFFFF)
    else
        print(text)
    end
end

function createFolders()
    local configFolder = getWorkingDirectory() .. "\\config\\"
    local scriptsFolder = configFolder .. "MolodoyScripts\\"
    
    -- Создаем папку config если не существует
    if not doesDirectoryExist(configFolder) then
        createDirectory(configFolder)
    end
    
    -- Создаем папку MolodoyScripts если не существует
    if not doesDirectoryExist(scriptsFolder) then
        createDirectory(scriptsFolder)
    end
    
    return true
end


function loadKoapData()
    -- Создаем папки если их нет
    createFolders()
    
    local file = io.open(koapFile, "r")
    if file then
        local content = file:read("*a")
        file:close()
        
        local func = loadstring(content)
        if func then
            koapData = func()
            return true
        else
            msg("КОАП: Ошибка загрузки данных!")
            return false
        end
    else
        createKoapFile()
        return false
    end
end



function createKoapFile()
    -- Создаем папки если их нет
    createFolders()
    
    local file = io.open(koapFile, "w")
    if file then
        file:write("return {\n")
        
        local sections = {
            "Для водителей",
            "Для пешеходов", 
            "Особая часть",
            "Нарушение общественного порядка",
            "Парковка и движение ТС в неположенном месте"
        }
        
        for i, sectionName in ipairs(sections) do
            file:write("  [\"" .. sectionName .. "\"] = {\n")
            local section = defaultKoap[sectionName]
            
            local articles = {}
            for article, data in pairs(section) do
                table.insert(articles, {article = article, data = data})
            end
            table.sort(articles, function(a, b) return a.article < b.article end)
            
            for j, item in ipairs(articles) do
                local endChar = (j == #articles) and "" or ","
                file:write("    [\"" .. item.article .. "\"] = {summa = " .. item.data.summa .. ", text = \"" .. item.data.text .. "\"}" .. endChar .. "\n")
            end
            
            local endChar = (i == #sections) and "" or ","
            file:write("  }" .. endChar .. "\n")
        end
        
        file:write("}")
        file:close()
        msg("{FF0000}[MolodoyHelper] {FFFFFF}КОАП: Файл создан! Перезагрузите скрипт.")
        return true
    else
        msg("КОАП: Ошибка создания файла!")
        return false
    end
end

function loadYkData()
    -- Создаем папки если их нет
    createFolders()
    
    local file = io.open(ykFile, "r")
    if file then
        local content = file:read("*a")
        file:close()
        
        local func = loadstring(content)
        if func then
            ykData = func()
            return true
        else
            msg("УК: Ошибка загрузки данных!")
            return false
        end
    else
        createYkFile()
        return false
    end
end

function createYkFile()
    -- Создаем папки если их нет
    createFolders()
    
    local file = io.open(ykFile, "w")
    if file then
        file:write("return {\n")
        
        local chapters = {
            "Глава 1. Нападение",
            "Глава 2. Наркотические вещества",
            "Глава 3. Оружие",
            "Глава 4. Взяточничество",
            "Глава 5. Неподчинение",
            "Глава 6. Проникновение",
            "Глава 7. Угон",
            "Глава 8. Оскорбления",
            "Глава 9. Соучастие в преступлении",
            "Глава 10. Бандитизм",
            "Глава 11. Терроризм",
            "Глава 12. Преступления в сфере служебной деятельности",
            "Глава 13. Обман",
            "Глава 14. Использование предметов государственного назначения",
            "Глава 15. Митинги и мятежи",
            "Глава 16. Проституция",
            "Глава 17. Телесные повреждения",
            "Глава 18. Государственные преступления"
        }
        
        for i, chapterName in ipairs(chapters) do
            file:write("  [\"" .. chapterName .. "\"] = {\n")
            local chapter = defaultYk[chapterName]
            
            local articles = {}
            for article, data in pairs(chapter) do
                table.insert(articles, {article = article, data = data})
            end
            table.sort(articles, function(a, b) return a.article < b.article end)
            
            for j, item in ipairs(articles) do
                local endChar = (j == #articles) and "" or ","
                file:write("    [\"" .. item.article .. "\"] = {srok = " .. item.data.srok .. ", text = \"" .. item.data.text .. "\"}" .. endChar .. "\n")
            end
            
            local endChar = (i == #chapters) and "" or ","
            file:write("  }" .. endChar .. "\n")
        end
        
        file:write("}")
        file:close()
        msg("{FF0000}[MolodoyHelper] {FFFFFF}УК: Файл создан! Перезагрузите скрипт.")
        return true
    else
        msg("УК: Ошибка создания файла!")
        return false
    end
end


function showMainMenu(targetID)
    if not targetID or targetID == "" then
        msg("{FF0000}[MolodoyHelper] {FFFFFF}Использование: /sticket [ID игрока]")
        return
    end
    
    local targetID_num = tonumber(targetID)
    if not targetID_num then
        msg("{FF0000}[MolodoyHelper] {FFFFFF}Ошибка: ID должен быть числом!")
        return
    end
    
    local target = getPlayerByID(targetID_num)
    if not target then
        msg("Игрок с ID " .. targetID .. " не найден!")
        return
    end
    
    local targetName = sampGetPlayerNickname(target)
    

    local dialogItems = "Для водителей\nДля пешеходов\nОсобая часть\nНарушение общественного порядка\nПарковка и движение ТС"
    
    lua_thread.create(function()
        sampShowDialog(3912, "КОАП - Штраф для " .. targetName, dialogItems, "Выбрать", "Отмена", 2)
        
        while sampIsDialogActive(3912) do wait(100) end
        
        local _, button, list, _ = sampHasDialogRespond(3912)
        if button == 1 then 
            if list == 0 then
                showSectionMenu(1)
            elseif list == 1 then
                showSectionMenu(2)
            elseif list == 2 then
                showSectionMenu(3)
            elseif list == 3 then
                showSectionMenu(4)
            elseif list == 4 then
                showSectionMenu(5)
            end
        end
    end)
    

    dialogData = {
        targetID = targetID, 
        targetName = targetName,
        targetPlayer = target
    }
end


function showSectionMenu(sectionIndex)
    local sectionNames = {
        "Для водителей",
        "Для пешеходов", 
        "Особая часть",
        "Нарушение общественного порядка",
        "Парковка и движение ТС в неположенном месте"
    }
    
    local sectionName = sectionNames[sectionIndex]
    if not sectionName or not koapData[sectionName] then 
        msg("Ошибка: раздел не найден!")
        return 
    end
    
    local dialogItems = ""
    local articles = {}
    
    for article, data in pairs(koapData[sectionName]) do
        table.insert(articles, {article = article, data = data})
    end
    

    table.sort(articles, function(a, b) return a.article < b.article end)
    

    for i, item in ipairs(articles) do
        dialogItems = dialogItems .. item.article .. " - " .. item.data.text .. " (" .. item.data.summa .. " руб)\n"
    end
    
    lua_thread.create(function()
        sampShowDialog(3913, "КОАП - " .. sectionName, dialogItems, "Выбрать", "Назад", 2)
        
        while sampIsDialogActive(3913) do wait(100) end
        
        local _, button, list, _ = sampHasDialogRespond(3913)
        if button == 1 and list >= 0 then 
            local articleData = articles[list + 1]
            if articleData then
                issueTicket(articleData.article, articleData.data.text, articleData.data.summa)
            end
        elseif button == 0 then 
            showMainMenu(dialogData.targetID)
        end
    end)
    
    
    dialogData.sectionName = sectionName
    dialogData.articles = articles
end


function issueTicket(article, text, summa)
    local targetID = dialogData.targetID
    
    
    local reason = "ст. " .. article .. " КОАП РФ"
    
    local command = "/ticket " .. targetID .. " " .. summa .. " " .. reason
    
    
    sampSendChat(command)
    
    msg("{FF0000}[MolodoyHelper] {FFFFFF}Штраф выписан: " .. dialogData.targetName .. " - " .. summa .. " руб. по ст. " .. article)
end


function showYkMainMenu(targetID)
    if not targetID or targetID == "" then
        msg("{FF0000}[MolodoyHelper] {FFFFFF}Использование: /ssu [ID игрока]")
        return
    end
    
    local targetID_num = tonumber(targetID)
    if not targetID_num then
        msg("{FF0000}[MolodoyHelper] {FFFFFF}Ошибка: ID должен быть числом!")
        return
    end
    
    local target = getPlayerByID(targetID_num)
    if not target then
        msg("{FF0000}[MolodoyHelper] {FFFFFF}Игрок с ID " .. targetID .. " не найден!")
        return
    end
    
    local targetName = sampGetPlayerNickname(target)
    
    
    local dialogItems = ""
    local chapters = {}
    
    for chapterName, _ in pairs(ykData) do
        table.insert(chapters, chapterName)
    end
    
    
    table.sort(chapters, function(a, b) 
        local numA = tonumber(a:match("(%d+)")) or 0
        local numB = tonumber(b:match("(%d+)")) or 0
        return numA < numB
    end)
    
    for i, chapter in ipairs(chapters) do
        dialogItems = dialogItems .. chapter .. "\n"
    end
    
    lua_thread.create(function()
        sampShowDialog(5000, "УК - Розыск для " .. targetName, dialogItems, "Выбрать", "Отмена", 2)
        
        while sampIsDialogActive(5000) do wait(100) end
        
        local _, button, list, _ = sampHasDialogRespond(5000)
        if button == 1 and list >= 0 then 
            local chapterName = chapters[list + 1]
            if chapterName then
                showYkSectionMenu(targetID, targetName, chapterName)
            end
        end
    end)
    
    dialogData = {
        targetID = targetID, 
        targetName = targetName,
        targetPlayer = target
    }
end


function showYkSectionMenu(targetID, targetName, chapterName)
    if not ykData[chapterName] then 
        msg("Ошибка: глава не найдена!")
        return 
    end
    
    local dialogItems = ""
    local articles = {}
    
    for article, data in pairs(ykData[chapterName]) do
        table.insert(articles, {article = article, data = data})
    end
    
 
    table.sort(articles, function(a, b) return a.article < b.article end)
    

    for i, item in ipairs(articles) do
        dialogItems = dialogItems .. item.article .. " - " .. item.data.text .. " (" .. item.data.srok .. " лет)\n"
    end
    
    lua_thread.create(function()
        sampShowDialog(5001, "УК - " .. chapterName, dialogItems, "Выбрать", "Назад", 2)
        
        while sampIsDialogActive(5001) do wait(100) end
        
        local _, button, list, _ = sampHasDialogRespond(5001)
        if button == 1 and list >= 0 then 
            local articleData = articles[list + 1]
            if articleData then
                issueWanted(articleData.article, articleData.data.text, articleData.data.srok, targetID, targetName)
            end
        elseif button == 0 then 
            showYkMainMenu(targetID)
        end
    end)
end


function issueWanted(article, text, srok, targetID, targetName)

    local reason = "ст. " .. article .. " УК РФ"
    
    msg("{FF0000}[MolodoyHelper] {FFFFFF}Выдача розыска: " .. targetName .. " - " .. srok .. " лет по ст. " .. article)
    

    lua_thread.create(function()
        for i = 1, srok do
            local command = "/su " .. targetID .. " " .. reason
            sampSendChat(command)
            wait(1000) 
        end
        msg("{FF0000}[MolodoyHelper] {FFFFFF}Розыск выписан: " .. targetName .. " - " .. srok .. " лет по ст. " .. article)
    end)
end


function getPlayerByID(id)
    for i = 0, 1000 do
        if sampIsPlayerConnected(i) then
            
            if i == id then
                return i
            end
        end
    end
    return nil
end


function checkForUpdates(isAutoCheck)
    lua_thread.create(function()
        -- Если это авто-проверка и уже проверяли, не флудим
        if isAutoCheck and autoUpdateChecked then 
            return 
        end
        
        sampAddChatMessage("{FF0000}[MolodoyHelper] {FFFFFF}Проверка обновлений...", -1)
        
        local handle = io.popen('curl -s "' .. VERSION_URL .. '"')
        local online_version = handle:read("*a")
        handle:close()

        online_version = online_version:gsub("%s+", "")  -- Убираем пробелы и переносы строк

        if online_version and online_version ~= "" then
            -- Помечаем что авто-проверка выполнена (только для авто-проверки)
            if isAutoCheck then
                autoUpdateChecked = true
            end
            
            sampAddChatMessage("{FF0000}[MolodoyHelper] {FFFFFF}Локальная: {00FF00}" .. VERSION .. "{FFFFFF}, Удаленная: {00FF00}" .. online_version, -1)
            
            if online_version > VERSION then
                sampAddChatMessage("{FF0000}[MolodoyHelper] {00FF00}Найдено обновление! Используйте /supdate", -1)
                return true, online_version
            else
                sampAddChatMessage("{FF0000}[MolodoyHelper] {FFFFFF}Версия актуальна", -1)
                return false
            end
        else
            sampAddChatMessage("{FF0000}[MolodoyHelper] {FFFF00}Не удалось проверить обновления", -1)
            if isAutoCheck then
                autoUpdateChecked = true -- Все равно помечаем как проверенное чтобы не повторять
            end
            return false
        end
    end)
end

function updateScript()
    lua_thread.create(function()
        sampAddChatMessage("{FF0000}[MolodoyHelper] {FFFFFF}Начинаю обновление...", -1)
        
        -- Сначала проверяем версию (ручная проверка)
        local updateAvailable, online_version = checkForUpdates(false)
        
        if not updateAvailable then
            sampAddChatMessage("{FF0000}[MolodoyHelper] {FFFF00}Обновление не требуется или недоступно", -1)
            return
        end
        
        sampAddChatMessage("{FF0000}[MolodoyHelper] {FFFFFF}Скачиваю версию " .. online_version .. "...", -1)
        
        -- Сохраняем конфиги
        local currentConfig = {}
        if doesFileExist(koapFile) then
            local file = io.open(koapFile, "r")
            if file then
                currentConfig.koap = file:read("*a")
                file:close()
            end
        end
        
        if doesFileExist(ykFile) then
            local file = io.open(ykFile, "r")
            if file then
                currentConfig.yk = file:read("*a")
                file:close()
            end
        end
        
        -- Скачиваем новый скрипт
        local scriptPath = thisScript().path
        local handle = io.popen('curl -s -o "' .. scriptPath .. '" "' .. SCRIPT_URL .. '"')
        handle:close()
        
        -- Проверяем успешность скачивания
        if doesFileExist(scriptPath) then
            local file = io.open(scriptPath, "r")
            if file then
                local content = file:read("*a")
                file:close()
                
                if content and content ~= "" then
                    sampAddChatMessage("{FF0000}[MolodoyHelper] {00FF00}Скрипт обновлен до версии " .. online_version .. "!", -1)
                    sampAddChatMessage("{FF0000}[MolodoyHelper] {FFFFFF}Перезагрузите скрипт для применения изменений", -1)
                    
                    -- Восстанавливаем конфиги
                    if currentConfig.koap then
                        local file = io.open(koapFile, "w")
                        if file then
                            file:write(currentConfig.koap)
                            file:close()
                        end
                    end
                    
                    if currentConfig.yk then
                        local file = io.open(ykFile, "w")
                        if file then
                            file:write(currentConfig.yk)
                            file:close()
                        end
                    end
                else
                    sampAddChatMessage("{FF0000}[MolodoyHelper] {FF0000}Ошибка: скачанный файл пуст", -1)
                end
            else
                sampAddChatMessage("{FF0000}[MolodoyHelper] {FF0000}Ошибка чтения скачанного файла", -1)
            end
        else
            sampAddChatMessage("{FF0000}[MolodoyHelper] {FF0000}Ошибка скачивания скрипта", -1)
        end
    end)
end


function autoCheckUpdates()
    lua_thread.create(function()
        wait(3000) -- Ждем немного после загрузки
        checkForUpdates(true) -- true = это авто-проверка
    end)
end

-- Ручная проверка через команду
function cmd_scheck()
    checkForUpdates(false) -- false = это ручная проверка
end


function cmd_supdate()
    updateScript()
end

function cmd_sversion()
    msg("{FF0000}[MolodoyHelper] {FFFFFF}Текущая версия: " .. VERSION)
    msg("{FF0000}[MolodoyHelper] {FFFFFF}Для проверки обновлений используйте /supdate")
end


function cmd_sticket(targetID)
    if not koapData or not next(koapData) then
        msg("КОАП: Данные не загружены! Перезагрузите скрипт.")
        return
    end
    
    if not targetID or targetID == "" then
        msg("{FF0000}[MolodoyHelper] {FFFFFF}Использование: /sticket [ID игрока]")
        return
    end
    
    showMainMenu(targetID)
end


function cmd_ssu(targetID)
    if not ykData or not next(ykData) then
        msg("УК: Данные не загружены! Проверьте файл yk.json")
        return
    end
    
    if not targetID or targetID == "" then
        msg("{FF0000}[MolodoyHelper] {FFFFFF}Использование: /ssu [ID игрока]")
        return
    end
    
    showYkMainMenu(targetID)
end

function cmd_shelp()
    msg("{FF0000}[MolodoyHelper] {FFFFFF}=== Умные системы штрафов и розыска ===")
    msg("{FF0000}[MolodoyHelper] {FFFFFF}/sticket [id] - Выписать умный штраф по КОАП")
    msg("{FF0000}[MolodoyHelper] {FFFFFF}/ssu [id] - Выдать умный розыск по Уголовному кодексу")
    msg("{FF0000}[MolodoyHelper] {FFFFFF}/supdate - Обновить скрипт")
    msg("{FF0000}[MolodoyHelper] {FFFFFF}/sversion - Показать версию")
    msg("{FF0000}[MolodoyHelper] {FFFFFF}/scheck - Проверить обновления")
    msg("{FF0000}[MolodoyHelper] {FFFFFF}=== =============================== ===")
end

sampRegisterChatCommand("supdate", cmd_supdate)
sampRegisterChatCommand("sversion", cmd_sversion)
sampRegisterChatCommand("scheck", cmd_scheck)
sampRegisterChatCommand("shelp", cmd_shelp)
sampRegisterChatCommand("sticket", cmd_sticket)
sampRegisterChatCommand("ssu", cmd_ssu)


function main()
    while not isSampAvailable() do
        wait(100)
    end
    
    wait(1000)
    
    script_initialized = true
    
    -- Проверяем обновления при запуске
    if CHECK_UPDATE_ON_START then
        autoCheckUpdates()
    end
    
    
    if loadKoapData() then
        msg("{FF0000}[MolodoyHelper] {FFFFFF}КОАП: Система загружена. Используйте /sticket [id]")
    else
        msg("{FF0000}[MolodoyHelper] {FF8C00}КОАП: Используйте /sticket [id] после перезагрузки скрипта")
    end
    
    if loadYkData() then
        msg("{FF0000}[MolodoyHelper] {FFFFFF}УК: Система загружена. Используйте /ssu [id]")
        msg("{FF0000}[MolodoyHelper] {FFFFFF}Версия: " .. VERSION .. " - Используйте /shelp для списка команд")
    else
        msg("{FF0000}[MolodoyHelper] {FF8C00}УК: Используйте /ssu [id] после перезагрузки скрипта")
    end
    
    while true do
        wait(1000)
    end
end