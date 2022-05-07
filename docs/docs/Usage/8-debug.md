# Debug

If you are confused about what the animator is currently playing, you can use the Canim.debug property.

```ts
const some_label = LocalPlayer.PlayerGui.ScreenGui.TextLabel

game.GetService("RunService").RenderStepped.Connect((delta_time) => {
	animator.update(delta_time);
	some_label.Text = game.GetService("HttpService").JSONEncode(animator.debug);
});
```

![type:video](video/debug.mp4)
