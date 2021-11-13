//
//  HomeViewController.swift
//  notifyApp
//
//  Created by Tofu-imac on 3/6/21.
//

import UIKit

enum BrowsectionType {
    
    case newReleases(viewModels: [NewReleasesCellViewModel]) // 1
    case featuredPlaylists(viewModels: [FeaturedPlaylistCellViewModel]) // 2
    case recommendTracks(viewModels: [RecommendTrackCellViewModel]) // 3
    
    var title: String {
        switch self {
        case .newReleases:
            return "New Released Album"
        case .featuredPlaylists:
            return "Featured Playlist"
        case .recommendTracks:
            return "Recommended"
        
    }
    
    }
}

class HomeViewController: UIViewController {
    
    private var newAlbums: [Album] = []
    private var playlist: [Playlist] = []
    private var tracks: [AudioTrack] = []
    
    
    private var collectionView: UICollectionView  = UICollectionView (
    
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            print("indexSection:", sectionIndex)
            return HomeViewController.creatSectionLayout(section: sectionIndex)
            
        }
    )
    
    private let spinner: UIActivityIndicatorView = {
       let spinner = UIActivityIndicatorView()
        spinner.tintColor = .red
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private var sections = [BrowsectionType]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSetting))
        
        
        configuCollectionView()
        view.addSubview(spinner)
        
        fetchData()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
    
    private func configuCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(NewReleaseCollectionViewCell.self, forCellWithReuseIdentifier: NewReleaseCollectionViewCell.identifier)
        
        collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        
        collectionView.register(RecommendedTracksCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTracksCollectionViewCell.identifier)
   
        // register title header
        collectionView.register(TitleHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderReusableView.cellIdentifer)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
    }

    func fetchData() {
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        var newReleases: NewReleasesResponse?
        var featuredPlaylist: FeaturedPlaylistsReponse?
        var recommendations: RecommendationsResponse?
        
        //New Releases
        APICaller.shared.getNewRelease { result in
            // xong việc sẽ rời khỏi DispatchGroup
            defer {
                group.leave()
            }
            
            switch result {
            case .success(let model):
                newReleases = model
              
            case .failure(let error):
                print(error.localizedDescription)
            
            
            }
        }
        
        //Featured Playlist,
        APICaller.shared.getFeaturedPlaylists { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                featuredPlaylist =  model
                break
            case .failure(let error):
                print(error.localizedDescription)
            
            }
        }
        
        //Recommend Tracks,
        APICaller.shared.getRecommendedGenres { result in
            
            switch result {
            case .success(let model):
                let genres  = model.genres
                var seeds = Set<String>()
                while  seeds.count < 5 {
                    if let random = genres.randomElement() {
                        seeds.insert(random)
                    }
                }
                APICaller.shared.getRecommendations(genres: seeds) { recommendedResults in
                    
                defer {
                        group.leave()
                    }
                    switch recommendedResults {
                        case .success(let model):
                            recommendations = model
                        case .failure(let error):
                            print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
        // Sau khi hoàn thành tất cả các task thì Group sẽ báo 1 notify về main queue
        group.notify(queue: .main) {
            guard let newAlbums = newReleases?.albums.items,
                  let playlists = featuredPlaylist?.playlists.items,
                  let tracks = recommendations?.tracks else {
//                fatalError("Models are nil")
                    return
            }
            
            self.configureModels(newAlbums: newAlbums, playlists: playlists, tracks: tracks)
        }
        
    }
    

    
    
    private func configureModels(newAlbums: [Album], playlists: [Playlist], tracks: [AudioTrack]) {
        
        self.newAlbums = newAlbums
        self.playlist = playlists
        self.tracks = tracks
        
            // configure Models
        sections.append(.newReleases(viewModels: newAlbums.compactMap({
            return NewReleasesCellViewModel(name: $0.name, artworkURL: URL(string: $0.images.first?.url ?? ""), numberOfTracks: $0.total_tracks, artistName: $0.artists.first?.name ?? "")
        })))
        sections.append(.featuredPlaylists(viewModels: playlists.compactMap({
            return FeaturedPlaylistCellViewModel(name: $0.name, artworkURL: URL(string: $0.images.first?.url ?? ""), creatorName: $0.owner.display_name)
        })))
        sections.append(.recommendTracks(viewModels: tracks.compactMap({
            return RecommendTrackCellViewModel(name: $0.name, artistName: $0.artists.first?.name ?? "-", artworkURL: URL(string: $0.album?.images.first?.url ?? ""))
        })))
        collectionView.reloadData()
        
        //thêm các section cũng phải theo thứ tự newRelease, featuredPlaylist, recommendTracks
    }
    @objc func didTapSetting() {
    
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

    

}

extension HomeViewController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard  let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleHeaderReusableView.cellIdentifer, for: indexPath) as? TitleHeaderReusableView, kind == UICollectionView.elementKindSectionHeader  else {
            return UICollectionReusableView()
        }
        let section = indexPath.section
        let title = sections[section].title
         
        header.configure(with: title)
     
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
        case .newReleases(let viewModels):
            return viewModels.count
        case .featuredPlaylists(let viewModels):
            return viewModels.count
        case .recommendTracks(let viewModels):
            return viewModels.count

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let type = sections[indexPath.section]
        
        switch type {
        case .newReleases(viewModels: let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleaseCollectionViewCell.identifier, for: indexPath) as? NewReleaseCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewmodel = viewModels[indexPath.row]
            cell.configure(with: viewmodel)
            return cell
        case .featuredPlaylists(viewModels: let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier, for: indexPath) as? FeaturedPlaylistCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewmodel = viewModels[indexPath.row]
            cell.configure(with: viewmodel)
            
            return cell
        case .recommendTracks(viewModels: let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTracksCollectionViewCell.identifier, for: indexPath) as? RecommendedTracksCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewmodel = viewModels[indexPath.row]
            cell.configure(with: viewmodel)
            return cell
        
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
     static func creatSectionLayout(section: Int) -> NSCollectionLayoutSection {
        
        let supplementaryViews = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        
        
        switch section {
        case 0:
            // Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension:.fractionalWidth(1), heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2 , trailing: 2)
            
            //Vertical Group in Horizontal group\
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1)), subitem: item ,count: 3)// 3 ptu 1 cột
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .fractionalHeight(0.4)), subitem: verticalGroup ,count: 1)
            
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems  = supplementaryViews
            return section
        case 1:
            // Item
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension:.absolute(200), heightDimension: .absolute(200)))
            
            //contentInsets sẽ làm việc theo cách sau: Đầu tiên nó sẽ tính vị trí và size cho từng element sau đó sẽ điều chỉnh lại size cho mỗi item
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            //Vertical Group in Horizontal group\
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(400)), subitem: item ,count: 2)
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(400)), subitem: verticalGroup ,count: 1)
            
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems  = supplementaryViews
            return section
        case 2:
            // Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                                                widthDimension:.fractionalWidth(1.0),
                                                heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            //Vertical Group in Horizontal group\
            let Group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80)), subitem: item ,count: 1)
            // Section
            let section = NSCollectionLayoutSection(group: Group)
            section.boundarySupplementaryItems  = supplementaryViews
            return section
            
        default :
            // Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension:.fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390)), subitem: item ,count: 1)
        
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems  = supplementaryViews

            return section
        
        }
        
      
    }
    
    
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let typeSection = sections[indexPath.section]
      
        switch typeSection {
        case .featuredPlaylists:
            let playlist = playlist[indexPath.row]
            let vc = PlayListViewController(playList: playlist)
            vc.title = playlist.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)

        case .newReleases:
            let album = self.newAlbums[indexPath.row]
            let vc =  AlbumViewController(album: album)
            vc.title = album.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            
        case .recommendTracks:
            
            
            break;
        }
        
        
    }
    
}
