--[[              
  /     \  _____     __| _/  ____   \______   \ ___.__.   ____    /     \  _____   _______ |  | __  ____  ________
 /  \ /  \ \__  \   / __ | _/ __ \   |    |  _/<   |  |  /  _ \  /  \ /  \ \__  \  \_  __ \|  |/ /_/ __ \ \___   /
/    Y    \ / __ \_/ /_/ | \  ___/   |    |   \ \___  | (  <_> )/    Y    \ / __ \_ |  | \/|    < \  ___/  /    / 
\____|__  /(____  /\____ |  \___  >  |______  / / ____|  \____/ \____|__  /(____  / |__|   |__|_ \ \___  >/_____ \
        \/      \/      \/      \/          \/  \/                      \/      \/              \/     \/       \/
------------------------CREDITS------------------------
-- Copyright 2019-2020 ©oMarkez. All rights reserved --
-------------------------------------------------------
]]
function DrawText3d(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
	local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 20,20,20,150)
end

bomber = {}
bombeCount = 0

RegisterNetEvent("setBombe")
AddEventHandler("setBombe", function(timer)
    bombeCount = bombeCount + 1
    local model = 1626933972
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end
    local playerPos = GetEntityCoords(PlayerPedId(), true)
    local taskeCoords = {
        x = playerPos.x,
        y = playerPos.y,
        z = playerPos.z
    }
    local taske = CreateObject(model, playerPos.x, playerPos.y, playerPos.z - 0.7, true, false, true)
    FreezeEntityPosition(taske, true)
    SetEntityAsMissionEntity(taske, true, false)
    SetEntityCollision(taske, false, true)
    PlaceObjectOnGroundProperly(taske)
    bomber[bombeCount] = {timer = timer, x = taskeCoords.x, y = taskeCoords.y, z = taskeCoords.z, object = taske}
    function playBeepSound()
        TriggerEvent("InteractSound_CL:PlayWithinDistanceCoord", taskeCoords, 600.0, "bombsoudn", 0.3)
    end

    function reduceTimer()
        timer = timer - 1
        if(bomber[bombeCount]) then
            bomber[bombeCount].timer = timer
        end
    end

    repeat 
        reduceTimer()
        if(timer > 5)then
            playBeepSound()
            Citizen.Wait(1000)
        elseif(timer <= 5)then
            playBeepSound()
            Citizen.Wait(200)
            playBeepSound()
            Citizen.Wait(200)
            playBeepSound()
            Citizen.Wait(200)
            playBeepSound()
            Citizen.Wait(200)
            playBeepSound()
            Citizen.Wait(200)
        end
    until timer <= 0 or bomber[bombeCount] == nil

    if bomber[bombeCount] then
        AddExplosion(playerPos.x, playerPos.y, playerPos.z, 34, 1.0, true, false, 0.8)
        DeleteObject(taske)
        SetEntityAsNoLongerNeeded(taske)
        bomber[bombeCount] = nil
    end
end)

local hasLos = false
local wait = 0
local isDefusing = false
local desfuseTime = 0
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(wait)
        local spillerPos = GetEntityCoords(PlayerPedId(), true)
        for k,v in pairs(bomber) do
            local distance = Vdist2(bomber[k].x, bomber[k].y, bomber[k].z,spillerPos.x,spillerPos.y,spillerPos.z)
            if distance < 3.0 then
                closeToBomb = bomber[k]
                if(hasLos)then
                    if(isDefusing) then
                        DrawText3d(bomber[k].x, bomber[k].y, bomber[k].z - 0.5, "Disarmere bombe... ~g~"..desfuseTime.." tilbage")
                    else
                        DrawText3d(bomber[k].x, bomber[k].y, bomber[k].z - 0.5, "~g~Tryk E for at disarmere bombe ~w~(Tid tilbage: ~r~"..bomber[k].timer.."~w~ sekunder)")
                        if(IsControlJustPressed(0, 38))then
                            TriggerServerEvent("disarmerBombe", k)
                        end
                    end
                end
            elseif distance < 35.0 and distance > 3.0 then
                closeToBomb = bomber[k]
                if(hasLos)then
                    DrawText3d(bomber[k].x, bomber[k].y, bomber[k].z - 0.5, "Tid: ~r~"..bomber[k].timer.."~w~ sekunder")
                end
            else
                closeToBomb = nil
            end
        end
    end
end)

Citizen.CreateThread(function()
    local time = 500
    while true do
        Wait(time)
        if not config.bombe.skalHaveLOS then
            break
        end
        if(closeToBomb)then
            time = 100
            if(HasEntityClearLosToEntityInFront(PlayerPedId(), closeToBomb.object)) then
                hasLos = true
            else
                time = 500
                hasLos = false
            end
        end
    end
end)

RegisterNetEvent("defuseBombe")
AddEventHandler("defuseBombe", function(bombe)
    if bomber[bombe] then
        TaskStartScenarioInPlace(PlayerPedId(), config.bombe.defuseAnim, 0, true)
        isDefusing = true
        desfuseTime = config.bombe.defuseTid

        function reduceDefuseTimer()
            desfuseTime = desfuseTime - 1
        end

        while desfuseTime > 0 do
            Citizen.Wait(1000)
            reduceDefuseTimer()
        end

        if(math.random(config.bombe.defuseChance[1], config.bombe.defuseChance[2]) == 1)then
            TriggerEvent("pNotify:SendNotification",{
                text = config.bombe.successTekst,
                type = "success",
                timeout = 3000,
                layout = "centerLeft",
                queue = "global",
                animation = {
                    open = "gta_effects_fade_in", 
                    close = "gta_effects_fade_out"
                },
                killer = true
            })
            isDefusing = false
            ClearPedTasks(PlayerPedId())
            if(config.bombe.sletBombe)then
                local bomb = bomber[bombe].object
                if(DoesEntityExist(bomb)) then
                    SetEntityAsMissionEntity(bomb, 1, 1)
                    DeleteObject(bomb)
                    SetEntityAsNoLongerNeeded(bomb)
                end
            end
            bomber[bombe] = nil
        else
            TriggerEvent("pNotify:SendNotification",{
                text = config.bombe.mislykkedesTekst,
                type = "error",
                timeout = 3000,
                layout = "centerLeft",
                queue = "global",
                animation = {
                    open = "gta_effects_fade_in", 
                    close = "gta_effects_fade_out"
                },
                killer = true
            })
            isDefusing = false
            ClearPedTasks(PlayerPedId())
        end
    end
end)