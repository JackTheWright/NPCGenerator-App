//
//  EmptyViewForNpc.swift
//  NPCGenerator
//
//  Created by Jack Wright on 2024-09-19.
//

import SwiftUI

struct EmptyViewForNpc: View {
    @Binding var forError: Bool
    @Binding var opacity: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .fill(forError ? Color(.red) : Color(.cyan))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                Text(forError ? "An error has occured... Please try again" : "Tap the generate button to create your first NPC")
                    .fontWeight(.semibold)
                    .padding(CommonConstants.totalEdges)
                    .multilineTextAlignment(.center)
            }
        }
        .clipShape(.rect(cornerRadii: CommonConstants.corner))
        .padding(CommonConstants.totalEdges)
        .clipped()
        .opacity(opacity)
    }
}

#Preview {
    @State var opacity: Double = 1.0
    @State var forError: Bool = false
    return EmptyViewForNpc(forError: $forError, opacity: $opacity)
}
