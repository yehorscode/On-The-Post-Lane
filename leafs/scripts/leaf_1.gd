extends RigidBody2D

@export var ground_level: float = 0.0 
@export var settle_velocity_threshold: float = 0.1 

func _ready():
	rotation_degrees = randf_range(-180, 180)
	angular_velocity = randf_range(-2, 2)

func _physics_process(_delta):
	if global_position.y >= ground_level - 0.05 and linear_velocity.length() < settle_velocity_threshold:
		freeze = true
		set_physics_process(false)
