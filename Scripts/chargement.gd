extends Control


func loading():
	get_node("TextureRect/AnimationPlayer").play("loading")
	get_node(".").visible = true
	
func hide_loading():
	get_node("TextureRect/AnimationPlayer").stop()
	get_node(".").visible = false
