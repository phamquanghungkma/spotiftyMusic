//
//  PlayListViewController.swift
//  notifyApp
//
//  Created by Tofu-imac on 3/6/21.
//

import UIKit

class PlayListViewController: UIViewController {
    

    private let playList: Playlist

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
    
    
    private var viewModels = [RecommendTrackCellViewModel]()
    
    
    init(playList: Playlist) {
        self.playList = playList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = playList.name
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        setUpCollectionView()
        
        APICaller.shared.getPlaylistDetails(for: playList) { [weak self] results in
            DispatchQueue.main.async {
                switch results {
                case .success(let model):
                    // RecommendedTrackCellViewModel
                    self?.viewModels = model.tracks.items.compactMap({
                        RecommendTrackCellViewModel(name:$0.track.name,
                                                    artistName: $0.track.artists.first?.name ?? "_",
                                                    artworkURL: URL(string: $0.track.album?.images.first?.url ?? ""))
                    })
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                 
                }
                
            
            }
            
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
    }
    
    @objc private func didTapShare() {
        print(playList.external_urls)
        
        guard let url = URL(string: playList.external_urls["spotify"] ?? "") else {
            return
        }
        
        
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
        
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true, completion: nil)
        
    }
    
    func setUpCollectionView() {
        collectionView.register(PlaylistHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: PlaylistHeaderCollectionReusableView.cellIdentifer)
        collectionView.register(RecommendedTracksCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTracksCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
    }

}

extension PlayListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTracksCollectionViewCell.identifier, for: indexPath) as? RecommendedTracksCollectionViewCell {
//
//            print("DataCell1","Called")
//            let viewmodel = self.viewModels[indexPath.row]
//            print("DataCell", viewmodel.name)
//
//            cell.configure(with: viewmodel)
//
//            return cell
//        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTracksCollectionViewCell.identifier, for: indexPath) as? RecommendedTracksCollectionViewCell else {
            print("loi")
            return UICollectionViewCell()
        }
        
        cell.configure(with: self.viewModels[indexPath.row])
        
        return cell
        
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
        let headerViewModel = PlaylistHeaderViewModel(name: playList.name, ownerName: playList.owner.display_name, description: playList.description, artworkURL: URL(string: playList.images.first?.url ?? ""))
        
        header.configure(with: headerViewModel)
        header.delegate = self
        
        return header
    }
    
}

extension PlayListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // Play Song
        
        
    }
}

extension PlayListViewController: PlaylistHeaderCollectionReusableViewDelegate {
 
    func playlistHeaderColelctionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        
        print("Playing all")
    }
    
    
}
