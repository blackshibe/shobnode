# CanimPose

The class used for poses in the library. It shares many similiarities with CanimTrack, however canim avoids inheritance.

## Methods

---

### CanimPose.load_sequence
```
CanimPose.load_sequence(id: string | KeyframeSequence): void
```

Loads the AnimationTrack for the pose. Does not yield and fires finished_loading when it's finished.

!!! caution
	Canim calls this automatically. There is no reason to do it yourself.

## Events

---

### CanimPose.keyframe_reached
```
CanimPose.keyframe_reached: Signal
```

Fires when a named keyframe is stepped over by the animator.

---

### CanimPose.finished_loading
```
CanimPose.finished_loading: Signal
```

Fires when the animation finishes loading.

---

### CanimPose.started
```
CanimPose.started: Signal
```

Fires when the animation starts.

---

### CanimPose.finished
```
CanimPose.finished: Signal
```

Fires when the animation ends.

## Properties

---

### CanimPose.keyframe
```
CanimPose.keyframe?: customKeyframe
```

Contains animation data that Canim interprets. You can edit this to change the animation data.
nil if the animation is unloaded.

---

### CanimPose.bone_weights
```
CanimPose.bone_weights: { [index: string]: number | undefined } = {};
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
	this property is additionally multiplied by CanimPose.weight.

---

### CanimPose.name
```
CanimPose.name: string
```

Name of the pose.

---

### CanimPose.priority
```
CanimPose.priority: number
```

Priority of the pose.

---

### CanimPose.fading
```
CanimPose.fading: boolean
```

Whether the pose is fading out.

---

### CanimPose.fade_time
```
CanimPose.fade_time: number
```

Controls how quickly the pose fades out after stopping.

---

### CanimTrack.loaded
```
CanimTrack.loaded: boolean
```

Whether the track is loaded.

---

### CanimPose.stopping
```
CanimPose.stopping: boolean
```

If true, the Pose will stop playing at the next `Canim.update` call.

---

### CanimPose.time
```
CanimPose.time: number
```

How long the animation has played for.

