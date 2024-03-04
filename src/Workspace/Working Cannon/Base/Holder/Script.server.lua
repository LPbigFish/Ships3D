local toPivot = script.Parent:GetChildren()
local mainPart = script.Parent
local cannon: Model = script.Parent.Parent.Parent.Cannon

for i,v in pairs(toPivot) do
	if v == mainPart then
		continue
	end
	
	if v:IsA("Part") then
		local v: Part = v
		v.PivotOffset = mainPart.PrimaryPart.CFrame:ToObjectSpace(v.CFrame)
	end
end


cannon.Changed:Connect(function(attribute: string) 
	if attribute == "Origin" then
		mainPart:PivotTo(CFrame.new(mainPart.PrimaryPart.Position) * CFrame.Angles(0, math.rad(cannon.PrimaryPart.Orientation.Z + 45), math.rad(90)))
	end
end)


