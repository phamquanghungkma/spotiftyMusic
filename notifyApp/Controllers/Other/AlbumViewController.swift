//
//  AlbumViewController.swift
//  notifyApp
//
//  Created by Tofu-imac on 8/23/21.
//

import UIKit

class AlbumViewController: UIViewController {
    
    private var viewModels = [RecommendTrackCellViewModel]()

    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(
        sectionProvider: { _, _  -> NSCollectionLayoutSection? in
            // Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                                                widthDimension:.fractionalWidth(1.0),
                                                heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            //Vertical Group in Horizontal group\
            let Group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80)), subitem: item ,count: 1)
            // Section
            let section = NSCollectionLayoutSection(group: Group)
            section.boundarySupplementaryItems = [
                NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)),
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
            ]
            return section

        }
    ))
    
    private let album: Album
    
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        collectionView.frame = view.bounds
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = album.name
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        setUpCollectionView()
        
        APICaller.shared.getAlbumDetails(for: album) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.viewModels = model.tracks.items.compactMap({
                        RecommendTrackCellViewModel(
                            name:$0.name,
                            artistName: $0.artists.first?.name ?? "-",
                            artworkURL: URL(string: $0.album?.images.first?.url ?? ""))
                    })
                    self?.collectionView.reloadData()
           
                case .failure(let error):
                    print(error.localizedDescription)
                    break;
                }
            }
        }
        
    
    }
    
    func setUpCollectionView() {
        collectionView.register(PlaylistHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: PlaylistHeaderCollectionReusableView.cellIdentifer)
        collectionView.register(AlbumTracksCollectionViewCell.self, forCellWithReuseIdentifier: AlbumTracksCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.frame = view.bounds

    }

}




extension AlbumViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // Play Song
        
        
    }
}

extension AlbumViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumTracksCollectionViewCell.identifier, for: indexPath) as? AlbumTracksCollectionViewCell {
            
            let viewmodel = self.viewModels[indexPath.row]
            
            cell.configure(with: viewmodel)
            
            return cell
        }
        
        
        return UICollectionViewCell()
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlaylistHeaderCollectionReusableView.cellIdentifer, for: indexPath)  as? PlaylistHeaderCollectionReusableView ,
              kind == UICollectionView.elementKindSectionHeader
        else {
            return UICollectionReusableView()
        }
        let headerViewModel = PlaylistHeaderViewModel(
            name: album.name,
            ownerName: album.artists.first?.name,
            description: "Release Date: \(String.formattedDate(string: album.release_date))",
            artworkURL: URL(string: album.images.first?.url ?? ""))

        header.configure(with: headerViewModel)
        header.delegate = self
        
        return header
    }

}

extension AlbumViewController: PlaylistHeaderCollectionReusableViewDelegate {
 
    func playlistHeaderColelctionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        
        print("Playing all")
    }
    
    
}