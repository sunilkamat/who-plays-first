//
//  ContentView.swift
//  who-plays-first
//
//  Created by Sunil Kamat on 3/25/25.
//

import SwiftUI
import UIKit

struct PlayerCircle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var color: Color
    var isSelected: Bool = false
    var number: Int
    var rotation: Double = 0
}

struct TouchDetector: UIViewRepresentable {
    let onTouch: (CGPoint) -> Void
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.isMultipleTouchEnabled = true
        view.backgroundColor = .clear
        
        let gesture = TouchGestureRecognizer(coordinator: context.coordinator)
        view.addGestureRecognizer(gesture)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onTouch: onTouch)
    }
    
    class Coordinator: NSObject {
        let onTouch: (CGPoint) -> Void
        
        init(onTouch: @escaping (CGPoint) -> Void) {
            self.onTouch = onTouch
        }
        
        @objc func handleTouch(_ gesture: TouchGestureRecognizer) {
            if let view = gesture.view {
                let location = gesture.location(in: view)
                // Use the location directly in the view's coordinate system
                onTouch(location)
            }
        }
    }
}

class TouchGestureRecognizer: UIGestureRecognizer {
    private weak var coordinator: TouchDetector.Coordinator?
    
    init(coordinator: TouchDetector.Coordinator) {
        self.coordinator = coordinator
        super.init(target: coordinator, action: #selector(TouchDetector.Coordinator.handleTouch(_:)))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        handleTouches(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        handleTouches(touches, with: event)
    }
    
    private func handleTouches(_ touches: Set<UITouch>, with event: UIEvent) {
        for touch in touches {
            if let view = view {
                let location = touch.location(in: view)
                coordinator?.onTouch(location)
            }
        }
    }
}

struct ContentView: View {
    @State private var players: [PlayerCircle] = []
    @State private var isSelecting = false
    @State private var selectedPlayer: PlayerCircle?
    @State private var showError = false
    @State private var availableColors: [Color] = [
        .red, .blue, .green, .orange, .purple, .pink, .yellow, .mint
    ]
    @State private var selectedPlayerCount: Int = 2
    
    // Constants for circle size and touch detection
    private let circleSize: CGFloat = 150
    private let touchDetectionRadius: CGFloat = 75
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        if !isSelecting {
                            VStack {
                                Text("Select number of players")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Picker("Number of Players", selection: $selectedPlayerCount) {
                                    ForEach(2...8, id: \.self) { count in
                                        Text("\(count)").tag(count)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .padding(.horizontal)
                                
                                if players.count > 0 {
                                    Text("\(players.count)/\(selectedPlayerCount) players")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding()
                        }
                        
                        Spacer()
                        
                        // Reset button
                        Button(action: resetGame) {
                            Image(systemName: "arrow.counterclockwise.circle.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                    
                    Spacer()
                    
                    // Game area
                    ZStack {
                        ForEach(Array(players.enumerated()), id: \.element.id) { index, player in
                            ZStack {
                                // Player circle with overlay
                                Circle()
                                    .fill(player.color)
                                    .frame(width: circleSize, height: circleSize)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white, lineWidth: player.isSelected ? 8 : 0)
                                            .blur(radius: player.isSelected ? 4 : 0)
                                    )
                                    .scaleEffect(player.isSelected ? 1.1 : 1.0)
                                    .opacity(player.isSelected ? 1 : 0.7)
                                    .rotationEffect(.degrees(player.rotation))
                                    .position(player.position)
                                    .animation(.easeInOut(duration: 0.3), value: player.isSelected)
                                
                                // Player number
                                Text("\(player.number)")
                                    .font(.system(size: 60, weight: .bold))
                                    .foregroundColor(.white)
                                    .position(player.position)
                                    .rotationEffect(.degrees(-player.rotation))
                            }
                            .onAppear {
                                withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                                    players[index].rotation = 5
                                }
                            }
                        }
                        
                        TouchDetector { location in
                            if !isSelecting {
                                print("Touch detected at: \(location)")
                                print("Current players count: \(players.count)")
                                handleTouch(at: location)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    Spacer()
                }
            }
        }
        .alert("Selection Disrupted", isPresented: $showError) {
            Button("OK") {
                resetGame()
            }
        } message: {
            Text("Please start again")
        }
    }
    
    private func handleTouch(at location: CGPoint) {
        // Check if touch is near any existing player
        let isNearExistingPlayer = players.contains { player in
            let distance = hypot(player.position.x - location.x, player.position.y - location.y)
            return distance < touchDetectionRadius
        }
        
        print("Is near existing player: \(isNearExistingPlayer)")
        print("Available colors count: \(availableColors.count)")
        
        if !isNearExistingPlayer && players.count < selectedPlayerCount {
            // Create new player with random color
            if let color = availableColors.randomElement() {
                print("Creating new player at: \(location) with color: \(color)")
                let newPlayer = PlayerCircle(
                    position: location,
                    color: color,
                    isSelected: false,
                    number: players.count + 1
                )
                players.append(newPlayer)
                availableColors.removeAll { $0 == color }
                print("New players count: \(players.count)")
                
                // Start selection if we have enough players
                if players.count == selectedPlayerCount {
                    startSelection()
                }
            } else {
                print("No more colors available")
            }
        }
    }
    
    private func startSelection() {
        isSelecting = true
        selectedPlayer = nil
        
        // Stop jiggle animation for all players
        for index in players.indices {
            players[index].rotation = 0
        }
        
        // Total duration of 3 seconds
        let totalDuration: TimeInterval = 3.0
        let highlightDuration: TimeInterval = 0.2
        
        // Calculate how many highlights we can fit in 3 seconds
        let numberOfHighlights = Int(totalDuration / highlightDuration)
        
        // Create an array of random indices for highlighting
        var highlightIndices = (0..<numberOfHighlights).map { _ in
            Int.random(in: 0..<players.count)
        }
        
        // Animate through random players
        var currentIndex = 0
        Timer.scheduledTimer(withTimeInterval: highlightDuration, repeats: true) { timer in
            if currentIndex < numberOfHighlights {
                // Deselect all players first
                for index in players.indices {
                    players[index].isSelected = false
                }
                
                // Select random player
                let randomIndex = highlightIndices[currentIndex]
                players[randomIndex].isSelected = true
                currentIndex += 1
            } else {
                timer.invalidate()
                // Select random player after animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if let randomPlayer = players.randomElement() {
                        selectedPlayer = randomPlayer
                        players = players.filter { $0.id == randomPlayer.id }
                        isSelecting = false
                    }
                }
            }
        }
    }
    
    private func resetGame() {
        players = []
        isSelecting = false
        selectedPlayer = nil
        availableColors = [.red, .blue, .green, .orange, .purple, .pink, .yellow, .mint]
    }
}

#Preview {
    ContentView()
} 
