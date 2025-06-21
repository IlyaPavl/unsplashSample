//
//  CustomContentView.swift
//  UnsplashImageList
//
//  Created by Илья Павлов on 19.06.2025.
//

import UIKit

class CustomContentView: UIView, UIContentView {
    
    enum Constants {
        static let containerBackgroundColor = UIColor.systemGray6.withAlphaComponent(0.5)
        static let containerCornerRadius: CGFloat = 12
        
        static let imageContentMode: UIView.ContentMode = .scaleAspectFill
        static let imageCornerRadius: CGFloat = 8
        static let imageBackgroundColor = UIColor.systemGray6
        static let imageHeight: CGFloat = 250
        
        static let descriptionLabelNumberOfLines = 2
        static let descriptionLabelFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        static let likesLabelFont = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        static let containerInset: CGFloat = 8
        static let innerInset: CGFloat = 12
        static let likesTopInset: CGFloat = 8
        static let likesBottomInset: CGFloat = 12
    }
    
    private let imageView = WebImageView()
    private let descriptionLabel = UILabel()
    private let likesLabel = UILabel()
    private let containerView = UIView()
    
    var configuration: UIContentConfiguration {
        didSet {
            guard let config = configuration as? CustomContentConfiguration else { return }
            apply(configuration: config)
        }
    }
    
    init(configuration: CustomContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setupViews()
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func apply(configuration: CustomContentConfiguration) {
        descriptionLabel.text = configuration.title
        likesLabel.text = configuration.likes
        likesLabel.textColor = configuration.textColor
        descriptionLabel.textColor = configuration.textColor
        imageView.set(imageURL: configuration.image)
    }
}

// MARK: - UI Setup
private extension CustomContentView {
    func setupViews() {
        addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(likesLabel)
        
        setupContainerView()
        setupImageView()
        setupDescriptionLabel()
        setupLikesLabel()
        setupConstraints()
    }
    
    func setupContainerView() {
        containerView.backgroundColor = Constants.containerBackgroundColor
        containerView.layer.cornerRadius = Constants.containerCornerRadius
    }
    
    func setupImageView() {
        imageView.contentMode = Constants.imageContentMode
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.imageCornerRadius
        imageView.backgroundColor = Constants.imageBackgroundColor
    }
    
    func setupDescriptionLabel() {
        descriptionLabel.numberOfLines = Constants.descriptionLabelNumberOfLines
        descriptionLabel.font = Constants.descriptionLabelFont
    }
    
    func setupLikesLabel() {
        likesLabel.font = Constants.likesLabelFont
    }
    
    func setupConstraints() {
        [containerView, imageView, descriptionLabel, likesLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.containerInset),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.containerInset),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.containerInset),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.containerInset),
            
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.innerInset),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.innerInset),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.innerInset),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageHeight),
            
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.innerInset),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.innerInset),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.innerInset),
            
            likesLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.likesTopInset),
            likesLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.innerInset),
            likesLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.innerInset),
            likesLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.likesBottomInset)
        ])
    }
}
