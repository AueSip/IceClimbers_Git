extends Node2D

onready var timer = PlayerStats.get_node("TempTimer")
onready var titleScreen = $TitleScreen
onready var titleScreenButton = $TitleScreen/Play
onready var titleScreenLabel = $TitleScreen/RichTextLabel
onready var levelSelect = $LevelSelect
onready var levelButtons = $LevelSelect/GridContainer

onready var game_scene = "res://Scenes/Main.tscn"

func _on_Play_pressed():
	titleScreen.set_visible(false)
	levelSelect.set_visible(true)

func _ready():
	for button in levelButtons.get_children():
		if button.name == "Level1":
			button.add_color_override("font_color", Color(0,1,0,1))
		else:
			button.add_color_override("font_color", Color(1,0,0,1))
	
	titleScreenButton.connect("pressed", self, "title_screen_button_pressed")


func _on_Level1_pressed():
	levelSelect.set_visible(false)
	$"/root/ScreenTransitionManager".transition_to_scene("res://Scenes/Levels/Level_000.tscn")
	#get_tree().change_scene("res://Scenes/Levels/Level_000.tscn")
	timer.start()



	
