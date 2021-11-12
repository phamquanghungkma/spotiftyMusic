//
//  NewReleaseCollectionViewCell.swift
//  notifyApp
//
//  Created by Tofu-imac on 8/5/21.
//

import UIKit
import SDWebImage

class NewReleaseCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "NewReleaseCell"
    
    
    private let albumCoverImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        
        return label
    }()
    
    private let numberOfTrackLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .thin)
        
        return label
    }()
    
    private let artistNameLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .light)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 8
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(numberOfTrackLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        let imageSize: CGFloat  = contentView.height - 10
        let imageSize: CGFloat  = contentView.height - 10

        let albumLabelSize = albumNameLabel.sizeThatFits(CGSize(width: contentView.width - imageSize - 10, height: contentView.height - 10))
        
        albumNameLabel.sizeToFit()
        artistNameLabel.sizeToFit()
        numberOfTrackLabel.sizeToFit()
        
        albumCoverImageView.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)
        
        let albumLabelHeight = min(60, albumLabelSize.height)
        
        albumNameLabel.frame = CGRect(x: albumCoverImageView.right + 10, y: 5, width: albumLabelSize.width, height: albumLabelHeight)
        
        artistNameLabel.frame = CGRect(x: albumCoverImageView.right + 10, y: albumNameLabel.bottom, width: contentView.width - albumCoverImageView.right - 10, height: 30)
        
        numberOfTrackLabel.frame = CGRect(x: albumCoverImageView.right + 10, y: contentView.bottom - 44, width:  numberOfTrackLabel.width, height: 44)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTrackLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    func configure(with viewModel: NewReleasesCellViewModel) {
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        numberOfTrackLabel.text = "Tracks: \(viewModel.numberOfTracks)"
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
    
    
}
