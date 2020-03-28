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
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_bombe")

RegisterServerEvent("disarmerBombe")
AddEventHandler("disarmerBombe", function(bombe)
    if source then
        local user_id = vRP.getUserId({source})
        if(vRP.tryGetInventoryItem({user_id, config.items.defuseItem, 1, true})) then
            TriggerClientEvent("defuseBombe", source, bombe)
        else
            TriggerClientEvent("pNotify:SendNotification", player, {
                text = "Du har ikke et disarmeringskit.", 
                type = "error", 
                queue = "global", 
                timeout = 4000, 
                layout = "centerLeft",
                animation = {
                    open = "gta_effects_fade_in", 
                    close = "gta_effects_fade_out"
                }
            })
        end
    end
end)

vRP.registerMenuBuilder({"main", function(add, data)
	local user_id = vRP.getUserId({data.player})
	if user_id ~= nil then
		local choices = {}

        if (vRP.getInventoryItemAmount({user_id, config.items.bombeItem}) > 0) then
            choices[config.menu.titel] = {function(player,choice)
                vRP.prompt({player,config.menu.prompt, "", function(player,timerTid)
                    if (timerTid and timerTid ~= " " and tonumber(timerTid) > 0) then
                        if(tonumber(timerTid) <= tonumber(config.maxTimer)) then
                            if (vRP.tryGetInventoryItem({user_id, config.items.bombeItem, 1, true})) then
                                TriggerClientEvent("setBombe", player, tonumber(timerTid))
                            end
                        else
                            TriggerClientEvent("pNotify:SendNotification", player, {
                                text = config.menu.forLangTid, 
                                type = "error", 
                                queue = "global", 
                                timeout = 4000, 
                                layout = "centerLeft",
                                animation = {
                                    open = "gta_effects_fade_in", 
                                    close = "gta_effects_fade_out"
                                }
                            })
                        end
                    end
                end})
            end, config.menu.deskription}
        end

		add(choices)
	end
end})