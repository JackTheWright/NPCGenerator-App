//
//  NetworkManager.swift
//  NPCGenerator
//
//  Created by Jack Wright on 2024-09-22.
//

import Foundation
import Alamofire
import RxSwift
import RxRelay

protocol NetworkManagerProtocol {
    var allNPCsObservable: Observable<[NpcDetails]> { get }
    var currentPage: Int { get set }
    func getAllNPCs(offset: Int, pageSize: Int)
    func editNPC(npcDetails: NpcDetails)
    func getNPCById(id: Int)
}

class NetworkManager: NetworkManagerProtocol {
    var currentPage: Int = 0

    var allNPCs = BehaviorRelay<[NpcDetails]>(value: [])

    var allNPCsObservable: Observable<[NpcDetails]> {
        allNPCs.asObservable()
    }

    func getAllNPCs(offset: Int, pageSize: Int) {
        NetworkService.shared.getAllNPCs(offset: offset, pageSize: pageSize)
            .responseDecodable(of: PaginatedData<NpcDetails>.self) { [weak self] response in
                debugPrint("Response: \(response)")
                guard let this = self else { return }
                if let response = response.value {
                    if response.page.number == 0 {
                        this.allNPCs.accept(response.jsonData)
                    } else {
                        var currentItems: [NpcDetails] = this.allNPCs.value
                        currentItems.append(contentsOf: response.jsonData)
                        this.allNPCs.accept(currentItems)
                    }
                    this.currentPage += 1
                    debugPrint("Got NPCs")
                } else if let error = response.error {
                    debugPrint("Error getting all NPCs: \(error)")
                }
            }
    }

    func editNPC(npcDetails: NpcDetails) {
        do {
            try NetworkService.shared.editNPC(npc: npcDetails)
        } catch let error {
            debugPrint("Error editing NPC: \(error.localizedDescription)")
        }
    }

    func getNPCById(id: Int) {
        NetworkService.shared.getNPCByID(id: id).responseDecodable(of: NpcDetails.self) { response in
            debugPrint("Response: \(response)")
        }
    }
}
