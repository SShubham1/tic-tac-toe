extends Control

func _on_pvc_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/GameBoard.tscn")
	Global.game_mode = "PVC"
func _on_pvp_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/GameBoard.tscn")
	Global.game_mode = "PVP"

func _on_settings_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Settings.tscn")
	Global.game_mode="PVC"
