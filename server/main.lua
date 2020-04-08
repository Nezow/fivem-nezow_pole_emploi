ESX = nil

print("By nezow")

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_joblisting:setJobslaughterer')
AddEventHandler('esx_joblisting:setJobslaughterer', function(job)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    
    xPlayer.setJob("slaughterer", 0)  
end)

RegisterServerEvent('esx_joblisting:setJobsunemployed')
AddEventHandler('esx_joblisting:setJobsunemployed', function(job)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    
    xPlayer.setJob("unemployed", 0)  
end)
