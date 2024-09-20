//
//  NPCCellView.swift
//  NPCGenerator
//
//  Created by Jack Wright on 2024-09-18.
//

import SwiftUI

private enum Constants {
    static let edges = NSDirectionalEdgeInsets(top: 24, leading: 0, bottom: 24, trailing: 0)
    static let imagePadding = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
    static let chevronPadding = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
    static let corner = RectangleCornerRadii(topLeading: 16, bottomLeading: 16, bottomTrailing: 16, topTrailing: 16)
    static let smallEdges = EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
}

struct NPCCellView: View {
    @Binding var name: String
    @Binding var race: String
    @Binding var age: String
    @Binding var profession: String

    var body: some View {
        HStack {
            Image(systemName: Race.raceCheck(stringToCheck: race.lowercased()).imageName).imageScale(.large).padding(EdgeInsets(Constants.imagePadding))
            VStack {
                HStack {
                    Text("\(name)").font(.title2).fontWeight(.semibold)
                    Spacer()
                }
                Spacer().frame(height: 24)
                HStack {
                    Text("\(race)").font(.footnote)
                    Rectangle().frame(width: 1, height: 16)
                    Text("\(age)").font(.footnote)
                    Rectangle().frame(width: 1, height: 16)
                    Text("\(profession)").font(.footnote)
                    Spacer()
                }
            }.padding(EdgeInsets(Constants.edges))
            Image(systemName: "chevron.right").padding(EdgeInsets(Constants.chevronPadding))
        }.background {
            Rectangle().fill(Color(.cyan)).clipShape(.rect(cornerRadii: Constants.corner))
        }.padding(CommonConstants.totalEdges)
    }
}

struct NPCCellSmallView: View {
    var name: String
    var body: some View {
        VStack {
            Text("\(name)")
                .font(.footnote)
                .padding(Constants.smallEdges)
                .frame(height: 64)
        }.frame(maxWidth: .infinity)
    }
}

#Preview {
    return NPCCellSmallView(name: "lollers")
}

