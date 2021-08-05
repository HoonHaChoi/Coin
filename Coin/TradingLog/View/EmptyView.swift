//
//  EmptyView.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/05.
//

import UIKit

class EmptyView: UIView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "등록한 일지가 없습니다..!"
        return label
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "market")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    func configure() {
        addSubview(titleLabel)
        addSubview(imageView)
        
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor,constant: 10).isActive = true
        
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50).isActive = true
    }
}
