//
//  FeaturedPlaylistCollectionViewCell.swift
//  spotify-clone
//
//  Created by Walid Rafei on 5/19/21.
//

import UIKit

class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeaturedPlaylistCollectionViewCell"
    
    private let playlistCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private let creatorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 5
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(playlistCoverImageView)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(creatorNameLabel)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize = contentView.width - 40
        playlistCoverImageView.frame = CGRect(x: (contentView.width - imageSize) / 2, y:20, width:imageSize, height: imageSize)
        
        playlistNameLabel.frame = CGRect(x: 20, y: playlistCoverImageView.bottom + 10, width: contentView.width - 30, height: 30)
        
        creatorNameLabel.frame = CGRect(x: 20, y: playlistNameLabel.bottom , width: contentView.width - 30, height: 30)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistNameLabel.text = nil
        playlistCoverImageView.image = nil
        creatorNameLabel.text = nil
    }
    
    func configure(with viewModel: FeaturedPlaylistCellViewModel) {
        playlistNameLabel.text = viewModel.name
        playlistCoverImageView.sd_setImage(with: viewModel.artWorkURL, completed: nil)
        creatorNameLabel.text = viewModel.creatorName
    }
}
