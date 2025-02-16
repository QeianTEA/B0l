extends Control


func _ready():
	pass


func _on_start_game_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/hub_menu.tscn")
	

func _on_options_button_pressed():
	pass


func _on_exit_button_pressed():
	get_tree().quit()
