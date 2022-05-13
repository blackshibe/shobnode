# Rebasing

Canim introduces 2 properties: CanimTrack.rebase_target and CanimTrack.rebase_basis

The general behavior is that specifying both properties is proper rebasing, while only specifying rebase_target gives you animation overlap.

I will bring out a custom rig for this one, as well as a few animations.

UMP45 & PP19. We will use the idle for both rigs to bring the Reload and Magcheck from one to the other.
![rig1](img/rig.png)

UMP45 Magcheck
![type:video](video/magcheck.mp4)

UMP45 Reload
![type:video](video/reload.mp4)

For this to work, several conditions must be met:

-   **currently, for every motor6d in the rig, its local axis' must be the same, or similiar between rigs.**
    this means that if we translate each motor6d transform by CFrame(1, 0, 0). both must move in the same direction.
-   **the part1 of every motor6d must be the same between rigs.**
    this essentially means both rigs must be structurally similiar.

Let's try some code I wrote:
```ts
// We will try getting the animation from the UMP45 to play on the PP19
let reload = animator.load_animation("reload", 2, "rbxassetid://9049365997");
let check = animator.load_animation("check", 2, "rbxassetid://9049352527");
reload.finished_loading.Wait();
check.finished_loading.Wait();

let from = animator.load_pose("from", 1, "rbxassetid://9323658024");
let to = animator.load_pose("to", 1, "rbxassetid://9005865007");

// the looped property on the animations I imported is assigned randomly, so I make sure they don't loop
reload.looped = false;
check.looped = false;

game.GetService("UserInputService").InputBegan.Connect((input) => {
	if (input.KeyCode === Enum.KeyCode.R) {
		print("playing reload");
		animator.play_animation("reload");
	} else if (input.KeyCode === Enum.KeyCode.E) {
		print("playing check");
		animator.play_animation("check");
	} else if (input.KeyCode === Enum.KeyCode.Z) {
		print("removed rebasing!");
		check.rebase_basis = undefined;
		check.rebase_target = undefined;
		reload.rebase_basis = undefined;
		reload.rebase_target = undefined;
	} else if (input.KeyCode === Enum.KeyCode.X) {
		print("setup rebasing!");
		check.rebase_basis = from;
		check.rebase_target = to;
		reload.rebase_basis = from;
		reload.rebase_target = to;
	}
});

animator.play_pose("to");

game.GetService("RunService").RenderStepped.Connect((delta_time) => {
	animator.update(delta_time);
	// irrelevant...
	let offset = character.WaitForChild("offsets").WaitForChild("idle") as CFrameValue;
	character.SetPrimaryPartCFrame(game.GetService("Workspace").CurrentCamera!.CFrame.ToWorldSpace(offset.Value));
});

```

![type:video](video/new-properties-rebase.mp4)

Without rebasing, the idle position that both animations start out in is completely wrong. After rebasing they are better. This demonstrates the limitations; 
the UMP45 and PP19 have very different resting positions for the left arm, however the animation still runs seamlessly, although with different resulting rotation. The same applies to the gun root's position and rotation.