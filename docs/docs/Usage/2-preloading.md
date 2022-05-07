# Preloading

If you have multiple animations, It might be a good idea to preload them. Take a look at this script:

```ts
let character = game.GetService("Workspace").WaitForChild("dummy") as Model;
let animator = new Canim();
animator.assign_model(character);

// taken from the R15 Animate script
const animations = [
	"rbxassetid://507766666",
	"rbxassetid://507766951",
	"rbxassetid://507766388",
	"rbxassetid://507777826",
	"rbxassetid://507767714",
	"rbxassetid://507784897",
	"rbxassetid://507785072",
	"rbxassetid://507776879",
	"rbxassetid://507777268",
	"rbxassetid://507777451",
	"rbxassetid://507777623",
	"rbxassetid://507770818",
	"rbxassetid://507770677",
];

animations.forEach((element) => {
	print("loading", element);
	let start = tick();
	cache_get_keyframe_sequence(element);
	print(tick() - start, "to load");
});

// the idea is that we take a few animations, load them, and them play them for a few seconds each
let loaded: CanimTrack[] = [];
animations.forEach((element) => {
	let start = tick();
	let track = animator.load_animation(tostring(math.random()), 1, element);
	loaded.push(track);
	print(tick() - start, "to load");
});

game.GetService("RunService").RenderStepped.Connect((delta_time) => {
	animator.update(delta_time);
});

while (true) {
	loaded.forEach((element) => {
		element.looped = true;
		print("playing", element.name);
		animator.play_animation(element.name);
		wait(3);
		animator.stop_animation(element.name);
		wait(2);
	});
}

```

You can see that the first time the animations load takes considerably more time. We first `cache_get` every single keyframe sequence we want;
```ts
// taken from the R15 Animate script
const animations = [
	"rbxassetid://507766666",
	"rbxassetid://507766951",
	"rbxassetid://507766388",
	"rbxassetid://507777826",
	"rbxassetid://507767714",
	"rbxassetid://507784897",
	"rbxassetid://507785072",
	"rbxassetid://507776879",
	"rbxassetid://507777268",
	"rbxassetid://507777451",
	"rbxassetid://507777623",
	"rbxassetid://507770818",
	"rbxassetid://507770677",
];

animations.forEach((element) => {
	print("loading", element);
	let start = tick();
	cache_get_keyframe_sequence(element);
	print(tick() - start, "to load");
});
```

Now, every animation we load that has one of the preloaded IDs will load instantly, and we will not have to wait for the event. We can then

```ts
let loaded: CanimTrack[] = [];
animations.forEach((element) => {
	let start = tick();
	let track = animator.load_animation(tostring(math.random()), 1, element);
	loaded.push(track);
	print(tick() - start, "to load");
});

game.GetService("RunService").RenderStepped.Connect((delta_time) => {
	animator.update(delta_time);
});
```

![type:video](video/basic-loading-anim.mp4)