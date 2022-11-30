# shobnode

Simple declarative debugging library with an imperative interface for Roblox projects used extensively in Deadline.

## examples

```ts
// imperative
import { Shobnode } from "@rbxts/shobnode";

Shobnode.setup();
Shobnode.display_variable(1, `Hello world, I will appear in the top left corner of the screen.`);
Shobnode.display_variable(2, `Hello world.`);

LogService.MessageOut.Connect((message, _type) => {
	Shobnode.log(message, _type);
});
```

```ts
import { Shobnode } from "@rbxts/shobnode";

const catch_error_while = (reason: string, func: () => void, err_occured?: () => void) => {
	xpcall(func, (err) => {
		let data: string[] = [
			`something went very wrong while ${reason}`,
			"please let the developers know about the following:",
			"",
		];

		print(err);

		(err as string).split("\n").forEach((element) => data.push(element));
		data.push("this error will disappear in 20 seconds.");
		Shobnode.display_node(100, new UDim2(0.5, 0, 0.5, 0), data, new Color3(1, 0, 0), true);

		task.delay(20, () => {
			Shobnode.display_node(100, new UDim2(), []);
		});
		err_occured?.();
	});
};

catch_error_while(
	"doing something important",
	() => {
		throw "oops";
	},
	() => {
		print("I'm handling it");
	}
);
```

```tsx
// declarative - hoarcekat story
import Roact from "@rbxts/roact";
import ShobnodeNode from "@rbxts/shobnode/out/ui/ShobnodeNode";
import ShobnodeTable from "@rbxts/shobnode/out/ui/ShobnodeTable";

export = (target: Instance) => {
	let sheet = Roact.mount(
		<frame>
			<ShobnodeTable position={new UDim2()} header={"Header"} data={["data", "lol", "hi", () => {}]} />
			<ShobnodeNode
				data={["line 1", "line 2"]}
				position={Roact.createBinding(new UDim2(0.5, 0, 0.5, 100))[0]}
				color={new Color3(1, 0, 0)}
			/>
		</frame>,
		target
	);
	return () => Roact.unmount(sheet);
};
```
