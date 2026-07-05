//
//  ReleaseRow.swift
//  SwiftNEW
//

import SwiftUI

@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
extension SwiftNEW {

    @ViewBuilder
    func releaseRow(_ new: Model, bodyFont: Font, spacing: CGFloat? = nil) -> some View {
        let contentAlignment: HorizontalAlignment = align == .trailing ? .trailing : .leading
        let frameAlignment: Alignment = align == .trailing ? .trailing : .leading

        HStack(spacing: 12) {
            if align == .leading || align == .center {
                iconBadge(systemName: new.displayedIcon, toSystemName: new.iconTransitionTarget)
            }

            VStack(alignment: contentAlignment, spacing: spacing ?? 3) {
                Text(new.title)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                Text(new.subtitle)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                Text(new.body)
                    .font(bodyFont)
                    .foregroundStyle(.secondary)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: frameAlignment)

            if align == .trailing {
                iconBadge(systemName: new.displayedIcon, toSystemName: new.iconTransitionTarget)
            }
        }
        .padding(.leading)
        .padding(.bottom)
    }
}
