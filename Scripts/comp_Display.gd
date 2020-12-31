extends Control

const Competence = preload("res://Scenes/Competence.tscn")
const Formule = preload("res://Scenes/Formule.tscn")
var MenuOpen = false
var comps_data = []
var form_data = []
var list_comp = []
var list_form = []

func _ready():
	comps_data = Json_reader.comps_data
	form_data = Json_reader.forms_data
	
	get_node("Content Holder/HBoxContainer/Compe_check").connect("toggled", self, "display_list", [list_comp])
	get_node("Content Holder/HBoxContainer/Formu_check").connect("toggled", self, "display_list", [list_form])
	refresh_comps_list([comps_data, form_data])
	
func refresh_comps_list(list):
	var node = get_node("Content Holder/Comp/DiplayList")
#	--- Supprime tous les noeuds résiduels lors d'un chargement de factions ---
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
	
	var competence_label = Label.new()
	competence_label.text = "Compétences"
	competence_label.name = "Compétences"
	competence_label.add_font_override("font", load("res://Fonts/Text_font.tres"))
	node.add_child(competence_label)
#	--- Ajoute tous les noeuds de la faction correspondante ---
	for p in list[0]:
		var comp = Competence.instance().init(p)
		comp.name = p
		node.add_child(comp)
		list_comp.append(comp)
		
	var formule_label = Label.new()
	formule_label.text = "Formules"
	formule_label.name = "Formules"
	formule_label.add_font_override("font", load("res://Fonts/Text_font.tres"))
	node.add_child(formule_label)
	for p in list[1]:
		var form = Formule.instance().init(p)
		form.name = p
		node.add_child(form)
		list_form.append(form)
	
#	--- solution dégueue mais ça marche ---
	var c = Control.new()
	c.rect_min_size = Vector2(0,0)
	node.add_child(c)
	
func _on_LineEdit_text_changed(search_clue):
	for n in list_comp + list_form:
		var name = n.get_node("Front/TextureButton/Nom").text
		n.visible = search_clue.is_subsequence_ofi(name.substr(0,len(search_clue)))
		
func display_list(boolean, list):
	for i in list:
		i.visible = boolean
	match list:
		list_comp:
			get_node("Content Holder/Comp/DiplayList/Compétences").visible = boolean
		list_form:
			get_node("Content Holder/Comp/DiplayList/Formules").visible = boolean
