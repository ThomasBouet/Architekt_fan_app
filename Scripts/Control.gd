extends Control

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
	var fig_max = get_node("Max")
	fig_max.text = profil["Max"]
	
	return self
