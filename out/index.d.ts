/// <reference types="@rbxts/types" />
/// <reference types="@rbxts/compiler-types" />
import Signal from "./lib/Signal";
import Maid from "./lib/Maid";
declare type signalInfo = {
    played: boolean;
    name: string;
    time: number;
};
declare type customPose = {
    name: string;
    cframe: CFrame;
    weight: number;
};
declare type customKeyframe = {
    name: string;
    time: number;
    children: {
        [index: string]: customPose;
    };
};
declare type customKeyframeSequence = {
    name: string;
    children: customKeyframe[];
};
export declare const cache_get_keyframe_sequence: (id: string) => KeyframeSequence;
declare class CanimPose {
    keyframe?: customKeyframe;
    keyframe_reached: Signal<(name: string) => void, false>;
    finished_loading: Signal<() => void, false>;
    started: Signal<() => void, false>;
    finished: Signal<() => void, false>;
    transitions: {
        [index: string]: transition;
    };
    bone_weights: {
        [index: string]: number | undefined;
    };
    name: string;
    loaded: boolean;
    priority: number;
    weight: number;
    time: number;
    looped: boolean;
    stopping: boolean;
    fading: boolean;
    fade_time: number;
    fade_start: number;
    load_sequence(id: string | KeyframeSequence | Keyframe): void;
}
declare class CanimTrack {
    sequence?: customKeyframeSequence;
    last_keyframe?: customKeyframe;
    rebase_target?: CanimPose;
    rebase_basis?: CanimPose;
    queued_animation?: CanimTrack;
    transition_disable: {
        [index: string]: boolean;
    };
    transitions: {
        [index: string]: transition;
    };
    keyframe_reached: Signal<(name: string) => void, false>;
    finished_loading: Signal<() => void, false>;
    finished: Signal<() => void, false>;
    started: Signal<() => void, false>;
    signals: signalInfo[];
    bone_weights: {
        [index: string]: [[number, number, number], [number, number, number]] | undefined;
    };
    name: string;
    id: string;
    stopping: boolean;
    loaded: boolean;
    priority: number;
    weight: number;
    speed: number;
    time: number;
    length: number;
    looped: boolean;
    transition_disable_all: boolean;
    playing: boolean;
    load_sequence(id: string | KeyframeSequence): void;
}
declare type transition = {
    start: number;
    finish: number;
    cframe: CFrame;
};
export declare class Canim {
    identified_bones: {
        [index: string]: Motor6D | undefined;
    };
    playing_animations: CanimTrack[];
    playing_poses: CanimPose[];
    animations: {
        [index: string]: CanimTrack | CanimPose | undefined;
    };
    transitions: {
        [index: string]: Array<{
            start: number;
            finish: number;
            cframe: CFrame;
        }> | undefined;
    };
    model?: Model;
    maid: Maid;
    debug: string[];
    constructor();
    assign_model(model: Model): void;
    destroy(): void;
    load_animation(name: string, priority: number, id: string | KeyframeSequence): CanimTrack;
    load_pose(name: string, priority: number, id: string | KeyframeSequence): CanimPose;
    play_animation(id: string): void | CanimTrack;
    play_pose(id: string): void | CanimPose;
    stop_animation(name: string): void;
    update(delta_time: number): void;
}
export {};
