# Overlapping animations

This is mentioned in the feature list. If you specify rebase_target but not rebase_basis you can play animations on top of each other, as they will be additive.
I'm lazy, so I will reuse animations again, Fire & Magcheck:

![type:video](video/overlapping-animations-fire.mp4)
![type:video](video/overlapping-animations-magcheck.mp4)

# The script

```ts
let fire = animator.load_animation("fire", 2, "rbxassetid://9049341595");
let check = animator.load_animation("check", 2, "rbxassetid://9049352527");
fire.finished_loading.Wait();
check.finished_loading.Wait();

let idle = animator.load_pose("idle", 1, "rbxassetid://9323658024");

// the looped property on the animations I imported is assigned randomly, so I make sure they don't loop
fire.looped = false;
check.looped = false;

game.GetService("UserInputService").InputBegan.Connect((input) => {
	if (input.KeyCode === Enum.KeyCode.R) {
		print("playing reload");
		animator.play_animation("check");
	} else if (input.KeyCode === Enum.KeyCode.Q) {
		print("playing fire");
		animator.play_animation("fire");
	} else if (input.KeyCode === Enum.KeyCode.Z) {
		print("removed rebasing!");
		check.rebase_target = undefined;
		fire.rebase_target = undefined;
	} else if (input.KeyCode === Enum.KeyCode.X) {
		print("setup rebasing!");
		check.rebase_target = idle;
		fire.rebase_target = idle;
	}
});

animator.play_pose("idle");
```

![type:video](video/overlapping-animations-result.mp4)

Without rebase_target, the animations don't play on top of each other.