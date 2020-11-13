extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Description_visible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(sort):
	get_node("LinkButton/Nom").text = sort["Nom"]
	get_node("VBoxContainer/Description").bbcode_text = sort["Description"]
	get_node("VBoxContainer/Cara").text = "Concentration : "+ sort["Concentration"] +", Composants : "+ sort["Cout"] +", Portée : "+ sort["Portée"] +", Cible : " + sort["Cible"]
	get_node("VBoxContainer/Amélioration").bbcode_text = sort["Améliorations"]
	return self
	
func resize_self():
	var x = get_node("ColorRect").rect_size.x
	var y = get_node("VBoxContainer").rect_size.y + get_node("ColorRect").rect_size.y
	if Description_visible:
		get_node(".").rect_min_size = Vector2(x, y)
	else:
		get_node(".").rect_min_size = get_node("ColorRect").rect_size
		
func _on_LinkButton_pressed():
	Description_visible = !Description_visible
	get_node("VBoxContainer").visible = Description_visible
	resize_self()

