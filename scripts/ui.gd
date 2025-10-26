extends Control

@onready var value_label = $Value

func _ready() -> void:
	value_label.text = str(Global.leaves_picked_up)
func _process(_delta):
	value_label.text = str(Global.leaves_picked_up)
