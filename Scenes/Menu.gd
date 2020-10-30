extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func move(target):
	var tween = get_node("TweenMenu")
	tween.interpolate_property(self, "position", position, target, 0.1, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.1)
	tween.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
