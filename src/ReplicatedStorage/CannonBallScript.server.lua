local blocking = false

game:GetService("RunService").Heartbeat:Connect(function(deltaTime: number) 
	script.Parent.NegativePart.CFrame = script.Parent.CFrame
end)

script.Parent.Touched:Connect(function(otherPart: BasePart)	
	if not blocking then
		blocking = true
		script.Parent.NegativePart.Size *= Vector3.new(2.2, 1.2, 1.2)
		shared["hole_maker"](otherPart, script.Parent.NegativePart)
		script.Parent.NegativePart.Size /= Vector3.new(2.2, 1.2, 1.2)
		task.wait(0.001)
		blocking = false
	end
end)