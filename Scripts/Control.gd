extends Control

func _ready():
	pass # Replace with function body.

func init(profil):
#	print(profil)
	var nom = get_node("Nom/Label")
	nom.text = profil["Nom"]
	var pa = get_node("PA")
	pa.text = profil["PA"]
	var cout = get_node("Cout")
	cout.text = profil["Cout"]
	var fig_max = get_node("Max")
	fig_max.text = profil["Max"]
	
	return self
	
func manage_recruitement(p_max, r):
	get_node("Max").text = str(r)
	if r == p_max:
		get_node("_max2").visible = true
		get_node("Remove").visible = true
		get_node("Add").visible = false
		get_node("Max").visible = true
	if r < p_max:
		get_node("Max").visible = true
		get_node("_max2").visible = false
		get_node("Remove").visible = true
	if r == 0:
		get_node("Max").visible = false
		get_node("Remove").visible = false
		get_node("Add").visible = true
	pass
