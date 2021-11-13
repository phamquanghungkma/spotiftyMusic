//
//  TitleHeaderReusableView.swift
//  notifyApp
//
//  Created by Tofu-imac on 8/26/21.
//

import UIKit

class TitleHeaderReusableView: UICollectionReusableView {
        static let cellIdentifer = "titleHeader"
    
    
    private let label: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGroupedBackground
        addSubview(label)
        self.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 15 , y: 0 , width: width - 30, height: height)
    }
    
    func configure(with title: String) {
        label.text = title
    }
}
