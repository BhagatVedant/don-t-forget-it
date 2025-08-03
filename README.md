# Don't Forget It ## 🏆 Game Jam 2025

This game was created for **Game Jam 2025** with the theme **"Loop"**! Built under time constraints, it showcases innovative gameplay mechanics that blend memory challenges with traditional platforming. The unique "forgetting" system was designed to create tension and emotional investment in the player's learned abilities.

### Jam Theme Integration - "Loop"
- **Memory Loop**: The core mechanic creates a loop of learning → forgetting → relearning abilities
- **Checkpoint Loop**: Players repeatedly cycle through checkpoint-to-checkpoint challenges
- **Punishment Loop**: Hit spikes or run out of time → lose abilities → reset → try again
- **Ability Loop**: Gain abilities at checkpoints, lose them through failure, regain through progression
- **Narrative Loop**: The concept of "Don't Forget It" implies breaking free from cycles of memory losst! 🧠✨

A challenging platformer where your abilities fade from memory over time. Can you remember what you've learned before it's too late?

## 🎮 Play the Game

**[▶️ Play Don't Forget It! on itch.io](https://deadlineboss.itch.io/dont-forget-it)**

## � Game Jam 2025

This game was created for **Game Jam 2025**! Built under time constraints, it showcases innovative gameplay mechanics that blend memory challenges with traditional platforming. The unique "forgetting" system was designed to create tension and emotional investment in the player's learned abilities.

### Jam Theme Integration
- **Memory as Gameplay**: The core mechanic directly ties into themes of learning, forgetting, and perseverance
- **Time Pressure**: Jam deadlines inspired the in-game timer mechanics
- **Progressive Difficulty**: Designed to be completable but challenging within jam timeframes

## �🎯 Game Overview

Don't Forget It! is a unique platformer that combines parkour mechanics with memory challenges. As you progress through the levels, you'll face a cruel twist - if you don't reach the next checkpoint in time, you'll lose your abilities one by one until you forget everything you've learned.

### Core Concept
- **Memory Loss Mechanics**: Fail to reach checkpoints in time and lose abilities permanently
- **Progressive Learning**: Gain new abilities as you advance through checkpoints
- **Time Pressure**: Each level section has a timer - beat it or lose an ability
- **Punishment System**: Hit spikes and lose abilities immediately with dramatic red flash effects

## 🕹️ Controls

| Action | Key/Button |
|--------|------------|
| **Move** | A/D or Arrow Keys |
| **Jump** | Space |
| **Dash** | E |
| **Double Jump** | Space (in mid-air, unlocked at Checkpoint 2) |
| **Fullscreen** | F11 or Alt+Enter |

## 🎮 Game Mechanics

### Checkpoint System
- **Checkpoint 1**: Learn the basic mechanics with instructional screen
- **Checkpoint 2**: Unlock double jump ability
- **Final Checkpoint**: Victory screen with stats

### Ability Progression & Loss
The game features a unique "forgetting" system:

1. **Stage 0**: All abilities (Move, Jump, Dash, Double Jump)
2. **Stage 1**: Lose Double Jump
3. **Stage 2**: Lose Dash
4. **Stage 3**: Lose Jump (can only move)
5. **Stage 4**: Lose All Movement (Game Over)

### Timer Mechanics
- Each checkpoint level has a **5.5-second timer**
- Failing to reach the next checkpoint in time results in ability loss
- Red screen flash indicates punishment/reset
- Timer is hidden when you're safe at a checkpoint

### Hazards
- **Spikes**: Instant ability loss + red flash effect
- **Time Pressure**: Constant threat of memory loss

## 🎨 Features

### Visual Polish
- **Screen Effects**: Red flash on ability loss/reset, white transitions
- **UI System**: Clean, retro-style interface with custom fonts
- **Fullscreen Support**: F11 or Alt+Enter to toggle
- **Responsive Design**: Scales properly across different screen sizes

### Audio
- **Background Music**: Atmospheric mushroom-themed soundtrack
- **Sound Effects**: Dash swooshes, checkpoint completion sounds
- **Audio Balancing**: Carefully tuned volume levels for immersion

### Accessibility
- **Multiple Input Methods**: Keyboard and gamepad support
- **Clear Instructions**: Checkpoint 1 tutorial explains all mechanics
- **Visual Feedback**: Screen flashes and UI feedback for all actions

## 🏗️ Technical Details

### Built With
- **Engine**: Godot 4.4
- **Language**: GDScript
- **Rendering**: Forward+ renderer for optimal performance
- **Resolution**: 1024x600 (16:10 aspect ratio)
- **Development Context**: Game Jam 2025 - rapid prototyping and polished execution

### Project Structure
```
📁 Project Root
├── 🎨 UI/                    # User Interface components
├── ⚙️ Managers/              # System management scripts  
├── 🎮 GameObjects/           # Game entities (spikes, checkpoints, stars)
├── 🎬 Scenes/                # Main game scenes
├── 🔤 Fonts/                 # Typography assets
├── 🖼️ Icons/                 # Game icons and images
├── 🎵 Audio/                 # Sound effects and music
├── 🏰 castle/                # Game world and levels
├── 👤 Player/                # Player character and mechanics
├── 🌍 World/                 # Level environments
└── 🧪 Test/                  # Development test files
```

### Key Systems
- **SceneManager**: Handles transitions, checkpoints, and game state
- **AudioManager**: Manages background music and sound effects
- **StarManager**: Tracks collectible stars (future feature)
- **Checkpoint System**: Complex ability management and timing mechanics

## 🎯 Gameplay Tips

### For New Players
1. **Read the Instructions**: Checkpoint 1 explains everything you need to know
2. **Practice Movement**: Get comfortable with basic controls before the timer starts
3. **Plan Your Route**: Look ahead to plan the most efficient path
4. **Don't Panic**: The timer is generous if you know where you're going

### Advanced Strategies
1. **Dash Timing**: Use dash to cover horizontal distance quickly
2. **Double Jump Conservation**: Save your double jump for when you really need it
3. **Memory Palace**: Try to remember the level layout to improve your times
4. **Risk vs Reward**: Sometimes it's better to take a safe route than risk hitting spikes

## 🏆 Scoring System

Your performance is tracked with these metrics:
- **Completion Time**: How long it took to beat the game
- **Times Reset**: How many times you lost abilities and reset
- **Memory Efficiency**: How well you maintained your abilities

## 🛠️ Development Features

### Debug Controls
- **V Key**: Instant victory (for testing)
- **Console Output**: Detailed logging for development

### Customizable Settings
- **Timer Duration**: Adjustable per checkpoint (default 5.5s)
- **Ability Stages**: Configurable progression system
- **Audio Levels**: Separate volume controls for music and SFX

## 🎨 Art & Design

### Visual Style
- **Pixel Art**: Clean, minimalist pixel art aesthetic
- **Color Palette**: Dark backgrounds with contrasting game elements
- **Typography**: Custom retro font (edit-undo.brk) throughout

### Animation System
- **Player States**: Idle, walk, jump, fall, dash/roll animations
- **Smooth Transitions**: Tweened UI animations and screen effects
- **Visual Feedback**: Screen flashes, fade effects, and particle systems

## 🔄 Game States

### Menu System
- **Main Menu**: Play, Credits, Quit options
- **Credits Screen**: Development acknowledgments
- **Victory Screen**: Final stats and "press any key" return

### Gameplay States
- **Tutorial Phase**: Guided learning at Checkpoint 1
- **Active Play**: Timer-based challenge sections
- **Checkpoint Rest**: Safe zones between challenges
- **Game Over**: Ability loss leading to restart

## 🚀 Future Enhancements

Potential features for future updates:
- **Multiple Levels**: Expanded world with different themes
- **Star Collection**: Optional collectibles for completionists  
- **Leaderboards**: Global time tracking and competition
- **Accessibility Options**: Colorblind support, subtitle options
- **Mobile Support**: Touch controls for mobile devices

## 🙏 Credits & Acknowledgments

### Game Jam 2025
- **Event**: Created for Game Jam 2025
- **Theme**: "Loop" - Cycles of learning, forgetting, and progression
- **Development Time**: Built within jam constraints
- **Theme Implementation**: Memory loops, checkpoint cycles, and ability progression/regression
- **Achievement**: Complete game with polished mechanics and professional presentation

### Audio Assets
- **Background Music**: "Mushroom Background Music" by sunsai
- **Dash Sound**: "Swoosh26" by kwahmah_02  
- **Victory Sound**: "8-bit Mini Win Sound Effect" by evretro

### Development Tools
- **Godot Engine**: Open-source game development platform
- **VS Code**: Primary development environment
- **Git**: Version control and project management

---

## 📞 Contact & Support

- **itch.io Page**: [Don't Forget It!](https://deadlineboss.itch.io/dont-forget-it)
- **Developer Tag**: DeadlineBoss
- **Developer Name**: Vedant Bhagat
- **Repository**: [GitHub](https://github.com/BhagatVedant/don-t-forget-it)

---

### 🎮 Ready to Test Your Memory?

**[Play Don't Forget It! Now](https://deadlineboss.itch.io/dont-forget-it)**

*Can you remember what you've learned before time runs out?*

---

*Made with 💙 in Godot Engine*