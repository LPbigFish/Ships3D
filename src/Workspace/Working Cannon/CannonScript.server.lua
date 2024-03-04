local rep = game:GetService("ReplicatedStorage")
local debris = game:GetService("Debris")
local fastcast = require(game:GetService("ServerScriptService").Dependencies.FastCastRedux)

local cannon = workspace["Working Cannon"]
local cannonball = rep.CannonBall

local caster = fastcast.new()
local behavior = fastcast.newBehavior()
local blocking = false

local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Exclude
params.FilterDescendantsInstances = {cannon}

behavior.RaycastParams = params

behavior.Acceleration = Vector3.new(0, -20, 0)
behavior.AutoIgnoreContainer = false
behavior.CanPierceFunction = (function(cast, result, segmentVelocity)
	local result: Part = result.Instance
	if result:FindFirstChild("Value") then
		local value: StringValue = result:FindFirstChild("Value")
		return	value.Value == "Destroyable"
	end
	return false
end)
behavior.CosmeticBulletTemplate = rep.CannonBall
behavior.CosmeticBulletContainer = workspace.Projectiles

caster.LengthChanged:Connect(function(ActiveCast, lastPoint: Vector3, rayDir: Vector3, displacement: number, segmentVelocity: Vector3, cosmeticBulletObject: Part) 
	local newpos = CFrame.new(lastPoint + (rayDir * displacement)) * CFrame.Angles(rayDir.X, rayDir.Y, rayDir.Z)

	cosmeticBulletObject.CFrame = newpos
end)

caster.RayPierced:Connect(function(ActiveCast, RaycastResult: RaycastResult, segmentVelocity, cosmeticBulletObject: Part)
	--local explosion = Instance.new("Explosion")
	--explosion.BlastRadius = 1
	--explosion.Position = RaycastResult.Position
	--explosion.Parent = workspace

	--debris:AddItem(explosion, 0.2)
	if not blocking then
		blocking = true
		local explosion = Instance.new("Explosion")
		explosion.Parent = workspace
		explosion.BlastRadius = 1
		explosion.Position = RaycastResult.Position
		debris:AddItem(explosion, 2)
		
		local negative = rep.NegativePart:Clone()
		negative.Parent = workspace
		negative.Position = RaycastResult.Position
		negative.Rotation = cosmeticBulletObject.Rotation
		negative.Size *= Vector3.new(2.2, 1, 1)
		shared["hole_maker"](RaycastResult.Instance, negative)
		negative.Size /= Vector3.new(2.2, 1, 1)
		negative:Destroy()
		task.wait(0.2)
		blocking = false
	end
end)

while true do
	wait(3)

	local goalpos = cannon.Cannon["Shootin Part"].CFrame * CFrame.new(0, -50, 0)
	local dir = (goalpos.Position - cannon.Cannon["Shootin Part"].Position).Unit

	caster:Fire(cannon.Cannon["Shootin Part"].Attachment.WorldPosition, dir, 100, behavior)

	wait(1.5)

	cannon.Cannon:PivotTo(cannon.Cannon.PrimaryPart.CFrame * CFrame.Angles(0, 0, math.rad(15)))
end