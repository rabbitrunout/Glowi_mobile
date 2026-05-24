//
//  GlowiIcon.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-04-18.
//

import SwiftUI

struct GlowiAssetIcon: View {
    let name: String
    let size: CGFloat

    var body: some View {
        Image(name)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
    }
}

struct GlowiIconBadge: View {
    let assetName: String
    let size: CGFloat
    let background: Color

    init(assetName: String, size: CGFloat = 20, background: Color = Color.white.opacity(0.12)) {
        self.assetName = assetName
        self.size = size
        self.background = background
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(background)
                .frame(width: 42, height: 42)

            GlowiAssetIcon(name: assetName, size: size)
        }
    }
}

#Preview {
    ZStack {
        Theme.backgroundGradient.ignoresSafeArea()

        VStack(spacing: 16) {
            GlowiAssetIcon(name: "icon-clubs", size: 40)
            GlowiIconBadge(assetName: "icon-ribbon")
        }
        .padding()
    }
}
