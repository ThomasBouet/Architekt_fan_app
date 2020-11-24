extends Node2D


func _ready():
	pass # Replace with function body.
	
func move(target):
	var tween = get_node("TweenMenu")
	tween.interpolate_property(self, "position", position, target, 0.1, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.1)
	tween.start()
