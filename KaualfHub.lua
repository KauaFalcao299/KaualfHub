-- // Kaualf Hub Completo no Rayfield
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Função de notificação Rayfield + nativa
local function Notify(title, text)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 3
    })
end

-- Carregar Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🎯 Kaualf Hub",
   LoadingTitle = "Carregando Hub...",
   LoadingSubtitle = "by Kaualf",
   Theme = "Default",
   DisableRayfieldPrompts = true,
   DisableBuildWarnings = false,
   ConfigurationSaving = {Enabled = false},
})

-- ===================================================
-- 👥 JOGADORES
-- ===================================================
local TabPlayers = Window:CreateTab("👥 Jogadores")

local SelectedPlayer = nil
local BubbleMessage = ""

-- Dropdown de jogadores
local DropPlayers = TabPlayers:CreateDropdown({
   Name = "🎯 Selecionar Jogador",
   Options = {},
   CurrentOption = {},
   Callback = function(option)
      SelectedPlayer = option[1]
   end,
})

local function RefreshPlayers()
   local names = {}
   for _,plr in ipairs(Players:GetPlayers()) do
      table.insert(names, plr.Name)
   end
   if #names == 0 then names = {"Ninguém"} end
   DropPlayers:Refresh(names, {names[1]})
   SelectedPlayer = names[1]
end

RefreshPlayers()
Players.PlayerAdded:Connect(RefreshPlayers)
Players.PlayerRemoving:Connect(RefreshPlayers)

local function GetTarget()
   return Players:FindFirstChild(SelectedPlayer)
end

-- Função para criar botão de jogador
local function CreatePlayerButton(name, callback)
    TabPlayers:CreateButton({Name = name, Callback = callback})
end

-- 🔨BAN (tenta ban real, se erro deixa invisível)
CreatePlayerButton("🔨BAN", function()
    local t = GetTarget()
    if t then
        local success, err = pcall(function()
            t:Kick("Você foi banido pelo Kaualf Hub!")
        end)
        if not success then
            -- Deixa invisível se não conseguir kickar
            if t.Character then
                for _,part in ipairs(t.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 1
                        if part:FindFirstChild("face") then part.face:Destroy() end
                    end
                end
            end
        end
        Notify("Kaualf Hub", t.Name.." foi banido!")
    else
        Notify("Kaualf Hub", "Jogador não encontrado")
    end
end)

-- Outros botões jogadores
CreatePlayerButton("Kill ☠️", function()
    local t = GetTarget()
    if t and t.Character and t.Character:FindFirstChild("Humanoid") then
        t.Character.Humanoid.Health = 0
        Notify("Kaualf Hub", t.Name.." foi morto!")
    end
end)

CreatePlayerButton("TP ↔️", function()
    local t = GetTarget()
    if t and t.Character and LocalPlayer.Character then
        t.Character:MoveTo(LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(3,0,0))
        Notify("Kaualf Hub", t.Name.." teleportado até você!")
    end
end)

CreatePlayerButton("Se TP 🔄", function()
    local t = GetTarget()
    if t and t.Character and LocalPlayer.Character then
        LocalPlayer.Character:MoveTo(t.Character.HumanoidRootPart.Position + Vector3.new(3,0,0))
        Notify("Kaualf Hub", "Você foi até "..t.Name)
    end
end)

CreatePlayerButton("Congelar 🧊", function()
    local t = GetTarget()
    if t and t.Character then
        for _,p in pairs(t.Character:GetChildren()) do if p:IsA("BasePart") then p.Anchored = true end end
        Notify("Kaualf Hub", t.Name.." congelado!")
    end
end)

CreatePlayerButton("Descongelar 🔓", function()
    local t = GetTarget()
    if t and t.Character then
        for _,p in pairs(t.Character:GetChildren()) do if p:IsA("BasePart") then p.Anchored = false end end
        Notify("Kaualf Hub", t.Name.." descongelado!")
    end
end)

CreatePlayerButton("Fogo 🔥", function()
    local t = GetTarget()
    if t and t.Character then
        for _,p in pairs(t.Character:GetChildren()) do
            if p:IsA("BasePart") then
                local fire = Instance.new("Fire")
                fire.Size = 5
                fire.Heat = 10
                fire.Parent = p
            end
        end
        Notify("Kaualf Hub", t.Name.." em chamas!")
    end
end)

CreatePlayerButton("Neve ❄️", function()
    local t = GetTarget()
    if t and t.Character then
        for _,p in pairs(t.Character:GetChildren()) do
            if p:IsA("BasePart") then
                local emitter = Instance.new("ParticleEmitter")
                emitter.Texture = "rbxassetid://241594504"
                emitter.Rate = 20
                emitter.Lifetime = NumberRange.new(1,2)
                emitter.Parent = p
            end
        end
        Notify("Kaualf Hub", t.Name.." coberto de neve!")
    end
end)

CreatePlayerButton("Explodir 💥", function()
    local t = GetTarget()
    if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
        local exp = Instance.new("Explosion")
        exp.Position = t.Character.HumanoidRootPart.Position
        exp.BlastRadius = 10
        exp.Parent = workspace
        Notify("Kaualf Hub", t.Name.." explodiu!")
    end
end)

CreatePlayerButton("Sentar 🪑", function()
    local t = GetTarget()
    if t and t.Character and t.Character:FindFirstChild("Humanoid") then
        t.Character.Humanoid.Sit = true
        Notify("Kaualf Hub", t.Name.." sentou!")
    end
end)

CreatePlayerButton("Levitar 🕊️", function()
    local t = GetTarget()
    if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
        t.Character.HumanoidRootPart.Anchored = true
        Notify("Kaualf Hub", t.Name.." levitando!")
    end
end)

-- Prender com modelo Toolbox
CreatePlayerButton("Prender ⛓️", function()
    local t = GetTarget()
    if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
        local model = game:GetObjects("rbxassetid://6414409964")[1]
        model.Parent = workspace
        model:SetPrimaryPartCFrame(t.Character.HumanoidRootPart.CFrame)
        Notify("Kaualf Hub", t.Name.." foi preso!")
    end
end)

CreatePlayerButton("Desprender 🔓", function()
    for _,obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj.Name == "Cage" then obj:Destroy() end
    end
    Notify("Kaualf Hub", "Todas as prisões removidas!")
end)

-- Bubble Chat
local TextBoxMsg = TabPlayers:CreateInput({
    Name = "💬 Mensagem BubbleChat",
    PlaceholderText = "Digite a mensagem...",
    RemoveTextAfterFocusLost = false,
    Callback = function(value) BubbleMessage = value end
})

TabPlayers:CreateButton({
    Name = "Enviar 💬",
    Callback = function()
        local t = GetTarget()
        if t and t.Character and t.Character:FindFirstChild("Head") and BubbleMessage ~= "" then
            game:GetService("Chat"):Chat(t.Character.Head, BubbleMessage, Enum.ChatColor.White)
            Notify("Kaualf Hub", "Mensagem enviada para "..t.Name)
        else
            Notify("Kaualf Hub", "Jogador inválido ou mensagem vazia")
        end
    end
})

-- ===================================================
-- 🙋 VOCÊ
-- ===================================================
local TabYou = Window:CreateTab("🙋 Você")

TabYou:CreateButton({Name = "Invisível 👻", Callback = function()
   if LocalPlayer.Character then
      for _,p in ipairs(LocalPlayer.Character:GetDescendants()) do
         if p:IsA("BasePart") then p.Transparency = 1 end
         if p:IsA("Decal") and p.Name == "face" then p:Destroy() end
      end
      Notify("Kaualf Hub", "Você ficou invisível!")
   end
end})

TabYou:CreateButton({Name = "God Mode 🛡️", Callback = function()
   if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
      LocalPlayer.Character.Humanoid.MaxHealth = math.huge
      LocalPlayer.Character.Humanoid.Health = math.huge
      Notify("Kaualf Hub", "God Mode ativado!")
   end
end})

TabYou:CreateSlider({
    Name = "Super Jump ⬆️",
    Range = {50,300},
    Increment = 10,
    CurrentValue = 50,
    Callback = function(v)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = v
        end
    end
})

TabYou:CreateSlider({
    Name = "WalkSpeed 🏃",
    Range = {16,200},
    Increment = 5,
    CurrentValue = 16,
    Callback = function(v)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = v
        end
    end
})

TabYou:CreateSlider({
    Name = "Gravity 🌌",
    Range = {0,200},
    Increment = 5,
    CurrentValue = 196.2,
    Callback = function(v)
        workspace.Gravity = v
        Notify("Kaualf Hub", "Gravidade ajustada para "..v)
    end
})

-- ===================================================
-- 🔮 EXTRAS / TROLLS
-- ===================================================
local TabExtra = Window:CreateTab("🔮 Extras / Trolls")

TabExtra:CreateButton({Name = "Explosão Global 🌍", Callback = function()
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local exp = Instance.new("Explosion")
            exp.Position = plr.Character.HumanoidRootPart.Position
            exp.BlastRadius = 10
            exp.Parent = workspace
        end
    end
    Notify("Kaualf Hub", "Explosão Global!")
end})

TabExtra:CreateButton({Name = "Loop Kill 🔂", Callback = function()
    local t = GetTarget()
    if t and t.Character and t.Character:FindFirstChild("Humanoid") then
        spawn(function()
            while t and t.Character and t.Character:FindFirstChild("Humanoid") do
                t.Character.Humanoid.Health = 0
                task.wait(1)
            end
        end)
        Notify("Kaualf Hub", "Loop Kill iniciado para "..t.Name)
    end
end})

TabExtra:CreateButton({Name = "Teleportar Todos 🔀", Callback = function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                plr.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(math.random(2,5),0,math.random(2,5))
            end
        end
        Notify("Kaualf Hub", "Todos teleportados!")
    end
end})

TabExtra:CreateButton({Name = "Mensagem Global 📢", Callback = function()
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("Head") then
            game:GetService("Chat"):Chat(plr.Character.Head, "Oi do Kaualf Hub!", Enum.ChatColor.White)
        end
    end
    Notify("Kaualf Hub", "Mensagem Global enviada!")
end})

TabExtra:CreateButton({Name = "Confetti Party 🎉", Callback = function()
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local emitter = Instance.new("ParticleEmitter")
            emitter.Texture = "rbxassetid://241594504"
            emitter.Lifetime = NumberRange.new(1,2)
            emitter.Rate = 100
            emitter.Parent = plr.Character.HumanoidRootPart
        end
    end
    Notify("Kaualf Hub", "Festa de confete!")
end})

TabExtra:CreateButton({Name = "Abrir Comandos ADMIN ⚡", Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end})

TabExtra:CreateButton({Name = "Abrir Dark Spawner 🌱", Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/iwantsom3/script/refs/heads/main/Gag"))()
end})

TabExtra:CreateButton({Name = "Abrir Trax Spawner 🧠", Callback = function()
    loadstring(game:HttpGet("https://gitlab.com/traxscriptss/traxscriptss/-/raw/main/visual2.lua"))()
end})

Rayfield:LoadConfiguration()
