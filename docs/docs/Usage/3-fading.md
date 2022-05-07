# Fading

animations fade out faster or slower depending on the fade_time property. It's not dynamic, meaning changing it after the animation stops will have no effect until the next time it's stopped.
Additionally, the fadeout jumps if another animation stops when the first is not done fading out.
You can disable fading with `CanimTrack.transition_disable_all`

!!! caution
	currently, fadeout is unstable on rebased tracks. 

```ts
let track = animator.load_animation("main", 1, "rbxassetid://507766666");
track.fade_time = 0.25;
track.looped = false;

// demonstrate the fade-out
animator.play_animation("main");
track.finished.Connect(() => {
	wait(2);
	animator.play_animation("main");
});
```

![type:video](video/new-properties-fade-time.mp4)


