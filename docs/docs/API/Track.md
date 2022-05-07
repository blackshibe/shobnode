# CanimTrack

The class used for tracks in the library. It shares many similiarities with CanimTrack, however canim avoids inheritance.

## Methods

---

### CanimTrack.load_sequence
```
CanimTrack.load_sequence(id: string | KeyframeSequence): void
```

Loads the AnimationTrack for the track. Does not yield and fires finished_loading when it's finished.

!!! caution
	Canim calls this automatically. There is no reason to do it yourself.

## Events

---

### CanimTrack.keyframe_reached
```
CanimTrack.keyframe_reached: Signal
```

Fires when a named keyframe is stepped over by the animator.

---

### CanimTrack.finished_loading
```
CanimTrack.finished_loading: Signal
```

Fires when the animation finishes loading.

---

### CanimTrack.started
```
CanimTrack.started: Signal
```

Fires when the animation starts.

---

### CanimTrack.finished
```
CanimTrack.finished: Signal
```

Fires when the animation ends.


## Properties


---

### CanimTrack.sequence
```
CanimTrack.sequence?: customKeyframe
```

Contains animation data that Canim interprets. You can edit this to change the animation data.
nil if the animation is unloaded.

---

### CanimTrack.bone_weights
```
CanimTrack.bone_weights: { [index: string]: number | undefined } = {};
```

Controls how much individual axis of individual Motor6D Transforms are affected by this animation. <br/>
you can use `__CANIM_DEFAULT_BONE_WEIGHT` for the index to affect all bones:
```ts
    animation.bone_weights.__CANIM_DEFAULT_BONE_WEIGHT = [
    	// x y z
    	[1, 1, 1],
    	// rx ry rz
    	[1, 1, 0.1],
    ];
```

!!! note
	this property is additionally multiplied by CanimTrack.weight.

---

### CanimTrack.name
```
CanimTrack.name: string
```

Name of the track.

---

### CanimTrack.priority
```
CanimTrack.priority: number
```

Priority of the track.

---

### CanimTrack.fading
```
CanimTrack.fading: boolean
```

Whether the track is fading out.

---

### CanimTrack.fade_time
```
CanimTrack.fade_time: number
```

Controls how quickly the track fades out after stopping.

---

### CanimTrack.loaded
```
CanimTrack.loaded: boolean
```

Whether the track is loaded.

---

### CanimTrack.stopping
```
CanimTrack.stopping: boolean
```

If true, the track will stop playing at the next `Canim.update` call.

---

### CanimTrack.playing
```
CanimTrack.playing: boolean
```

Whether the track is playing.

---

### CanimTrack.speed
```
CanimTrack.speed: number
```

Speed of the track. deltatime from `Canim.update()` is multiplied by this function.

---

### CanimTrack.time
```
CanimTrack.time: number
```

How long the animation has played for.

---

### CanimTrack.length
```
CanimTrack.length: number
```

How long the track is, in seconds.


---

### CanimTrack.looped
```
CanimTrack.looped: number
```

Controls whether the track will automatically restart once it reaches the end.

---

### CanimTrack.queued_animation
```
CanimTrack.queued_animation?: CanimTrack
```

Temporary property to make sure animations run seamlessly, one after the other.

!!! caution
	Only use this if you must.

---

### CanimTrack.rebase_target
```
CanimTrack.rebase_target?: CanimTrack
```

Rebase target for the animation.
TODO: better documentation

---

### CanimTrack.rebase_basis
```
CanimTrack.rebase_basis?: CanimTrack
```

Rebase basis for the animation.
TODO: better documentation

---

### CanimTrack.sequence
```
CanimTrack.sequence?: customKeyframeSequence
```

Animation data used by the animator.

---

### CanimTrack.transition_disable
```
CanimTrack.transition_disable: { [index: string]: boolean }
```

If a Motor6D name is included in this table, transitions will not play for it.

---

### CanimTrack.transition_disable_all
```
CanimTrack.transition_disable_all: boolean
```

Controls whether transitions are disabled for this track.