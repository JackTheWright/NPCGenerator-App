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
    static let allNpcsTileHeight: CGFloat = 100
    static let spacerHeight: CGFloat = 64
    static let totalEdgesWithTop = EdgeInsets(top: 24, leading: 48, bottom: 0, trailing: 48)
    static let totalEdgesWithBottom = EdgeInsets(top: 24, leading: 24, bottom: 24, trailing: 24)
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
        NavigationStack {
            VStack {
                HStack {
                    Text("NPC Generator")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }.padding(CommonConstants.totalEdges)
                Spacer().frame(height: CommonConstants.standardSpacing6)
                VStack {
                    VStack {
                        HStack {
                            Text("Most Recently Generated")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .padding(Constants.totalEdgesWithTop)
                            Spacer()
                        }
                        ZStack {
                            NpcCellView(
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
                                let name = oldNPCs
                                NpcCellSmallView(name: name[cell])
                                    .background(
                                        name[cell] != Constants.defaultSmallCellTitle ?
                                        Color.white :
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
                        .padding(CommonConstants.innerEdges)
                        Button(action: generate) {
                            Text("Generate")
                        }.buttonStyle(.borderedProminent)
                            .clipShape(.rect(cornerRadii: CommonConstants.corner))
                            .border(.clear)
                            .tint(.yellow)
                            .foregroundStyle(.black)
                            .zIndex(3.0)
                            .padding(Constants.totalEdgesWithBottom)
                    }.background {
                        Image(uiImage: UIImage(named: "backgroundImage")!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(
                                .rect(cornerRadii: CommonConstants.corner)
                            )
                            .clipped()
                            .padding(CommonConstants.totalEdges)
                        Rectangle()
                            .clipShape(.rect(cornerRadii: CommonConstants.corner))
                            .foregroundStyle(.black)
                            .opacity(0.5)
                            .padding(CommonConstants.totalEdges)
                    }
                    NavigationLink(
                        destination: ConversionControllerView().ignoresSafeArea().navigationTitle("All NPCs")
                    ) {
                        HStack {
                            Text("All NPCs")
                                .foregroundStyle(.white)
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.white)
                        }.frame(height: Constants.allNpcsTileHeight)
                            .padding()
                            .background {
                                ZStack {
                                    Image(uiImage: UIImage(named: "tileImage")!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(
                                            height: Constants.allNpcsTileHeight
                                        ).clipShape(
                                            .rect(cornerRadii: CommonConstants.corner)
                                        )
                                        .clipped()
                                    Rectangle()
                                        .frame(height: Constants.allNpcsTileHeight)
                                        .clipShape(.rect(cornerRadii: CommonConstants.corner))
                                        .foregroundStyle(.black)
                                        .opacity(0.5)
                                }
                            }.padding(CommonConstants.totalEdges)
                    }.foregroundStyle(.clear)
                }
                Spacer()
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
