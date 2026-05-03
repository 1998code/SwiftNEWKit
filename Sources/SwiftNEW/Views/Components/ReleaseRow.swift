//
//  ReleaseRow.swift
//  SwiftNEW
//

import SwiftUI

@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
extension SwiftNEW {

    @ViewBuilder
    func releaseRow(_ new: Model, bodyFont: Font, spacing: CGFloat? = nil) -> some View {
        HStack {
            if align == .leading || align == .center {
                iconBadge(systemName: new.icon)
                    .padding(.trailing)
            }

            VStack(alignment: align == .trailing ? .trailing : .leading, spacing: spacing) {
                Text(new.title).font(.headline).lineLimit(1)
                Text(new.subtitle).font(.subheadline).foregroundColor(.secondary).lineLimit(1)
                Text(new.body).font(bodyFont).foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: align == .trailing ? .trailing : .leading)

            if align == .trailing {
                iconBadge(systemName: new.icon)
                    .padding(.leading)
            }
        }
    }
}
