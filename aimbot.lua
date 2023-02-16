local camera = workspace.CurrentCamera
local players = game:GetService("Players")
local randomplayer = players:GetPlayers()[math.random(2, #players:GetPlayers())]
local randomcharacter = randomplayer.Character
local player = players.LocalPlayer
local char = player.Character
local uis=game:GetService("UserInputService")
local maxDistance = 500
local c
local function getClosest(cframe)
   local ray = Ray.new(cframe.Position, cframe.LookVector).Unit
   
   local target = nil
   local mag = math.huge
   
   for i,v in pairs(game.Players:GetPlayers()) do
       if v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("HumanoidRootPart") and v ~= game.Players.LocalPlayer and v.Character.Torso.Material ~= "Forcefield" then
           local magBuf = (v.Character.Head.Position - ray:ClosestPoint(v.Character.Head.Position)).Magnitude
           
           if magBuf < mag then
               mag = magBuf
               target = v
           end
       end
   end
   
   return target
end
local function isBehindWall(plr)
    local params = RaycastParams.new()
    local charac = plr.Character or plr.CharacterAdded:Wait()
    local direction = CFrame.new(game.Players.LocalPlayer.Character.Head.Position, charac.HumanoidRootPart.Position).LookVector
    params.FilterDescendantsInstances = {char}
    local ray = workspace:Raycast(game.Players.LocalPlayer.Character.Head.Position, charac.HumanoidRootPart.Position, params)
    if ray and ray.Instance and (ray.Instance:IsA("BasePart") and not game.Players:FindFirstChild(ray.Instance:FindFirstAncestorWhichIsA("Model").Name)) then
        return true
    elseif ray == nil then
        return false
    end
end
local function aim()
    print(isBehindWall(getClosest(camera.CFrame)))
	if isBehindWall(getClosest(camera.CFrame)) ~= true then
		camera.CFrame = CFrame.lookAt(player.Character.Head.Position, getClosest(camera.CFrame).Character.Head.Position)
	end
end
c=uis.InputBegan:Connect(function(inp)
	if inp.KeyCode == Enum.KeyCode.U then
		aim()
	end
end)
