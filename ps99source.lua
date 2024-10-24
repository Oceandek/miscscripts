getgenv().Config = {
    ["Farming"] = {
        ["AutoEvents"] = {"Party Box", "Mini Pinata", "Mini Lucky Block"},
        ["AutoOpen"] = {"Gift Bag", "Large Gift Bag", "Mini Chest", "Diamond Gift Bag"},
        ["AutoPotions"] = {"Diamonds", "Damage", "Walkspeed", "Treasure Hunter", "Coins"},
        ["AutoFlags"] = {"Fortune Flag"}
    },
    ["Webhook"] = {
        ["HugeURL"] = "https://discord.com/api/webhooks/1259237758107390022/6NMO4uAN-SQkoZokNhNR_dbWjtopaB04iIjJc14Poq4HdhWL1qHG82ojs-eQRVwZQVk0",
        ["StatsURL"] = "https://discord.com/api/webhooks/1287486380699816137/_p4nTBgXaqCO3smLf5a0VkYC7ysdX-nEcWyHj-d_fdgmpaCRgiKSNLEJiw0OHhLTcJUQ",
        ["UserID"] = "683695252481245216",
        ["SendEvery"] = 15
    },
    ["Misc"] = {
        ["AutoDaycare"] = true,
        ["UltraFPS"] = true,
        ["AutoBuyAllSlots"] = true,
        ["EquipEnchants"] = {"Diamonds", "Diamonds", "Coins", "Fortune", "Criticals", "Huge Hunter", "Treasure Hunter", "Shiny Hunter", "Treasure Hunter"},
        },
    ["Elemental"] = {
        ["AutoBuyCubes"] = {"Ultra Pet Cube"},
        ["AutoTrainerQuests"] = true,
        ["AutoFarmChest"] = false,
    },
    ["AutoMailUser"] = "Fastmocean"
}
loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/2bdebaf848a6be382ed338dad329aaf2.lua"))()
