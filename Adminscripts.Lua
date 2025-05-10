local Players = game:GetService("Players")
local flyingPlayers = {}
local frozenPlayers = {}
local bannedPlayers = {}

-- プレイヤーの飛行を有効にする
local function enableFly(player)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local humanoid = player.Character.Humanoid
        humanoid.PlatformStand = true
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = player.Character.HumanoidRootPart
        flyingPlayers[player.UserId] = bodyVelocity

        game:GetService("RunService").Heartbeat:Connect(function()
            if flyingPlayers[player.UserId] then
                local moveDirection = player.Character.Humanoid.MoveDirection
                bodyVelocity.Velocity = moveDirection * 50 + Vector3.new(0, 50, 0)
            end
        end)
    end
end

-- プレイヤーの飛行を無効にする
local function disableFly(player)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local humanoid = player.Character.Humanoid
        humanoid.PlatformStand = false
        if flyingPlayers[player.UserId] then
            flyingPlayers[player.UserId]:Destroy()
            flyingPlayers[player.UserId] = nil
        end
    end
end

-- プレイヤーをキック
local function kickPlayer(player)
    player:Kick("You have been kicked!")
end

-- プレイヤーをバン
local function banPlayer(player)
    table.insert(bannedPlayers, player.UserId)
    player:Kick("You have been banned!")
end

-- プレイヤーのバン解除
local function unbanPlayer(player)
    for i, bannedId in ipairs(bannedPlayers) do
        if bannedId == player.UserId then
            table.remove(bannedPlayers, i)
            break
        end
    end
end

-- プレイヤーをキル
local function killPlayer(player)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.Health = 0
    end
end

-- プレイヤーを凍結
local function freezePlayer(player)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.HumanoidRootPart.Anchored = true
        frozenPlayers[player.UserId] = true
    end
end

-- プレイヤーの凍結解除
local function unfreezePlayer(player)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.HumanoidRootPart.Anchored = false
        frozenPlayers[player.UserId] = nil
    end
end

-- プレイヤーのスピード変更
local function changeSpeed(player, speed)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = speed
    end
end

-- プレイヤーを透明にする
local function setInvisible(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.Transparency = 1
    end
end

-- プレイヤーを透明解除する
local function setVisible(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.Transparency = 0
    end
end

-- プレイヤーを自分の位置に移動
local function bringPlayer(player)
    if player.Character then
        player.Character:SetPrimaryPartCFrame(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
    end
end

-- プレイヤーの体力を回復
local function healPlayer(player)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.Health = player.Character.Humanoid.MaxHealth
    end
end

-- !fly コマンド
local function handleFlyCommand(player)
    if flyingPlayers[player.UserId] then
        disableFly(player)
    else
        enableFly(player)
    end
end

-- !invisible コマンド
local function handleInvisibleCommand(player, args)
    if args[2] == "all" then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player then
                setInvisible(p)
            end
        end
    elseif args[2] then
        local target = Players:FindFirstChild(args[2])
        if target then
            setInvisible(target)
        end
    else
        setInvisible(player)
    end
end

-- !uninvisible コマンド
local function handleUninvisibleCommand(player, args)
    if args[2] == "all" then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player then
                setVisible(p)
            end
        end
    elseif args[2] then
        local target = Players:FindFirstChild(args[2])
        if target then
            setVisible(target)
        end
    else
        setVisible(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(msg)
        local args = string.split(msg, " ")
        local cmd = args[1]:lower()

        if cmd == "!fly" then
            handleFlyCommand(player)
        elseif cmd == "!kick" then
            if args[2] == "all" then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player then
                        kickPlayer(p)
                    end
                end
            else
                local target = Players:FindFirstChild(args[2])
                if target then
                    kickPlayer(target)
                end
            end
        elseif cmd == "!ban" then
            if args[2] == "all" then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player then
                        banPlayer(p)
                    end
                end
            else
                local target = Players:FindFirstChild(args[2])
                if target then
                    banPlayer(target)
                end
            end
        elseif cmd == "!unban" then
            if args[2] == "all" then
                for _, p in ipairs(Players:GetPlayers()) do
                    unbanPlayer(p)
                end
            else
                local target = Players:FindFirstChild(args[2])
                if target then
                    unbanPlayer(target)
                end
            end
        elseif cmd == "!kill" then
            if args[2] == "all" then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player then
                        killPlayer(p)
                    end
                end
            else
                local target = Players:FindFirstChild(args[2])
                if target then
                    killPlayer(target)
                end
            end
        elseif cmd == "!freeze" then
            if args[2] == "all" then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player then
                        freezePlayer(p)
                    end
                end
            else
                local target = Players:FindFirstChild(args[2])
                if target then
                    freezePlayer(target)
                end
            end
        elseif cmd == "!unfreeze" then
            if args[2] == "all" then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player then
                        unfreezePlayer(p)
                    end
                end
            else
                local target = Players:FindFirstChild(args[2])
                if target then
                    unfreezePlayer(target)
                end
            end
        elseif cmd == "!speed" then
            local speed = tonumber(args[3])
            if args[2] == "all" then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player then
                        changeSpeed(p, speed)
                    end
                end
            else
                local target = Players:FindFirstChild(args[2])
                if target then
                    changeSpeed(target, speed)
                end
            end
        elseif cmd == "!invisible" then
            handleInvisibleCommand(player, args)
        elseif cmd == "!uninvisible" then
            handleUninvisibleCommand(player, args)
        elseif cmd == "!bring" then
            local target = Players:FindFirstChild(args[2])
            if target then
                bringPlayer(target)
            end
        elseif cmd == "!heal" then
            healPlayer(player)
        end
    end)
end)
