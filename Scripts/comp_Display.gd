extends Control

const Competence = preload("res://Scenes/Competence.tscn")
const Formule = preload("res://Scenes/Formule.tscn")
var MenuOpen = false
var comps_data = []
var form_data = []

func _ready():
	comps_data = Json_reader.comps_data
	form_data = Json_reader.forms_data
	
	
	refresh_comps_list([comps_data, form_data])
	
func refresh_comps_list(list):
	var node = get_node("Content Holder/Comp/DiplayList")
#	--- Supprime tous les noeuds résiduels lors d'un chargement de factions ---
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
	
	var competence_label = Label.new()
	competence_label.text = "Compétences"
	get_node("Content Holder/Comp/DiplayList").add_child(competence_label)
#	--- Ajoute tous les noeuds de la faction correspondante ---	
	for p in list[0]:
		var comp = Competence.instance().init(p)
		comp.name = p
		get_node("Content Holder/Comp/DiplayList").add_child(comp)
		comp.resize_self()
		
	var formule_label = Label.new()
	formule_label.text = "Formules"
	get_node("Content Holder/Comp/DiplayList").add_child(formule_label)
	for p in list[1]:
		var form = Formule.instance().init(p)
		form.name = p
		get_node("Content Holder/Comp/DiplayList").add_child(form)
		form.resize_self()
	
#	--- solution dégueue mais ça marche ---
	var c = Control.new()
	c.rect_min_size = Vector2(0,0)
	get_node("Content Holder/Comp/DiplayList").add_child(c)
	
func _on_LineEdit_text_changed(search_clue):
	var nodes_profil = get_node("Content Holder/Comp/DiplayList").get_children()
	nodes_profil.pop_back()
	
	for n in nodes_profil:
		var name = n.get_child(1).get_child(0).text
		n.visible = search_clue.is_subsequence_ofi(name.substr(0,len(search_clue)))
	
