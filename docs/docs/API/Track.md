# CanimTrack

The class used for tracks in the library. It shares many similiarities with CanimPose, however canim avoids inheritance.

## Methods

## Events

## Properties

<!-- 
	sequence?: customKeyframeSequence;
	last_keyframe?: customKeyframe;
	rebase_target?: CanimPose;
	rebase_basis?: CanimPose;
	queued_animation?: CanimTrack;

	transition_disable: { [index: string]: boolean } = {};
	transitions: { [index: string]: transition } = {};

	signals: signalInfo[] = [];
	bone_weights: { [index: string]: [[number, number, number], [number, number, number]] | undefined } = {};

	name = "animation_track";
	id = "";

	stopping = false;
	loaded = false;
	priority = 0;
	weight = 1;
	speed = 1;
	time = 0;
	length = 0;
	looped = false;
	transition_disable_all = false;
	playing = false;

	load_sequence(id: string | KeyframeSequence) {
		task.spawn(() => {
			this.signals = [];
			this.id = typeIs(id, "Instance") ? "" : id;

			const sequence = typeIs(id, "Instance") ? id : cache_get_keyframe_sequence(id);
			sequence.Name = this.name;

			const actual_sequence = convert_keyframe_sequence_instance(sequence);
			let highest_keyframe: customKeyframe | undefined;

			for (const [_, keyframe] of pairs(actual_sequence.children)) {
				if (keyframe.time > (highest_keyframe?.time || 0)) highest_keyframe = keyframe;
				if (keyframe.name !== "Keyframe") {
					this.signals.push({
						played: false,
						time: keyframe.time,
						name: keyframe.name,
					});
				}

				// idk what this does
				for (const [rawindex, pose] of pairs(keyframe.children)) {
					if (pose.weight === 0) task.defer(() => delete keyframe.children[rawindex]);
				}
			}

			if (!highest_keyframe) return; // warn("KeyframeSequence has no children");

			this.sequence = actual_sequence;
			this.length = highest_keyframe.time;
			this.last_keyframe = highest_keyframe;

			// a race condition may happen if the event isn't deferred
			task.defer(() => {
				this.loaded = true;
				this.finished_loading.Fire();
			});
		});
	}
} -->
