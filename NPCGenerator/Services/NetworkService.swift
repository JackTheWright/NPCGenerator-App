//
//  NetworkService.swift
//  NPCGenerator
//
//  Created by Jack Wright on 2024-09-18.
//

import Foundation
import Combine
import Alamofire

private enum Constants {
    // I know this is insecure, but it is just for project purposes.
    static let URL = "http://127.0.0.1:8080"
}

class NetworkService {
    static let shared = NetworkService()
    @Published var mostRecentNPC: NpcDetails?
    @Published var error: Bool = false

    func getNPCs() {
        AF.request("\(Constants.URL)\(API.getNPCs.endpoint)")
            .responseDecodable(of: [NpcDetails].self) { response in
                debugPrint("Response: \(response)")
                if let gimli = response.value?.first {
                    debugPrint("First Item: \(gimli.id), \(gimli.name), \(gimli.age), \(gimli.race)")
                }
            }
    }

    func getNPCByID(id: Int) -> DataRequest {
        AF.request("\(Constants.URL)\(API.getNPCByID(id: id).endpoint)")
    }

    func editNPC(npc: NpcDetails) throws {
        let jsonEncoder = JSONEncoder()
        let jsonData = try jsonEncoder.encode(npc)
        let jsonValue = try JSONSerialization.jsonObject(with: jsonData, options: [])
        guard let jsonDict = jsonValue as? [String: Any] else { return }
        AF.request(
            "\(Constants.URL)\(API.editNPC(id: npc.id).endpoint)",
            method: .put,
            parameters: jsonDict
        ).responseDecodable(of: NpcDetails.self) { response in
            debugPrint("Response: \(response)")
        }
    }

    func deleteNPC(npcID: Int) {
        AF.request(
            "\(Constants.URL)\(API.deleteNPC(id: npcID).endpoint)",
            method: .delete
        ).response { response in
            debugPrint("Response: \(response)")
        }
    }

    func generateNPC() {
        AF.request("\(Constants.URL)\(API.generateNPC.endpoint)")
            .responseDecodable(of: NpcDetails.self) { response in
            debugPrint("Response: \(response)")
            if let npc = response.value {
                debugPrint("First Item: \(npc.id), \(npc.name), \(npc.age), \(npc.race)")
                self.mostRecentNPC = npc
                self.error = false
            } else if let error = response.error {
                debugPrint("Error: \(error)")
                self.error = true
            }
        }
    }

    func getAllNPCs(offset: Int, pageSize: Int) -> DataRequest {
        let params: Parameters = [
            "offset": offset,
            "pageSize": pageSize
        ]
        return AF.request("\(Constants.URL)\(API.getNPCs.endpoint)", parameters: params)
    }
}

enum API {
    case getNPCs
    case getNPCByID(id: Int)
    case editNPC(id: Int)
    case deleteNPC(id: Int)
    case generateNPC

    var endpoint: String {
        switch self {
        case .getNPCs:
            return "/npcDetails"
        case .getNPCByID(let id), .editNPC(let id), .deleteNPC(let id):
            return "/npcDetails/\(id)"
        case .generateNPC:
            return "/ai/generate"
        }
    }
}
