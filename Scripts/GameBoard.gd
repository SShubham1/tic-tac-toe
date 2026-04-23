extends Control

# --- GAME STATE (1 = X, -1 = O, 0 = Empty) ---
var board = [0, 0, 0, 0, 0, 0, 0, 0, 0] 
var current_player = 1 
var starting_player = 1
var game_active = true
var ai_thinking = false

# Constant array for O(1) memory lookup
const WIN_LINES = [
	[0, 1, 2], [3, 4, 5], [6, 7, 8], # Rows
	[0, 3, 6], [1, 4, 7], [2, 5, 8], # Columns
	[0, 4, 8], [2, 4, 6]             # Diagonals
]

const THEME_OVERRIDES = ["font_color", "font_pressed_color", "font_hover_color", "font_disabled_color"]

# --- SCORE TRACKERS ---
var score_x = 0
var score_o = 0
var score_draw = 0

# --- NODE PATHS ---
@onready var grid_buttons = $UIContainer/GridContainer.get_children()
@onready var status_lbl = $UIContainer/StatusLbl
@onready var x_lbl = $UIContainer/ScoreContainer/XLbl
@onready var o_lbl = $UIContainer/ScoreContainer/OLbl
@onready var draw_lbl = $UIContainer/ScoreContainer/DrawLbl
@onready var level_lbl = $LevelLbl

func _ready() -> void:
	if Global.game_mode=="PVP":
		level_lbl.hide()
	else:
		level_lbl.show()
		level_lbl.text=Global.LEVEL_MAP[Global.level]
	for i in range(grid_buttons.size()):
		grid_buttons[i].pressed.connect(_on_cell_pressed.bind(i))
	reset_board()
	update_scores()

# --- THE CORE GAME LOOP ---
func _on_cell_pressed(index: int) -> void:
	if not game_active or board[index] != 0 or ai_thinking:
		return
		
	make_move(index, current_player)
	
	if check_win(board, current_player):
		handle_win(current_player)
	elif check_draw():
		handle_draw()
	else:
		current_player = -current_player 
		update_status_text()
		
		if Global.game_mode == "PVC" and current_player == -1 and game_active:
			ai_turn()

func make_move(index: int, player: int) -> void:
	board[index] = player
	var btn = grid_buttons[index]
	
	var color = Color.RED if player == 1 else Color.BLUE
	for property in THEME_OVERRIDES:
		btn.add_theme_color_override(property, color)

	btn.text = "X" if player == 1 else "O"
	
# --- WIN / DRAW MATH ---
func check_win(b: Array, player: int) -> bool:
	var target_sum = player * 3 
	for line in WIN_LINES:
		if b[line[0]] + b[line[1]] + b[line[2]] == target_sum:
			return true
	return false

func check_draw() -> bool:
	return not 0 in board

# --- UI HANDLERS ---
func handle_win(player: int) -> void:
	game_active = false
	if player == 1:
		status_lbl.text = "Player X Won! 🎉" if Global.game_mode == "PVP" else "You Won! 🎉"
		score_x += 1
	else:
		status_lbl.text = "Player O Won! 🎉" if Global.game_mode == "PVP" else "Computer Won! 😭"
		score_o += 1
	update_scores()

func handle_draw() -> void:
	game_active = false
	status_lbl.text = "It's a Draw! 🤝"
	score_draw += 1
	update_scores()

func update_status_text() -> void:
	if Global.game_mode == "PVC":
		status_lbl.text = "Your turn" if current_player == 1 else "Computer turn"
	elif Global.game_mode == "PVP":
		status_lbl.text = "X turn" if current_player == 1 else "O turn"

func update_scores() -> void:
	x_lbl.text = "X: %d" % score_x
	o_lbl.text = "O: %d" % score_o
	draw_lbl.text = "Draw: %d" % score_draw

# --- RESET LOGIC ---
func reset_board() -> void:
	board.fill(0)
	current_player = starting_player
	game_active = true
	ai_thinking = false
	update_status_text()
	
	for btn in grid_buttons:
		btn.text = ""
	
	if Global.game_mode == "PVC" and current_player == -1:
		ai_turn()
		
func reset_scores() -> void:
	score_x = 0
	score_o = 0
	score_draw = 0
	update_scores()

# --- CONTROL BUTTON SIGNALS ---
func _on_main_menu_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func _on_play_again_btn_pressed() -> void:
	starting_player = -starting_player 
	reset_board()

func _on_restart_btn_pressed() -> void:
	starting_player = 1
	reset_board()
	reset_scores()
	
# --- AI LOGIC ---
func ai_turn() -> void:
	ai_thinking = true
	await get_tree().create_timer(0.3).timeout
	
	if not game_active or not ai_thinking:
		return
		
	var empty_cells = []
	for i in range(9):
		if board[i] == 0:
			empty_cells.append(i)
			
	var chosen_index = -1
	
	if randf() <= Global.difficulty:
		if empty_cells.size() == 9:
			chosen_index = [0, 2, 4, 6, 8].pick_random() 
			if OS.is_debug_build(): print("Optimal Move (Hardcoded First Move)")
		else:
			chosen_index = get_best_move(empty_cells)
			if OS.is_debug_build(): print("Optimal Move (Minimax with Alpha-Beta)")
	else:
		chosen_index = empty_cells.pick_random()
		if OS.is_debug_build(): print("Random Move")
			
	ai_thinking = false
	_on_cell_pressed(chosen_index)

# --- MINIMAX ALGORITHM (With Alpha-Beta Pruning) ---
func get_best_move(empty_cells: Array) -> int:
	var best_score = -INF
	var best_move = -1
	
	for i in empty_cells:
		board[i] = -1 
		var score = minimax(board, 0, false, -INF, INF) 
		board[i] = 0 
		
		if score > best_score:
			best_score = score
			best_move = i
			
	return best_move

func minimax(temp_board: Array, depth: int, is_maximizing: bool, alpha: float, beta: float) -> int:
	if check_win(temp_board, -1): return 10 - depth 
	if check_win(temp_board, 1): return -10 + depth 
	if not 0 in temp_board: return 0 
	
	if is_maximizing:
		var best_score = -INF
		for i in range(9):
			if temp_board[i] == 0:
				temp_board[i] = -1
				var score = minimax(temp_board, depth + 1, false, alpha, beta)
				temp_board[i] = 0
				best_score = max(best_score, score)
				alpha = max(alpha, best_score)
				if beta <= alpha: break 
		return best_score
	else:
		var best_score = INF
		for i in range(9):
			if temp_board[i] == 0:
				temp_board[i] = 1
				var score = minimax(temp_board, depth + 1, true, alpha, beta)
				temp_board[i] = 0
				best_score = min(best_score, score)
				beta = min(beta, best_score)
				if beta <= alpha: break 
		return best_score
