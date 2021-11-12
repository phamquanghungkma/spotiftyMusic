//
//  GenreCollectionViewCell.swift
//  notifyApp
//
//  Created by Tofu-imac on 9/10/21.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifer = "GenreCollectionViewCell"
    
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "music.quarternote.3", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
        return imageView
    }()
    
    private let label: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight:.semibold)
        return label
    }()
    
    
    private let colors: [UIColor] = [
        .systemPink,
        .systemRed,
        .systemBlue,
        .systemTeal,
        .systemPurple,
        .systemGray,
        .systemFill,
        .systemGreen,
        .systemTeal,
        .systemYellow,
        .systemIndigo
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 8
        contentView.addSubview(label)
        contentView.addSubview(imageView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(x:10, y:contentView.height/2, width: contentView.width - 20, height: contentView.height / 2)
        imageView.frame = CGRect(x: contentView.width/2 , y: 10, width: contentView.width/2, height: contentView.height/2)
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        imageView.image = UIImage(systemName: "music.quarternote.3", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
    }
    
    func configure(with viewModel: CategoryCellViewModel) {
        label.text = viewModel.title
        imageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        contentView.backgroundColor = colors.randomElement()
        
    }
}
