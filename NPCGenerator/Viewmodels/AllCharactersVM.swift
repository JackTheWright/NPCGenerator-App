//
//  AllCharactersVM.swift
//  NPCGenerator
//
//  Created by Jack Wright on 2024-09-22.
//

import Foundation
import RxSwift
import RxDataSources
import UIKit

private enum Constants {
    static let pageNumber = 10
}

class AllCharactersVM {
    let disposeBag = DisposeBag()
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        networkManager.getAllNPCs(offset: 0, pageSize: Constants.pageNumber)
    }

    var npcList: Observable<[NpcDetails]> {
        networkManager.allNPCsObservable
    }

    func getNextPage() {
        networkManager.getAllNPCs(offset: networkManager.currentPage, pageSize: Constants.pageNumber)
    }
}
