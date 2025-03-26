//
//  who_plays_firstApp.swift
//  who-plays-first
//
//  Created by Sunil Kamat on 3/25/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                // Background image
                GeometryReader { geometry in
                    Image("LaunchScreenImage")
                        .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                }
                .ignoresSafeArea()
                
                VStack {
                    // Top text
                    Text("Who Plays First?")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 60)
                    
                    Spacer()
                    
                    // Bottom text
                    Text("App by Sunil Kamat")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.gray)
                        .padding(.bottom, 120)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

@main
struct who_plays_firstApp: App {
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
    }
}
