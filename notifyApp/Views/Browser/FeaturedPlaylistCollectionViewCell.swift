//
//  FeaturedPlaylistCollectionViewCell.swift
//  notifyApp
//
//  Created by Tofu-imac on 8/5/21.
//

import UIKit

class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FeaturedPlaylistCell"
    
    
    private let playlistCoverImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let playlistNameLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .center
//        label.textColor = .systemBackground
        label.textColor = .red

        return label
    }()
    
    
    private let creatorNameLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .thin)
        label.textAlignment = .center
        label.textColor = .systemGreen

        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(playlistCoverImageView)
        contentView.addSubview(creatorNameLabel)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        creatorNameLabel.frame = CGRect(
            x: 3,
            y: contentView.height - 30,
            width: contentView.width - 6,
            height: 30
        )
        
        playlistNameLabel.frame = CGRect(
            x: 3,
            y: contentView.height - 60,
            width: contentView.width - 6,
            height: 30
        )
        
        let imageSize = contentView.height - 70
        playlistCoverImageView.frame = CGRect(
            x: (contentView.width - imageSize)/2 ,
            y: 3,
            width: imageSize,
            height: imageSize
        
        )
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistNameLabel.text = nil
        creatorNameLabel.text = nil
        playlistCoverImageView.image = nil
    }
    
    func configure(with viewModel: FeaturedPlaylistCellViewModel) {
        playlistNameLabel.text = viewModel.name
        creatorNameLabel.text = viewModel.creatorName
        playlistCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
    
    
}
