//
//  VerticalSlider.swift
//  LearnSolarSystem
//
//  Created by Hans Arthur Cupiterson on 21/05/24.
//

import SwiftUI

struct VerticalSlider: View {
    @Binding var sliderValue: Double

    var body: some View {
        VStack {
            GeometryReader { geometry in
                Slider(value: $sliderValue, in: 0.1...2.0) {
                    Text("Scale: \(sliderValue, specifier: "%.1f")")
                }
                .rotationEffect(.degrees(-90))
                .frame(width: geometry.size.width / 4, height: geometry.size.height, alignment: .trailing)
                .padding(.leading, -50)
            }
        }
    }
}

#Preview {
    VerticalSlider(sliderValue: .constant(0.5))
}
