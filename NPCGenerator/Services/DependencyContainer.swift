//
//  DependencyContainer.swift
//  NPCGenerator
//
//  Created by Jack Wright on 2024-09-22.
//

import Foundation
import Swinject

class DependencyContainer {

    static let shared = DependencyContainer()
    let container: Container

    init() {
        self.container = Container()

        container.register(NetworkManagerProtocol.self) { _ in
            NetworkManager()
        }

        container.register(AllCharactersVM.self) { swinject in
            AllCharactersVM(networkManager: swinject.resolve(NetworkManagerProtocol.self)!)
        }
    }
}
