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
        [icon, iconTransitionTarget, title, subtitle, body]
            .compactMap { $0 }
            .joined(separator: "|")
    }

    public var icon: String
    public var toIcon: String?
    public var icons: [String]?
    public var title: String
    public var subtitle: String
    public var body: String

    public var displayedIcon: String {
        icons?.first ?? icon
    }

    public var iconTransitionTarget: String? {
        if let icons, icons.count > 1 {
            return icons[1]
        }
        return toIcon
    }

    public init(icon: String, toIcon: String? = nil, icons: [String]? = nil, title: String, subtitle: String, body: String) {
        self.icon = icon
        self.toIcon = toIcon
        self.icons = icons
        self.title = title
        self.subtitle = subtitle
        self.body = body
    }

    enum CodingKeys: String, CodingKey {
        case icon
        case toIcon
        case icons
        case title
        case subtitle
        case body
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let decodedIcons = try container.decodeIfPresent([String].self, forKey: .icons)

        if let decodedIcon = try container.decodeIfPresent(String.self, forKey: .icon) {
            icon = decodedIcon
        } else if let firstIcon = decodedIcons?.first {
            icon = firstIcon
        } else {
            throw DecodingError.keyNotFound(
                CodingKeys.icon,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Expected either `icon` or at least one value in `icons`."
                )
            )
        }

        toIcon = try container.decodeIfPresent(String.self, forKey: .toIcon)
        icons = decodedIcons
        title = try container.decode(String.self, forKey: .title)
        subtitle = try container.decode(String.self, forKey: .subtitle)
        body = try container.decode(String.self, forKey: .body)
    }
}
