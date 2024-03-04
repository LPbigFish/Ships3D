shared["hole_maker"] = function(touched: Part, extruder: Part)
	print("trying to sub")
	local success, new_sub = pcall(function() 
		return touched:SubtractAsync({ extruder })
	end)
	
	if success and new_sub then
		new_sub.Position = touched.Position
		new_sub.Parent = touched.Parent
		new_sub.Name = touched.Name
		for i,v in pairs(touched:GetChildren()) do
			v.Parent = new_sub
		end
	end
	
	touched:Destroy()
end