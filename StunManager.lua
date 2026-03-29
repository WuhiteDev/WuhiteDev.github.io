
local StunManager = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- RemoteEvents
local applyStunRemote = ReplicatedStorage:FindFirstChild("ApplyStun") or Instance.new("RemoteEvent", ReplicatedStorage)
applyStunRemote.Name = "ApplyStun"

local endStunRemote = ReplicatedStorage:FindFirstChild("EndStun") or Instance.new("RemoteEvent", ReplicatedStorage)
endStunRemote.Name = "EndStun"

local activeStuns = {}
local movementBackup = {}

-- Apply Stun
function StunManager:ApplyStun(character : Model, duration : number, freezeMovement : boolean, IFrame : boolean)
	if not character or typeof(character) ~= "Instance" or not character:IsA("Model") then
		warn("StunManager: Invalid Character")
		return
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		warn("StunManager: Humanoid not founded")
		return
	end

	local now = tick()
	local newEndTime = now + duration
	local currentEndTime = activeStuns[character] or 0

	-- Atualiza o tempo do stun
	if newEndTime > currentEndTime then
		activeStuns[character] = newEndTime
	end

	local player = game.Players:GetPlayerFromCharacter(character)

	if character:GetAttribute("Stunned") ~= true then
		character:SetAttribute("Stunned", true)
		
		if IFrame then
			character:SetAttribute("IFrame", true)
		end
		
		if freezeMovement then
			movementBackup[character] = {
				WalkSpeed = humanoid.WalkSpeed,
				JumpPower = humanoid.JumpPower,
			}
			humanoid.WalkSpeed = 0
			humanoid.JumpPower = 0
		end

		if player then
			applyStunRemote:FireClient(player, freezeMovement)
		end

		task.spawn(function()
			while activeStuns[character] and tick() < activeStuns[character] do
				if freezeMovement and humanoid then
					humanoid.WalkSpeed = 0
					humanoid.JumpPower = 0
				end
				task.wait(0.05)
			end

			self:ClearStun(character)
		end)
	else
		if player then
			applyStunRemote:FireClient(player, freezeMovement)
		end
	end
end

function StunManager:ClearStun(character)
	if not character or typeof(character) ~= "Instance" or not character:IsA("Model") then
		return
	end

	activeStuns[character] = nil
	character:SetAttribute("Stunned", false)

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid and movementBackup[character] then
		local backup = movementBackup[character]
		humanoid.WalkSpeed = backup.WalkSpeed
		humanoid.JumpPower = backup.JumpPower
		movementBackup[character] = nil
		if character:GetAttribute("IFrame") == true then character:SetAttribute("IFrame",false) end
	end

	local player = game.Players:GetPlayerFromCharacter(character)
	if player then
		endStunRemote:FireClient(player)
	end


end

return StunManager
