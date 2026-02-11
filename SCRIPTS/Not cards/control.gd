extends Control

@onready var errors: Label = $Errors
@onready var event_card_manager: Node2D = $"../EventCardManager"
@onready var skip: Label = $Skip
@onready var high_score_number: Label = $ScoresVBox/HighScoreHBox/HighScoreNUMBER
@onready var current_score_number: Label = $ScoresVBox/CurrentScoreHBox/CurrentScoreNUMBER
@onready var timer: Timer = $Timer


var save_file_path = "res://saves/savefile.save"
var high_score
var reset_high_score_value := 0 


func _ready() -> void:
	errors.visible = true
	error_message("")
	skip.modulate = Color(0, 0, 0, 0)
	
	current_score_number.text = "0"
	set_hs(0)
	
	load_score()


#func do_it_button_pressed():
	#errors.visible = true
	#await event_card_manager.event_req_card_check()
func skip_button_pressed():
	event_card_manager.skip_event()

func activate_skip_button():
	skip.get_node("SkipLabelArea/CollisionShape2D").disabled = false
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(skip, "modulate", Color(1,1,1,1), 1.5)
func deactivate_skip_button():
	skip.get_node("SkipLabelArea/CollisionShape2D").disabled = true
	var tween = get_tree().create_tween()
	tween.tween_property(skip, "modulate", Color(1,1,1,0), 0.5)
	
#func activate_doit_button():
	#do_it.get_node("DoItLabelArea/CollisionShape2D").disabled = false
#func deactivate_doit_button():
	#do_it.get_node("DoItLabelArea/CollisionShape2D").disabled = true
	
	
func _on_reset_game_pressed() -> void:
	get_tree().reload_current_scene() 
func _on_reset_high_score_button_pressed() -> void:
	var file = FileAccess.open(save_file_path, FileAccess.WRITE) 
	var highest_score = 0 
	file.store_var(highest_score)
	load_score()


func load_score():
	if FileAccess.file_exists(save_file_path):
		var file = FileAccess.open(save_file_path, FileAccess.READ)

		if file.get_length() > 0:
			var value = file.get_var()
			high_score = value
			high_score_number.text = str(high_score)
		else:
			print("Arquivo existe, mas está vazio.")
			high_score = 0
			set_hs(0)
	else:
		print("Nenhum arquivo encontrado.")
		high_score = 0
		set_hs(0)

func save(highest_score):
	var file = FileAccess.open(save_file_path, FileAccess.WRITE) 
	highest_score = int(high_score_number.text)
	file.store_var(highest_score)
	
func error_message(text):
	
	errors.text = text
	
	if timer.time_left == 0:
		errors.modulate = Color(1,1,1,0) # garante alpha 0

		var tween2 = get_tree().create_tween()
		tween2.tween_property(errors, "modulate", Color(1,1,1,0.7), 0.23)
		
	timer.start()
func _on_timer_timeout() -> void:
	var tween2 = get_tree().create_tween()
	tween2.tween_property(errors, "modulate", Color(1,1,1,0), 0.23)


func set_hs(new_high_score):
	high_score_number.text = str(new_high_score)
	return
func set_s(score):
	current_score_number.text = str(score)
	return

func _on_skip_label_area_mouse_entered() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($Skip, "scale", Vector2(1.3, 1.3), 0.23).set_trans(Tween.TRANS_EXPO)
func _on_skip_label_area_mouse_exited() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($Skip, "scale", Vector2(1, 1), 0.23).set_trans(Tween.TRANS_EXPO)


#func _on_doit_timer_timeout() -> void:
	#var tween2 = get_tree().create_tween()
	#tween2.tween_property(errors, "modulate", Color(1,1,1,0), 0.3)

func _on_option_area_area_entered(area: Area2D) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(area.get_parent(), "scale", Vector2(1.2, 1.2), 1)
func _on_option_area_area_exited(area: Area2D) -> void:
	var tween2 = get_tree().create_tween()
	tween2.tween_property(area.get_parent(), "scale", Vector2(1, 1), 1)

func activate_options_area() -> void:
	event_card_manager.get_children()[0].get_node("Left").get_node("Option1").get_children()[0].get_children()[0].disabled = false
	event_card_manager.get_children()[0].get_node("Center").get_node("Option2").get_children()[0].get_children()[0].disabled = false
	event_card_manager.get_children()[0].get_node("Right").get_node("Option3").get_children()[0].get_children()[0].disabled = false
#func deactivate_options_area() -> void:
	#event_card_manager.global_event_card.get_node("Left/Option1Area/CollisionShape2D").disabled = true
	#event_card_manager.get_children()[0].get_node("Center/Option2Area/CollisionShape2D").disabled = true
	#event_card_manager.get_children()[0].get_node("Right/Option3Area/CollisionShape2D").disabled = true

func option_area_clicked(option_number):
	event_card_manager.global_event_option_cliked = option_number
	await event_card_manager.event_req_card_check() #will get the global event option clicked updated
	
func open_and_activate_options():
	if !event_card_manager.is_event_open:
		var left = event_card_manager.global_event_card.get_node("Left")
		var center = event_card_manager.global_event_card.get_node("Center")
		var right = event_card_manager.global_event_card.get_node("Right")

		var tween3 = get_tree().create_tween()
		tween3.tween_property(left, "position", Vector2(left.position.x - 130, left.position.y), 0.3)
		var tween4 = get_tree().create_tween()
		tween4.tween_property(center, "position", Vector2(center.position.x, center.position.y), 0.3)
		var tween5 = get_tree().create_tween()
		tween5.tween_property(right, "position", Vector2(right.position.x + 130, right.position.y), 0.3)
		
		await tween5.finished
		activate_options_area()
		
		event_card_manager.is_event_open = 1
	
