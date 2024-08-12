//
//  DetailPageDescriptionCell.swift
//  STYLiSH
//
//  Created by 小妍寶 on 2024/7/26.
//

import UIKit

class DetailPageStoryCell: UITableViewCell{
    
    let storyLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: "storyCell")
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        storyLabel.translatesAutoresizingMaskIntoConstraints = false
        storyLabel.textColor = .gray
        storyLabel.font = UIFont.systemFont(ofSize: 15)
        
        self.contentView.addSubview(storyLabel)
        
        NSLayoutConstraint.activate ([
            storyLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            storyLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            storyLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.85),
            storyLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15),
            storyLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15)
        ])
        storyLabel.numberOfLines = 0
    }
    
    func updateUI(product: ProductProtocol) {
        
        self.storyLabel.text = product.story
    }
}
