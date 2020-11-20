extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Description_visible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(formule):
	get_node("TextureButton/Nom").text = formule
	var form_split = Json_reader.forms_data[formule][3].split("Améliorations : ")
	print(form_split)
	get_node("VBoxContainer/Description").bbcode_text = form_split[0]
	get_node("VBoxContainer/HBoxContainer/Cout").text = "Cout : " + Json_reader.forms_data[formule][0]
	get_node("VBoxContainer/HBoxContainer/Portee").text = "Portée : " + Json_reader.forms_data[formule][1]
	get_node("VBoxContainer/HBoxContainer/Cible").text = "Cible : " + Json_reader.forms_data[formule][2]
	get_node("VBoxContainer/Amélioration").text = form_split[1] if form_split.size() > 1 else ""
	return self
	
func resize_self():
	var x = get_node("ColorRect").rect_size.x
	var y = get_node("VBoxContainer").rect_size.y + get_node("ColorRect").rect_size.y
	if Description_visible:
		get_node(".").rect_min_size = Vector2(x, y)
	else:
		get_node(".").rect_min_size = get_node("ColorRect").rect_size
		
func _on_TextureButton_pressed():
	Description_visible = !Description_visible
	get_node("VBoxContainer").visible = Description_visible
	resize_self()

func _on_Description_meta_clicked(meta):
	get_node("Competence_Dialog").display_comp(meta)
