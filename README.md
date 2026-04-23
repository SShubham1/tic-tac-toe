# 🎮 Tic-Tac-Toe (Godot 4)

A Tic-Tac-Toe game built with the Godot 4 Engine. It features a complete UI, dynamic difficulty scaling, and a powerful AI opponent powered by the Minimax algorithm with Alpha-Beta pruning.

---

## ✨ Key Features & Engineering
* **Difficulty based AI:** Implements the Minimax algorithm. At Level 5 (Difficulty 1.0), the AI plays perfectly, it will either win or force a draw and at level 1 (Difficulty 0.0) it plays purely randomly.
* **Alpha-Beta Pruning:** Optimized the AI decision tree to skip unnecessary calculations, reducing move-calculation time to near-zero milliseconds.
* **Zero-Sum Game Theory:** Board states are evaluated mathematically using `1` (X) and `-1` (O), eliminating complex nested win-condition loops.
* **Concurrency Safety:** Engineered an `ai_thinking` lock state to prevent players from spam-clicking and breaking the game loop.
* **Memory Optimization:** Uses O(1) constant lookups for win lines and UI theme overrides, and utilizes in-place array filling (`board.fill(0)`) to prevent memory leaks.
* **Clean Architecture:** Fully modularized codebase separating Scripts, Scenes, Assets, and Themes.

---

## 📁 Project Structure
```text
├── Assets/       # UI Icons and visual elements (icon.svg)
├── Fonts/        # Custom typography (NotoColorEmoji, OpenSans)
├── Scenes/       # Godot scene files (MainMenu, GameBoard, Settings)
├── Scripts/      # Core logic and GDScripts (Global state, AI engine)
├── Themes/       # Custom UI resources and StyleBoxes
└── project.godot # Engine configuration
```

---

## 🤖 AI Collaboration Disclaimer
*As per the task guidelines, I want to be fully transparent about my development process and AI usage.*

**What I built entirely by myself (Game Logic & Architecture):**
* Designed the complete UI/UX layout, Scene Tree, and Global State Management.
* Implemented the core mathematical mapping for the dynamic difficulty slider.
* Devised the underlying **Zero-Sum Game Theory logic**, choosing to represent the board as `1` (X) and `-1` (O) to highly optimize the win-checking equations.
* Identified and fixed UI race conditions (e.g., locking the board while the AI calculates).
* Organized and refactored the entire project architecture into a modular, production-ready format.

**Where I used AI (Syntax & Scaffolding):**
* I used AI in grunt work like generating assets and refining `README.md` and optimized my code.
* I used AI to help correctly structure the recursive syntax for the **Minimax Algorithm with Alpha-Beta pruning** as boilerplate, adapting it to work seamlessly with my custom `1` and `-1` board state design.

---

## 🛠️ How to Run Locally
1. Clone this repository to your local machine.
2. Open the **Godot 4 Engine**.
3. Click on "Import" and select the `project.godot` file.
4. Press `F5` to run the game!

---

**Developed by:** Shubham Shrivastav | Chemical Engineering UG1 | Jadavpur University
