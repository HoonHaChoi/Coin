//
//  EmptyView.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/05.
//

import UIKit

class EmptyView: UIView {

    let titleString: String
    let descriptionString: String
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .basicColor
        label.text = titleString
        return label
    }()
    
    lazy var descriptionLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .middleGrayColor
        label.text = descriptionString
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    init(frame: CGRect, title: String, description: String) {
        self.titleString = title
        self.descriptionString = description
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        self.titleString = ""
        self.descriptionString = ""
        super.init(coder: coder)
        configure()
    }

    func configure() {
        addSubview(titleLabel)
        addSubview(descriptionLable)
        
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -40).isActive = true
        
        descriptionLable.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        descriptionLable.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

    }
}
