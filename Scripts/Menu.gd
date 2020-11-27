extends Control


func move(target):
	var tween = get_node("TweenMenu")
	tween.interpolate_property(self, "position", rect_position, target, 0.1, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.1)
	tween.start()
