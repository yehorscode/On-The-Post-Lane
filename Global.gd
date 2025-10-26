extends Node

var leaves_picked_up: int = 0

signal leaves_updated(count: int)

func add_leaf() -> void:
	leaves_picked_up += 1
	leaves_updated.emit(leaves_picked_up) 
	print("Leaves now: ", leaves_picked_up) 

func reset_leaves() -> void:
	leaves_picked_up = 0
	leaves_updated.emit(leaves_picked_up)
