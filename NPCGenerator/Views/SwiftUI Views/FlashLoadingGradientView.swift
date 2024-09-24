//
//  FlashLoadingGradientView.swift
//  NPCGenerator
//
//  Created by Jack Wright on 2024-09-19.
//

import SwiftUI

struct FlashLoadingGradient: View {
    @State private var gradientOffset = -1.0
    @Binding var opacity: Double

    let gradientColors: [Color] = [.blue, .mint, .green, .blue]

    var body: some View {
        GeometryReader { geometry in
            LinearGradient(
                stops: [
                    Gradient.Stop(color: .cyan, location: 0.15),
                    Gradient.Stop(color: .mint, location: 0.7),
                    Gradient.Stop(color: .white, location: 0.85),
                    Gradient.Stop(color: .cyan, location: 1.0),
                ],
                startPoint: .init(x: gradientOffset, y: 0),
                endPoint: .init(x: gradientOffset + 1.0, y: 0)
            )
                .frame(width: geometry.size.width, height: geometry.size.height)
                .onAppear {
                    withAnimation(Animation.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                        gradientOffset = 1.0
                    }
                }
        }
        .clipShape(.rect(cornerRadii: CommonConstants.corner))
        .padding(CommonConstants.innerEdges)
        .clipped()
        .opacity(opacity)
    }
}

#Preview {
    @State var opacity: Double = 1.0
    return FlashLoadingGradient(opacity: $opacity)
}
