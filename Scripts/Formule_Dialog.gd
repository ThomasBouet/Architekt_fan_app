extends AcceptDialog

func _ready():
	get_ok().add_font_override("font", load("res://Fonts/Text_font.tres"))
	get_label().add_font_override("font", load("res://Fonts/Text_font.tres"))

func display_form(form):
	get_ok().add_font_override("font", load("res://Fonts/Text_font.tres"))
	get_node(".").window_title = form
	var formule = Json_reader.forms_data[form]
	get_node("VBoxContainer/HBoxContainer/Cout").text = "Cout : " + formule[0]
	get_node("VBoxContainer/HBoxContainer/Cible").text = "Portée : " + formule[1]
	get_node("VBoxContainer/HBoxContainer/Portee").text = "Cible : " + formule[2]
	
	var form_split = formule[3].split("Améliorations : \r\n")
	get_node("VBoxContainer/Description").bbcode_text = form_split[0]
	get_node("VBoxContainer/Amélioration").bbcode_text = form_split[1] if form_split.size() > 1 else ""
	get_node("VBoxContainer/amelio_desc").visible = form_split.size() > 1
	get_node("VBoxContainer/Amélioration").visible = form_split.size() > 1
	
	get_node(".").popup_centered()
	
func _on_Description_meta_clicked(meta):
	get_node("Competence").display_comp(meta)
	
func _on_Amlioration_meta_clicked(meta):
	get_node("Competence").display_comp(meta)
