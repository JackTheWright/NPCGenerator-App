//
//  GeneratorVM.swift
//  NPCGenerator
//
//  Created by Jack Wright on 2024-09-18.
//

import Foundation
import Combine

class GeneratorVM: ObservableObject {
    let networkService = NetworkService()
    @Published var mostRecentNPC: NpcDetails?
    @Published var errorGettingNPC: Bool = false

    @Published var lastThreeNPCs: [String] = ["Ungenerated", "Ungenerated", "Ungenerated"]
    private var npcCancellable: AnyCancellable?
    private var errorCancellable: AnyCancellable?

    init() {
        npcCancellable = networkService.$mostRecentNPC
            .sink(receiveValue: { [weak self] details in
            guard let this = self else { return }
            if details != nil, let oldNpc = this.mostRecentNPC {
                this.lastThreeNPCs.insert(oldNpc.name, at: 0)
                if this.lastThreeNPCs.count > 3 {
                    this.lastThreeNPCs.remove(at: 3)
                }
            }
            this.mostRecentNPC = details
        })

        errorCancellable = networkService.$error
            .removeDuplicates()
            .sink(receiveValue: { [weak self] error in
                guard let this = self else { return }
                this.errorGettingNPC = error
            })
    }

    func getNPCs() {
        networkService.getNPCs()
    }

    func generateNPCs() {
        networkService.generateNPC()
    }

    func getNPCById(id: Int) {
        
    }
}
