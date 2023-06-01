-- MADE BY Sever#7777
-- MADE BY Sever#7777
-- MADE BY Sever#7777
script_name('AutoPiar')
script_author('Sever#7777')

require 'lib.moonloader'
local imgui = require 'imgui'
local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local event = require 'samp.events'
local themes =import "lib/imgui_themes.lua"

update_state = false

local script_vers = 1
local script_vers_text = "1.00"

local update_url = "https://raw.githubusercontent.com/WeisBer/autopiar/main/update.ini"
local update_path = getWorkingDirectory() .. "/update.ini"

local script_url = ""
local script_path = thisScript().path

local window = imgui.ImBool(false)
local LastSMI = 1
local active = {
    vr = false,
    ad = false
}
local default_cfg = {
    active = {
        vr1 = false,
        vr2 = false,
        ad = false,
        fam = false,
        s = false,
        rb = false,
        fb = false,
        al = false,
        smi = 4,
        add = 1
    },
    text = {
        vr1 = '',
        vr2 = '',
        ad = '',
        fam = '',
        s = '',
        rb = '',
        fb = '',
        al = ''
    },
    kd = {
        vr = 180,
        ad = 60,
        fam = 120,
        s = 60,
        rb = 60,
        fb = 60,
        al = 120
    },
    score = {
        vr = 0,
        ad = 0,
        fam = 0,
        s = 0,
        rb = 0,
        fb = 0,
        al = 0
    }
}
local cfg = inicfg.load(default_cfg, 'autopiar.ini')

local Vr1 = imgui.ImBool(cfg.active.vr1)
local Vr2 = imgui.ImBool(cfg.active.vr2)
local Ad = imgui.ImBool(cfg.active.ad)
local Fam = imgui.ImBool(cfg.active.fam)
local S = imgui.ImBool(cfg.active.s)
local Rb = imgui.ImBool(cfg.active.rb)
local Fb = imgui.ImBool(cfg.active.fb)
local Al = imgui.ImBool(cfg.active.al)
local SelectAd = imgui.ImInt(cfg.active.smi)
local SelectAdd = imgui.ImInt(cfg.active.add)
local VrText1 = imgui.ImBuffer(256)
local VrText2 = imgui.ImBuffer(256)
local AdText = imgui.ImBuffer(256)
local FamText = imgui.ImBuffer(256)
local SText = imgui.ImBuffer(256)
local RbText = imgui.ImBuffer(256)
local FbText = imgui.ImBuffer(256)
local AlText = imgui.ImBuffer(256)
local VrKd = imgui.ImInt(cfg.kd.vr)
local AdKd = imgui.ImInt(cfg.kd.ad)
local FamKd = imgui.ImInt(cfg.kd.fam)
local SKd = imgui.ImInt(cfg.kd.s)
local RbKd = imgui.ImInt(cfg.kd.rb)
local FbKd = imgui.ImInt(cfg.kd.fb)
local AlKd = imgui.ImInt(cfg.kd.al)
VrText1.v = tostring(cfg.text.vr1)
VrText2.v = tostring(cfg.text.vr2)
AdText.v = tostring(cfg.text.ad)
FamText.v = tostring(cfg.text.fam)
SText.v = tostring(cfg.text.s)
RbText.v = tostring(cfg.text.rb)
FbText.v = tostring(cfg.text.fb)
AlText.v = tostring(cfg.text.al)

local score = {
    vr = 0,
    ad = 0,
    fam = 0,
    s = 0,
    rb = 0,
    fb = 0,
    al = 0
}
score['vr'] = cfg.score.vr
score['ad'] = cfg.score.ad
score['fam'] = cfg.score.fam
score['s'] = cfg.score.s
score['rb'] = cfg.score.rb
score['fb'] = cfg.score.fb
score['al'] = cfg.score.al

function save()
    cfg.text.vr1 = VrText1.v
    cfg.text.vr2 = VrText2.v
    cfg.text.ad = AdText.v
    cfg.text.fam = FamText.v
    cfg.text.s = SText.v
    cfg.text.rb = RbText.v
    cfg.text.fb = FbText.v
    cfg.text.al = AlText.v
    cfg.kd.vr = VrKd.v
    cfg.kd.ad = AdKd.v
    cfg.kd.fam = FamKd.v
    cfg.kd.s = SKd.v
    cfg.kd.rb = RbKd.v
    cfg.kd.fb = FbKd.v
    cfg.kd.al = AlKd.v
    cfg.active.smi = SelectAd.v
    cfg.active.vr1 = Vr1.v
    cfg.active.vr2 = Vr2.v
    cfg.active.s = S.v
    cfg.active.fam = Fam.v
    cfg.active.ad = Ad.v
    cfg.active.rb = Rb.v
    cfg.active.fb = Fb.v
    cfg.active.al = Al.v
    cfg.score.vr = score['vr']
    cfg.score.ad = score['ad']
    cfg.score.fam = score['fam']
    cfg.score.s = score['s']
    cfg.score.rb = score['rb']
    cfg.score.fb = score['fb']
    cfg.score.al = score['al']
    inicfg.save(cfg, 'autopiar.ini')
    sampAddChatMessage('[AutoPiar]{FFFFFF} Конфиг успешно сохранен!', 0x80DEEA)
end
if not doesFileExist(getWorkingDirectory()..'\\config\\autopiar.ini') then
    file = io.open(getWorkingDirectory()..'\\config\\autopiar.ini', 'a')
    file:close()
end

function imgui.OnDrawFrame()
    if not window.v then imgui.ShowCursor = false end

    if window.v then
        imgui.ShowCursor = true
        local x, y = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(x / 2, y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(680, 400), imgui.Cond.FirstUseEver)

        imgui.Begin(u8'AutoPiar Версия: ' .. script_vers_text, window, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar)

        imgui.BeginChild('##MAIN', imgui.ImVec2(680, 230), false)
        imgui.Columns(2, '##FUNCTIONS', false); imgui.SetColumnWidth(-1, 425)
        imgui.Text('')
        imgui.AlignTextToFramePadding(); imgui.Text('/vr'); imgui.PushItemWidth(375); imgui.SameLine(); imgui.SetCursorPosX(40); imgui.InputText(u8'##Отправка сообщений в /vr1', VrText1); imgui.PopItemWidth()
        imgui.AlignTextToFramePadding(); imgui.Text('/vr'); imgui.PushItemWidth(375); imgui.SameLine(); imgui.SetCursorPosX(40); imgui.InputText(u8'##Отправка сообщений в /vr2', VrText2); imgui.PopItemWidth()
        imgui.AlignTextToFramePadding(); imgui.Text('/s'); imgui.PushItemWidth(375); imgui.SameLine(); imgui.SetCursorPosX(40); imgui.InputText(u8'##Отправка сообщений в /s', SText); imgui.PopItemWidth()
        imgui.AlignTextToFramePadding(); imgui.Text('/fam'); imgui.PushItemWidth(375); imgui.SameLine(); imgui.SetCursorPosX(40); imgui.InputText(u8'##Отправка сообщений в /fam', FamText); imgui.PopItemWidth()
        imgui.AlignTextToFramePadding(); imgui.Text('/ad'); imgui.PushItemWidth(375); imgui.SameLine(); imgui.SetCursorPosX(40); imgui.InputText(u8'##Отправка сообщений в /ad', AdText); imgui.PopItemWidth()
        imgui.AlignTextToFramePadding(); imgui.Text('/rb'); imgui.PushItemWidth(375); imgui.SameLine(); imgui.SetCursorPosX(40); imgui.InputText(u8'##Отправка сообщений в /rb', RbText); imgui.PopItemWidth()
        imgui.AlignTextToFramePadding(); imgui.Text('/fb'); imgui.PushItemWidth(375); imgui.SameLine(); imgui.SetCursorPosX(40); imgui.InputText(u8'##Отправка сообщений в /fb', FbText); imgui.PopItemWidth()
        imgui.AlignTextToFramePadding(); imgui.Text('/al'); imgui.PushItemWidth(375); imgui.SameLine(); imgui.SetCursorPosX(40); imgui.InputText(u8'##Отправка сообщений в /al', AlText); imgui.PopItemWidth()
        imgui.AlignTextToFramePadding(); imgui.Text(u8'Выбор радиостанции:'); imgui.SameLine(); imgui.RadioButton('LS##AD', SelectAd, 1); imgui.SameLine(); imgui.RadioButton('SF##AD', SelectAd, 2); imgui.SameLine(); imgui.RadioButton('LV##AD', SelectAd, 3); imgui.SameLine(); imgui.RadioButton(u8'Авто выбор##AD', SelectAd, 4)

        imgui.NextColumn()
        imgui.Text('')
        imgui.AlignTextToFramePadding(); imgui.PushItemWidth(100); imgui.InputInt(u8'Задержка##vr', VrKd, 5); imgui.PopItemWidth(); imgui.SameLine(); imgui.Checkbox(u8'Вкл/Выкл##CheckboxVR', Vr1)
        imgui.AlignTextToFramePadding(); imgui.Checkbox(u8'Вкл/Выкл##VR_AD2', Vr2)
        imgui.AlignTextToFramePadding(); imgui.PushItemWidth(100); imgui.InputInt(u8'Задержка##s', SKd, 5); imgui.PopItemWidth(); imgui.SameLine(); imgui.Checkbox(u8'Вкл/Выкл##CheckboxS', S)
        imgui.AlignTextToFramePadding(); imgui.PushItemWidth(100); imgui.InputInt(u8'Задержка##fam', FamKd, 5); imgui.PopItemWidth(); imgui.SameLine(); imgui.Checkbox(u8'Вкл/Выкл##CheckboxFAM', Fam)
        imgui.AlignTextToFramePadding(); imgui.PushItemWidth(100); imgui.InputInt(u8'Задержка##ad', AdKd, 5); imgui.PopItemWidth(); imgui.SameLine(); imgui.Checkbox(u8'Вкл/Выкл##CheckboxAD', Ad)
        imgui.AlignTextToFramePadding(); imgui.PushItemWidth(100); imgui.InputInt(u8'Задержка##rb', RbKd, 5); imgui.PopItemWidth(); imgui.SameLine(); imgui.Checkbox(u8'Вкл/Выкл##CheckboxRB', Rb)
        imgui.AlignTextToFramePadding(); imgui.PushItemWidth(100); imgui.InputInt(u8'Задержка##fb', FbKd, 5); imgui.PopItemWidth(); imgui.SameLine(); imgui.Checkbox(u8'Вкл/Выкл##CheckboxFB', Fb)
        imgui.AlignTextToFramePadding(); imgui.PushItemWidth(100); imgui.InputInt(u8'Задержка##al', AlKd, 5); imgui.PopItemWidth(); imgui.SameLine(); imgui.Checkbox(u8'Вкл/Выкл##CheckboxAL', Al)
        imgui.AlignTextToFramePadding(); imgui.Text(u8'Forever ADD:'); imgui.SameLine(); imgui.RadioButton(u8'Есть', SelectAdd, 1); imgui.SameLine(); imgui.RadioButton(u8'Нет', SelectAdd, 2) 
        imgui.EndChild()

        imgui.BeginChild('##STATS', imgui.ImVec2(680, 65))

        imgui.Text(u8'Статистика отправленной рекламы:')
        imgui.Columns(7, '##STATS', true)
        imgui.CenterColumnText('VR')
        -- imgui.Separator()
        imgui.CenterColumnText(tostring(score['vr']))
        imgui.NextColumn()
        imgui.CenterColumnText('AD')
        imgui.CenterColumnText(tostring(score['ad']))
        imgui.NextColumn()
        imgui.CenterColumnText('FAM')
        imgui.CenterColumnText(tostring(score['fam']))
        imgui.NextColumn()
        imgui.CenterColumnText('S')
        imgui.CenterColumnText(tostring(score['s']))
        imgui.NextColumn()
        imgui.CenterColumnText('RB')
        imgui.CenterColumnText(tostring(score['rb']))
        imgui.NextColumn()
        imgui.CenterColumnText('FB')
        imgui.CenterColumnText(tostring(score['fb']))
        imgui.NextColumn()
        imgui.CenterColumnText('AL')
        imgui.CenterColumnText(tostring(score['al']))
        imgui.NextColumn()

        imgui.EndChild()

        if imgui.Button(u8'Обнулить счетчик', imgui.ImVec2(330, 21)) then
            for k, v in pairs(score) do
                score[k] = 0
            end
        end
        
		imgui.SameLine(); if imgui.Button(u8'Сохранить конфиг', imgui.ImVec2(330, 21)) then save() end
	if imgui.CollapsingHeader(u8'Темы') then
    if imgui.Button(u8'Монохром', imgui.ImVec2(330, 21)) then
		     themes.SwitchColorTheme(1)
	    end
	imgui.SameLine(); if imgui.Button(u8'Черно-оранжевая', imgui.ImVec2(330, 21)) then
		     themes.SwitchColorTheme(2)
	    end
	if imgui.Button(u8'Темная', imgui.ImVec2(330, 21)) then
		     themes.SwitchColorTheme(3)
	    end
	imgui.SameLine(); if imgui.Button(u8'Вишнёвая', imgui.ImVec2(330, 21)) then
		     themes.SwitchColorTheme(4)
	    end
	if imgui.Button(u8'Темно-красная', imgui.ImVec2(330, 21)) then
		     themes.SwitchColorTheme(5)
	    end
	imgui.SameLine(); if imgui.Button(u8'Темно-зеленая', imgui.ImVec2(330, 21)) then
		     themes.SwitchColorTheme(6)
	    end
	if imgui.Button(u8'Светло-Розовая', imgui.ImVec2(330, 21)) then
		     themes.SwitchColorTheme(7)
		end
	imgui.SameLine(); if imgui.Button(u8'Салатовая', imgui.ImVec2(330, 21)) then
		     themes.SwitchColorTheme(8)
		end
	if imgui.Button(u8'Светло-Красная тема', imgui.ImVec2(330, 21)) then
		     themes.SwitchColorTheme(9)
	    end
	imgui.SameLine(); if imgui.Button(u8'Бирюзовая', imgui.ImVec2(330, 21)) then
		     themes.SwitchColorTheme(10)
		end
end
        imgui.End()
    end
end

function imgui.CenterColumnText(text)
    imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
    imgui.Text(text)
end

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(2000) end

    sampRegisterChatCommand('autopiar', function()
        window.v = not window.v
        imgui.Process = window.v
    end)
   
   downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then
                sampAddChatMessage("[AutoPiar]{FFFFFF} Доступно обновление! Версия: " .. updateIni.info.vers_text, 0x80DEEA)
                update_state = true
            end
        end
    end)
	
	while true do
        wait(0)

        if update_state then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
				    sampAddChatMessage('[AutoPiar]{FFFFFF} AutoPiar был успешно обновлен!', 0x80DEEA)
                    thisScript():reload()
                end
            end)
            break
        end
end

    if active['vr'] then sampAddChatMessage('true', -1) end

    lua_thread.create(vr)
    lua_thread.create(s)
    lua_thread.create(fam)
    lua_thread.create(ad)
    lua_thread.create(rb)
    lua_thread.create(fb)
    lua_thread.create(al)
end



function onScriptTerminate(script, quit)
    if script == thisScript() then save() end
end

function event.onServerMessage(color, text)
    if SelectAd.v == 4 then
        if text:find('LS') and color == 1941201407 then LastSMI = 0 end
        if text:find('SF') and color == 1941201407 then LastSMI = 2 end
        if text:find('LV') and color == 1941201407 then LastSMI = 1 end
    end
    if text:find('Вы отменили публикацию своего объявления') and color == 1941201407 and Ad.v then
        lua_thread.create(function() wait(500); sampSendChat(u8:decode('/ad '..AdText.v)) end)
    end
end

function event.onShowDialog(dialogId, style, title, button1, button2, text)
    if dialogId == 25628 and active['vr'] then
        sampSendDialogResponse(dialogId, 1, 0, nil)
        sampCloseCurrentDialogWithButton(0)
        active['vr'] = false
        return false
    end
    if dialogId == 25476 and active['ad'] then
        if SelectAd.v == 1 then sampSendDialogResponse(25476, 1, 0, nil) end
        if SelectAd.v == 2 then sampSendDialogResponse(25476, 1, 2, nil) end
        if SelectAd.v == 3 then sampSendDialogResponse(25476, 1, 1, nil) end
        if SelectAd.v == 4 then sampSendDialogResponse(25476, 1, LastSMI, nil) end
        return false
    end
    if dialogId == 15346 and active['ad'] then
        sampSendDialogResponse(15346, 1, 0, nil)
        return false
    end
    if dialogId == 15347 and active['ad'] then
        sampSendDialogResponse(15347, 1, nil, nil)
        active['ad'] = false
        return false
    end
    if dialogId == 15379 and active['ad'] then
        sampSendDialogResponse(15379, 1, nil, nil)
        active['ad'] = true
        return false
    end
end

function vr()
    while true do wait(100)
        if Vr1.v and VrText1.v then
            wait(100)
            active['vr'] = true
            sampSendChat(u8:decode('/vr '..VrText1.v))
            wait(100)
            if Vr2.v and VrText2.v then
                if SelectAdd.v == 2 then wait(11000) else wait(300) end
                active['vr'] = true
                sampSendChat(u8:decode('/vr '..VrText2.v))
            end
            score['vr'] = score['vr'] + 1
            wait((VrKd.v*1000) + math.random(2000, 5000))
        end
    end
end

function s()
    while true do wait(100)
        if S.v and SText.v then
            wait(100)
            sampSendChat(u8:decode('/s '..SText.v))
            score['s'] = score['s'] + 1
            wait((SKd.v*1000) + math.random(2000, 5000))
        end
    end
end

function fam()
    while true do wait(100)
        if Fam.v and FamText.v then
            wait(100)
            sampSendChat(u8:decode('/fam '..FamText.v))
            score['fam'] = score['fam'] + 1
            wait((FamKd.v*1000) + math.random(2000, 5000))
        end
    end
end

function ad()
    while true do wait(100)
        if Ad.v and AdText.v then
            wait(100)
            active['ad'] = true
            sampSendChat(u8:decode('/ad '..AdText.v))
            score['ad'] = score['ad'] + 1
            wait((AdKd.v*1000) + math.random(2000, 5000))
        end
    end
end

function rb()
    while true do wait(100)
        if Rb.v and RbText.v then
            wait(100)
            sampSendChat(u8:decode('/rb '..RbText.v))
            score['rb'] = score['rb'] + 1
            wait((RbKd.v*1000) + math.random(2000, 5000))
        end
    end
end

function fb()
    while true do wait(100)
        if Fb.v and FbText.v then
            wait(100)
            sampSendChat(u8:decode('/fb '..FbText.v))
            score['fb'] = score['fb'] + 1
            wait((FbKd.v*1000) + math.random(2000, 5000))
        end
    end
end

function al()
    while true do wait(100)
        if Al.v and AlText.v then
            wait(100)
            sampSendChat(u8:decode('/al '..AlText.v))
            score['al'] = score['al'] + 1
            wait((AlKd.v*1000) + math.random(2000, 5000))
        end
    end
end

function closeDialog()
	sampSetDialogClientside(true)
	sampCloseCurrentDialogWithButton(0)
	sampSetDialogClientside(false)
end

function theme()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2
 
    style.WindowPadding = ImVec2(6, 4)
    style.WindowRounding = 5.0
    style.ChildWindowRounding = 5.0
    style.FramePadding = ImVec2(5, 2)
    style.FrameRounding = 5.0
    style.ItemSpacing = ImVec2(7, 5)
    style.ItemInnerSpacing = ImVec2(1, 1)
    style.TouchExtraPadding = ImVec2(0, 0)
    style.IndentSpacing = 6.0
    style.ScrollbarSize = 12.0
    style.ScrollbarRounding = 5.0
    style.GrabMinSize = 20.0
    style.GrabRounding = 2.0
    style.WindowTitleAlign = ImVec2(0.5, 0.5)

    colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.TextDisabled]           = ImVec4(0.28, 0.30, 0.35, 1.00)
    colors[clr.WindowBg]               = ImVec4(0.16, 0.18, 0.22, 1.00)
    colors[clr.ChildWindowBg]          = ImVec4(0.19, 0.22, 0.26, 0)
    colors[clr.PopupBg]                = ImVec4(0.05, 0.05, 0.10, 0.90)
    colors[clr.Border]                 = ImVec4(0.19, 0.22, 0.26, 1.00)
    colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.FrameBg]                = ImVec4(0.19, 0.22, 0.26, 1.00)
    colors[clr.FrameBgHovered]         = ImVec4(0.22, 0.25, 0.30, 1.00)
    colors[clr.FrameBgActive]          = ImVec4(0.22, 0.25, 0.29, 1.00)
    colors[clr.TitleBg]                = ImVec4(0.19, 0.22, 0.26, 1.00)
    colors[clr.TitleBgActive]          = ImVec4(0.19, 0.22, 0.26, 1.00)
    colors[clr.TitleBgCollapsed]       = ImVec4(0.19, 0.22, 0.26, 0.59)
    colors[clr.MenuBarBg]              = ImVec4(0.19, 0.22, 0.26, 1.00)
    colors[clr.ScrollbarBg]            = ImVec4(0.20, 0.25, 0.30, 0.60)
    colors[clr.ScrollbarGrab]          = ImVec4(0.41, 0.55, 0.78, 1.00)
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.49, 0.63, 0.86, 1.00)
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.49, 0.63, 0.86, 1.00)
    colors[clr.ComboBg]                = ImVec4(0.20, 0.20, 0.20, 0.99)
    colors[clr.CheckMark]              = ImVec4(0.90, 0.90, 0.90, 0.50)
    colors[clr.SliderGrab]             = ImVec4(1.00, 1.00, 1.00, 0.30)
    colors[clr.SliderGrabActive]       = ImVec4(0.80, 0.50, 0.50, 1.00)
    colors[clr.Button]                 = ImVec4(0.41, 0.55, 0.78, 1.00)
    colors[clr.ButtonHovered]          = ImVec4(0.49, 0.62, 0.85, 1.00)
    colors[clr.ButtonActive]           = ImVec4(0.49, 0.62, 0.85, 1.00)
    colors[clr.Header]                 = ImVec4(0.19, 0.22, 0.26, 1.00)
    colors[clr.HeaderHovered]          = ImVec4(0.22, 0.24, 0.28, 1.00)
    colors[clr.HeaderActive]           = ImVec4(0.22, 0.24, 0.28, 1.00)
    colors[clr.Separator]              = ImVec4(0.41, 0.55, 0.78, 1.00)
    colors[clr.SeparatorHovered]       = ImVec4(0.41, 0.55, 0.78, 1.00)
    colors[clr.SeparatorActive]        = ImVec4(0.41, 0.55, 0.78, 1.00)
    colors[clr.ResizeGrip]             = ImVec4(0.41, 0.55, 0.78, 1.00)
    colors[clr.ResizeGripHovered]      = ImVec4(0.49, 0.61, 0.83, 1.00)
    colors[clr.ResizeGripActive]       = ImVec4(0.49, 0.62, 0.83, 1.00)
    colors[clr.CloseButton]            = ImVec4(0.41, 0.55, 0.78, 1.00)
    colors[clr.CloseButtonHovered]     = ImVec4(0.50, 0.63, 0.84, 1.00)
    colors[clr.CloseButtonActive]      = ImVec4(0.41, 0.55, 0.78, 1.00)
    colors[clr.PlotLines]              = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.PlotLinesHovered]       = ImVec4(0.90, 0.70, 0.00, 1.00)
    colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
    colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
    colors[clr.TextSelectedBg]         = ImVec4(0.41, 0.55, 0.78, 1.00)
    colors[clr.ModalWindowDarkening]   = ImVec4(0.16, 0.18, 0.22, 0.76)
end
theme()