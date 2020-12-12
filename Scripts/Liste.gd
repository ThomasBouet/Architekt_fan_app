extends Control

const Profil = preload("res://Scenes/Profil.tscn")
var MenuOpen = false
var teams
var cur_team = []
const load_timer = 0.2


func _ready():
	get_node("MesListes").text = "Mes Listes"
	get_node("Content/Profils_list_display").connect("save", self, "_on_save")
	fill_list_menu()
	
func fill_list_menu():
	var node = get_node("ListeSelecteur/ScrollContainer/VBoxContainer")
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
		
	teams = Json_reader.get_team_saved()
	for t in teams:
		var button = Button.new()
		var nom = t.split(".json")[0]
		button.text = nom
		node.add_child(button)
		button.connect("pressed", self, "display_team", [nom])
		button.add_font_override("font", load("res://Fonts/Text_font.tres"))

func _on_MenuButton_pressed():
	get_node("ListeSelecteur").popup_centered()
	
func _on_Delete_pressed(team_name):
	var node = get_node("ConfirmDialog")
	node.show_dialog("Suppression", "Etes vous sur de vouloir supprimer l'équipe " + team_name + "?")
	node.connect("confirmed", self, "_on_AcceptSuppressionDialog_confirmed", [team_name], CONNECT_ONESHOT)
	
func clean_list_diplay():
	var node = get_node("Content/Profils_list_display/Profils/DiplayList")
#	--- Supprime tous les noeuds résiduels lors d'un chargement de factions ---
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
	
func _on_AcceptSuppressionDialog_confirmed(team_name):
	teams.remove(team_name)
	clean_list_diplay()
	var dir = Directory.new()
	dir.remove("user://" + team_name + ".json")

	fill_list_menu()
	get_node("Content/Faction").text = ""
	get_node("Content/HBoxContainer").visible = false
	get_node("Content/Profils_list_display/").reset_para()
	
func display_team(team_name):
	if get_node("ListeSelecteur").is_visible_in_tree():
		get_node("ListeSelecteur").hide()
	
	get_node("loading_anim").loading()
	yield(get_tree().create_timer(load_timer), "timeout")
	
	var node = get_node("Content/Profils_list_display")
	node.reset_para()
	
	cur_team = team_name + ".json"
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
	if get_node("Content/HBoxContainer/DeleteButton").is_connected("pressed", self, "_on_Delete_pressed"):
		get_node("Content/HBoxContainer/DeleteButton").disconnect("pressed", self, "_on_Delete_pressed")
	get_node("Content/HBoxContainer/DeleteButton").connect("pressed", self, "_on_Delete_pressed", [team_name])
	
	yield(load_faction(node, team_faction), "completed")
	recreate_list(team_members)
	
	if get_node("Content/HBoxContainer/SaveButton").is_connected("pressed", self, "save"):
		get_node("Content/HBoxContainer/SaveButton").disconnect("pressed", self, "save")
	get_node("Content/HBoxContainer/SaveButton").connect("pressed", self, "save", [team_name])
	
	get_node("Content/HBoxContainer/ExportButton").visible = true
	if get_node("Content/HBoxContainer/ExportButton").is_connected("pressed", self, "export_test"):
		get_node("Content/HBoxContainer/ExportButton").disconnect("pressed", self, "export_test")
	get_node("Content/HBoxContainer/ExportButton").connect("pressed", self, "export_list", [team_name])

	yield(get_tree().create_timer(load_timer), "timeout")
	get_node("loading_anim").hide_loading()
	
func load_faction(node, faction):
	node.change_faction(faction)
	yield(get_tree().create_timer(2), "timeout")
	
func recreate_list(list):
	for p in list:
		if p["Type"] == "Héro" or p["Type"] == "Héro/Alchimiste":
			get_node("Content/Profils_list_display/Profils/DiplayList/" + p["Imgs"]).find_node("Add").emit_signal("pressed")
			list.erase(p)
#	print(list)
	for p in list:
		get_node("Content/Profils_list_display/Profils/DiplayList/" + p["Imgs"]).find_node("Add").emit_signal("pressed")
	
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
	
func save(team_name):
	var node = get_node("ConfirmDialog")
	node.show_dialog("Sauvegarde", "Voulez-vous enregistrer les modifications faites à la liste " + team_name + " ?")
	node.connect("confirmed", self, "save_changes", [team_name], CONNECT_ONESHOT)
	
func save_changes(team_name):
	var path = "user://" + team_name + ".json"
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
		
func export_list(team_name):
	save_changes(team_name)
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
	get_node("ImportDialog").connect("confirmed", self, "import_confirmed")
	get_node("ImportDialog").rect_position = Vector2(get_node("ImportDialog").rect_position.x, get_node("ImportDialog").rect_position.y-84*2)
	
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
		fill_list_menu()
