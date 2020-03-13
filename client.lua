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

local sitting = false
local lastPos = nil
local currentSitObj = nil
local currentScenario = nil


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)


		local playerPed = GetPlayerPed(-1)

		if sitting and not IsPedUsingScenario(playerPed, currentScenario) then
			wakeup()
		end

		if (GetLastInputMethod(2) and IsControlJustPressed(0, 23)) and not IsPedInAnyVehicle(playerPed, true) then			

			if sitting then
				wakeup()
			else

				local object, distance = ESX.Game.GetClosestObject(Config.Interactables)

				

				if distance < 1.5 then

					local hash = GetEntityModel(object)
					local data = nil
					local modelName = nil
					local found = false
					
				

					for k,v in pairs(Config.Sitable) do
						if GetHashKey(k) == hash then
							data = v
							modelName = k
							found = true
							break
						end
					end

					if found == true then
						sit(object, modelName, data)

					end

				end

			end
			
		end

	end
end)

function wakeup()
	ClearPedTasks(playerPed)
	sitting = false
	SetEntityCoords(playerPed, lastPos)
	FreezeEntityPosition(playerPed, false)
	FreezeEntityPosition(currentSitObj, false)
	
	currentSitObj = nil
	currentScenario = nil
end

function sit(object, modelName, data)

	
	local pos = GetEntityCoords(object)
	local id = pos.x .. pos.y .. pos.z
	


			local playerPed = GetPlayerPed(-1)
			lastPos = GetEntityCoords(playerPed)
			currentSitObj = id

			FreezeEntityPosition(object, true)

			currentScenario = data.scenario

		if GetEntityHeading(object) <=181 then 
		
		 if string.match(modelName, "chair") or string.match(modelName, "Chair") then
			TaskStartScenarioAtPosition(playerPed, currentScenario, pos.x, pos.y, pos.z - data.verticalOffset, GetEntityHeading(object)+180.0, 0, true, true)
		  else
			TaskStartScenarioAtPosition(playerPed, currentScenario, lastPos.x, pos.y, pos.z - data.verticalOffset, GetEntityHeading(object)+180.0, 0, true, true)
		 end
		
		 elseif GetEntityHeading(object) >=181 then 
		
		 if string.match(modelName, "chair") or string.match(modelName, "Chair") then 
			TaskStartScenarioAtPosition(playerPed, currentScenario, pos.x, pos.y, pos.z - data.verticalOffset, GetEntityHeading(object)+180.0, 0, true, true)
		  else
		 	TaskStartScenarioAtPosition(playerPed, currentScenario, pos.x, lastPos.y, pos.z - data.verticalOffset, GetEntityHeading(object)+180.0, 0, true, true)
		 end
		
		end


end
