ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	Wait(0)
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
        ESX.ShowHelpNotification("~g~✅Vous avez un nouveau métier")
    elseif item == unemployed then
    	_menuPool:CloseAllMenus(true)
        TriggerServerEvent('esx_joblisting:setJobsunemployed')
        ESX.ShowHelpNotification("~g~✅Vous avez un nouveau métier")
        end
    end
end

AddPoleemploiMenu(mainMenu)
_menuPool:RefreshIndex()

local nezow = {
    {title="Pôle Emploi", colour=5, id=267, x = -269.37, y = -955.19, z = 30.25}
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
        local pl = false
        _menuPool:ProcessMenus()
        for k in pairs(nezow) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, nezow[k].x, nezow[k].y, nezow[k].z)
            if dist <= 1.2 then
                pl = true
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_TALK~ pour ouvrir le pôle emploi")
				if IsControlJustPressed(1,51) then
                    mainMenu:Visible(not mainMenu:Visible())
				end
            end
        end
        if pl then
            Wait(1)
        else
            Wait(400)
        end
    end
end)
