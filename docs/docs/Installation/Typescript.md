# Typescript


TODO: Publish the package

simply run `npm i @rbxts/canim` inside a roblox-ts project.

You should be able to use canim now:

```ts
import { Canim } from "@rbxts/canim";

// R15 default dummy
let character = game.GetService("Workspace").WaitForChild("dummy") as Model;
let animator = new Canim();
animator.assign_model(character);

// loading poses is the same, but only the 1st keyframe is used.
let animation = animator.load_animation("dance", 1, "rbxassetid://507771019");
animation.finished_loading.Wait();

// the animation will play with lowered rotation and with unaffected position
animation.looped = true;
animation.bone_weights.__CANIM_DEFAULT_BONE_WEIGHT = [
	// x y z
	[1, 1, 1],
	// rx ry rz
	[0.5, 0.5, 0.5],
];

animation.keyframe_reached.Connect((name) => {
	print("marker reached:", name);
});

animation.started.Connect(() => {
	print("started");
});

animation.finished.Connect(() => {
	print("finished");
});

animator.play_animation("dance");
game.GetService("RunService").RenderStepped.Connect((delta_time) => {
	animator.update(delta_time);
});
```
