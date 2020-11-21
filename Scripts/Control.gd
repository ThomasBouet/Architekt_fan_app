extends Control

var profil
var cara_displayed = false

func _ready():
	pass # Replace with function body.

func init(p, hide):
	profil = p	
	get_node("Nom/Label").text = profil["Nom"]
	get_node("Infos/PA").text = profil["PA"]
	get_node("Infos/Cout").text = profil["Cout"]
	get_node("Infos/Max").text = profil["Max"]
	
	get_node("VBoxContainer/Cara/Cara/COM").text = "COM : " + profil["Cbt"]
	get_node("VBoxContainer/Cara/Cara/DEF").text = "DEF : " + profil["Def"]
	get_node("VBoxContainer/Cara/Cara/ESP").text = "ESP : " + profil["Esp"]
	get_node("VBoxContainer/Cara/Cara/REF").text = "REF : " + profil["Ref"]
	get_node("VBoxContainer/Cara/Cara/PA").text = "PA : " + profil["PA"]
	get_node("VBoxContainer/Cara/PVSATK/PVS").text = "Vie : " + profil["Vie"]
	get_node("VBoxContainer/Cara/PVSATK/MVT").text = "Mvt : " + profil["Mvt"]
	get_node("VBoxContainer/Cara/PVSATK/ATK").text = "Dégats : " + profil["Dmg"]
	get_node("VBoxContainer/Cara/PVSATK/TIR").text = "Tir : " + profil["Tir"]
	
	var bb_str_comp = ""
	for i in profil["Compétences"].split(","):
		bb_str_comp += "[url=" + i + "]" + i + "[/url] " if i != "-" else ""
	get_node("VBoxContainer/Cara/VBoxContainer/COMP/Competence").bbcode_text = bb_str_comp
	
	var bb_str_form = ""
	for i in profil["Formules"].split(","):
		bb_str_form += "[url=" + i + "]" + i + "[/url] " if i != "-" else ""
	get_node("VBoxContainer/Cara/VBoxContainer/SORT/Formule").bbcode_text = bb_str_form
	
	get_node("Remove").visible = false
	
	if profil["Type"] == "Troupe":
		get_node("TextureRect").texture = ResourceLoader.load("res://Sprites/UI/sword_01c.png")
		get_node("ColorRect").color = "#7d653d"
	elif profil["Type"] == "Héro" or profil["Type"] == "Héro/Alchimiste":
		get_node("TextureRect").texture = ResourceLoader.load("res://Sprites/UI/helmet_02d.png")
		get_node("ColorRect").color = "#551a1a"
	elif profil["Type"] == "Alchimiste":
		get_node("TextureRect").texture = ResourceLoader.load("res://Sprites/UI/potion_03c.png")
		get_node("ColorRect").color = "#26621a"
	elif profil["Type"] == "Spécial":
		get_node("TextureRect").texture = ResourceLoader.load("res://Sprites/UI/cookie_01a.png")
		get_node("ColorRect").color = "#3d777d"
		
	get_node("Infos/Max").text = "0" 
	
	if profil["Max"] == "0" or hide:
			get_node("Add").visible = false
			
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

func _on_Button_pressed():
	get_node("Cards_Display").display_cards(profil)


func _on_Competence_meta_clicked(meta):
	get_node("Comp_Display").display_comp(meta)

func _on_Formule_meta_clicked(meta):
	get_node("Form_Display").display_form(meta)
