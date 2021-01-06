local GetTime = globals.RealTime;
local GetLocal = entities.GetLocalPlayer;

local lastTime = 0;
local MapNames = {
	['ar_baggage'] = 'Baggage', -- Added assets
	['ar_dizzy'] = 'Dizzy', -- Added assets
	['ar_lunacy'] = 'Lunacy', -- Added assets
	['ar_monastery'] = 'Monastery', -- Added assets
	['ar_shoots'] = 'Shoots', -- Added assets
	['cs_agency'] = 'Agency', -- Added assets
	['cs_assault'] = 'Assault', -- Added assets
	['cs_italy'] = 'Italy', -- Added assets
	['cs_militia'] = 'militia', -- Added assets
	['cs_office'] = 'Office', -- Has assets
	['de_anubis'] = 'Anubis', -- Added assets
	['de_bank'] = 'Bank', -- Added assets
	['de_cache'] = 'Cache', -- Added assets
	['de_cbble'] = 'Cobblestone', -- Added assets
	['de_chlorine'] = 'Chlorine', -- Added assets
	['de_dust2'] = 'Dust II', -- Has assets
	['de_inferno'] = 'Inferno', -- Added assets
	['de_lake'] = 'Lake', -- Added assets
	['de_mirage'] = 'Mirage', -- Has assets
	['de_nuke'] = 'Nuke', -- Added assets
	['de_overpass'] = 'Overpass', -- Added assets
	['de_safehouse'] = 'Safehouse', -- Added assets
	['de_shortdust'] = 'Shortdust', -- Added assets
	['de_shortnuke'] = 'Shortnuke', -- Added assets
	['de_stmarc'] = 'St. Marc', -- Added assets
	['de_sugarcane'] = 'Sugarcane', -- Added assets
	['de_train'] = 'Train', -- Added assets
	['de_vertigo'] = 'Vertigo', -- Added assets
	['dz_blacksite'] = 'Blacksite', -- Added assets
	['dz_junglety'] = 'Junglety', -- Added assets
	['dz_sirocco'] = 'Sirocco', -- Added assets
}

local function UpdateConfig(state, details, imgL, imgLT, imgS, imgST, timestamps)
    local strings = {
        "ClientID=794589042624430090"; "\n";
        "State="; state; "\n";
        "Details="; details; "\n";
        "StartTimestamp="; "\n";
        "EndTimestamp="; "\n";
        "LargeImage="; imgL; "\n";
        "LargeImageTooltip="; imgLT; "\n";
        "SmallImage="; imgS; "\n";
        "SmallImageTooltip="; imgST;
    }

    file.Write("config.txt", table.concat(strings))
end

callbacks.Register("Draw", function()

    if lastTime < GetTime()-1 then
        local mapName = engine.GetMapName()

        if mapName ~= "" then

            local pLocal = GetLocal()

            if not pLocal then
                return;
            end

            local uname = pLocal:GetName()
            --local ent = entities.FindByClass('CCSGameRulesProxy')[1];
            --local data = ent:GetProp('cs_gamerules_data', 'm_iMatchStats_RoundResults[1]')
            local kills =  entities.GetPlayerResources():GetPropInt('m_iKills', pLocal:GetIndex())
            local deaths =  entities.GetPlayerResources():GetPropInt('m_iDeaths', pLocal:GetIndex())
            local kd = kills / ((deaths == 0) and 1 or deaths);
            kd = math.floor(kd * 100) / 100
            local smallIcon = gui.GetValue('rbot.master') and ((GetTime()%4 > 2) and 'aimware' or 'raging') or 'aimware'
            local map = function()
                return 'On ' .. ((MapNames[mapName] ~= nil) and MapNames[mapName] or string.sub(mapName, 2)) .. ' as ' .. uname
            end
            map = map()

            if engine.GetServerIP() ~= '' then
                if MapNames[mapName] ~= nil then
                    UpdateConfig(kd .. ' KD', 'Community server', mapName, map, smallIcon, (smallIcon:gsub("^%l", string.upper)))
                else
                    UpdateConfig(kd .. ' KD', 'Community server', 'csgo', map, smallIcon, (smallIcon:gsub("^%l", string.upper)))
                end
            else
                if MapNames[mapName] ~= nil then
                    UpdateConfig(kd .. ' KD', 'Official server', mapName, map, smallIcon, (smallIcon:gsub("^%l", string.upper)))
                else
                    UpdateConfig(kd .. ' KD', 'Official server', 'csgo', map, smallIcon, (smallIcon:gsub("^%l", string.upper)))
                end
            end
        else
            UpdateConfig('Idle', 'In the menus', 'csgo', 'In the menus', 'aimware', 'Aimware')
        end

        lastTime = GetTime();
    end
end)