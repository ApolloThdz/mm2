loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))().MakeWindow({Name="Dexins",HidePremium=false,SaveConfig=true,ConfigFolder="OrionTest",IntroText="Dexins Hub Loading...",IntroIcon="rbxassetid://16924654288",Icon="rbxassetid://16924654288"}):MakeTab({Name="Main",Icon="rbxassetid://16924656716",PremiumOnly=false}):AddSection({Name="Esp and Tracers"}):AddToggle({Name="ESP Toggle",Default=false,Callback=function(enabled)ESPEnabled=enabled;if enabled then for _,player in pairs(game:GetService("Players"):GetPlayers())do if player~=game.Players.LocalPlayer then local Arrow=Drawing.new("Triangle")Arrow.Visible=false;Arrow.Filled=true;Arrow.Thickness=1;Arrow.Transparency=0.5;local color=player:FindFirstChild("Backpack")and(player.Backpack:FindFirstChild("Knife")and Color3.new(1,0,0))or(player.Backpack:FindFirstChild("Gun")and Color3.new(0,0,1))or Color3.new(1,1,1);Arrow.Color=color;local function Update()local c;c=game:GetService("RunService").RenderStepped:Connect(function()if player and player.Character then local char=player.Character;local humanoid=char:FindFirstChildOfClass("Humanoid")if humanoid and char.PrimaryPart and humanoid.Health>0 then local _,visible=workspace.CurrentCamera:WorldToViewportPoint(char.PrimaryPart.Position)if not visible then local relativePos=workspace.CurrentCamera:WorldToViewportPoint(char.PrimaryPart.Position);local direction=(Vector2.new(relativePos.X,relativePos.Y)-Vector2.new(0.5,0.5)).unit;local base=direction*80;local sideLength=16/2;local baseL=base+Vector2.new(direction.Y,-direction.X)*sideLength;local baseR=base-Vector2.new(direction.Y,-direction.X)*sideLength;local tip=direction*(80+16);Arrow.PointA=Vector2.new(math.round(baseL.X),math.round(baseL.Y));Arrow.PointB=Vector2.new(math.round(baseR.X),math.round(baseR.Y));Arrow.PointC=Vector2.new(math.round(tip.X),math.round(tip.Y));Arrow.Visible=true;else Arrow.Visible=false;end else Arrow.Visible=false;end else Arrow.Visible=false;if not player or not player.Parent then Arrow:Remove();c:Disconnect();end end end)end;coroutine.wrap(Update)()end end end end end)
