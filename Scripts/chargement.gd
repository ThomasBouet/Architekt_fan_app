extends Sprite


func loading():
	get_node("AnimationPlayer").play("loading")
	get_node(".").visible = true
	
func hide_loading():
	get_node("AnimationPlayer").stop()
	get_node(".").visible = false
