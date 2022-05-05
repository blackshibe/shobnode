# Luau

Imagine using Luau

```lua
local Canim = require(path.to.canim).Canim

-- R15 default dummy
local character = game:GetService("Workspace"):WaitForChild("dummy")
local animator = Canim.new()

animator:assign_model(character)

-- loading poses is the same, but only the 1st keyframe is used.
local animation = animator:load_animation("dance", 1, "rbxassetid://507771019")
animation.finished_loading:Wait()

-- automatic retrying is not implemented
if not animation.sequence then
	error("animation couldn't load")
end

-- the animation will play with lowered rotation and with unaffected position
animation.looped = true
animation.bone_weights.__CANIM_DEFAULT_BONE_WEIGHT = { { 1, 1, 1 }, { 0.5, 0.5, 0.5 } }
animation.keyframe_reached:Connect(function(name)
	print("marker reached:", name)
end)
animation.started:Connect(function()
	print("started")
end)
animation.finished:Connect(function()
	print("finished")
end)

animator:play_animation("dance")

game:GetService("RunService").RenderStepped:Connect(function(delta_time)
	animator:update(delta_time)
end)

```
