extends Control


var panel_visible = false

func init():
	$"Panel/FigNb".text = "0"
	$"Panel/CombatValue".text = "0"
	$"Panel/EspritValue".text = "0"
	$"Panel/RefValue".text = "0"
	$"Panel/DefenseValue".text = "0"
	$"Panel/PAValue".text = "0"
	$"Panel/DmgValues".text = "Max : 0 Moy : 0 Min : 0"
	$"Panel/TirValues".text = "Max : 0 Moy : 0 Min : 0"
	$"Panel/MvtValues".text = "-/-/-"
	$"Panel/PVsValues".text = "-/-/-"

func avg_stats(team):
	var nb_tireurs = 0
	var nb_profils = len(team) if !team.empty() else 1
#	if team.empty():
#		nb_profils = 1
#	Récupération des valeurs
	var esp = 0
	var com = 0
	var def = 0
	var ref = 0
	var pa = 0
	var vie = []
	var mvt = []
	var dmg = []
	var tir = []
	for p in team:
		esp += int(p["Esp"])
		com += int(p["Cbt"])
		def += int(p["Def"])
		ref += int(p["Ref"])
		pa += int(p["PA"])
		vie.append(p["Vie"].split("/"))
		mvt.append(p["Mvt"].split("/"))
		dmg.append(p["Dmg"].split("/"))
		if p["Tir"] != "-":
			tir.append(p["Tir"].split(" ")[2].split("/"))
			nb_tireurs += 1
			
#	--- Gestion vie ---
	var vies = [0,0,0]
	for v in vie:
		vies[0] += int(v[0])
		vies[1] += int(v[1])
		vies[2] += int(v[2])
	for i in range(0,3):
		vies[i] = vies[i]/nb_profils
	vie = str(vies[0]) + "/" + str(vies[1]) + "/" + str(vies[2]) 
		
	# --- Gestion mvt ---
	var mvts = [0,0,0]
	for mo in mvt:
		mvts[0] += int(mo[0])
		mvts[1] += int(mo[1])
		mvts[2] += int(mo[2])
	for i in range(0,3):
		mvts[i] = mvts[i]/nb_profils
	mvt = str(mvts[0]) + "/" + str(mvts[1]) + "/" + str(mvts[2])
	
	# --- Gestion dmg ---
	var dmgs = [0,0,0,0,0,0]
	var dmg_max = 0
	var dmg_min = 99
	var dmg_avg = 0
	
	for d in dmg:
		dmgs[0] = int(d[0][0])
		dmgs[1] = int(d[1][0])
		dmgs[2] = int(d[2][0])
		dmgs[3] = int(d[3][0])
		dmgs[4] = int(d[4][0])
		dmgs[5] = int(d[5][0])
		
		dmg_max = dmgs.max() if dmgs.max() > dmg_max else dmg_max
		dmg_min = dmgs.min() if dmgs.min() < dmg_min else dmg_min
		
		dmg_avg += (dmgs[0] + dmgs[1] + dmgs[2] + dmgs[3] + dmgs[4] + dmgs[5])/ 6
	dmg_avg = dmg_avg/nb_profils
	dmg_min = dmg_min if dmg_min != 99 else 0
	dmg = "Max : " + str(dmg_max) + " Moy : " + str(dmg_avg) + " Min : " + str(dmg_min)
	
#	--- Gestion tir ---
	var tirs = [0,0,0,0,0,0]
	var tir_max = 0
	var tir_min = 99
	var tir_avg = 0
	
	for t in tir:
		tirs[0] = int(t[0][0])
		tirs[1] = int(t[1][0])
		tirs[2] = int(t[2][0])
		tirs[3] = int(t[3][0])
		tirs[4] = int(t[4][0])
		tirs[5] = int(t[5][0])
		
		tir_max = tirs.max() if tirs.max() > tir_max else tir_max
		tir_min = tirs.min() if tirs.min() < tir_min else tir_min
		
		tir_avg += (tirs[0] + tirs[1] + tirs[2] + tirs[3] + tirs[4] + tirs[5])/ 6
	tir_avg = tir_avg/nb_tireurs if nb_tireurs != 0 else tir_avg
	tir_min = tir_min if tir_min != 99 else 0
	tir = "Max : " + str(tir_max) + " Moy : " + str(tir_avg) + " Min : " + str(tir_min)
	
#	--- Gestion stats ---
	esp = str(esp/nb_profils)
	com = str(com/nb_profils)
	ref = str(ref/nb_profils)
	def = str(def/nb_profils)
	pa = str(pa/nb_profils)
	
	nb_profils = len(team) if !team.empty() else 0
	
	$"Panel/FigNb".text = str(nb_profils)
	$"Panel/CombatValue".text = com
	$"Panel/EspritValue".text = esp
	$"Panel/RefValue".text = ref
	$"Panel/DefenseValue".text = def
	$"Panel/PAValue".text = pa
	$"Panel/DmgValues".text = dmg
	$"Panel/TirValues".text = tir
	$"Panel/MvtValues".text = mvt
	$"Panel/PVsValues".text = vie
	
func _on_Button_pressed():
	panel_visible = !panel_visible
	$"Panel".visible = panel_visible
	$"Button".text = "Cacher les statistiques" if panel_visible else "Afficher les statistiques"
	resize_self()
	
func resize_self():
	var x = $"Button".rect_size.x
	var y = $"Button".rect_size.y + $"Panel".rect_size.y
	if panel_visible:
		get_node(".").rect_min_size = Vector2(x, y)
	else:
		get_node(".").rect_min_size =  $"Button".rect_size
		
		
