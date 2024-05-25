//
//  LoadingView.swift
//  LearnSolarSystem
//
//  Created by Hans Arthur Cupiterson on 20/05/24.
//

import SwiftUI

struct LoadingView: View {
    @Binding var isLoading: Bool
    @Environment(\.dismiss) private var dismiss
    @State private var rocketOpacity: Double = 0.0
    @State private var loadingText: String = "Loading assets"
    @State private var loadingIdx: Int = 0
    var loadings = [
        "Loading assets",
        "Loading assets.",
        "Loading assets..",
        "Loading assets..."
    ]
    
    var body: some View {
        VStack {
            if isLoading {
                ZStack {
                    Color.black.ignoresSafeArea()
                    ForEach(0..<50) { _ in
                        Circle()
                            .fill(Color.white)
                            .frame(width: 2, height: 2)
                            .position(
                                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                                y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                            )
                    }
                    VStack {
                        Image("rocket")
                            .resizable()
                            .frame(width: 100, height: 150)
                            .scaledToFill()
                            .opacity(rocketOpacity)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 1).repeatForever()) {
                                    rocketOpacity = 1
                                }
                                startLoadingTextAnimation()
                            }
                        Text("\(loadingText)")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .onChange(of: isLoading) { oldValue, newValue in
            dismiss()
        }
    }
    
    private func startLoadingTextAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            loadingText = loadings[loadingIdx]
            if loadingIdx >= loadings.count - 1 {
                loadingIdx = 0
            } else {
                loadingIdx += 1
            }
        }
    }
}

#Preview {
    LoadingView(isLoading: .constant(true))
}

