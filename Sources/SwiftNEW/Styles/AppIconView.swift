//
//  AppIconView.swift
//  SwiftNEW
//
//  Created by Ming on 7/1/2025.
//
#if os(iOS)
import SwiftUI

public struct AppIconView: View {
    public var body: some View {
        Bundle.main.iconFileName
            .flatMap {
                UIImage(named: $0)
            }
            .map {
                Image(uiImage: $0)
                    .resizable()
                    .frame(width: 65, height: 65)
                    .overlay(
                        RoundedRectangle(cornerRadius: 19, style: .continuous)
                            .stroke(.gray, lineWidth: 1)
                    )
            }
            .clipShape(RoundedRectangle(cornerRadius: 19, style: .continuous))
    }
}
#endif
