extends VBoxContainer


const Profil = preload("res://Scenes/Profil.tscn")
var maxPts = 180 setget set_maxPts, get_maxPts
var currentPTS = 0 setget set_curPts, get_curPts
var Team = [] setget set_Team, get_Team 
var list_hero = []
var list_alchi = []
var list_tpe = []
var faction = "Profils"
signal begin_loading
signal end_loading
signal save
	
func set_curPts(v):
	currentPTS = v
	
func get_curPts():
	return currentPTS
	
func set_maxPts(v):
	maxPts = v
	
func get_maxPts():
	return maxPts
	
func set_Team(v):
	Team = v
	
func get_Team():
	return Team
	
func _ready():
	get_node("Panel").init()
	
func add_to_team(node):
#	print("adding " + node.profil["Nom"])
	if faction == "Profils":
		return
		
	var res = Team_handler.add_to_team(maxPts, currentPTS, faction, Team, node)
	
	if typeof(res) == TYPE_STRING:
		show_message("Ajout impossible", res)
		return
		
	Team = res[0]
	currentPTS = res[1]
	get_node("ProgressBar").value = currentPTS
	get_node("Panel").avg_stats(Team)
	emit_signal("save", Team_handler.get_nb_heros(Team) != 0)
	
	if faction == "Triade de Jade":
		Team_handler.unlock_sarge(Team, get_node("Profils/DiplayList/Sergent"))
	
	if faction == "Cartel" or faction == "Khaliman":
		Team_handler.unlock_animals(Team, list_hero + list_alchi + list_tpe)
#		--- Gestion des mofications de recutement ---
	if Json_reader.CHANGE_RECRUTEMENT.has(node.profil["Imgs"]):
		var node_to_modify = Json_reader.CHANGE_RECRUTEMENT[node.profil["Imgs"]][0]
		var qty = Json_reader.CHANGE_RECRUTEMENT[node.profil["Imgs"]][1]
		var node_modified = get_node("Profils/DiplayList/"+node_to_modify)
		if node_modified != null:
			var new_max = qty + node_modified.get_max()
			node_modified.set_max(new_max)
			node_modified.manage_recruitement(node_modified.get_recuitement())
	
func remove_from_team(node):
#	print("removing " + node.profil["Nom"])
	var res = Team_handler.remove_from_team(currentPTS, Team, node)
	Team = res[0]
	currentPTS = res[1]
	get_node("ProgressBar").value = currentPTS
	get_node("Panel").avg_stats(Team)
	emit_signal("save", (Team_handler.get_nb_heros(Team) != 0) if currentPTS < maxPts else false)
	
	if faction == "Triade de Jade":
		var res2 = Team_handler.lock_sarge(Team, get_node("Profils/DiplayList/Sergent"), currentPTS)
		Team = res2[0] 
		currentPTS = res2[1]
		get_node("ProgressBar").value = currentPTS
		get_node("Panel").avg_stats(Team)
		
	if faction == "Cartel" or faction == "Khaliman":
		var res2 = Team_handler.lock_animals(Team, list_hero + list_alchi + list_tpe, currentPTS) 
		Team = res2[0]
		currentPTS = res2[1]
		get_node("ProgressBar").value = currentPTS
		get_node("Panel").avg_stats(Team)
	
#		--- Gestion des mofications de recutement ---
	if Json_reader.CHANGE_RECRUTEMENT.has(node.profil["Imgs"]):
		var node_to_modify = Json_reader.CHANGE_RECRUTEMENT[node.profil["Imgs"]][0]
		var qty = Json_reader.CHANGE_RECRUTEMENT[node.profil["Imgs"]][1]
		var node_modified = get_node("Profils/DiplayList/"+node_to_modify)
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
					get_node("ProgressBar").value = currentPTS
					get_node("Panel").avg_stats(Team)

func display_list_type_profil(categorie, list, cat_list, hide):
	var node = get_node("Profils/DiplayList")
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
	
func refresh_profils_list(list, hide=false, tous=false):
	get_node("HBoxContainer/heros").disconnect("toggled", self, "display_list")
	get_node("HBoxContainer/alchis").disconnect("toggled", self, "display_list")
	get_node("HBoxContainer/troupes").disconnect("toggled", self, "display_list")

	list_hero = []
	list_alchi = []
	list_tpe = []
	var lists = Json_reader.get_list_for_each_type(list)
	var node = get_node("Profils/DiplayList")
	
#	--- Supprime tous les noeuds résiduels lors d'un chargement de factions ---
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
		
	display_list_type_profil("Héros", lists[0] if !tous else Team_handler.sort_profil_list(lists[0]), list_hero, hide)
	display_list_type_profil("Alchimistes", lists[1] if !tous else Team_handler.sort_profil_list(lists[1]), list_alchi, hide)
	display_list_type_profil("Troupes", lists[2] if !tous else Team_handler.sort_profil_list(lists[2]), list_tpe, hide)
#	
#	--- solution dégueue mais ça marche ---
	var c = Control.new()
	c.rect_min_size = Vector2(0,0)
	node.add_child(c)
	
	get_node("HBoxContainer/heros").connect("toggled", self, "display_list", [list_hero])
	get_node("HBoxContainer/alchis").connect("toggled", self, "display_list", [list_alchi])
	get_node("HBoxContainer/troupes").connect("toggled", self, "display_list", [list_tpe])
	
func display_list(boolean, list):
	for i in list:
		i.visible = boolean
	
func _on_ProgressBar_value_changed(value):
	get_node("ProgressBar/Label").text = str(value) + "/" + str(maxPts)
	
func show_message(title, msg):
	get_node("DisplayDialog").show_dialog(title, msg)
	
func _on_LineEdit_text_changed(search_clue):
	var nodes_profil = list_hero + list_alchi + list_tpe
	for n in nodes_profil:
		var name = n.get_node("Nom/Label").text
		n.visible = search_clue.is_subsequence_ofi(name.substr(0,len(search_clue)))
	
func _on_SpinBox_value_changed(value):
	if Team_handler.get_nb_heros(Team) > 1 and maxPts <= 200:
		show_message("Problème", "Réduction de la limite de recrutement impossible.\nPour changer la limlite veuillez d'abords retirez un des héros de votre liste.")
		return
	maxPts = int(value)
	_on_ProgressBar_value_changed(get_node("ProgressBar").value)
	
func change_tous():
	emit_signal("begin_loading")
	Team = []
	faction = "Profils"
	get_node("Panel").visible = false
	get_node("ProgressBar").visible = false
	get_node("HBoxContainer2").visible = false
	get_node("HBoxContainer").visible = true
	get_node("LineEdit").visible = true
	refresh_profils_list(Json_reader.load_all_factions(), true, true)
	emit_signal("end_loading")

# --- Gestion de l'affichage des profils ---
func change_faction(f):
	emit_signal("begin_loading")
	faction = f
	Team = []
	currentPTS = 0
	get_node("Panel").visible = true
	get_node("Panel").resize_self()
	get_node("ProgressBar").visible = true
	get_node("ProgressBar").value = currentPTS
	get_node("HBoxContainer2").visible = true
	get_node("HBoxContainer").visible = false
	get_node("LineEdit").visible = false
	refresh_profils_list(Json_reader.profils_data[f])
	emit_signal("end_loading")
	
func reset_para():
	Team = []
	maxPts = 180
	currentPTS = 0
	list_hero = []
	list_alchi = []
	list_tpe = []
	get_node("Panel").avg_stats(Team)
	get_node("ProgressBar").max_value = maxPts
	get_node("ProgressBar").value = currentPTS
	get_node("HBoxContainer2/SpinBox").value = maxPts
	get_node("ProgressBar").visible = false
	get_node("Panel").visible = false
	get_node("HBoxContainer2").visible = false
	
