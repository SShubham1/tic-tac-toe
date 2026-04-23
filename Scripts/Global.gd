extends Node
var difficulty: float
var level: int
var game_mode: String
const LEVEL_MAP = {
		1: "Level 1: Happy 🤗",
		2: "Level 2: Kiddo 🤓",
		3: "Level 3: Smarty 🧐",
		4: "Level 4: Hell 😈",
		5: "Level 5: Impossible 💀"
	}
const PROJECT_LINK = "https://github.com/SShubham1/tic-tac-toe"
func _ready() -> void:
	difficulty = 0.5 # current difficulty
	level = int(difficulty*4)+1
	game_mode = "PVC" # PVP or PVC
