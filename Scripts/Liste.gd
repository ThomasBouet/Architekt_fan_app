extends Control

const Profil = preload("res://Scenes/Profil.tscn")
var MenuOpen = false
var maxPts = 180
var currentPTS = 0
var teams = Json_reader.get_team_saved()
var cur_team = []
var Team = []
var list_hero = []
var list_alchi = []
var list_tpe = []

func _ready():
	get_node("MesListes").text = "Mes Listes"
	get_node("Content/Content Holder/Panel").init()
	get_node("Content/Content Holder/Panel").visible = false
	get_node("Content/Content Holder/ProgressBar").visible = false
	
	get_node("AccepSuppressiontDialog").add_cancel("Annuler")
	fill_list_menu()
	
func fill_list_menu():
	teams = Json_reader.get_team_saved()
	for t in teams:
		var nom = t.split(".json")[0]
		get_node("Content/MenuButton").get_popup().add_item(nom)
	get_node("Content/MenuButton").get_popup().connect("id_pressed", self, "display_team")
	
func _on_Delete_pressed(id):
	get_node("AccepSuppressiontDialog").dialog_text = "Etes vous sur de vouloir supprimer l'équipe " + teams[id].split(".json")[0] + "?"
	get_node("AccepSuppressiontDialog").popup_centered()
	get_node("AccepSuppressiontDialog").connect("confirmed", self, "_on_AcceptSuppressionDialog_confirmed", [id])
	
func clean_list_diplay():
	var node = get_node("Content/Content Holder/Profils/DiplayList")
#	--- Supprime tous les noeuds résiduels lors d'un chargement de factions ---
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
		
	get_node("Content/Content Holder/Panel").visible = false
	get_node("Content/Content Holder/ProgressBar").visible = false
	
func _on_AcceptSuppressionDialog_confirmed(id):
	var nom = teams[id]
	teams.remove(nom)
	get_node("Content/MenuButton").get_popup().clear()
	clean_list_diplay()
	var dir = Directory.new()
	dir.remove("user://" + nom)
	
	fill_list_menu()
	get_node("Content/Faction").text = ""
	get_node("Delete").visible = false
	
func display_team(id):
#	print(id)
	cur_team = teams[id]
	Team = []
	currentPTS = 0
	var infos_team = Json_reader.get_team(cur_team)
	var team_max = infos_team[0]
	var team_faction = infos_team[1]
	var team_members = infos_team[2]
	
	maxPts = team_max
	get_node("Content/Faction").visible = true
	get_node("Content/Faction").text = team_faction
	get_node("Content/Content Holder/Panel").visible = true
	get_node("Content/Content Holder/Panel").resize_self()
	get_node("Content/Content Holder/ProgressBar").visible = true
	get_node("Content/Content Holder/ProgressBar").max_value = team_max
	get_node("Content/Content Holder/HBoxContainer2/SpinBox").value = team_max
	get_node("Content/Content Holder").visible = true
	get_node("Content/HBoxContainer").visible = true
	get_node("Content/HBoxContainer/DeleteButton").visible = true
	get_node("Content/HBoxContainer/DeleteButton").disconnect("pressed", self, "_on_Delete_pressed")
	get_node("Content/HBoxContainer/DeleteButton").connect("pressed", self, "_on_Delete_pressed", [id])
	
	refresh_profils_list(Json_reader.profils_data[team_faction])
	recreate_list(team_members)
	
	get_node("Content/HBoxContainer/SaveButton").disconnect("pressed", self, "save")
	get_node("Content/HBoxContainer/SaveButton").connect("pressed", self, "save", [id])
	
	get_node("Content/HBoxContainer/ExportButton").visible = true
	get_node("Content/HBoxContainer/ExportButton").disconnect("pressed", self, "export_test")
	get_node("Content/HBoxContainer/ExportButton").connect("pressed", self, "export_list", [id])
	
func display_list_type_profil(categorie, list, cat_list, hide):
	var node = get_node("Content/Content Holder/Profils/DiplayList")
	var label = Label.new()
	label.text = categorie
	label.add_font_override("font", load("res://Fonts/Text_font.tres"))
	node.add_child(label)
#	--- Ajoute tout les héros de la faction correspondante ---	
	for p in list:
		var profil = Profil.instance().init(p, hide)
		profil.name = p["Imgs"]
		profil.find_node("Add").connect("pressed", self, "add_to_team", [profil])
		profil.find_node("Remove").connect("pressed", self, "remove_from_team", [profil])
		node.add_child(profil)
		profil.resize_self(node.rect_size)
		cat_list.append(profil)
	
func refresh_profils_list(list, hide=false):
	get_node("Content/Content Holder/HBoxContainer/heros").disconnect("toggled", self, "display_list")
	get_node("Content/Content Holder/HBoxContainer/alchis").disconnect("toggled", self, "display_list")
	get_node("Content/Content Holder/HBoxContainer/troupes").disconnect("toggled", self, "display_list")

	list_hero = []
	list_alchi = []
	list_tpe = []
	var lists = Json_reader.get_list_for_each_type(list)
	var node = get_node("Content/Content Holder/Profils/DiplayList")
#	--- Supprime tous les noeuds résiduels lors d'un chargement de factions ---
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
		
	display_list_type_profil("Héros", lists[0], list_hero, hide)
	display_list_type_profil("Alchimistes", lists[1], list_alchi, hide)
	display_list_type_profil("Troupes", lists[2], list_tpe, hide)
	
#	--- solution dégueue mais ça marche ---
	var c = Control.new()
	c.rect_min_size = Vector2(0,0)
	node.add_child(c)
	
	get_node("Content/Content Holder/HBoxContainer/heros").connect("toggled", self, "display_list", [list_hero])
	get_node("Content/Content Holder/HBoxContainer/alchis").connect("toggled", self, "display_list", [list_alchi])
	get_node("Content/Content Holder/HBoxContainer/troupes").connect("toggled", self, "display_list", [list_tpe])
	
func recreate_list(list):
	var hero = null
	for p in list:
		if p["Type"] == "Héro" or p["Type"] == "Héro/Alchimiste":
			get_node("Content/Content Holder/Profils/DiplayList/" + p["Imgs"]).find_node("Add").emit_signal("pressed")
			list.erase(p)
#	print(list)
	for p in list:
		get_node("Content/Content Holder/Profils/DiplayList/" + p["Imgs"]).find_node("Add").emit_signal("pressed")
	
func display_list(boolean, list):
	for i in list:
		i.visible = boolean
	
func _on_ProgressBar_value_changed(value):
	get_node("Content/Content Holder/ProgressBar/Label").text = str(value) + "/" + str(maxPts)
	must_save()
	
func add_to_team(node):
	var res = Team_handler.add_to_team(maxPts, currentPTS, get_node("Content/Faction").text, Team, node)
	if typeof(res) == TYPE_STRING:
		show_message("Ajout impossible", res)
		return
		
	Team = res[0]
	currentPTS = res[1]
	get_node("Content/Content Holder/ProgressBar").value = currentPTS
	get_node("Content/Content Holder/Panel").avg_stats(Team)
	get_node("Content/HBoxContainer/SaveButton").visible = Team_handler.get_nb_heros(Team) != 0
	
	if get_node("Content/Faction").text == "Triade de Jade":
		Team_handler.unlock_sarge(Team, get_node("Content/Content Holder/Profils/DiplayList/Sergent"))
	
	if get_node("Content/Faction").text == "Cartel" or get_node("Content/Faction").text == "Khaliman":
		var res2 = Team_handler.unlock_animals(Team, list_hero + list_alchi + list_tpe)
#		--- Gestion des mofications de recutement ---
	if Json_reader.CHANGE_RECRUTEMENT.has(node.profil["Imgs"]):
		var node_to_modify = Json_reader.CHANGE_RECRUTEMENT[node.profil["Imgs"]][0]
		var qty = Json_reader.CHANGE_RECRUTEMENT[node.profil["Imgs"]][1]
		var node_modified = get_node("Content Holder/Profils/DiplayList/"+node_to_modify)
		if node_modified != null:
			var new_max = qty + node_modified.get_max()
			node_modified.set_max(new_max)
			node_modified.manage_recruitement(node_modified.get_recuitement())
	must_save()
	
func remove_from_team(node):
#	print("removing " + node.profil["Nom"])
	var res = Team_handler.remove_from_team(currentPTS, Team, node)
	Team = res[0]
	currentPTS = res[1]
	get_node("Content/Content Holder/ProgressBar").value = currentPTS
	get_node("Content/Content Holder/Panel").avg_stats(Team)
	get_node("Content/HBoxContainer/SaveButton").visible = (Team_handler.get_nb_heros(Team) != 0) if currentPTS < maxPts else false
	
	if get_node("Content/Faction").text == "Triade de Jade":
		var res2 = Team_handler.lock_sarge(Team, get_node("Content/Content Holder/Profils/DiplayList/Sergent"), currentPTS)
		Team = res2[0] 
		currentPTS = res2[1]
		get_node("Content/Content Holder/ProgressBar").value = currentPTS
		get_node("Content/Content Holder/Panel").avg_stats(Team)
		
	if get_node("Content/Faction").text == "Cartel" or get_node("Content/Faction").text == "Khaliman":
		var res2 = Team_handler.lock_animals(Team, list_hero + list_alchi + list_tpe, currentPTS) 
		Team = res2[0]
		currentPTS = res2[1]
		get_node("Content/Content Holder/ProgressBar").value = currentPTS
		get_node("Content/Content Holder/Panel").avg_stats(Team)
	
#		--- Gestion des mofications de recutement ---
	if Json_reader.CHANGE_RECRUTEMENT.has(node.profil["Imgs"]):
		var node_to_modify = Json_reader.CHANGE_RECRUTEMENT[node.profil["Imgs"]][0]
		var qty = Json_reader.CHANGE_RECRUTEMENT[node.profil["Imgs"]][1]
		var node_modified = get_node("Content/Content Holder/Profils/DiplayList/"+node_to_modify)
		if node_modified != null:
#			print(node_modified.get_max())
			var new_max = node_modified.get_max() - qty 
			var nb_recruited = node_modified.get_recuitement()
			node_modified.set_max(new_max)
			node_modified.manage_recruitement(nb_recruited)
			if nb_recruited > new_max:
				for _i in range(nb_recruited - new_max):
					Team.remove(Team.find(node_modified.profil))
					currentPTS -= int(node_modified.profil["Cout"])
					get_node("Content/Content Holder/ProgressBar").value = currentPTS
					get_node("Content/Content Holder/Panel").avg_stats(Team)
					
	must_save()
	
func show_message(title, msg):
	get_node("OverWriteDialog").window_title = title
	get_node("OverWriteDialog").dialog_text = msg
	get_node("OverWriteDialog").popup_centered()
	
func must_save():
	var infos_list = Json_reader.get_team(cur_team)
	get_node("Content/HBoxContainer/SaveButton").visible = !Team_handler.compare_list(Team, infos_list[2]) or infos_list[0] != maxPts
	
func save(id):
	get_node("SaveDialoge").add_cancel("Annuler")
	get_node("SaveDialoge").dialog_text = "Voulez-vous enregistrer les modifications faites à la liste " + teams[id].split(".json")[0] + " ?"
	get_node("SaveDialoge").connect("confirmed", self, "save_changes", [id])
	get_node("SaveDialoge").popup_centered()
	
func save_changes(id):
	var path = "user://" + teams[id]
	var file = File.new()
	if file.file_exists(path):
		file.open(path, File.WRITE)
		var team_stored = [maxPts, get_node("Content/Faction").text, Team]
		file.store_string(to_json(team_stored))
		file.close()
		must_save()
	else:
		show_message("Problème d'enregistrement", "La liste n'existe pas o_O ?")
		
func export_list(id):
	save_changes(id)
	var list_to_str = get_node("ExportImport").export_list(Json_reader.get_team(cur_team))
	get_node("ExportDialog").popup_centered()
	get_node("ExportDialog").dialog_text = list_to_str
	get_node("ExportDialog").connect("confirmed", self, "export_confirmed", [list_to_str])
	get_node("ExportDialog").get_ok().text = "Copier dans le presse-papier"
	
func export_confirmed(list_str):
	OS.set_clipboard(list_str)
	get_node("OverWriteDialog").popup_centered()
	get_node("OverWriteDialog").dialog_text = "La liste à été copiée dans le presse-papier"
	
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
	
func _on_SpinBox_value_changed(value):
	maxPts = int(value)
	_on_ProgressBar_value_changed(get_node("Content/Content Holder/ProgressBar").value)
	pass # Replace with function body.
