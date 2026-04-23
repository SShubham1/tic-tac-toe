extends Control

func _ready() -> void:
	$UIContainer/DiffContainer/HSlider.value = Global.difficulty
	$UIContainer/DiffContainer/DiffMsg.text = Global.LEVEL_MAP[Global.level]

func _on_main_menu_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func _on_h_slider_value_changed(value: float) -> void:
	Global.difficulty=value
	Global.level = int(Global.difficulty*4)+1
	$UIContainer/DiffContainer/DiffMsg.text = Global.LEVEL_MAP[Global.level]


func _on_exit_btn_pressed() -> void:
	if OS.has_feature("web"):
		OS.shell_open(Global.PROJECT_LINK) 
	else:
		get_tree().quit()
