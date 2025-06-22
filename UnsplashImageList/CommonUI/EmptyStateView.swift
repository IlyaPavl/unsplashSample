//
//  EmptyView.swift
//  UnsplashImageList
//
//  Created by Илья Павлов on 21.06.2025.
//

import UIKit

final class EmptyStateView: UIView {
    init(text: String) {
        super.init(frame: .zero)
        setupWith(text)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupWith(_ text: String) {
        let emptyTextLabel = UILabel()
        emptyTextLabel.text = text
        emptyTextLabel.textAlignment = .center
        emptyTextLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        emptyTextLabel.textColor = .secondaryLabel
        emptyTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(emptyTextLabel)
        NSLayoutConstraint.activate([
            emptyTextLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
