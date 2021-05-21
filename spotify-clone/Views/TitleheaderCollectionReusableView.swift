//
//  TitleheaderCollectionReusableView.swift
//  spotify-clone
//
//  Created by Walid Rafei on 5/19/21.
//

import UIKit

class TitleheaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "TitleheaderCollectionReusableView"
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 15, y: 0, width: width - 30, height: height)
    }
    
    func configure(with title: String) {
        label.text = title
    }
}
