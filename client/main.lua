local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	Citizen.Wait(0)
    end
end)

_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Pôle emploi","")
_menuPool:Add(mainMenu)

function AddPoleemploiMenu(menu)
	local poleemploi = _menuPool:AddSubMenu(menu, "Métier", nil, nil, "shopui_title_conveniencestore", "shopui_title_conveniencestore")

    local unemployed = NativeUI.CreateItem("Chômeur", "~b~Salaire : 60$")
    poleemploi.SubMenu:AddItem(unemployed)

    local slaughterer = NativeUI.CreateItem("Abatteur", "~b~Salaire : 80$")
    poleemploi.SubMenu:AddItem(slaughterer)

    poleemploi.SubMenu.OnItemSelect = function(menu, item)
    if item == slaughterer then
    	_menuPool:CloseAllMenus(true)
        TriggerServerEvent('esx_joblisting:setJobslaughterer')
        Citizen.Wait(1)
        ESX.ShowHelpNotification("~g~✅Vous avez un nouveau métier")
    elseif item == unemployed then
    	_menuPool:CloseAllMenus(true)
        TriggerServerEvent('esx_joblisting:setJobsunemployed')
        Citizen.Wait(1)
        ESX.ShowHelpNotification("~g~✅Vous avez un nouveau métier")
        end
    end
end

AddPoleemploiMenu(mainMenu)
_menuPool:RefreshIndex()

local nezow = {
    {title="Pôle Emploi", colour=5, id=267, x = -269.3767395019531, y = -955.19580078125, z = 30.25070571899414}
}

Citizen.CreateThread(function()
    for _, info in pairs(nezow) do
        info.blip = AddBlipForCoord(info.x, info.y, info.z)
        SetBlipSprite(info.blip, info.id)
        SetBlipDisplay(info.blip, 4)
        SetBlipScale(info.blip, 0.8)
        SetBlipColour(info.blip, info.colour)
        SetBlipAsShortRange(info.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(info.title)
        EndTextCommandSetBlipName(info.blip)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _menuPool:ProcessMenus()
        _menuPool:MouseEdgeEnabled (false);

        for k in pairs(nezow) do

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, nezow[k].x, nezow[k].y, nezow[k].z)

            if dist <= 1.2 then
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_TALK~ pour ouvrir le pôle emploi")
				if IsControlJustPressed(1,51) then 
                    mainMenu:Visible(not mainMenu:Visible())
				end
            end
        end
    end
end)