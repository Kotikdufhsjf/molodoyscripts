

local scriptFolder = getWorkingDirectory() .. "\\config\\MolodoyScripts\\"
local koapData = {}
local koapFile = scriptFolder .. "koap.json"
local ykData = {}
local ykFile = scriptFolder .. "yk.json"
local dialogData = {}
local script_initialized = false

-- === ��������� �������������� ===
local VERSION = "1.0" -- ������� ������ �������
local VERSION_URL = "https://raw.githubusercontent.com/Kotikdufhsjf/molodoyscripts/main/versionAutoSu.txt"
local SCRIPT_URL = "https://raw.githubusercontent.com/Kotikdufhsjf/molodoyscripts/main/autosu.lua"
local CHECK_UPDATE_ON_START = true -- ��������� ���������� ��� �������
local autoUpdateChecked = false -- ���� ��� ����-�������� ��� ����
-- ================================


local defaultKoap = {
    ["��� ���������"] = {
        ["1.13"] = {summa = 8000, text = "����� �� ������� ����� ��������� ����� ���������� ��� ���������� ���������"},
        ["1.14"] = {summa = 10000, text = "���������� �� � ������������ ����������"},
        ["1.15"] = {summa = 20000, text = "���������� ��������� ��� ����������"},
        ["1.16"] = {summa = 30000, text = "������������� �� � �������������������� ����������� � �����������"}
    },
    ["��� ���������"] = {
        ["2.6"] = {summa = 5000, text = "��������� ������ ��������� �� ���������� ���������"},
        ["2.7"] = {summa = 10000, text = "������� ����� ��������������� ���� � ������������ �����"},
        ["2.8"] = {summa = 7000, text = "������������� ���������������� � ����������� � ����������� ������"},
        ["2.9"] = {summa = 15000, text = "����� �� ���������� �������� ���������� ���������� �������"}
    },
    ["������ �����"] = {
        ["3.10"] = {summa = 50000, text = "�������� ������ ����� ��� �������� ����� ��� ���������� ��"},
        ["3.11"] = {summa = 100000, text = "�������� ��������� �� ��������������� �����"},
        ["3.12"] = {summa = 25000, text = "��������� ������ ������������ ������ � ��������� �������"},
        ["3.13"] = {summa = 40000, text = "�������� ���������� ��� ��"}
    },
    ["��������� ������������� �������"] = {
        ["4.11"] = {summa = 20000, text = "������������� ��������������� ������� � ������������ ������ ��� ����������"},
        ["4.12"] = {summa = 10000, text = "���������� ������������������� ���������� ��� �������"},
        ["4.13"] = {summa = 30000, text = "������� ������ �������� ��� ���������� ��������������"},
        ["4.14"] = {summa = 50000, text = "������� � ���������� ������� ������"}
    },
    ["�������� � �������� �� � ������������ �����"] = {
        ["5.11"] = {summa = 15000, text = "�������� �� ������ ��� �������������� ��� ����������"},
        ["5.12"] = {summa = 10000, text = "�������� �� �������� � ����������� �������� (����� 20 ��/�)"},
        ["5.13"] = {summa = 30000, text = "�������� �� ����� ��� ����������� ��������������� ����������"},
        ["5.14"] = {summa = 25000, text = "������������� ���������� ������ ��� ������������� ����������"}
    }
}


local defaultYk = {
    ["����� 1. ���������"] = {
        ["1.1"] = {srok = 5, text = "��������� �� ����������� ����"},
        ["1.2"] = {srok = 6, text = "��������� �� ���������� ������������������ �������"}
    },
    ["����� 2. ������������� ��������"] = {
        ["2.1"] = {srok = 4, text = "�������� �/��� ��������� ������������� �������"},
        ["2.2"] = {srok = 6, text = "���� ������������� �������"},
        ["2.3"] = {srok = 6, text = "������������ ������������� �������"}
    },
    ["����� 3. ������"] = {
        ["3.1"] = {srok = 2, text = "������� ������ � �������� ����"},
        ["3.2"] = {srok = 4, text = "����������� �������/������� ������"}
    },
    ["����� 4. ��������������"] = {
        ["4.1"] = {srok = 3, text = "������� ������� ������������ ����"},
        ["4.2"] = {srok = 4, text = "���� ������ ������������ ����"},
        ["4.3"] = {srok = 4, text = "�������� ������ ����������� �����"}
    },
    ["����� 5. ������������"] = {
        ["5.1"] = {srok = 4, text = "������������ ���������� ������������������ �������"},
        ["5.2"] = {srok = 4, text = "����� �� ������� ������"},
        ["5.3"] = {srok = 4, text = "������������ �������� �������������"}
    },
    ["����� 6. �������������"] = {
        ["6.1"] = {srok = 4, text = "������������� �� ���������� ����������"},
        ["6.2"] = {srok = 6, text = "������������� �� ���������� ������� ����"}
    },
    ["����� 7. ����"] = {
        ["7.1"] = {srok = 5, text = "������� �����/���� ���������������� �/�"},
        ["7.2"] = {srok = 3, text = "������� �����/���� ������������ �/�"}
    },
    ["����� 8. �����������"] = {
        ["8.1"] = {srok = 2, text = "����������� �������/��������������� ��������"},
        ["8.2"] = {srok = 3, text = "���������� �������/������������"}
    },
    ["����� 9. ��������� � ������������"] = {
        ["9.1"] = {srok = 4, text = "��������� � ������������"},
        ["9.2"] = {srok = 3, text = "�������������� ������������/����"}
    },
    ["����� 10. ���������"] = {
        ["10.1"] = {srok = 6, text = "����������"},
        ["10.2"] = {srok = 4, text = "��������������"},
        ["10.3"] = {srok = 4, text = "������"},
        ["10.4"] = {srok = 3, text = "�����������/����� ���������"},
        ["10.5"] = {srok = 5, text = "�����������"}
    },
    ["����� 11. ���������"] = {
        ["11.1"] = {srok = 6, text = "������������/����������� �������"},
        ["11.2"] = {srok = 6, text = "������ ����������"},
        ["11.3"] = {srok = 6, text = "��������� ������� �/��� ����������� ���"}
    },
    ["����� 12. ������������ � ����� ��������� ������������"] = {
        ["12.1"] = {srok = 5, text = "��������������� ������� ��� ��������� ����������"},
        ["12.2"] = {srok = 4, text = "��������� ����������"}
    },
    ["����� 13. �����"] = {
        ["13.1"] = {srok = 3, text = "������� �� ����������"},
        ["13.2"] = {srok = 5, text = "������� �� ����������� ����"},
        ["13.3"] = {srok = 4, text = "���� � ����������� ����������� ������������������ �������"}
    },
    ["����� 14. ������������� ��������� ���������������� ����������"] = {
        ["14.1"] = {srok = 4, text = "�������� ����������"},
        ["14.2"] = {srok = 4, text = "������� ����� ��������������� ��������"}
    },
    ["����� 15. ������� � ������"] = {
        ["15.1"] = {srok = 3, text = "�����������/������� � ������������������� ��������"},
        ["15.2"] = {srok = 6, text = "�����������/������� � ����������� ������"}
    },
    ["����� 16. �����������"] = {
        ["16.1"] = {srok = 4, text = "������� � �����������"},
        ["16.2"] = {srok = 3, text = "���������� � ������� ������������"},
        ["16.3"] = {srok = 5, text = "�������������"}
    },
    ["����� 17. �������� �����������"] = {
        ["17.1"] = {srok = 4, text = "���������� ���������� ������ ����� ��������"},
        ["17.2"] = {srok = 5, text = "���������� ���������� ������� ������� ����� ��������"},
        ["17.3"] = {srok = 6, text = "���������� ���������� ������� ����� ��������"}
    },
    ["����� 18. ��������������� ������������"] = {
        ["18.1"] = {srok = 6, text = "���������� � ��������������� ������"},
        ["18.2"] = {srok = 5, text = "������������ ������ ��������������� ������������"},
        ["18.3"] = {srok = 6, text = "������� � ������ ������������ �����������"},
        ["18.4"] = {srok = 4, text = "���������� ��������������� ��������������� ��������"},
        ["18.5"] = {srok = 4, text = "���������� ����������� ���������������� ���������"}
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
    
    -- ������� ����� config ���� �� ����������
    if not doesDirectoryExist(configFolder) then
        createDirectory(configFolder)
    end
    
    -- ������� ����� MolodoyScripts ���� �� ����������
    if not doesDirectoryExist(scriptsFolder) then
        createDirectory(scriptsFolder)
    end
    
    return true
end


function loadKoapData()
    -- ������� ����� ���� �� ���
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
            msg("����: ������ �������� ������!")
            return false
        end
    else
        createKoapFile()
        return false
    end
end



function createKoapFile()
    -- ������� ����� ���� �� ���
    createFolders()
    
    local file = io.open(koapFile, "w")
    if file then
        file:write("return {\n")
        
        local sections = {
            "��� ���������",
            "��� ���������", 
            "������ �����",
            "��������� ������������� �������",
            "�������� � �������� �� � ������������ �����"
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
        msg("{FF0000}[MolodoyHelper] {FFFFFF}����: ���� ������! ������������� ������.")
        return true
    else
        msg("����: ������ �������� �����!")
        return false
    end
end

function loadYkData()
    -- ������� ����� ���� �� ���
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
            msg("��: ������ �������� ������!")
            return false
        end
    else
        createYkFile()
        return false
    end
end

function createYkFile()
    -- ������� ����� ���� �� ���
    createFolders()
    
    local file = io.open(ykFile, "w")
    if file then
        file:write("return {\n")
        
        local chapters = {
            "����� 1. ���������",
            "����� 2. ������������� ��������",
            "����� 3. ������",
            "����� 4. ��������������",
            "����� 5. ������������",
            "����� 6. �������������",
            "����� 7. ����",
            "����� 8. �����������",
            "����� 9. ��������� � ������������",
            "����� 10. ���������",
            "����� 11. ���������",
            "����� 12. ������������ � ����� ��������� ������������",
            "����� 13. �����",
            "����� 14. ������������� ��������� ���������������� ����������",
            "����� 15. ������� � ������",
            "����� 16. �����������",
            "����� 17. �������� �����������",
            "����� 18. ��������������� ������������"
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
        msg("{FF0000}[MolodoyHelper] {FFFFFF}��: ���� ������! ������������� ������.")
        return true
    else
        msg("��: ������ �������� �����!")
        return false
    end
end


function showMainMenu(targetID)
    if not targetID or targetID == "" then
        msg("{FF0000}[MolodoyHelper] {FFFFFF}�������������: /sticket [ID ������]")
        return
    end
    
    local targetID_num = tonumber(targetID)
    if not targetID_num then
        msg("{FF0000}[MolodoyHelper] {FFFFFF}������: ID ������ ���� ������!")
        return
    end
    
    local target = getPlayerByID(targetID_num)
    if not target then
        msg("����� � ID " .. targetID .. " �� ������!")
        return
    end
    
    local targetName = sampGetPlayerNickname(target)
    

    local dialogItems = "��� ���������\n��� ���������\n������ �����\n��������� ������������� �������\n�������� � �������� ��"
    
    lua_thread.create(function()
        sampShowDialog(3912, "���� - ����� ��� " .. targetName, dialogItems, "�������", "������", 2)
        
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
        "��� ���������",
        "��� ���������", 
        "������ �����",
        "��������� ������������� �������",
        "�������� � �������� �� � ������������ �����"
    }
    
    local sectionName = sectionNames[sectionIndex]
    if not sectionName or not koapData[sectionName] then 
        msg("������: ������ �� ������!")
        return 
    end
    
    local dialogItems = ""
    local articles = {}
    
    for article, data in pairs(koapData[sectionName]) do
        table.insert(articles, {article = article, data = data})
    end
    

    table.sort(articles, function(a, b) return a.article < b.article end)
    

    for i, item in ipairs(articles) do
        dialogItems = dialogItems .. item.article .. " - " .. item.data.text .. " (" .. item.data.summa .. " ���)\n"
    end
    
    lua_thread.create(function()
        sampShowDialog(3913, "���� - " .. sectionName, dialogItems, "�������", "�����", 2)
        
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
    
    
    local reason = "��. " .. article .. " ���� ��"
    
    local command = "/ticket " .. targetID .. " " .. summa .. " " .. reason
    
    
    sampSendChat(command)
    
    msg("{FF0000}[MolodoyHelper] {FFFFFF}����� �������: " .. dialogData.targetName .. " - " .. summa .. " ���. �� ��. " .. article)
end


function showYkMainMenu(targetID)
    if not targetID or targetID == "" then
        msg("{FF0000}[MolodoyHelper] {FFFFFF}�������������: /ssu [ID ������]")
        return
    end
    
    local targetID_num = tonumber(targetID)
    if not targetID_num then
        msg("{FF0000}[MolodoyHelper] {FFFFFF}������: ID ������ ���� ������!")
        return
    end
    
    local target = getPlayerByID(targetID_num)
    if not target then
        msg("{FF0000}[MolodoyHelper] {FFFFFF}����� � ID " .. targetID .. " �� ������!")
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
        sampShowDialog(5000, "�� - ������ ��� " .. targetName, dialogItems, "�������", "������", 2)
        
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
        msg("������: ����� �� �������!")
        return 
    end
    
    local dialogItems = ""
    local articles = {}
    
    for article, data in pairs(ykData[chapterName]) do
        table.insert(articles, {article = article, data = data})
    end
    
 
    table.sort(articles, function(a, b) return a.article < b.article end)
    

    for i, item in ipairs(articles) do
        dialogItems = dialogItems .. item.article .. " - " .. item.data.text .. " (" .. item.data.srok .. " ���)\n"
    end
    
    lua_thread.create(function()
        sampShowDialog(5001, "�� - " .. chapterName, dialogItems, "�������", "�����", 2)
        
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

    local reason = "��. " .. article .. " �� ��"
    
    msg("{FF0000}[MolodoyHelper] {FFFFFF}������ �������: " .. targetName .. " - " .. srok .. " ��� �� ��. " .. article)
    

    lua_thread.create(function()
        for i = 1, srok do
            local command = "/su " .. targetID .. " " .. reason
            sampSendChat(command)
            wait(1000) 
        end
        msg("{FF0000}[MolodoyHelper] {FFFFFF}������ �������: " .. targetName .. " - " .. srok .. " ��� �� ��. " .. article)
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
        -- ���� ��� ����-�������� � ��� ���������, �� ������
        if isAutoCheck and autoUpdateChecked then 
            return 
        end
        
        sampAddChatMessage("{FF0000}[MolodoyHelper] {FFFFFF}�������� ����������...", -1)
        
        local handle = io.popen('curl -s "' .. VERSION_URL .. '"')
        local online_version = handle:read("*a")
        handle:close()

        online_version = online_version:gsub("%s+", "")  -- ������� ������� � �������� �����

        if online_version and online_version ~= "" then
            -- �������� ��� ����-�������� ��������� (������ ��� ����-��������)
            if isAutoCheck then
                autoUpdateChecked = true
            end
            
            sampAddChatMessage("{FF0000}[MolodoyHelper] {FFFFFF}���������: {00FF00}" .. VERSION .. "{FFFFFF}, ���������: {00FF00}" .. online_version, -1)
            
            if online_version > VERSION then
                sampAddChatMessage("{FF0000}[MolodoyHelper] {00FF00}������� ����������! ����������� /supdate", -1)
                return true, online_version
            else
                sampAddChatMessage("{FF0000}[MolodoyHelper] {FFFFFF}������ ���������", -1)
                return false
            end
        else
            sampAddChatMessage("{FF0000}[MolodoyHelper] {FFFF00}�� ������� ��������� ����������", -1)
            if isAutoCheck then
                autoUpdateChecked = true -- ��� ����� �������� ��� ����������� ����� �� ���������
            end
            return false
        end
    end)
end

function updateScript()
    lua_thread.create(function()
        sampAddChatMessage("{FF0000}[MolodoyHelper] {FFFFFF}������� ����������...", -1)
        
        -- ������� ��������� ������ (������ ��������)
        local updateAvailable, online_version = checkForUpdates(false)
        
        if not updateAvailable then
            sampAddChatMessage("{FF0000}[MolodoyHelper] {FFFF00}���������� �� ��������� ��� ����������", -1)
            return
        end
        
        sampAddChatMessage("{FF0000}[MolodoyHelper] {FFFFFF}�������� ������ " .. online_version .. "...", -1)
        
        -- ��������� �������
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
        
        -- ��������� ����� ������
        local scriptPath = thisScript().path
        local handle = io.popen('curl -s -o "' .. scriptPath .. '" "' .. SCRIPT_URL .. '"')
        handle:close()
        
        -- ��������� ���������� ����������
        if doesFileExist(scriptPath) then
            local file = io.open(scriptPath, "r")
            if file then
                local content = file:read("*a")
                file:close()
                
                if content and content ~= "" then
                    sampAddChatMessage("{FF0000}[MolodoyHelper] {00FF00}������ �������� �� ������ " .. online_version .. "!", -1)
                    sampAddChatMessage("{FF0000}[MolodoyHelper] {FFFFFF}������������� ������ ��� ���������� ���������", -1)
                    
                    -- ��������������� �������
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
                    sampAddChatMessage("{FF0000}[MolodoyHelper] {FF0000}������: ��������� ���� ����", -1)
                end
            else
                sampAddChatMessage("{FF0000}[MolodoyHelper] {FF0000}������ ������ ���������� �����", -1)
            end
        else
            sampAddChatMessage("{FF0000}[MolodoyHelper] {FF0000}������ ���������� �������", -1)
        end
    end)
end


function autoCheckUpdates()
    lua_thread.create(function()
        wait(3000) -- ���� ������� ����� ��������
        checkForUpdates(true) -- true = ��� ����-��������
    end)
end

-- ������ �������� ����� �������
function cmd_scheck()
    checkForUpdates(false) -- false = ��� ������ ��������
end


function cmd_supdate()
    updateScript()
end

function cmd_sversion()
    msg("{FF0000}[MolodoyHelper] {FFFFFF}������� ������: " .. VERSION)
    msg("{FF0000}[MolodoyHelper] {FFFFFF}��� �������� ���������� ����������� /supdate")
end


function cmd_sticket(targetID)
    if not koapData or not next(koapData) then
        msg("����: ������ �� ���������! ������������� ������.")
        return
    end
    
    if not targetID or targetID == "" then
        msg("{FF0000}[MolodoyHelper] {FFFFFF}�������������: /sticket [ID ������]")
        return
    end
    
    showMainMenu(targetID)
end


function cmd_ssu(targetID)
    if not ykData or not next(ykData) then
        msg("��: ������ �� ���������! ��������� ���� yk.json")
        return
    end
    
    if not targetID or targetID == "" then
        msg("{FF0000}[MolodoyHelper] {FFFFFF}�������������: /ssu [ID ������]")
        return
    end
    
    showYkMainMenu(targetID)
end

function cmd_shelp()
    msg("{FF0000}[MolodoyHelper] {FFFFFF}=== ����� ������� ������� � ������� ===")
    msg("{FF0000}[MolodoyHelper] {FFFFFF}/sticket [id] - �������� ����� ����� �� ����")
    msg("{FF0000}[MolodoyHelper] {FFFFFF}/ssu [id] - ������ ����� ������ �� ���������� �������")
    msg("{FF0000}[MolodoyHelper] {FFFFFF}/supdate - �������� ������")
    msg("{FF0000}[MolodoyHelper] {FFFFFF}/sversion - �������� ������")
    msg("{FF0000}[MolodoyHelper] {FFFFFF}/scheck - ��������� ����������")
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
    
    -- ��������� ���������� ��� �������
    if CHECK_UPDATE_ON_START then
        autoCheckUpdates()
    end
    
    
    if loadKoapData() then
        msg("{FF0000}[MolodoyHelper] {FFFFFF}����: ������� ���������. ����������� /sticket [id]")
    else
        msg("{FF0000}[MolodoyHelper] {FF8C00}����: ����������� /sticket [id] ����� ������������ �������")
    end
    
    if loadYkData() then
        msg("{FF0000}[MolodoyHelper] {FFFFFF}��: ������� ���������. ����������� /ssu [id]")
        msg("{FF0000}[MolodoyHelper] {FFFFFF}������: " .. VERSION .. " - ����������� /shelp ��� ������ ������")
    else
        msg("{FF0000}[MolodoyHelper] {FF8C00}��: ����������� /ssu [id] ����� ������������ �������")
    end
    
    while true do
        wait(1000)
    end
end