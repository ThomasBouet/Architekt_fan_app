extends Control
	
	
func _on_Liste_Btn_pressed():
	print("Listes")
	if get_tree().change_scene("res://Scenes/Liste.tscn") != OK:
		print("Une erreur innatendue est arrivée")
	
func _on_Profil_Btn_pressed():
	print("Profils")
	if get_tree().change_scene("res://Scenes/Profils_Display.tscn") != OK:
		print("Une erreur innatendue est arrivée")
	
func _on_Accueil_Btn_pressed():
	print("Accueil")
	if get_tree().change_scene("res://Scenes/Accueil.tscn") != OK:
		print("Une erreur innatendue est arrivée")
	
func _on_Regle_Btn_pressed():
	print("Règles")
	if get_tree().change_scene("res://Scenes/regles.tscn") != OK:
		print("Une erreur innatendue est arrivée")
	
func _on_CaF_Btn_pressed():
	print("CaF")
	if get_tree().change_scene("res://Scenes/Comp_et_Form_Display.tscn") != OK:
		print("Une erreur innatendue est arrivée")
