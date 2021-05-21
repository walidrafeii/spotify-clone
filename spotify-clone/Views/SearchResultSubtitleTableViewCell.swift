//
//  SearchResultSubtitleTableViewCell.swift
//  spotify-clone
//
//  Created by Walid Rafei on 5/20/21.
//

import Foundation
import UIKit
import SDWebImage

class SearchResultSubtitleTableViewCell: UITableViewCell {
    static let identifier = "SearchResultSubtitleTableViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        return label
    }()
    
    private let subtitlelabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(iconImageView)
        contentView.addSubview(subtitlelabel)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = contentView.height - 10
        let labelHeight = contentView.height / 2
        iconImageView.frame = CGRect(x: 10, y: 5, width: imageSize, height:imageSize)
        label.frame = CGRect(x: iconImageView.right + 10, y: 0, width: contentView.width, height: labelHeight)
        subtitlelabel.frame = CGRect(x: iconImageView.right + 10, y: label.bottom, width: contentView.width, height: labelHeight)
        iconImageView.layer.cornerRadius = imageSize / 2
        iconImageView.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
        subtitlelabel.text = nil
    }
    
    func configure(with viewModel: SearchResultSubtitleTableViewCellViewModel) {
        label.text = viewModel.title
        subtitlelabel.text = viewModel.subtitle
        iconImageView.sd_setImage(with: viewModel.imageURL, completed: nil)
    }
}
