extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init():
	$"FigNb".text = "0"
	$"CombatValue".text = "0"
	$"EspritValue".text = "0"
	$"RefValue".text = "0"
	$"DefenseValue".text = "0"
	$"PAValue".text = "0"
	$"DmgValues".text = "-/-/-/-/-/-"
	$"TirValues".text = "-/-/-/-/-/-"
	$"MvtValues".text = "-/-/-"
	$"PVsValues".text = "-/-/-"

func avg_stats(team):
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
		mvt.append(p["Vie"].split("/"))
		dmg.append(p["Dmg"].split("/"))
		if p["Tir"] != "-":
			tir.append(p["Tir"].split(" ")[1].split("/"))
			
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
		mvts[1] += int(mo[0])
		mvts[2] += int(mo[0])
	for i in range(0,3):
		mvts[i] = mvts[i]/nb_profils
	mvt = str(mvts[0]) + "/" + str(mvts[1]) + "/" + str(mvts[2])
	
	# --- Gestion dmg ---
	var dmgs = [0,0,0,0,0,0]
	for d in dmg:
		dmgs[0] += int(d[0])
		dmgs[1] += int(d[1])
		dmgs[2] += int(d[2])
		dmgs[3] += int(d[3])
		dmgs[4] += int(d[4])
		dmgs[5] += int(d[5])
	for i in range(0,6):
		dmgs[i] = dmgs[i]/nb_profils
	dmg = str(dmgs[0]) + "/" + str(dmgs[1]) + "/" + str(dmgs[2]) + "/" + str(dmgs[3]) + "/" + str(dmgs[4]) + "/" + str(dmgs[5])
	
#	--- Gestion tir ---
	var tirs = [0,0,0,0,0,0]
	for t in tir:
		tirs[0] += int(t[0])
		tirs[1] += int(t[1])
		tirs[2] += int(t[2])
		tirs[3] += int(t[3])
		tirs[4] += int(t[4])
		tirs[5] += int(t[5])
	for i in range(0,6):
		tirs[i] = tirs[i]/nb_profils
	tir = str(tirs[0]) + "/" + str(tirs[1]) + "/" + str(tirs[2]) + "/" + str(tirs[3]) + "/" + str(tirs[4]) + "/" + str(tirs[5])
	
#	--- Gestion stats ---
	esp = str(esp/nb_profils)
	com = str(com/nb_profils)
	ref = str(ref/nb_profils)
	def = str(def/nb_profils)
	pa = str(pa/nb_profils)
	
	nb_profils = len(team) if !team.empty() else 0
	
	$"FigNb".text = str(nb_profils)
	$"CombatValue".text = com
	$"EspritValue".text = esp
	$"RefValue".text = ref
	$"DefenseValue".text = def
	$"PAValue".text = pa
	$"DmgValues".text = dmg
	$"TirValues".text = tir
	$"MvtValues".text = mvt
	$"PVsValues".text = vie
