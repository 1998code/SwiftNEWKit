//
//  Vmodel.swift
//  SwiftNEW
//
//  Created by Ming on 7/1/2025.
//

import SwiftUI

// MARK: - Model
public struct Vmodel: Codable, Hashable, Sendable {
    var version: String
    var subVersion: String?
    var new: [Model]
}
public struct Model: Codable, Hashable, Sendable {
    var icon: String
    var title: String
    var subtitle: String
    var body: String
}

