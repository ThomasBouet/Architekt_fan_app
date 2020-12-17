extends Control


var Description_visible = false

func init(scenario):
	get_node("Front/LinkButton/Nom").text = scenario["Nom"]
	get_node("Back/Info_Holder/Info/TextureRect").texture = ResourceLoader.load("res://Sprites/Scenarios/" + scenario["Image"])
	get_node("Back/Info_Holder/Info/Mise en place").text = scenario["Mise en place"] + "\n"
	get_node("Back/Info_Holder/Info/Deploiment").text = "\n" + scenario["Déploiement"] + "\n"
	get_node("Back/Info_Holder/Info/Condition de victoire").text = "\n" + scenario["Conditions de Victoire"] + "\n"
	get_node("Back/Info_Holder/Info/Regles speciales").text = "\n" + scenario["Régles Spéciales"]
	return self
	
func _on_LinkButton_pressed():
	Description_visible = !Description_visible
	get_node("Back").visible = Description_visible

