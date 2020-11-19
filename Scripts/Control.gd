extends Control

var profil
var cara_displayed = false

func _ready():
	pass # Replace with function body.

func init(p):
	profil = p
	var nom = get_node("Nom/Label")
	nom.text = profil["Nom"]
	var pa = get_node("Infos/PA")
	pa.text = profil["PA"]
	var cout = get_node("Infos/Cout")
	cout.text = profil["Cout"]
	var fig_max = get_node("Infos/Max")
	fig_max.text = profil["Max"]
	
	get_node("VBoxContainer/Cara/Cara/COM").text = profil["Cbt"]
	get_node("VBoxContainer/Cara/Cara/DEF").text = profil["Def"]
	get_node("VBoxContainer/Cara/Cara/ESP").text = profil["Esp"]
	get_node("VBoxContainer/Cara/Cara/REF").text = profil["Ref"]
	get_node("VBoxContainer/Cara/Cara/PA").text = profil["PA"]
	get_node("VBoxContainer/Cara/PVSATK/PVS").text = profil["Vie"]
	get_node("VBoxContainer/Cara/PVSATK/MVT").text = profil["Mvt"]
	get_node("VBoxContainer/Cara/PVSATK/ATK").text = profil["Dmg"]
	get_node("VBoxContainer/Cara/PVSATK/TIR").text = profil["Tir"]
	get_node("VBoxContainer/Cara/VBoxContainer/COMP/RichTextLabel").bbcode_text = profil["Compétences"]
	get_node("VBoxContainer/Cara/VBoxContainer/SORT/RichTextLabel").bbcode_text = profil["Sorts"]
	return self
	
func manage_recruitement(r):
	get_node("Infos/Max").text = str(r)
	if r == int(profil["Max"]):
		get_node("Infos/_max2").visible = true
		get_node("Remove").visible = true
		get_node("Add").visible = false
		get_node("Infos/Max").visible = true
	if r < int(profil["Max"]):
		get_node("Infos/Max").visible = true
		get_node("Infos/_max2").visible = false
		get_node("Add").visible = true
		get_node("Remove").visible = true
	if r == 0:
		get_node("Infos/Max").visible = false
		get_node("Remove").visible = false
		get_node("Add").visible = true
	pass
	
func get_recuitement():
	return int(get_node("Infos/Max").text)
	
func get_max():
	return int(profil["Max"])
	
func set_max(i):
	profil["Max"] = str(i)

func resize_self(display_list_size):
	var x = display_list_size.x
	var y = 64 + 216
	if cara_displayed:
		get_node(".").rect_min_size = Vector2(x, y)
	else:
		get_node(".").rect_min_size = Vector2(x, get_node("ColorRect").rect_min_size.y)

func _on_Nom_pressed():
	cara_displayed = !cara_displayed
	get_node("VBoxContainer").visible = cara_displayed
	resize_self(get_node(".").rect_size)
