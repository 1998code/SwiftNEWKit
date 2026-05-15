//
//  Vmodel.swift
//  SwiftNEW
//
//  Created by Ming on 7/1/2025.
//

import SwiftUI

// MARK: - Model
public struct Vmodel: Codable, Hashable, Identifiable, Sendable {
    public var id: String {
        [version, subVersion].compactMap { $0 }.joined(separator: "|")
    }

    public var version: String
    public var subVersion: String?
    public var new: [Model]

    public init(version: String, subVersion: String? = nil, new: [Model]) {
        self.version = version
        self.subVersion = subVersion
        self.new = new
    }
}

public struct Model: Codable, Hashable, Identifiable, Sendable {
    public var id: String {
        [icon, title, subtitle, body].joined(separator: "|")
    }

    public var icon: String
    public var title: String
    public var subtitle: String
    public var body: String

    public init(icon: String, title: String, subtitle: String, body: String) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.body = body
    }
}
