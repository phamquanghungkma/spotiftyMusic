//
//  SearchViewController.swift
//  notifyApp
//
//  Created by Tofu-imac on 3/6/21.
//

import UIKit

class SearchViewController: UIViewController {
   
    let searchController: UISearchController = {
  
        let vc = UISearchController(searchResultsController: SearchResultsViewController())
        vc.searchBar.placeholder = "Songs, Artirsts, Albums"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    
    private var categories = [Category]()
    
    private let collectionView: UICollectionView = UICollectionView (
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _,_  -> NSCollectionLayoutSection? in
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 7, bottom: 5 , trailing: 7)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(130)), subitem: item,count: 2)
            
            
            return NSCollectionLayoutSection(group: group)
        })
    )
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifer)
        view.addSubview(collectionView)
        
        
        APICaller.shared.getCategories { [weak self] results in
            DispatchQueue.main.async {
                switch results {
                case .success(let categories):
                    self?.categories = categories
                    self?.collectionView.reloadData()
                    break;
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    
  
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController,
            let query = searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        resultsController.delegate = self
        
        APICaller.shared.search(with: query) { results in
            DispatchQueue.main.async {
                switch results {
                case .success(let result):
                    resultsController.update(with: result)
                    break
                case .failure(let error):
                    print(#function, error.localizedDescription)
                }
            }
        }

    }
}

extension SearchViewController: SearchResultsViewControllerDelegate {
    func didTapResult(_ result: SearchResult) {
        switch result {
        case .artist(let model):
            break;
        case .album(let model):
            let vc = AlbumViewController(album: model)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .track(let model):
            break;
        case .playlist(let model):
            let vc = PlayListViewController(playList: model)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
    
    
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
    }
    
}
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifer, for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        let category = categories[indexPath.row]
        
        cell.configure(with: CategoryCellViewModel(title: category.name, artworkURL: URL(string: category.icons.first?.url ?? "")))
        return cell
        
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let category = categories[indexPath.row]
        let vc = CategoryViewController(category: category)
        
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
}


