//
//  RecommendedTrackCollectionViewCell.swift
//  spotify-clone
//
//  Created by Walid Rafei on 5/19/21.
//

import UIKit

class RecommendedTrackCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecommendedTrackCollectionViewCell"
        
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private let trackDuration: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 5
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(trackDuration)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        albumCoverImageView.frame = CGRect(x: 5, y: 2, width: contentView.height - 4, height: contentView.height - 4)
        
        trackNameLabel.frame = CGRect(x: albumCoverImageView.right + 10, y: 0, width: contentView.width / 1.5, height: contentView.height / 1.7)
        
        artistNameLabel.frame = CGRect(x: albumCoverImageView.right + 10, y: trackNameLabel.bottom, width: contentView.width - albumCoverImageView.right - 15, height: contentView.height / 2)
        
        trackDuration.frame = CGRect(x: contentView.right - 50, y: trackNameLabel.bottom, width: contentView.width - albumCoverImageView.right - 15, height: contentView.height / 2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        albumCoverImageView.image = nil
        artistNameLabel.text = nil
    }
    
    func configure(with viewModel: RecommendedTrackViewModel) {
        trackNameLabel.text = viewModel.name
        albumCoverImageView.sd_setImage(with: viewModel.artWorkURL, completed: nil)
        artistNameLabel.text = viewModel.artistName
        let trackDurationInMinutes = viewModel.trackDuration.msToSeconds.minuteSecondMS
        trackDuration.text = String(trackDurationInMinutes)
    }
}
