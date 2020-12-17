extends VBoxContainer

var profil
var cara_displayed = false

func init(p, hide):
	profil = p
	get_node("Front/HBoxContainer/Nom/HBoxContainer/Label").text = profil["Nom"]
	get_node("Front/HBoxContainer/Nom/Infos/PA").text = profil["PA"]
	get_node("Front/HBoxContainer/Nom/Infos/Cout").text = profil["Cout"]
	get_node("Front/HBoxContainer/Nom/Infos/Max").text = profil["Max"]
	
	get_node("Back/Stats_Holder/Stats/Cara/COM").text = " COM : " + profil["Cbt"]
	get_node("Back/Stats_Holder/Stats/Cara/DEF").text = " DEF : " + profil["Def"]
	get_node("Back/Stats_Holder/Stats/Cara/ESP").text = " ESP : " + profil["Esp"]
	get_node("Back/Stats_Holder/Stats/Cara/REF").text = " REF : " + profil["Ref"]
	get_node("Back/Stats_Holder/Stats/Cara/PA").text = " PA : " + profil["PA"]
	get_node("Back/Stats_Holder/Stats/PVSATK/PVS").text = " Vie : " + profil["Vie"]
	get_node("Back/Stats_Holder/Stats/PVSATK/MVT").text = " Mvt : " + profil["Mvt"]
	get_node("Back/Stats_Holder/Stats/PVSATK/ATK").text = " Dégats : " + profil["Dmg"]
	
	get_node("Back/Stats_Holder/Stats/PVSATK/TIR").visible = !(profil["Tir"] == "-")
	get_node("Back/Stats_Holder/Stats/PVSATK/TIR").text = "Tir : " + profil["Tir"]
	
	var bb_str_comp = ""
	for i in profil["Compétences"].split(","):
		bb_str_comp += "[url=" + i + "]" + i + "[/url] " if i != "-" else ""
		if i == "-":
			get_node("Back/Stats_Holder/Stats/CompEtForm/COMP").visible = false
			get_node("Back/Stats_Holder/Stats/CompEtForm/Competence").visible = false
	get_node("Back/Stats_Holder/Stats/CompEtForm/Competence").bbcode_text = " "+bb_str_comp
	
	var bb_str_form = ""
	for i in profil["Formules"].split(","):
		bb_str_form += "[url=" + i + "]" + i + "[/url] " if i != "-" else ""
		if i == "-":
			get_node("Back/Stats_Holder/Stats/CompEtForm/FORM").visible = false
			get_node("Back/Stats_Holder/Stats/CompEtForm/Formule").visible = false
	get_node("Back/Stats_Holder/Stats/CompEtForm/Formule").bbcode_text = " "+bb_str_form
	
	get_node("Front/HBoxContainer/Remove").visible = false
	
	match profil["Type"]:
		"Troupe":
			get_node("Front/HBoxContainer/Nom/HBoxContainer/TextureRect").texture = ResourceLoader.load("res://Sprites/UI/sword_01c.png")
			get_node("Front/ColorRect").color = "#7d653d"
		"Héro":
			get_node("Front/HBoxContainer/Nom/HBoxContainer/TextureRect").texture = ResourceLoader.load("res://Sprites/UI/helmet_02d.png")
			get_node("Front/ColorRect").color = "#551a1a"
		"Héro/Alchimiste":
			get_node("Front/HBoxContainer/Nom/HBoxContainer/TextureRect").texture = ResourceLoader.load("res://Sprites/UI/helmet_potion.png")
			get_node("Front/ColorRect").color = "#551a1a"
		"Alchimiste":
			get_node("Front/HBoxContainer/Nom/HBoxContainer/TextureRect").texture = ResourceLoader.load("res://Sprites/UI/potion_03c.png")
			get_node("Front/ColorRect").color = "#26621a"
		"Spécial":
			get_node("Front/HBoxContainer/Nom/HBoxContainer/TextureRect").texture = ResourceLoader.load("res://Sprites/UI/cookie_01a.png")
			get_node("Front/ColorRect").color = "#3d777d"
		
	get_node("Front/HBoxContainer/Nom/Infos/Max").text = "0/"+profil["Max"]
	
	if profil["Max"] == "0" or hide:
			get_node("Front/HBoxContainer/Add").visible = false
			get_node("Front/HBoxContainer/Nom/Infos/Max").visible = false
			
	return self
	
func manage_recruitement(r):
	get_node("Front/HBoxContainer/Nom/Infos/Max").text = str(r)
	get_node("Front/HBoxContainer/Nom/Infos/Max").text = str(r)+"/"+profil["Max"]
	var p_max = int(profil["Max"])
	if r == p_max:
		get_node("Front/HBoxContainer/Remove").visible = true
		get_node("Front/HBoxContainer/Add").visible = false
		get_node("Front/HBoxContainer/Nom/Infos/Max").visible = true
	if r < p_max and r > 0:
		get_node("Front/HBoxContainer/Nom/Infos/Max").visible = true
		get_node("Front/HBoxContainer/Add").visible = true
		get_node("Front/HBoxContainer/Remove").visible = true
	if r <= 0 and p_max > 0:
		get_node("Front/HBoxContainer/Nom/Infos/Max").visible = false
		get_node("Front/HBoxContainer/Remove").visible = false
		get_node("Front/HBoxContainer/Add").visible = true
	if r <= 0 and p_max <= 0:
		get_node("Front/HBoxContainer/Nom/Infos/Max").visible = false
		get_node("Front/HBoxContainer/Remove").visible = false
		get_node("Front/HBoxContainer/Add").visible = false
	
func get_recuitement():
	return int(get_node("Front/HBoxContainer/Nom/Infos/Max").text.split("/")[0])
	
func get_max():
	return int(profil["Max"])
	
func set_max(i):
	i = 0 if i < 0 else i
	profil["Max"] = str(i)

func _on_Nom_pressed():
	cara_displayed = !cara_displayed
	get_node("Back").visible = cara_displayed
	
func _on_Button_pressed():
	get_node("Cards_Display").display_cards(profil)
	
func _on_Competence_meta_clicked(meta):
	get_node("Comp_Display").display_comp(meta)
	
func _on_Formule_meta_clicked(meta):
	get_node("Form_Display").display_form(meta)
