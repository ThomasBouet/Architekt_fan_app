extends Control


func _on_Profils_pressed():
	if get_tree().change_scene("res://Scenes/Profils_Display.tscn") != OK:
		print("Une erreur innatendue est arrivée")
	
func _on_Mes_listes_pressed():
	if get_tree().change_scene("res://Scenes/Liste.tscn") != OK:
		print("Une erreur innatendue est arrivée")
	
func _on_Comptences_pressed():
	if get_tree().change_scene("res://Scenes/Comp_et_Form_Display.tscn") != OK:
		print("Une erreur innatendue est arrivée")
	
func _on_Sorts_pressed():
	if get_tree().change_scene("res://Scenes/Sort_display.tscn") != OK:
		print("Une erreur innatendue est arrivée")
	
func _on_Rgles_pressed():
	if get_tree().change_scene("res://Scenes/regles.tscn") != OK:
		print("Une erreur innatendue est arrivée")
	
func _on_Scnarios_pressed():
	if get_tree().change_scene("res://Scenes/scenar_disp.tscn") != OK:
		print("Une erreur innatendue est arrivée")
