-- Compiled with roblox-ts v1.2.9
local TS = _G[script]
local Signal = TS.import(script, script, "lib", "Signal")
local Maid = TS.import(script, script, "lib", "Maid")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local map = function(value, in_min, in_max, out_min, out_max)
	return ((value - in_min) * (out_max - out_min)) / (in_max - in_min) + out_min
end
local KeyframeSequenceProvider = game:GetService("KeyframeSequenceProvider")
local cached_tracks = {}
--[[
	Reason for the constant type assertion in this module is because animations have a defined structure while
	typescript thinks otherwise. Performance while keeping type control over the inner workings of this class were needed.
]]
--[[
	GET function for the customAnimator. Caches animationTracks and keeps them in memory,
	meaning consecutive loading is instant.
]]
local active_requests = {}
local cache_get_keyframe_sequence
cache_get_keyframe_sequence = function(id)
	-- prevents a race condition
	while active_requests[id] do
		RunService.Heartbeat:Wait()
	end
	local sequence = cached_tracks[id]
	if sequence then
		return sequence:Clone()
	end
	local success, fail = pcall(function()
		active_requests[id] = true
		sequence = KeyframeSequenceProvider:GetKeyframeSequenceAsync(id)
		active_requests[id] = false
	end)
	if not success or not sequence then
		warn("GetKeyframeSequenceAsync() failed for id " .. id)
		warn(fail)
		task.wait(1 / 30)
		active_requests[id] = false
		return cache_get_keyframe_sequence(id)
	end
	-- a new call is generated to clone the keyframe
	cached_tracks[id] = sequence
	return cache_get_keyframe_sequence(id)
end
local ease_in_out_quad = function(x)
	return if x < 0.5 then 2 * x * x else 1 - math.pow(-2 * x + 2, 2) / 2
end
local convert_pose_instance = function(pose)
	return {
		cframe = pose.CFrame,
		name = pose.Name,
		weight = pose.Weight,
	}
end
local convert_keyframe_instance = function(keyframe)
	local children = {}
	for _, value in pairs(keyframe:GetDescendants()) do
		local _value = value:IsA("Pose") and value.Weight
		if _value ~= 0 and (_value == _value and _value) then
			children[value.Name] = convert_pose_instance(value)
		end
	end
	return {
		name = keyframe.Name,
		time = keyframe.Time,
		children = children,
	}
end
local convert_keyframe_sequence_instance = function(sequence)
	local children = {}
	for _, value in pairs(sequence:GetChildren()) do
		if value:IsA("Keyframe") then
			local _children = children
			local _arg0 = convert_keyframe_instance(value)
			-- ▼ Array.push ▼
			_children[#_children + 1] = _arg0
			-- ▲ Array.push ▲
		end
	end
	return {
		name = sequence.Name,
		children = children,
	}
end
--[[
	A pose is much faster to playback than an "idle" animation.
]]
local CanimPose
do
	CanimPose = setmetatable({}, {
		__tostring = function()
			return "CanimPose"
		end,
	})
	CanimPose.__index = CanimPose
	function CanimPose.new(...)
		local self = setmetatable({}, CanimPose)
		return self:constructor(...) or self
	end
	function CanimPose:constructor()
		self.keyframe_reached = Signal.new()
		self.finished_loading = Signal.new()
		self.started = Signal.new()
		self.finished = Signal.new()
		self.transitions = {}
		self.bone_weights = {}
		self.name = "animation_track"
		self.loaded = false
		self.priority = 0
		self.weight = 1
		self.time = 0
		self.looped = false
		self.stopping = false
		self.fading = false
		self.fade_time = 0.5
		self.fade_start = tick()
	end
	function CanimPose:load_sequence(id)
		task.spawn(function()
			local sequence = if typeof(id) == "Instance" then id else cache_get_keyframe_sequence(id)
			if sequence:IsA("Keyframe") then
				local actual_keyframe = convert_keyframe_instance(sequence)
				self.keyframe = actual_keyframe
			else
				local actual_sequence = convert_keyframe_sequence_instance(sequence)
				self.keyframe = actual_sequence.children[1]
			end
			-- a race condition may happen if the event isn't deferred
			task.defer(function()
				self.loaded = true
				self.finished_loading:Fire()
			end)
		end)
	end
end
--[[
	Base class for the animator tracks.
	handles loading.
]]
local CanimTrack
do
	CanimTrack = setmetatable({}, {
		__tostring = function()
			return "CanimTrack"
		end,
	})
	CanimTrack.__index = CanimTrack
	function CanimTrack.new(...)
		local self = setmetatable({}, CanimTrack)
		return self:constructor(...) or self
	end
	function CanimTrack:constructor()
		self.transition_disable = {}
		self.transitions = {}
		self.keyframe_reached = Signal.new()
		self.finished_loading = Signal.new()
		self.finished = Signal.new()
		self.started = Signal.new()
		self.signals = {}
		self.bone_weights = {}
		self.name = "animation_track"
		self.id = ""
		self.stopping = false
		self.loaded = false
		self.priority = 0
		self.weight = 1
		self.speed = 1
		self.time = 0
		self.length = 0
		self.looped = false
		self.transition_disable_all = false
		self.playing = false
	end
	function CanimTrack:load_sequence(id)
		task.spawn(function()
			self.signals = {}
			self.id = if typeof(id) == "Instance" then "" else id
			local sequence = if typeof(id) == "Instance" then id else cache_get_keyframe_sequence(id)
			sequence.Name = self.name
			local actual_sequence = convert_keyframe_sequence_instance(sequence)
			local highest_keyframe
			for _, keyframe in pairs(actual_sequence.children) do
				local _exp = keyframe.time
				local _result = highest_keyframe
				if _result ~= nil then
					_result = _result.time
				end
				local _condition = _result
				if not (_condition ~= 0 and (_condition == _condition and _condition)) then
					_condition = 0
				end
				if _exp > _condition then
					highest_keyframe = keyframe
				end
				if keyframe.name ~= "Keyframe" then
					local _signals = self.signals
					local _arg0 = {
						played = false,
						time = keyframe.time,
						name = keyframe.name,
					}
					-- ▼ Array.push ▼
					_signals[#_signals + 1] = _arg0
					-- ▲ Array.push ▲
				end
				-- idk what this does
				for rawindex, pose in pairs(keyframe.children) do
					if pose.weight == 0 then
						task.defer(function()
							keyframe.children[rawindex] = nil
							return true
						end)
					end
				end
			end
			if not highest_keyframe then
				return nil
			end
			self.sequence = actual_sequence
			self.length = highest_keyframe.time
			self.last_keyframe = highest_keyframe
			-- a race condition may happen if the event isn't deferred
			task.defer(function()
				self.loaded = true
				self.finished_loading:Fire()
			end)
		end)
	end
end
--[[
	Base class.
]]
local Canim
do
	Canim = setmetatable({}, {
		__tostring = function()
			return "Canim"
		end,
	})
	Canim.__index = Canim
	function Canim.new(...)
		local self = setmetatable({}, Canim)
		return self:constructor(...) or self
	end
	function Canim:constructor()
		self.identified_bones = {}
		self.playing_animations = {}
		self.playing_poses = {}
		self.animations = {}
		self.transitions = {}
		self.maid = Maid.new()
		self.debug = {}
	end
	function Canim:assign_model(model)
		self.model = model
		local _exp = self.model:GetDescendants()
		local _arg0 = function(element)
			if element:IsA("Motor6D") and element.Part1 then
				self.identified_bones[element.Part1.Name] = element
			end
		end
		-- ▼ ReadonlyArray.forEach ▼
		for _k, _v in ipairs(_exp) do
			_arg0(_v, _k - 1, _exp)
		end
		-- ▲ ReadonlyArray.forEach ▲
	end
	function Canim:destroy()
		self.maid:DoCleaning()
		for _, track in pairs(self.animations) do
			track.finished_loading:Destroy()
			track.keyframe_reached:Destroy()
			track.started:Destroy()
			track.finished:Destroy()
		end
	end
	function Canim:load_animation(name, priority, id)
		local track = CanimTrack.new()
		track.name = name
		track.priority = priority
		track:load_sequence(id)
		self.animations[name] = track
		return track
	end
	function Canim:load_pose(name, priority, id)
		local track = CanimPose.new()
		track.name = name
		track.priority = priority
		track:load_sequence(id)
		self.animations[name] = track
		return track
	end
	function Canim:play_animation(id)
		local track = self.animations[id]
		if not track then
			return warn("invalid animation: ", id)
		end
		if TS.instanceof(track, CanimPose) then
			error("attempted to play a pose as an playedanimation")
		end
		track.time = 0
		local _signals = track.signals
		local _arg0 = function(element)
			element.played = false
		end
		-- ▼ ReadonlyArray.forEach ▼
		for _k, _v in ipairs(_signals) do
			_arg0(_v, _k - 1, _signals)
		end
		-- ▲ ReadonlyArray.forEach ▲
		if not (table.find(self.playing_animations, track) ~= nil) then
			local _playing_animations = self.playing_animations
			-- ▼ Array.push ▼
			_playing_animations[#_playing_animations + 1] = track
			-- ▲ Array.push ▲
			track.started:Fire()
		end
		return track
	end
	function Canim:play_pose(id)
		local track = self.animations[id]
		if not track then
			return warn("invalid animation: ", id)
		end
		if TS.instanceof(track, CanimTrack) then
			error("attempted to play a pose as an animation")
		end
		if not (table.find(self.playing_poses, track) ~= nil) then
			local _playing_poses = self.playing_poses
			-- ▼ Array.push ▼
			_playing_poses[#_playing_poses + 1] = track
			-- ▲ Array.push ▲
		end
		return track
	end
	function Canim:stop_animation(name)
		for _, value in pairs(self.playing_animations) do
			if value.name == name then
				value.stopping = true
			end
		end
		for _, value in pairs(self.playing_poses) do
			if value.name == name then
				value.stopping = true
			end
		end
	end
	function Canim:update(delta_time)
		local weight_sum = {}
		local weight_sum_rebased = {}
		local bone_totals = {}
		local new_playing = {}
		local debug = {}
		-- if this was done inside the first loop the rig would flicker randomly
		for _, track in pairs(self.playing_animations) do
			track.time += delta_time * track.speed
			if track.time >= track.length or (track.time < 0 or track.stopping) then
				for _, element in pairs(track.signals) do
					if track.time >= element.time and not element.played then
						element.played = true
						task.spawn(function()
							track.keyframe_reached:Fire(element.name)
						end)
					end
				end
				if track.looped and not track.stopping then
					track.playing = false
					track.finished:Fire()
					for _, element in pairs(track.signals) do
						element.played = false
					end
				else
					track.stopping = false
					-- transition to idle once the animation is ready for it
					if track.last_keyframe then
						if track.queued_animation then
							self:play_animation(track.queued_animation.name)
						end
						track.finished:Fire()
						for _, value in pairs(track.last_keyframe.children) do
							self.transitions[value.name] = self.transitions[value.name] or {}
							if not track.transition_disable[value.name] and not track.transition_disable_all then
								local _exp = self.transitions[value.name]
								local _arg0 = {
									start = tick(),
									finish = tick() + 1,
									cframe = value.cframe,
								}
								-- ▼ Array.push ▼
								_exp[#_exp + 1] = _arg0
								-- ▲ Array.push ▲
							end
						end
						continue
					end
				end
			end
			-- ▼ Array.push ▼
			new_playing[#new_playing + 1] = track
			-- ▲ Array.push ▲
		end
		for _, track in pairs(new_playing) do
			local _arg0 = "Track " .. (track.name .. (" " .. tostring(track.time)))
			-- ▼ Array.push ▼
			debug[#debug + 1] = _arg0
			-- ▲ Array.push ▲
			if not track.loaded or not track.sequence then
				continue
			end
			if track.time >= track.length and track.looped then
				track.time %= track.length
			end
			track.playing = true
			local first = nil
			local last = nil
			for _, keyframe in pairs(track.sequence.children) do
				if keyframe.time >= track.time and not last then
					last = keyframe
				elseif keyframe.time <= track.time then
					first = keyframe
				end
			end
			if not first or not last then
				return warn("Invalid KeyframeSequence; no start or stop point for " .. track.name)
			end
			for _, element in pairs(track.signals) do
				if track.time >= element.time and not element.played then
					element.played = true
					task.spawn(function()
						track.keyframe_reached:Fire(element.name)
					end)
				end
			end
			local bias = map(track.time, first.time, last.time, 0, 1)
			for _, value in pairs(first.children) do
				local bone = self.identified_bones[value.name]
				if bone then
					local a = value
					local b = last.children[value.name]
					local unbiased_cframe = a.cframe:Lerp(b.cframe, bias)
					local weight = track.bone_weights[value.name]
					local blended_cframe = unbiased_cframe
					if weight then
						local components = { blended_cframe:ToEulerAnglesXYZ() }
						blended_cframe = CFrame.new(unbiased_cframe.X * weight[1][1], unbiased_cframe.Y * weight[1][2], unbiased_cframe.Z * weight[1][3])
						local _blended_cframe = blended_cframe
						local _arg0_1 = CFrame.Angles(components[1] * weight[2][1], components[2] * weight[2][2], components[3] * weight[2][3])
						blended_cframe = _blended_cframe * _arg0_1
					end
					if track.rebase_target and (track.rebase_target.keyframe and track.rebase_target.keyframe.children[bone.Part1.Name]) then
						if track.rebase_basis and (track.rebase_basis.keyframe and track.rebase_basis.keyframe.children[bone.Part1.Name]) then
							local basis = track.rebase_basis.keyframe.children[bone.Part1.Name].cframe
							-- rebase blended_cframe from rebase_basis to rebase_target
							local _blended_cframe = blended_cframe
							local _arg0_1 = basis:Inverse()
							blended_cframe = _blended_cframe * _arg0_1
						else
							local _blended_cframe = blended_cframe
							local _arg0_1 = track.rebase_target.keyframe.children[bone.Part1.Name].cframe:Inverse()
							blended_cframe = _blended_cframe * _arg0_1
						end
						local sum = weight_sum_rebased[bone] or {}
						local _sum = sum
						local _arg0_1 = { track.priority, blended_cframe }
						-- ▼ Array.push ▼
						_sum[#_sum + 1] = _arg0_1
						-- ▲ Array.push ▲
						local _sum_1 = sum
						-- ▼ Map.set ▼
						weight_sum_rebased[bone] = _sum_1
						-- ▲ Map.set ▲
					else
						local sum = weight_sum[bone] or {}
						local _sum = sum
						local _arg0_1 = { track.priority, blended_cframe }
						-- ▼ Array.push ▼
						_sum[#_sum + 1] = _arg0_1
						-- ▲ Array.push ▲
						local _sum_1 = sum
						-- ▼ Map.set ▼
						weight_sum[bone] = _sum_1
						-- ▲ Map.set ▲
					end
				end
			end
		end
		for _, track in pairs(self.playing_poses) do
			local _arg0 = "Pose " .. (track.name .. (" " .. tostring(track.time)))
			-- ▼ Array.push ▼
			debug[#debug + 1] = _arg0
			-- ▲ Array.push ▲
			if not track.loaded or not track.keyframe then
				continue
			end
			local first = track.keyframe
			if not first then
				error("invalid Keyframe (none)")
			end
			for _, value in pairs(first.children) do
				local bone = self.identified_bones[value.name]
				if bone then
					local sum = weight_sum[bone] or {}
					local _sum = sum
					local _arg0_1 = { track.priority, value.cframe }
					-- ▼ Array.push ▼
					_sum[#_sum + 1] = _arg0_1
					-- ▲ Array.push ▲
					local _sum_1 = sum
					-- ▼ Map.set ▼
					weight_sum[bone] = _sum_1
					-- ▲ Map.set ▲
				end
			end
		end
		for index, value in pairs(self.identified_bones) do
			local sum = weight_sum[value] or {}
			local _sum = sum
			local _arg0 = { -1000, CFrame.new() }
			-- ▼ Array.push ▼
			_sum[#_sum + 1] = _arg0
			-- ▲ Array.push ▲
			local _sum_1 = sum
			-- ▼ Map.set ▼
			weight_sum[value] = _sum_1
			-- ▲ Map.set ▲
		end
		for index, value in pairs(weight_sum) do
			table.sort(value, function(a, b)
				return a[1] > b[1]
			end)
			-- transitions only work inbetween the last animation to play and any poses.
			if index.Part1 then
				local target_cframe = value[1][2]
				local transitions = self.transitions[index.Part1.Name]
				if transitions then
					for transition_index, transition in pairs(transitions) do
						if transition.finish == 0 then
							transition.finish = tick() + math.huge
							transitions[transition_index - 1 + 1] = nil
						end
						if transition.finish >= tick() and #weight_sum[index] <= 2 then
							local alpha = ease_in_out_quad(map(tick(), transition.start, transition.finish, 1, 0))
							target_cframe = target_cframe:Lerp(transition.cframe, alpha)
						elseif transition.finish <= tick() then
							transitions[transition_index - 1 + 1] = nil
						end
					end
				end
				local _target_cframe = target_cframe
				-- ▼ Map.set ▼
				bone_totals[index] = _target_cframe
				-- ▲ Map.set ▲
			end
		end
		for index, value in pairs(weight_sum_rebased) do
			if not index.Part1 then
				continue
			end
			for _, data in pairs(value) do
				local target_cframe = data[2]
				local transitions = self.transitions[index.Part1.Name]
				if transitions then
					for transition_index, transition in pairs(transitions) do
						if transition and (transition.finish >= tick() and #weight_sum[index] == 1) then
							local alpha = ease_in_out_quad(map(tick(), transition.start, transition.finish, 1, 0))
							target_cframe = target_cframe:Lerp(transition.cframe, alpha)
						else
							transitions[transition_index + 1] = nil
						end
					end
				end
				local _target_cframe = target_cframe
				local _arg0 = bone_totals[index] or CFrame.new()
				-- ▼ Map.set ▼
				bone_totals[index] = _target_cframe * _arg0
				-- ▲ Map.set ▲
			end
		end
		for index, value in pairs(bone_totals) do
			index.Transform = value
		end
		self.playing_animations = new_playing
		self.debug = debug
	end
end
return {
	cache_get_keyframe_sequence = cache_get_keyframe_sequence,
	Canim = Canim,
}
