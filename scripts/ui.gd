extends Control

@onready var value_label = $Value
@onready var achievement_text = $Achievement_bg/Achiv_text
@onready var achievement_bg = $Achievement_bg
@onready var achievement_jp2 = $Jp2
@onready var achievement_credit_15 = $Credit_15
@onready var achievement_kid67 = $"670"
@onready var achievement_credit_270 = $Credit_270
@onready var in_sound = $In
@onready var out_sound = $Out
@onready var ping_sound = $Ping
@onready var tip_label = $tip
var original_pos: Vector2 

func show_tooltip(toshow: String):
	in_sound.play() 
	
	achievement_text.text = toshow
	achievement_bg.visible = true
	var tween = create_tween()
	
	var screen_size = get_viewport().get_visible_rect().size
	var start_x = -screen_size.x 
	var target_x = original_pos.x
	achievement_bg.position.x = start_x
	tween.tween_property(achievement_bg, "position:x", target_x, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func(): ping_sound.play())
	tween.tween_interval(1.0)
	tween.tween_callback(func(): out_sound.play())
	tween.tween_property(achievement_bg, "position:x", start_x, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.finished.connect(func(): achievement_bg.visible = false)

func hide_all_achievements():
	achievement_jp2.visible = false
	achievement_credit_15.visible = false
	achievement_bg.visible = false
	achievement_kid67.visible = false
	achievement_credit_270.visible = false

func look_for_nums(count: int) -> void:
	if count >= 15 and not achievement_credit_15.visible:
		achievement_credit_15.visible = true
		show_tooltip("Uncle xi is proud")
	if count >= 21 and not achievement_jp2.visible:
		achievement_jp2.visible = true
		show_tooltip("The holy power")
	if count >= 67 and not achievement_kid67.visible:
		achievement_kid67.visible = true
		show_tooltip("What are we doing with the world...")
	if count >= 270 and not achievement_credit_270.visible:
		achievement_credit_270.visible = true
		show_tooltip("Communist China awaits you comrade!!!")  

func _on_leaves_updated(count: int) -> void:
	value_label.text = str(count)
	look_for_nums(count)  

func _ready() -> void:
	original_pos = achievement_bg.position
	Global.leaves_updated.connect(_on_leaves_updated) 
	value_label.text = str(Global.leaves_picked_up)
	hide_all_achievements()
	look_for_nums(Global.leaves_picked_up)
	
	
