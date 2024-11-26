extends Control

@onready var healthBar : TextureProgressBar = $HealthBar
@onready var ammoTxt : Label = $Ammo_txt
@onready var scoreTxt : Label = $Score_txt

func updateHealthBar(health, maxHealth):
	healthBar.max_value = maxHealth
	healthBar.value = health

func updateAmmo(ammo):
	ammoTxt.text = "Ammo: "+str(ammo)

func updateScore(score):
	scoreTxt.text = "Score: "+str(score)
