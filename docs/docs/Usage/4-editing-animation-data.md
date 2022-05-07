# Editing Animation Data

One of the features of canim is editing data on the fly, so let's learn how to do that.

# The concept

Motor6Ds have a property called Transform. It's much cheaper to set than C0 and C1 (around 5x faster) and is intended for animation. We can change the CFrame Canim sets.
I won't get into the math of creating good looking animations here. Instead, as an example, we can break every bone in the dummy's body.  <br/>

Canim parses Instances into a custom Lua table-based structure. The types in the source reflect this:
```ts
type customPose = { name: string; cframe: CFrame; weight: number };
type customKeyframe = { name: string; time: number; children: { [index: string]: customPose } };
type customKeyframeSequence = { name: string; children: customKeyframe[] };
```
KeyframeSequences hold Keyframes, which hold Poses. We can shuffle up the CFrames ourselves.

# The script

```ts
import { cache_get_keyframe_sequence, Canim, CanimTrack } from "@rbxts/canim";

cache_get_keyframe_sequence("rbxassetid://507766666");
print("Hello world");

// R15 default dummy
let character = game.GetService("Workspace").WaitForChild("dummy") as Model;
let animator = new Canim();
animator.assign_model(character);

// I won't bother creating the keyframes themselves. We can just steal a default animation.
let track = animator.load_animation("ouch", 1, "rbxassetid://507766666");
track.looped = true;
track.sequence!.children.forEach((element) => {
	for (const [_, value] of pairs(element.children)) {
		// every pose's cframe will be replaced with a blank CFrame that rotates itself by 1 radian per second.
		value.cframe = new CFrame().mul(CFrame.Angles(1 * element.time, 0, 0));
	}
});

animator.play_animation("ouch");

game.GetService("RunService").RenderStepped.Connect((delta_time) => {
	animator.update(delta_time);
});

```

We create an animation, and iterate over every single child of its keyframe sequence:
```ts
track.sequence!.children.forEach((element) => {
	for (const [_, value] of pairs(element.children)) {
		// every pose's cframe will be replaced with a blank CFrame that rotates itself by 1 radian per second.
		value.cframe = new CFrame().mul(CFrame.Angles(1 * element.time, 0, 0));
	}
});
```

![type:video](video/editing-animation-data.mp4)
