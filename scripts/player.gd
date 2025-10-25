extends CharacterBody2D
@onready var animated_sprite = $AnimatedSprite2D
@export var speed = 100
@export var normal_speed = 100
@export var boost_speed = 400

func _ready():
	animated_sprite.frame = 0
	
func get_input():
	var input_direction = Input.get_vector("Left", "Right", "Up", "Down")
	if Input.is_action_pressed("Q"):
		speed = boost_speed
	else:
		speed = normal_speed
	if Input.is_action_pressed("Left"):
		animated_sprite.frame = 1
	elif Input.is_action_pressed("Right"):
		animated_sprite.frame = 2
	elif Input.is_action_pressed("Down"):
		animated_sprite.frame = 3
	elif Input.is_action_pressed("Up"):
		animated_sprite.frame = 0
	
	velocity = input_direction * speed
	
func _physics_process(_delta):
	get_input()
	move_and_slide()
