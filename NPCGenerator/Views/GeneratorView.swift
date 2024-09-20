//
//  ContentView.swift
//  NPCGenerator
//
//  Created by Jack Wright on 2024-09-18.
//

import SwiftUI
import Combine

private enum Constants {
    static let defaultSmallCellTitle: String = "Old NPCs will go here."
    static let smallCellHeight: CGFloat = 80
    static let cornerRadius: CGFloat = 10
    static let duration: Double = 0.5
}

struct GeneratorView: View {
    @ObservedObject var viewModel = GeneratorVM()

    // Cancellables, making a set makes more sense for > 3
    @State var subscription : AnyCancellable?
    @State var error : AnyCancellable?

    // Variables to be used in UI Updates
    @State var name: String = "Name"
    @State var race: String = "Race"
    @State var age: String = "Age"
    @State var profession: String = "Profession"

    // Variables used to handle animated for cells
    @State private var isNewCellVisible = false
    @State private var oldNPCs: [String] = [
        Constants.defaultSmallCellTitle,
        Constants.defaultSmallCellTitle,
        Constants.defaultSmallCellTitle
    ]
    @State private var activeCells: Set<Int> = []
    @State private var animate: Bool = true
    @State private var opacity: Double = 0.0
    private let maxCells = 3

    // Variables for error handling
    @State private var errorOpacity: Double = 1.0
    @State private var forError: Bool = false

    // Publishers for NPC and errors that will be coming from VM and service
    var currentNpc: AnyPublisher<NpcDetails?, Never> {
        viewModel.$mostRecentNPC.eraseToAnyPublisher()
    }

    var errorPublisher: AnyPublisher<Bool, Never> {
        viewModel.$errorGettingNPC.eraseToAnyPublisher()
    }

    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Text("NPC Generator")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }.padding(CommonConstants.totalEdges)
                .frame(maxHeight: .infinity, alignment: .top)
                .zIndex(1)
                VStack {
                    HStack {
                        Text("Most Recently Generated")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(CommonConstants.totalEdges)
                        Spacer()
                    }
                    ZStack {
                        NPCCellView(
                            name: $name, race: $race, age: $age, profession: $profession
                        ).onAppear {
                            self.subscription = currentNpc.dropFirst().sink(receiveValue: { npcDetails in
                                if let npc = npcDetails {
                                    self.name = npc.name
                                    self.age = "\(npc.age)"
                                    self.race = npc.race
                                    self.profession = npc.profession
                                }
                                withAnimation {
                                    // Add new small cell at the beginning
                                    if self.viewModel.mostRecentNPC != nil {
                                        if self.oldNPCs.count >= self.maxCells {
                                            self.oldNPCs.removeLast() // Remove the last (far right) item if max is reached
                                        }
                                        self.oldNPCs.insert(self.viewModel.mostRecentNPC?.name ?? UUID().uuidString, at: 0)
                                    }

                                    // Reset to show the big cell again
                                }
                                self.isNewCellVisible = false
                                withAnimation {
                                    opacity = 0.0
                                }
                                if errorOpacity != 0.0 {
                                    withAnimation {
                                        opacity = 0.0
                                    }
                                }
                            })
                            
                            self.error = errorPublisher.dropFirst()
                                .sink(receiveValue: { error in
                                    forError = true
                                    withAnimation {
                                        errorOpacity = error ? 1.0 : 0.0
                                    }
                            })
                        }
                        FlashLoadingGradient(opacity: $opacity)
                        EmptyViewForNpc(forError: $forError, opacity: $errorOpacity)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    HStack {
                        ForEach(Array(oldNPCs.enumerated()), id: \.element) { cell, index in
                            let _ = debugPrint("index: \(index)")
                            let _ = debugPrint("names: \(oldNPCs.description)")
                            let _ = debugPrint("lastthree: \(viewModel.lastThreeNPCs.description)")
                            let name = oldNPCs
                            NPCCellSmallView(name: name[cell])
                                .background(
                                    name[cell] != Constants.defaultSmallCellTitle ?
                                        Color.mint :
                                        Color.gray
                                )
                                .cornerRadius(Constants.cornerRadius)
                                .animation(
                                    .easeInOut(duration: Constants.duration),
                                    value: activeCells
                                )
                        }
                    }
                    .frame(height: Constants.smallCellHeight)
                    .padding(CommonConstants.totalEdges)
                    Button(action: generate) {
                        Text("Generate")
                    }.buttonStyle(.bordered)
                    Spacer().frame(height: 64)
                    HStack {
                        Text("All NPCs")
                            .foregroundStyle(.white)
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.white)
                    }.frame(height: 128)
                        .padding()
                    .background {
                        ZStack {
                            Image(uiImage: UIImage(named: "backgroundImage")!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 128)
                                .clipShape(.rect(cornerRadii: CommonConstants.corner))
                                .clipped()
                            Rectangle()
                                .frame(height: 128)
                                .clipShape(.rect(cornerRadii: CommonConstants.corner))
                                .opacity(0.5)
                        }
                    }.padding(CommonConstants.totalEdges)

                }
            }
        }
    }

    private func generateNewCell() {
        withAnimation {
            opacity = 1.0
        } completion: {
            withAnimation {
                errorOpacity = 0.0
                isNewCellVisible = true
            }
        }
    }

    func getNPCs() {
        viewModel.getNPCs()
    }

    func generate() {
        viewModel.generateNPCs()
        generateNewCell()
    }
}

#Preview {
    GeneratorView()
}
