//
//  File.swift
//  NPCGenerator
//
//  Created by Jack Wright on 2024-09-20.
//

import Foundation
import SwiftUI

enum Race {
    case elf
    case halfelf
    case dwarf
    case gnome
    case human
    case tiefling
    case orc
    case halforc
    case goliath
    case unknown

    var imageName: String {
        switch self {
        case .elf:
            return  "tree"
        case .halfelf:
            return "leaf"
        case .dwarf:
            return "mountain.2"
        case .gnome:
            return "moon"
        case .human:
            return "person"
        case .tiefling:
            return "flame"
        case .orc:
            return "shield"
        case .halforc:
            return "shield.lefthalf.filled"
        case .goliath:
            return "snowflake"
        case .unknown:
            return "eye"
        }
    }

    static func raceCheck(stringToCheck: String) -> Race {
        if stringToCheck.contains("half") {
            if stringToCheck.contains("orc") {
                return .halforc
            } else if stringToCheck.contains("elf") {
                return .halfelf
            }
        } else if stringToCheck.contains("dwarf") {
            return .dwarf
        } else if stringToCheck.contains("gnome") {
            return .gnome
        } else if stringToCheck.contains("human") {
            return .human
        } else if stringToCheck.contains("orc") {
            return .orc
        } else if stringToCheck.contains("elf") {
            return .elf
        } else if stringToCheck.contains("tiefling") {
            return .tiefling
        } else if stringToCheck.contains("goliath") {
            return .goliath
        }
        return .unknown
    }
}
