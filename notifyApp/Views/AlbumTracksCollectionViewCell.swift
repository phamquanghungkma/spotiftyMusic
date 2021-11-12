//
//  AlbumTracksCollectionViewCell.swift
//  notifyApp
//
//  Created by Tofu-imac on 8/28/21.
//

import UIKit

class AlbumTracksCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AlbumTracksCell"
    
    private let trackNameLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .center
//        label.textColor = .systemBackground
        return label
    }()
    
    
    private let artistNameLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .thin)
        label.textAlignment = .center
//        label.textColor = .systemBackground
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .secondarySystemBackground
        backgroundColor = .secondarySystemBackground
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        trackNameLabel.frame = CGRect(
            x: 10,
            y: 0,
            width: contentView.width -  15,
            height: contentView.height  / 2)
        
        artistNameLabel.frame = CGRect(
            x: 10,
            y: contentView.height / 2,
            width: contentView.width  - 15 ,
            height: contentView.height / 2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        artistNameLabel.text = nil
    }
    
    func configure(with viewModel: RecommendTrackCellViewModel) {
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
    }
    
    
    
}

