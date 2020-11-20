extends Control

const Competence = preload("res://Scenes/Competence.tscn")
const Formule = preload("res://Scenes/Formule.tscn")
var MenuOpen = false
var comps_data = []

func _ready():
	var json_file = File.new()
	json_file.open("res://competences.json", File.READ)
	comps_data = JSON.parse(json_file.get_as_text()).result
	json_file.close()
	refresh_comps_list(comps_data)
	
func refresh_comps_list(list, hide=false):
	var node = get_node("Content Holder/Comp/DiplayList")
#	--- Supprime tous les noeuds résiduels lors d'un chargement de factions ---
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
#	--- Ajoute tous les noeuds de la faction correspondante ---	
	for p in list:
		var comp = Competence.instance().init(list[p])
		comp.name = p
		get_node("Content Holder/Comp/DiplayList").add_child(comp)
		comp.resize_self()
		comp.get_child(2).connect("meta_clicked", self, "display_comp")
	
#	--- solution dégueue mais ça marche ---
	var c = Control.new()
	c.rect_min_size = Vector2(0,0)
	get_node("Content Holder/Comp/DiplayList").add_child(c)
	
func display_comp(meta):
	var reg = RegEx.new()
	reg.compile("='(.*?)'}")
	var res = reg.search(meta)
	if res:
		res = res.get_string()
		res = res.substr(2, len(res)-4)
		get_node("CompDescription").window_title = res
		get_node("CompDescription/CompDescriptionPopUp").bbcode_text = comps_data[res]["Description"]
		get_node("CompDescription").rect_min_size = Vector2(get_node("CompDescription/CompDescriptionPopUp").rect_size.x + 10, get_node("CompDescription/CompDescriptionPopUp").rect_size.y + 50)
		get_node("CompDescription").popup_centered()
		
# --- Gestion des boutons du menu --
func move_menu():
	var init_pos = get_node("Menu").position
	var target = Vector2(init_pos.x + (319 if !MenuOpen else -319), init_pos.y)
	get_node("Menu").move(target)
	MenuOpen = !MenuOpen
	
func _on_MenuBtn_pressed():
	move_menu()
	
func _on_Accueil_pressed():
	get_tree().change_scene("res://Scenes/Accueil.tscn")
	
func _on_LineEdit_text_changed(search_clue):
	var nodes_profil = get_node("Content Holder/Comp/DiplayList").get_children()
	nodes_profil.pop_back()
	
	for n in nodes_profil:
		var name = n.get_child(1).get_child(0).text
		n.visible = search_clue.is_subsequence_ofi(name.substr(0,len(search_clue)))
	
