extends Node2D

@export var leaf_scene: PackedScene 
@export var spawn_height: float = 5.0  
@export var spawn_rate: float = 2.0  
@export var spawn_jitter: float = 0.5  
@export var max_leaves: int = 20  
@export var initial_spawn_count: int = 5  
@export var initial_delay_range: Vector2 = Vector2(0.3, 1.5)  
@export var spawn_offset: Vector2 = Vector2(1.0, 0.5)  
@export var initial_fall_speed: Vector2 = Vector2(0, 5)  

var timer: Timer
var spawned_leaves: int = 0  
var initial_timer: Timer  
var rng: RandomNumberGenerator  

func _ready():
	rng = RandomNumberGenerator.new()
	rng.seed = hash(str(name))  

	timer = Timer.new()
	timer.wait_time = 1.0 / spawn_rate
	timer.timeout.connect(_spawn_leaf)
	timer.autostart = true
	add_child(timer)

	if initial_spawn_count > 0:
		_start_initial_spawn()

func _start_initial_spawn():
	initial_timer = Timer.new()
	initial_timer.one_shot = true
	initial_timer.wait_time = rng.randf_range(initial_delay_range.x, initial_delay_range.y)
	initial_timer.timeout.connect(_spawn_one_initial)
	add_child(initial_timer)
	initial_timer.start()

func _spawn_one_initial():
	_spawn_leaf()
	initial_spawn_count -= 1  
	if initial_spawn_count > 0:

		initial_timer.wait_time = rng.randf_range(initial_delay_range.x, initial_delay_range.y)
		initial_timer.start()

func _spawn_leaf():
	if spawned_leaves >= max_leaves:
		return

	var leaf = leaf_scene.instantiate()
	get_tree().current_scene.call_deferred("add_child", leaf)
	leaf.add_to_group("leaves")

	var offset = Vector2(
		rng.randf_range(-spawn_offset.x, spawn_offset.x),
		-spawn_height + rng.randf_range(-spawn_offset.y, 0)  
	)
	leaf.global_position = global_position + offset

	leaf.linear_velocity = initial_fall_speed + Vector2(
		rng.randf_range(-2, 2),  
		rng.randf_range(1, 4)    
	)
	leaf.angular_velocity = rng.randf_range(-3, 3)  

	spawned_leaves += 1

	if timer.is_stopped():
		return
	var new_wait = (1.0 / spawn_rate) + rng.randf_range(-spawn_jitter, spawn_jitter)
	new_wait = max(0.1, new_wait)  
	timer.wait_time = new_wait

func _process(_delta):
	if initial_timer and not initial_timer.is_inside_tree():
		initial_timer = null
