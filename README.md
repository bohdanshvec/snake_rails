# Classic Snake Game

This is a classic Snake game. The snake (`ooooos`) crawls across the field, collects apples (`@`), and grows longer. It can crash into obstacles (`#`).

## 🎮 Gameplay Features

- **Field size**: Static — `130x27`
- **Apples** (`@`): 30 total. When one is eaten, it respawns elsewhere.
- **Obstacles** (`#`): 30 total
- **Movement**: Controlled with arrow keys (`↑`, `↓`, `←`, `→`)
- **Refresh rate**: Every `0.3` seconds
- **Exit**: Press `ESCAPE` to quit the game

### ❌ Game Over Conditions

You lose the game if:

- You move **out of bounds**
- The **snake’s head collides with its own body**
- The **snake’s head hits an obstacle**

At the end of the game, the reason for the loss is displayed, and you are redirected to the **home page**.

---

## 🛠️ Roadmap (Planned Features)

- [ ] Add **mobile device support**

---

Feel free to contribute or give feedback!
