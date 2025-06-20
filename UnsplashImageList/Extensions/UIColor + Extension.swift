//
//  UIColor + Extension.swift
//  UnsplashImageList
//
//  Created by Илья Павлов on 19.06.2025.
//


import UIKit

extension UIColor {
    convenience init?(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        guard hex.count == 6, let rgb = UInt64(hex, radix: 16) else { return nil }

        self.init(
            red: CGFloat((rgb >> 16) & 0xFF) / 255,
            green: CGFloat((rgb >> 8) & 0xFF) / 255,
            blue: CGFloat(rgb & 0xFF) / 255,
            alpha: 1
        )
    }
}
