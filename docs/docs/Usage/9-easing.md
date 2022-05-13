# Easing

Canim exposes a table called `CanimEasing` which contains easing functions. They are taken from the same library Roblox uses. You can also define your own functions if you wish.

```ts
animator = new Canim();
// everything fading out will now use back_out easing
// the default is quad_in_out
animator.fadeout_easing = CanimEasing.back_out
```