extends Control

func _on_jugar_pressed():
	get_tree().change_scene_to_file("res://juego.tscn")


func _on_opciones_pressed():
	get_tree().change_scene_to_file("res://options.tscn")


func _on_salir_pressed():
	get_tree().quit()
	
