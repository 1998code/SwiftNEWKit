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

        HStack(alignment: releaseRowVerticalAlignment, spacing: releaseRowSpacing) {
            if align == .leading || align == .center {
                iconBadge(systemNames: new.iconSequence)
            }

            VStack(alignment: contentAlignment, spacing: spacing ?? 3) {
                Text(new.title)
                    .font(releaseRowTitleFont)
                    .foregroundStyle(.primary)
                    .lineLimit(releaseRowTitleLineLimit)
                Text(new.subtitle)
                    .font(releaseRowSubtitleFont)
                    .foregroundStyle(.secondary)
                    .lineLimit(releaseRowTitleLineLimit)
                if showDescription {
                    Text(new.body)
                        .font(bodyFont)
                        .foregroundStyle(.secondary)
                        .lineSpacing(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity, alignment: frameAlignment)

            if align == .trailing {
                iconBadge(systemNames: new.iconSequence)
            }
        }
        .padding(.leading, releaseRowLeadingPadding)
        .padding(.bottom, releaseRowBottomPadding)
    }

    private var releaseRowVerticalAlignment: VerticalAlignment {
        #if os(watchOS)
        .top
        #else
        .center
        #endif
    }

    private var releaseRowSpacing: CGFloat {
        #if os(watchOS)
        8
        #else
        12
        #endif
    }

    private var releaseRowTitleLineLimit: Int? {
        #if os(watchOS)
        2
        #else
        1
        #endif
    }

    private var releaseRowTitleFont: Font {
        #if os(watchOS)
        .subheadline.weight(.semibold)
        #else
        .headline.weight(.semibold)
        #endif
    }

    private var releaseRowSubtitleFont: Font {
        #if os(watchOS)
        .footnote.weight(.medium)
        #else
        .subheadline.weight(.medium)
        #endif
    }

    private var releaseRowLeadingPadding: CGFloat {
        #if os(watchOS)
        8
        #else
        16
        #endif
    }

    private var releaseRowBottomPadding: CGFloat {
        #if os(watchOS)
        8
        #else
        16
        #endif
    }
}
