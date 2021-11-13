//
//  CategoryViewController.swift
//  notifyApp
//
//  Created by Tofu-imac on 9/26/21.
//

import UIKit

class CategoryViewController: UIViewController {

    let category: Category
    private var playlists = [Playlist]()
    
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout:
            UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(250)), subitem: item,count: 2)
                group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

                return NSCollectionLayoutSection(group: group)
                                                        
                }))
    
    init(category: Category) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = category.name
        view.backgroundColor = .systemBackground
        setUpCollectionView()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    func setUpCollectionView() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func fetchData() {
        APICaller.shared.getCategoryPlaylists(category: category) { [weak self] results in
            DispatchQueue.main.async {
                switch results {
                case .success(let playlitst):
                    self?.playlists = playlitst
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(#function,error.localizedDescription)
                }
            }
            
        }
    }

}

extension CategoryViewController: UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = PlayListViewController(playList: playlists[indexPath.row])
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier, for: indexPath) as? FeaturedPlaylistCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let playlist = playlists[indexPath.row]
        cell.configure(with: FeaturedPlaylistCellViewModel(name: playlist.name, artworkURL: URL(string: playlist.images.first?.url ?? ""), creatorName: playlist.owner.display_name))
        
        return cell
    }
    
    
}
