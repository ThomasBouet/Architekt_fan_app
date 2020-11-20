extends AcceptDialog


func display_form(form):
	var json_file = File.new()
	json_file.open("res://formules.json", File.READ)
	var form_data = JSON.parse(json_file.get_as_text()).result
	json_file.close()
	
	get_node(".").window_title = form
	var formule = form_data[form]
	get_node("VBoxContainer/HBoxContainer/Cout").text = "Cout : " + formule[0]
	get_node("VBoxContainer/HBoxContainer/Cible").text = "Portée : " + formule[1]
	get_node("VBoxContainer/HBoxContainer/Portee").text = "Cible : " + formule[2]
	
	var form_split = formule[3].split("Améliorations\r\n")
	get_node("VBoxContainer/Description").bbcode_text = form_split[0]
	get_node("VBoxContainer/Amélioration").text = form_split[1]
	
	get_node(".").popup_centered()
	
func _on_Description_meta_clicked(meta):
	get_node("Competence").display_comp(meta)
