# Canim

## Methods

---

### Canim.assign_model
```
Canim.assign_model(model: Model): void
```

Connects a model to the animator.

!!! info
	You can run this multiple times.

---

### Canim.load_animation
```
Canim.load_animation(name: string, priority: number, id: string | KeyframeSequence): CanimTrack 
```

Registers and begins loading the given animation. It can then be played with [Canim.load_animation](/API/Canim/#canimload_animation) using the name provided to load_animation. <br/>

!!! caution
	This does not yield! you must wait for the animation to finish loading. See [CanimTrack.finished_loading](#Track.finished_loading).

---

### Canim.load_pose
```
Canim.load_pose(name: string, priority: number, id: string | KeyframeSequence): CanimPose
```

Registers and begins loading the given pose. It can then be played with [Canim.play_pose](/API/Canim/#canimplay_pose) using the name provided to load_pose. <br/>
This takes in an AnimationTrack of any given animation length. Only the first frame of it is used.

!!! caution
	This does not yield! you must wait for the animation to finish loading. See [CanimPose.finished_loading](#Pose.finished_loading).


---

### Canim.play_animation
```
Canim.play_animation(id: string): void
```

Plays a track.

---

### Canim.play_pose
```
Canim.play_pose(id: string): void
```

Plays a pose.

!!! info
	You can run this multiple times.

---

### Canim.stop_animation
```
Canim.stop_animation(name: string): void
```

Stops playing any given pose or track.

---

### Canim.update
```
Canim.update(delta_time: number): void
```

Steps the animation player forward by `delta_time`.

!!! caution
	Canim does not connect this to RunService automatically!

---


### Canim.destroy
```
Canim.destroy(): void
```

Cleans up the class and all animations.

## Properties

---

### Canim.animations
```
Canim.animations: { [index: string]: CanimTrack | CanimPose | undefined; } = {};
```

Array of loaded animations.

---

### Canim.playing_animations
```
Canim.playing_animations: CanimTrack[]
```

Array of playing tracks.

---

### Canim.playing_poses
```
Canim.playing_poses: CanimPose[]
```

Array of playing poses.

---

### Canim.debug
```
Canim.debug: string[]
```

Contains information about currently playing tracks and poses.

---



