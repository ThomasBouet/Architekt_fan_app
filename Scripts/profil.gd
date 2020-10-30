extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(profil):
#	print(profil)
	var nom = get_node("Nom")
	nom.text = profil["Nom"]
	var pa = get_node("PA")
	pa.text = profil["PA"]
	var cout = get_node("Cout")
	cout.text = profil["Cout"]
	
	return self

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
