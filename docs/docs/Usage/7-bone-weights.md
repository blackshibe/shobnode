# Bone Weights

You can change how much different CFrame axis affect the final transform. This property is multipled by the `weight` property additionally.

```ts
let track = animator.load_animation("main", 1, "rbxassetid://507766666");
track.looped = true;

// there is no universal property, so a long name for an index is used
track.bone_weights.__CANIM_DEFAULT_BONE_WEIGHT = [
	// x y z
	[1, 1, 1],
	// rx ry rz
	[0.5, 0.5, 0.5],
];

// the indexes are the names of each Motor6D's .Part1.
// the neck will go insane
track.bone_weights.Head = [
	// x y z
	[1, 1, 1],
	// rx ry rz
	[5, 5, 5],
];

animator.play_animation("main");
```

![type:video](video/new-properties-bone-weights.mp4)

