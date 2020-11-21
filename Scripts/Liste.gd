extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const Profil = preload("res://Scenes/Profil.tscn")
var MenuOpen = false
var hashero = false
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
	var infos_team = Json_reader.get_team(cur_team)
	var team_max = infos_team[0]
	var team_faction = infos_team[1]
	var team_members = infos_team[2]
	
	get_node("Content/Faction").visible = true
	get_node("Content/Faction").text = team_faction
	get_node("Content/Content Holder/Panel").visible = true
	get_node("Content/Content Holder/ProgressBar").visible = true
	get_node("Content/Content Holder").visible = true
	get_node("Delete").visible = true
	get_node("Delete/DeleteButton").disconnect("pressed", self, "_on_Delete_pressed")
	get_node("Delete/DeleteButton").connect("pressed", self, "_on_Delete_pressed", [id])
	
	refresh_profils_list(Json_reader.profils_data[team_faction])
	recreate_list(team_members)
	
	get_node("Save/SaveButton").disconnect("pressed", self, "save")
	get_node("Save/SaveButton").connect("pressed", self, "save", [id])
	
	get_node("Content/Content Holder/ExportButton").visible = true
	get_node("Content/Content Holder/ExportButton").disconnect("pressed", self, "export_test")
	get_node("Content/Content Holder/ExportButton").connect("pressed", self, "export_list", [id, Json_reader.get_team(cur_team)])
	
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
		
	var hero_label = Label.new()
	hero_label.text = "Héros"
	node.add_child(hero_label)
#	--- Ajoute tout les héros de la faction correspondante ---	
	for p in lists[0]:
		var profil = Profil.instance().init(p, hide)
		profil.name = p["Imgs"]
		profil.find_node("Add").connect("pressed", self, "add_to_team", [p, profil])
		profil.find_node("Remove").connect("pressed", self, "remove_from_team", [p, profil])
		node.add_child(profil)
		profil.resize_self(node.rect_size)
		list_hero.append(profil)
		
	var alchi_label = Label.new()
	alchi_label.text = "Alchimistes"
	node.add_child(alchi_label)
#	--- Ajoute tout les alchimistes et héros de la faction correspondante ---	
	for p in lists[1]:
		var profil = Profil.instance().init(p, hide)
		profil.name = p["Imgs"]
		profil.find_node("Add").connect("pressed", self, "add_to_team", [p, profil])
		profil.find_node("Remove").connect("pressed", self, "remove_from_team", [p, profil])
		node.add_child(profil)
		profil.resize_self(node.rect_size)
		list_alchi.append(profil)
		
	var troupe_label = Label.new()
	troupe_label.text = "Troupes"
	node.add_child(troupe_label)
#	--- Ajoute toutes les troupes de la faction correspondante ---	
	for p in lists[2]:
		var profil = Profil.instance().init(p, hide)
		profil.name = p["Imgs"]
		profil.find_node("Add").connect("pressed", self, "add_to_team", [p, profil])
		profil.find_node("Remove").connect("pressed", self, "remove_from_team", [p, profil])
		node.add_child(profil)
		profil.resize_self(node.rect_size)
		list_tpe.append(profil)
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
			hero = p
	get_node("Content/Content Holder/Profils/DiplayList/" + hero["Imgs"]).find_node("Add").emit_signal("pressed")
	list.erase(hero)
	for p in list:
		get_node("Content/Content Holder/Profils/DiplayList/" + p["Imgs"]).find_node("Add").emit_signal("pressed")
	
func display_list(boolean, list):
	for i in list:
		i.visible = boolean
	
func _on_ProgressBar_value_changed(value):
	get_node("Content/Content Holder/ProgressBar/Label").text = str(value) + "/" + str(maxPts)
	must_save()
	
func add_to_team(p, node):
#	print("adding " + node.profil["Nom"])
	if node.profil["Type"] == "Héro" or node.profil["Type"] == "Héro/Alchimiste":
		if hashero:
#			TODO: Mettre un popup
			show_message("Ajout impossible", "Un héros se trouve déjà dans votre liste.\nVous ne pouvez avoir qu'un seul héro par liste.")
			return
		else:
			hashero = true
#			get_node("Save").visible = true
#	--- On autorise l'ajout que s'il l'on peut encore ajouter sans dépasser le seuil ---
	if currentPTS + int(node.profil["Cout"]) <= maxPts:
		Team.append(p)
		currentPTS += int(node.profil["Cout"])
		get_node("Content/Content Holder/ProgressBar").value = currentPTS
		get_node("Content/Content Holder/Panel").avg_stats(Team)
		
#		--- Gestion de l'atteinte du max de recrutement ---
		node.manage_recruitement(node.get_recuitement() + 1)
		
#		--- Gestion des mofications de recutement ---
		if Json_reader.CHANGE_RECRUTEMENT.has(node.profil["Imgs"]):
			var node_to_modify = Json_reader.CHANGE_RECRUTEMENT[node.profil["Imgs"]][0]
			var qty = Json_reader.CHANGE_RECRUTEMENT[node.profil["Imgs"]][1]
			var node_modified = get_node("Content/Content Holder/Profils/DiplayList/"+node_to_modify)
			if node_modified != null:
				var new_max = qty + node_modified.get_max()
				node_modified.set_max(new_max)
				node_modified.manage_recruitement(node_modified.get_recuitement())
	else:
		show_message("Ajout impossible", "L'ajout de ce profil n'est pas possible.\n La limite de point serait dépassée.")
	
	must_save()
	
func remove_from_team(p, node):
#	print("removing " + node.profil["Nom"])
	if (node.profil["Type"] == "Héro" or node.profil["Type"] == "Héro/Alchimiste") and hashero:
		hashero = false
		get_node("Save").visible = false
		
	Team.erase(p)
	currentPTS -= int(node.profil["Cout"])
	get_node("Content/Content Holder/ProgressBar").value = currentPTS
	get_node("Content/Content Holder/Panel").avg_stats(Team)
	
#	--- Gestion de l'atteinte du min de recrutement ---
	node.manage_recruitement(node.get_recuitement() - 1)
	
#		--- Gestion des mofications de recutement ---
	if Json_reader.CHANGE_RECRUTEMENT.has(node.profil["Imgs"]):
		var node_to_modify = Json_reader.CHANGE_RECRUTEMENT[node.profil["Imgs"]][0]
		var qty = Json_reader.CHANGE_RECRUTEMENT[node.profil["Imgs"]][1]
		var node_modified = get_node("Content/Content Holder/Profils/DiplayList/"+node_to_modify)
		if node_modified != null:
			var new_max = node_modified.get_max() - qty 
			var nb_recuited = node_modified.get_recuitement()
			node_modified.set_max(new_max)
			node_modified.manage_recruitement(new_max)
			if nb_recuited > new_max:
				for _i in range(nb_recuited - new_max):
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
	get_node("Save").visible = !Json_reader.compare_list(Team, infos_list[2]) or infos_list[0] != maxPts
	
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
	else:
		show_message("Problème d'enregistrement", "La liste n'existe pas o_O ?")
		
func export_list(id, list):
	save_changes(id)
	var list_to_str = get_node("ExportImport").export_list(list)
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
	get_node("ImportDialog").connect("confirmed", self, "import_confirmed", [get_node("ImportDialog").find_node("Liste").text, get_node("ImportDialog").find_node("ListName").text])

func import_confirmed(nom, list):
	var res = get_node("ExportImport").import_list(list)
	
	if typeof(res) == TYPE_STRING:
		get_node("OverWriteDialog").popup_centered()
		get_node("OverWriteDialog").dialog_text = res
		return
		
	var path = "user://" + nom + ".json"
	var file = File.new()
	if file.file_exists(path):
		show_message("Problème d'enregistrement", "Fichier déjà existant")
	else:
		file.open(path, File.WRITE)
		file.store_string(to_json(list))
		file.close()
	
func _on_SpinBox_value_changed(value):
	maxPts = int(value)
	_on_ProgressBar_value_changed(get_node("Content/Content Holder/ProgressBar").value)
	pass # Replace with function body.
