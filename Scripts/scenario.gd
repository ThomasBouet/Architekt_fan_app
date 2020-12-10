extends Control


var Description_visible = false
const bottom = 30

func init(scenario):
	get_node("LinkButton/Nom").text = scenario["Nom"]
	get_node("VBoxContainer/Mise en place").text = scenario["Mise en place"]
	get_node("VBoxContainer/Deploiment").text = scenario["Déploiement"]
	get_node("VBoxContainer/TextureRect").texture = ResourceLoader.load("res://Sprites/Scenarios/" + scenario["Image"])
	get_node("VBoxContainer/Condition de victoire").text = scenario["Conditions de Victoire"]
	get_node("VBoxContainer/Regles speciales").text = scenario["Régles Spéciales"]
	return self
	
func resize_self():
	var x = get_node("ColorRect").rect_size.x
	var y = bottom + get_node("VBoxContainer").rect_size.y + get_node("ColorRect").rect_size.y
	if Description_visible:
		get_node(".").rect_min_size = Vector2(x, y)
	else:
		get_node(".").rect_min_size = get_node("ColorRect").rect_size
		
func _on_LinkButton_pressed():
	Description_visible = !Description_visible
	get_node("VBoxContainer").visible = Description_visible
	resize_self()

