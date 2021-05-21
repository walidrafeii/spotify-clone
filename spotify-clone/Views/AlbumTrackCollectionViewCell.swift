//
//  AlbumTrackCollectionViewCell.swift
//  spotify-clone
//
//  Created by Walid Rafei on 5/20/21.
//

import UIKit

class AlbumTrackCollectionViewCell: UICollectionViewCell {
    static let identifier = "AlbumTrackCollectionViewCell"
        
    private let albumTrackNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.textAlignment = .center
        return label
    }()
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.7
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(albumTrackNumberLabel)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        albumTrackNumberLabel.frame = CGRect(x: 5, y: (contentView.height - 50) / 2, width: 50, height: 50)
        
        trackNameLabel.frame = CGRect(x: albumTrackNumberLabel.right, y: (contentView.height - 40) / 2, width: contentView.width - 100, height: 20)
        
        artistNameLabel.frame = CGRect(x: albumTrackNumberLabel.right, y: trackNameLabel.bottom, width: contentView.width - albumTrackNumberLabel.right - 15, height: 20)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        albumTrackNumberLabel.text = nil
        artistNameLabel.text = nil
        trackNameLabel.textColor = .label
    }
    
    func configure(with viewModel: AlbumCollectionViewCellViewModel) {
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
    }
    
    func setAlbumTrackNumberLabel(to value: Int) {
        albumTrackNumberLabel.text = String(value)
    }
    
    func toggleTrackNameColor() {
        if trackNameLabel.textColor == .systemGreen {
            trackNameLabel.textColor = .label
        } else {
            trackNameLabel.textColor = .systemGreen
        }
    }
}
