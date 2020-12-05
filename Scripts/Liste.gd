extends Control

const Profil = preload("res://Scenes/Profil.tscn")
var MenuOpen = false
var teams = Json_reader.get_team_saved()
var cur_team = []


func _ready():
	get_node("MesListes").text = "Mes Listes"
	get_node("Content/Profils_list_display").connect("save", self, "_on_save")
	fill_list_menu()
	
func fill_list_menu():
	teams = Json_reader.get_team_saved()
	for t in teams:
		var nom = t.split(".json")[0]
		get_node("Content/MenuButton").get_popup().add_item(nom)
	get_node("Content/MenuButton").get_popup().connect("id_pressed", self, "display_team")
	
func _on_Delete_pressed(id):
	var node = get_node("ConfirmDialog")
	node.show_dialog("Suppression", "Etes vous sur de vouloir supprimer l'équipe " + teams[id].split(".json")[0] + "?")
	node.connect("confirmed", self, "_on_AcceptSuppressionDialog_confirmed", [id], CONNECT_ONESHOT)
	
func clean_list_diplay():
	var node = get_node("Content/Profils_list_display/Profils/DiplayList")
#	--- Supprime tous les noeuds résiduels lors d'un chargement de factions ---
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
	
func _on_AcceptSuppressionDialog_confirmed(id):
	var nom = teams[id]
	teams.remove(nom)
	get_node("Content/MenuButton").get_popup().clear()
	clean_list_diplay()
	var dir = Directory.new()
	dir.remove("user://" + nom)

	fill_list_menu()
	get_node("Content/Faction").text = ""
	get_node("Content/HBoxContainer").visible = false
	get_node("Content/Profils_list_display/").reset_para()
	
func display_team(id):
	get_node("Loading_animation").loading()
#	print(id)
	var node = get_node("Content/Profils_list_display")
	node.reset_para()
	
	cur_team = teams[id]
	var infos_team = Json_reader.get_team(cur_team)
	var team_max = infos_team[0]
	var team_faction = infos_team[1]
	var team_members = infos_team[2]
	
	node.set_maxPts(team_max)
	
	get_node("Content/Faction").visible = true
	get_node("Content/Faction").text = team_faction
	get_node("Content/Profils_list_display/ProgressBar").max_value = team_max
	get_node("Content/Profils_list_display/HBoxContainer2/SpinBox").value = team_max
	node.visible = true
	get_node("Content/HBoxContainer").visible = true
	get_node("Content/HBoxContainer/DeleteButton").visible = true
	get_node("Content/HBoxContainer/DeleteButton").disconnect("pressed", self, "_on_Delete_pressed")
	get_node("Content/HBoxContainer/DeleteButton").connect("pressed", self, "_on_Delete_pressed", [id])
	
	node.change_faction(team_faction)
	recreate_list(team_members)
	
	get_node("Content/HBoxContainer/SaveButton").disconnect("pressed", self, "save")
	get_node("Content/HBoxContainer/SaveButton").connect("pressed", self, "save", [id])
	
	get_node("Content/HBoxContainer/ExportButton").visible = true
	get_node("Content/HBoxContainer/ExportButton").disconnect("pressed", self, "export_test")
	get_node("Content/HBoxContainer/ExportButton").connect("pressed", self, "export_list", [id])

	get_node("Loading_animation").hide_loading()
	
func recreate_list(list):
	for p in list:
		if p["Type"] == "Héro" or p["Type"] == "Héro/Alchimiste":
			get_node("Content/Profils_list_display/Profils/DiplayList/" + p["Imgs"]).find_node("Add").emit_signal("pressed")
			list.erase(p)
#	print(list)
	for p in list:
		get_node("Content/Profils_list_display/Profils/DiplayList/" + p["Imgs"]).find_node("Add").emit_signal("pressed")
	
func display_list(boolean, list):
	for i in list:
		i.visible = boolean
	
func _on_save(_value):
	must_save()
#	vérifier plutôt à l'ajout et au retrait d'un profil
	
func show_message(title, msg):
	var node = get_node("DisplayDialog")
	node.show_dialog(title, msg)
	
func must_save():
	var infos_list = Json_reader.get_team(cur_team)
	var Team = get_node("Content/Profils_list_display").get_Team()
	var maxPts = get_node("Content/Profils_list_display").get_maxPts()
	get_node("Content/HBoxContainer/SaveButton").visible = !Team_handler.compare_list(Team, infos_list[2]) or infos_list[0] != maxPts
	
func save(id):
	var node = get_node("ConfirmDialog")
	node.show_dialog("Sauvegarde", "Voulez-vous enregistrer les modifications faites à la liste " + teams[id].split(".json")[0] + " ?")
	node.connect("confirmed", self, "save_changes", [id], CONNECT_ONESHOT)
	
func save_changes(id):
	var path = "user://" + teams[id]
	var file = File.new()
	if file.file_exists(path):
		file.open(path, File.WRITE)
		var Team = get_node("Content/Profils_list_display").get_Team()
		var maxPts = get_node("Content/Profils_list_display").get_maxPts()
		var team_stored = [maxPts, get_node("Content/Faction").text, Team]
		file.store_string(to_json(team_stored))
		file.close()
		must_save()
		show_message("Sauvegarde", "La sauvegarde a été un succès" if !get_node("Content/HBoxContainer/SaveButton").visible else "Un problème est survenue lors de la sauvegarde.")
	else:
		show_message("Problème d'enregistrement", "La liste n'existe pas o_O ?")
		
func export_list(id):
	save_changes(id)
	var list_to_str = get_node("ExportImport").export_list(Json_reader.get_team(cur_team))
	show_message("Exportation", list_to_str)
	get_node("DisplayDialog").connect("confirmed", self, "export_confirmed", [list_to_str], CONNECT_ONESHOT)
	get_node("DisplayDialog").get_ok().text = "Copier dans le presse-papier"
	
func export_confirmed(list_str):
	OS.set_clipboard(list_str)
	print(OS.get_clipboard())
	show_message("Exportation", "La liste a été copiée dans le presse-papier" if OS.get_clipboard() == list_str else "La liste n'a pas été copiée dans le presse-papier")
	
func _on_ImportButton_pressed():
	get_node("ImportDialog").popup_centered()
	get_node("ImportDialog").add_cancel("Annuler")
	get_node("ImportDialog").connect("confirmed", self, "import_confirmed")
	
func import_confirmed():
	var nom = get_node("ImportDialog/VBoxContainer/ListName").text
	var list = get_node("ImportDialog/VBoxContainer/Liste").text
	var res = get_node("ExportImport").import_list(list)
#	print(res)
	if typeof(res) == TYPE_STRING:
		show_message("Erreur lors d'imortation", res)
		return
		
	var path = "user://" + nom + ".json"
	var file = File.new()
	if file.file_exists(path):
		show_message("Problème d'enregistrement", "Fichier déjà existant")
	else:
		file.open(path, File.WRITE)
		file.store_string(to_json(res))
		file.close()
		get_node("Content/MenuButton").get_popup().clear()
		fill_list_menu()
	
