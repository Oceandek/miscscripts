local daycareCmds = require(game:GetService("ReplicatedStorage").Library.Client.DaycareCmds)
local network = require(game:GetService("ReplicatedStorage").Library.Client.Network)

for i = 1, (30 - daycareCmds.GetMaxSlots()) do
    network.Invoke("DaycareSlotVoucher_Consume")
end
