!!! info
    I give no guarantees about the amount of bugs in this library.<br/>
    While it works without issues in production, there may be problems I am unaware of.<br/>
    If you have questions or issues, feel free to contact me on Discord (Black Shibe#4208)

canim is a roblox-ts written library that allows you to have more control over your animations.

## Features

-   #### Animation overlap

    Canim lets you play multiple animations on top of each other if they are rebased. You can see this implemented in [Deadline](https://www.roblox.com/games/3837841034/0-21-1-Deadline), for example when using the radio and shooting at the same time.

-   #### Rebasing

    Deadline reuses magcheck and radio-hold pose animations for multiple weapons easily using animation rebasing. This lets you cut down on time spent animating things.

-   #### Infinite animation priorities

    I honestly couldn't tell you why Roblox doesn't implement this already. <br/>
    Animations are sorted based off of number priority, not an Enum with 4 possible values.

-   #### Editing animations at runtime

    You can create, import or edit animations when the game is running without having to reupload them.

-   #### Preloading animations

    All animations are loaded with a lookup table. You can call it for every needed animation when the game is loading to ensure everything plays instantly after.

-   #### Separation of concerns

    Animations are split into Tracks and Poses. Poses only play a single keyframe to increase performance.

-   #### Non-linear easing

    Animations fade out with quad in-out easing instead of ugly linear easing.

-   #### Per-axis blending

    You can do this:

    ```ts
    // the animation will play with lowered rotation and with unaffected position
    animation.bone_weights.__CANIM_DEFAULT_BONE_WEIGHT = [
    	// x y z
    	[1, 1, 1],
    	// rx ry rz
    	[0.5, 0.5, 0.5],
    ];
    ```

## Caveats

-   #### Performance

    I have not tested how fast the default roblox animator is. Canim flattens the motor structure in order to make lookups when animating faster, but this may break rigs that have multiple Motor6D instances with the same name.

-   #### Lack of throttling

    Canim does not implement animator throttling.

-   #### Easing

    Canim does not implement any other easing than linear at the moment, considering it is designed to be played with animations exported from blender. This is very easy to implement yourself.
