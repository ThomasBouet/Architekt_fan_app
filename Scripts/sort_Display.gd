extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const Sort = preload("res://Scenes/Sort.tscn")
var MenuOpen = false
var comps_data = []
var sorts_data = []

func _ready():
	var json_file = File.new()
	json_file.open("res://competences.json", File.READ)
	comps_data = JSON.parse(json_file.get_as_text()).result
	json_file.close()
	
	json_file = File.new()
	json_file.open("res://sorts.json", File.READ)
	sorts_data = JSON.parse(json_file.get_as_text()).result
	json_file.close()
	refresh_sorts_list(sorts_data)
	
func refresh_sorts_list(list, hide=false):
	var node = get_node("Content Holder/Sort/DiplayList")
#	--- Supprime tous les noeuds résiduels lors d'un chargement de factions ---
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
#	--- Ajoute tous les noeuds de la faction correspondante ---	
	for p in list:
		var sort = Sort.instance().init(list[p])
		sort.name = p
		get_node("Content Holder/Sort/DiplayList").add_child(sort)
		sort.resize_self()
		sort.get_child(2).get_child(2).connect("meta_clicked", self, "display_comp")
	
#	--- solution dégueue mais ça marche ---
	var c = Control.new()
	c.rect_min_size = Vector2(0,0)
	get_node("Content Holder/Sort/DiplayList").add_child(c)
	
func display_comp(meta):
	print(meta)
	var reg = RegEx.new()
	reg.compile("='(.*?)'}")
	var res = reg.search(meta)
	if res:
		res = res.get_string()
		res = res.substr(2, len(res)-4)
		print(res, res in comps_data)
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
	
func _on_Tous_pressed():
	get_tree().change_scene("res://Scenes/Profils_Display.tscn")
	
func _on_Accueil_pressed():
	get_tree().change_scene("res://Scenes/Accueil.tscn")
	
func _on_Mes_listes_pressed():
	get_tree().change_scene("res://Scenes/Liste.tscn")
	
func _on_LineEdit_text_changed(search_clue):
	var nodes_profil = get_node("Content Holder/Sort/DiplayList").get_children()
	nodes_profil.pop_back()
	
	for n in nodes_profil:
		var name = n.get_child(1).get_child(0).text
		n.visible = search_clue.is_subsequence_ofi(name.substr(0,len(search_clue)))
	
