//
//  CommonConstants.swift
//  NPCGenerator
//
//  Created by Jack Wright on 2024-09-19.
//

import Foundation
import SwiftUI
import UIKit

enum CommonConstants {
    static let corner = RectangleCornerRadii(topLeading: 16, bottomLeading: 16, bottomTrailing: 16, topTrailing: 16)
    static let totalEdges = EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24)
    static let innerEdges = EdgeInsets(top: 0, leading: 48, bottom: 0, trailing: 48)

    static let screenWidth: CGFloat = UIScreen.main.bounds.width

    // Trying to keep all the app spacing to 8 pixels
    static let standardSpacing: CGFloat = 8
    static let standardSpacing2: CGFloat = 16
    static let standardSpacing3: CGFloat = 24
    static let standardSpacing4: CGFloat = 32
    static let standardSpacing6: CGFloat = 48
    static let standardSpacing8: CGFloat = 64
}
