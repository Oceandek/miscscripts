local player = game.Players.LocalPlayer
local remote = game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("World3Teleport")

if game.PlaceId == 17503543197 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Oceandek/miscscripts/main/ps99source.lua"))()
else
    local result = remote:InvokeServer()
end
