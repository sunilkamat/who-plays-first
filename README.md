# Who Plays First

A fun and interactive iOS app that helps determine who goes first in board games using a touch-based interface. Instead of rolling dice or drawing cards, players place their fingers on the screen to create a dynamic and engaging selection process.

## Features

- **Interactive Touch Interface**: Players place their fingers on the screen to create colorful circles
- **Dynamic Player Selection**: 
  - Select number of players (2-8)
  - Automatic player counting
  - Visual feedback with player numbers
- **Engaging Animations**:
  - Jiggling circles while waiting for players
  - Smooth selection animation
  - Color-coded player circles
- **Automatic Selection Process**:
  - Starts automatically when all players join
  - Animated selection sequence
  - Random winner selection
- **Easy Reset**: Quick reset button to start over
- **Professional Launch Screen**:
  - Custom launch screen with app branding
  - Smooth transition to main interface
  - Optimized for all device sizes

## How to Use

1. Launch the app
2. Select the number of players (2-8) using the segmented control at the top
3. Each player places their finger on the screen:
   - A colored circle appears with their player number
   - The circle jiggles to indicate it's active
   - Players can't place fingers too close to each other
4. When all players have joined:
   - The selection process starts automatically
   - Circles animate through each player
   - A random winner is selected
5. The winner's circle remains on screen
6. Use the reset button to start a new game

## Technical Details

- Built with SwiftUI and UIKit
- Supports multiple simultaneous touches
- Responsive design that works on all iOS devices
- Smooth animations and transitions
- Touch detection with collision avoidance
- Custom launch screen implementation using Storyboard
- Optimized asset loading and caching

## Requirements

- iOS 15.0 or later
- Xcode 13.0 or later
- Swift 5.5 or later

## Installation

1. Clone the repository
2. Open the project in Xcode
3. Build and run on your iOS device or simulator

## License

This project is available under the MIT License. See the LICENSE file for more info. 