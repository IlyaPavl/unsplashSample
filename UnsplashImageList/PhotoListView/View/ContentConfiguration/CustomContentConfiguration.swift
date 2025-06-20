//
//  CustomContentConfiguration.swift
//  UnsplashImageList
//
//  Created by Илья Павлов on 19.06.2025.
//

import UIKit

struct CustomContentConfiguration: UIContentConfiguration, Hashable {
    let title: String
    let likes: String
    let textColor: UIColor
    let image: String

    func makeContentView() -> UIView & UIContentView {
        return CustomContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> CustomContentConfiguration {
        return self
    }
}
