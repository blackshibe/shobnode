# canim

canim is a roblox-ts written library that allows you to have more control over your animations.
Animation library meant for the blender-roblox animation workflow<br/>

## features

-   rebasing
-   integer animation priority
-   editing animations at runtime
-   preloading animations
-   separation of concerns into Tracks and Poses

## usability notice

The library was developed and tested in production in a single game, Deadline.<br/>
While it works without issues, there may be caveats to its usability.<br/>
If you have questions, feel free to contact me on Discord (Black Shibe#4208)

## install

to-be-published on npm, for now use `npm install rbxts-canim-1.0.0.tgz` or a modified version of ./pack.sh

## usage

```lua
-- the TS API is the same.

local animator = Canim.new()

-- scans the rig for bones to cache during renderstepped
animator:assign_model(Instance.new("Model"))

-- poses can't move and only have one keyframe
local pose = self.equipped_data.animator:load_pose("idle", 1, "rbxassetid://0")
self.equipped_data.animator:play_pose("idle")

-- only linear easing is supported with no plans for any other type
local animation = self.equipped_data.animator:load_animation("interaction", 1, "rbxassetid://1")
animation.looped = true

-- default roblox api lacks this(?)
animation.finished_loading:Wait()
self.equipped_data.animator:play_animation("interaction")
```
