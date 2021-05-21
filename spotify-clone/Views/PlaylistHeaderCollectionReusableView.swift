//
//  PlaylistHeaderCollectionReusableView.swift
//  spotify-clone
//
//  Created by Walid Rafei on 5/19/21.
//

import UIKit
import SDWebImage

protocol PlaylistHeaderCollectionReusableViewDelegate: AnyObject {
    func PlaylistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView)
}
final class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "PlaylistHeaderCollectionReusableView"
    
    weak var delegate: PlaylistHeaderCollectionReusableViewDelegate?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.8
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 4
        label.textColor = .secondaryLabel
        label.minimumScaleFactor = 0.75
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let playlistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    private let playAllButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.tintColor = .white
        button.layer.cornerRadius = 23
        button.layer.masksToBounds = true
        let font = UIFont.systemFont(ofSize: 13, weight: .bold)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.white,
        ]

        button.setAttributedTitle(NSAttributedString(string: "SHUFFLE PLAY", attributes: attributes), for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(playlistImageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(playAllButton)
        playAllButton.addTarget(self, action: #selector(didTapPlayAll), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc private func didTapPlayAll() {
        delegate?.PlaylistHeaderCollectionReusableViewDidTapPlayAll(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = height / 2.5
        playlistImageView.frame = CGRect(x: (width - imageSize) / 2, y: 20, width: imageSize, height: imageSize)
        
        playAllButton.frame = CGRect(x: (width - 200) / 2, y: playlistImageView.bottom + 20, width: 200, height: 45)

        nameLabel.frame = CGRect(x: 10, y: playAllButton.bottom + 5, width: width - 20, height: 50)
        descriptionLabel.frame = CGRect(x: 10, y: nameLabel.bottom , width: width - 20, height: 60)
        
    }
    
    func configure(with viewModel: playlistHeaderViewModel) {
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
        playlistImageView.sd_setImage(with: viewModel.artWorkURL, completed: nil)
    }
}
