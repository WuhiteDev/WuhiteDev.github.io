local module = {}
local ProximityPromptService = game:GetService("ProximityPromptService")
local tween = game:GetService("TweenService")
local plr = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local IsAlive = false
local hrpvalues = {}
local headvalues = {}
function module.Execute()
	IsAlive = true
	local PromptFunction
	PromptFunction = ProximityPromptService.PromptShown:Connect(function(promptInstance: ProximityPrompt)
		if promptInstance.Parent:FindFirstChild("Humanoid") or promptInstance.Parent.Parent:FindFirstChild("Humanoid") then
		if IsAlive == false then PromptFunction:Disconnect() return end
		if promptInstance.Style == Enum.ProximityPromptStyle.Default then return end
		--sound.Emit(sounds.ButtonHover,plr.PlayerGui)
		local CustomProximity = script.CustomProximity:Clone()
		CustomProximity.Main.ObjectText.Text = promptInstance.ObjectText
		CustomProximity.Main.ActionText.Text = promptInstance.ActionText
		if uis.GamepadEnabled == true then
			CustomProximity.Main.Button.Key.Text = promptInstance.GamepadKeyCode.Name
		else
			CustomProximity.Main.Button.Key.Text = promptInstance.KeyboardKeyCode.Name
		end
		CustomProximity.Main.Size = UDim2.new(0,0,1,0)
		local StartTween = tween:Create(CustomProximity.Main,TweenInfo.new(.2),{["Size"] = UDim2.new(1,0,1,0)})
		StartTween:Play()
		game.Debris:AddItem(StartTween,.2)
		CustomProximity.Parent = promptInstance.Parent
		if promptInstance.Parent:FindFirstChild("HumanoidRootPart") then
			if hrpvalues[promptInstance.Parent.Name] then else
				hrpvalues[promptInstance.Parent.Name] = promptInstance.Parent.HumanoidRootPart.CFrame
			end
		end
		if promptInstance.Parent:FindFirstChild("Head") then
			if headvalues[promptInstance.Parent.Name] then else
				headvalues[promptInstance.Parent.Name] = promptInstance.Parent.Torso.Neck.C0
			end
		end
		local ProxyFunction = nil
		if promptInstance:FindFirstChild("Function") then
			ProxyFunction = require(promptInstance.Function)
		end
		local view
		local highlight = script.Highlight:Clone()
		highlight.Parent = promptInstance.Parent
		game.Debris:AddItem(highlight,.5)
		local tweenhigh = tween:Create(highlight,TweenInfo.new(.5,Enum.EasingStyle.Linear),{FillTransparency = 1,OutlineTransparency = 1})
		tweenhigh.Parent = highlight
		tweenhigh:Play()
			view = game:GetService("RunService").RenderStepped:Connect(function()
				local hrp = promptInstance.Parent:FindFirstChild("HumanoidRootPart")
				local head = promptInstance.Parent:FindFirstChild("Head")
				if head:FindFirstChild("HeadTween") then return end
				if not hrp then return end
				if hrp:FindFirstChild("HRPTween") then return end
				local vector1 = (plr.Character.Head.Position - promptInstance.Parent.Head.Position).Unit -- head of attacking player minus enemy head
				local elook = promptInstance.Parent.HumanoidRootPart.CFrame.LookVector -- enemy look
				local dot = vector1:Dot(elook)
				local head = promptInstance.Parent:FindFirstChild("Head")
				local visuhead = tween:Create(promptInstance.Parent.Torso.Neck,TweenInfo.new(.2),{C0 = CFrame.lookAt(Vector3.new(0, promptInstance.Parent.Torso.Neck.C0.Y, 0), promptInstance.Parent.Torso.CFrame:PointToObjectSpace(plr.Character.Torso.Position + Vector3.new(0, .5, 0))) * CFrame.Angles(math.rad(90), math.rad(180), 0)})
				visuhead:Play()
				task.wait(.2)
				visuhead:Destroy()
				if dot > .35 then return end
				local hrp = promptInstance.Parent:FindFirstChild("HumanoidRootPart")
				local visu = tween:Create(hrp,TweenInfo.new(.35,Enum.EasingStyle.Linear),{["CFrame"] = CFrame.lookAt(hrp.Position,Vector3.new(plr.Character.HumanoidRootPart.Position.X,hrp.Position.Y,plr.Character.HumanoidRootPart.Position.Z))})
				visu:Play()
				task.wait(visu.TweenInfo.Time)
				visu:Destroy()
		end)
		local cdtween = tween:Create(CustomProximity.Main.CD,TweenInfo.new(promptInstance.HoldDuration,Enum.EasingStyle.Linear),{["Size"] = UDim2.new(1,0,.05,0)})
		local completedtween = tween:Create(CustomProximity.Main.CD,TweenInfo.new(.1,Enum.EasingStyle.Linear),{["BackgroundColor3"] = Color3.fromRGB(0, 170, 255)})
		local backtween = tween:Create(CustomProximity.Main.CD,TweenInfo.new(.25,Enum.EasingStyle.Linear),{["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)})
		local holding = false
		local began = promptInstance.PromptButtonHoldBegan:Connect(function()
			cdtween:Play()
			--sound.Emit(sounds.Click,plr.PlayerGui)
		end)
		local ended = promptInstance.PromptButtonHoldEnded:Connect(function()
			if CustomProximity.Main.CD.Size == UDim2.new(1,0,.05,0) then
				--sound.Emit(sounds.ButtonClick,plr.PlayerGui)
				completedtween:Play()
				task.wait(.1)
				backtween:Play()
				return end
			cdtween:Cancel()
			while CustomProximity.Main.CD.Size.X.Scale > 0 and cdtween.PlaybackState ~= Enum.PlaybackState.Playing do
				task.wait()
				CustomProximity.Main.CD.Size -= UDim2.new(.04,0,0,0)
			end
			CustomProximity.Main.CD.Size = UDim2.new(0,0,.05,0)
		end)
		local trigger = promptInstance.TriggerEnded:Connect(function()
			if IsAlive == false then return end
			if ProxyFunction == nil then else
				ProxyFunction:Trigger(plr)
			end
			while CustomProximity.Main.CD.Size.X.Scale > 0 and cdtween.PlaybackState ~= Enum.PlaybackState.Playing do
				task.wait()
				CustomProximity.Main.CD.Size -= UDim2.new(.05,0,0,0)
			end
			CustomProximity.Main.CD.Size = UDim2.new(0,0,.05,0)
		end)
		local function stop()
			if CustomProximity then
				ended:Disconnect()
				began:Disconnect()
				trigger:Disconnect()
				cdtween:Destroy()
				if view then
					view:Disconnect()
				end
				CustomProximity.Main.Size = UDim2.new(1,0,1,0)
				tween:Create(CustomProximity.Main,TweenInfo.new(.2),{["Size"] = UDim2.new(0,0,1,0)}):Play()
				if hrpvalues[promptInstance.Parent.Name] then
					if promptInstance.Parent.HumanoidRootPart:FindFirstChild("HRPTween") then return end
					local hrptween = tween:Create(promptInstance.Parent.HumanoidRootPart,TweenInfo.new(.5),{["CFrame"] = hrpvalues[promptInstance.Parent.Name]})
					hrptween.Name = "HRPTween"
					hrptween.Parent = promptInstance.Parent.HumanoidRootPart
					hrptween:Play()
					local hrp = promptInstance.Parent.HumanoidRootPart
					task.delay(hrptween.TweenInfo.Time,function()
						hrptween:Destroy()
						hrp.CFrame = hrpvalues[promptInstance.Parent.Name]
					end)
				end
				if headvalues[promptInstance.Parent.Name] then
					if promptInstance.Parent.Head:FindFirstChild("HeadTween") then return end
					local headtween = tween:Create(promptInstance.Parent.Torso.Neck,TweenInfo.new(.5),{["C0"] = headvalues[promptInstance.Parent.Name]})
					headtween.Name = "HeadTween"
					headtween.Parent = promptInstance.Parent.Head
					headtween:Play()
					local neck = promptInstance.Parent.Torso.Neck
					task.delay(headtween.TweenInfo.Time,function()
						headtween:Destroy()
						neck.C0 = headvalues[promptInstance.Parent.Name]
					end)
				end
				task.wait(.2)
				CustomProximity:Destroy()
			end
		end
		plr.Character.Humanoid.Died:Once(function()
			IsAlive = false
			stop()
		end)
		promptInstance.PromptHidden:Once(stop)
		while view do
			task.wait(.01)
			if not CustomProximity then return end 
			if not CustomProximity:FindFirstChild("Main") then return end
			CustomProximity.Main.Button.Square1.Rotation += 1
			CustomProximity.Main.Button.Square2.Rotation -= 1
		end	
		else
			if IsAlive == false then PromptFunction:Disconnect() return end
			if promptInstance.Style == Enum.ProximityPromptStyle.Default then return end
			local CustomProximity = script.CustomProximityOBJECT:Clone()
			CustomProximity.Main.ObjectText.Text = promptInstance.ObjectText
			CustomProximity.Main.ActionText.Text = promptInstance.ActionText
			if uis.GamepadEnabled == true then
				CustomProximity.Main.Button.Key.Text = promptInstance.GamepadKeyCode.Name
			else
				CustomProximity.Main.Button.Key.Text = promptInstance.KeyboardKeyCode.Name
			end
			CustomProximity.Main.Size = UDim2.new(0,0,1,0)
			local StartTween = tween:Create(CustomProximity.Main,TweenInfo.new(.2),{["Size"] = UDim2.new(1,0,1,0)})
			StartTween:Play()
			game.Debris:AddItem(StartTween,.2)
			CustomProximity.Parent = promptInstance.Parent
			local ProxyFunction = nil
			if promptInstance:FindFirstChild("Function") then
				ProxyFunction = require(promptInstance.Function)
			end
			local view
			local highlight = script.Highlight:Clone()
			highlight.Parent = promptInstance.Parent
			game.Debris:AddItem(highlight,.5)
			local tweenhigh = tween:Create(highlight,TweenInfo.new(.5,Enum.EasingStyle.Linear),{FillTransparency = 1,OutlineTransparency = 1})
			tweenhigh.Parent = highlight
			tweenhigh:Play()
			local cdtween = tween:Create(CustomProximity.Main.CD,TweenInfo.new(promptInstance.HoldDuration,Enum.EasingStyle.Linear),{["Size"] = UDim2.new(1,0,.05,0)})
			local completedtween = tween:Create(CustomProximity.Main.CD,TweenInfo.new(.1,Enum.EasingStyle.Linear),{["BackgroundColor3"] = Color3.fromRGB(0, 170, 255)})
			local backtween = tween:Create(CustomProximity.Main.CD,TweenInfo.new(.25,Enum.EasingStyle.Linear),{["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)})
			local holding = false
			local began = promptInstance.PromptButtonHoldBegan:Connect(function()
				cdtween:Play()
			end)
			local ended = promptInstance.PromptButtonHoldEnded:Connect(function()
				if CustomProximity.Main.CD.Size == UDim2.new(1,0,.05,0) then
					completedtween:Play()
					task.wait(.1)
					backtween:Play()
					return end
				cdtween:Cancel()
				while CustomProximity.Main.CD.Size.X.Scale > 0 and cdtween.PlaybackState ~= Enum.PlaybackState.Playing do
					task.wait()
					CustomProximity.Main.CD.Size -= UDim2.new(.04,0,0,0)
				end
				CustomProximity.Main.CD.Size = UDim2.new(0,0,.05,0)
			end)
			local trigger = promptInstance.TriggerEnded:Connect(function()
				if IsAlive == false then return end
				if ProxyFunction == nil then else
					ProxyFunction:Trigger(plr)
				end
				while CustomProximity.Main.CD.Size.X.Scale > 0 and cdtween.PlaybackState ~= Enum.PlaybackState.Playing do
					task.wait()
					CustomProximity.Main.CD.Size -= UDim2.new(.05,0,0,0)
				end
				CustomProximity.Main.CD.Size = UDim2.new(0,0,.05,0)
			end)
			local function stop()
				if CustomProximity then
					ended:Disconnect()
					began:Disconnect()
					trigger:Disconnect()
					cdtween:Destroy()
					CustomProximity.Main.Size = UDim2.new(1,0,1,0)
					tween:Create(CustomProximity.Main,TweenInfo.new(.2),{["Size"] = UDim2.new(0,0,1,0)}):Play()
					task.wait(.2)
					CustomProximity:Destroy()
				end
			end
			plr.Character.Humanoid.Died:Once(function()
				IsAlive = false
				stop()
			end)
			promptInstance.PromptHidden:Once(stop)
		end
	end)
end
return module
