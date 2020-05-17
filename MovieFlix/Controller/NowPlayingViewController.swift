//
//  NowPlayingViewController.swift
//  MovieFlix
//
//  Created by Vijay Masal on 17/05/20.
//  Copyright © 2020 Vijay Masal. All rights reserved.
//

import UIKit
class NowPlayingViewController: UIViewController,Loadable{
    var collectionView: UICollectionView! = nil
    var movies = [Movie]()
    var searchMovies = [MovieCellViewModel]()
    let searchController = UISearchController(searchResultsController: nil)
    var isSearching : Bool = false
    let viewModel: MovieViewModel = MovieViewModel()
    private let refreshControl = UIRefreshControl()
    var acttivityIndicator : UIActivityIndicatorView! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        searchController.searchResultsUpdater = self
        self.definesPresentationContext = true
        self.navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.delegate = self
        configureHierarchy()
        bindViewModel()
        viewModel.getFactsData(isPlaying: true)
    }
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayoutDiffSection())
        collectionView.backgroundColor = UIColor(red: (240/255.0), green: (179/255.0), blue: (68/255.0), alpha: 1.0)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshMoviewData), for: .valueChanged)
        refreshControl.tintColor = UIColor.red
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.gray,]
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: attributes)
        showLoadingView()
    }
    @objc private func refreshMoviewData(_ sender: Any) {
        bindViewModel()
        viewModel.getFactsData(isPlaying: true)
        collectionView.reloadData()
        self.refreshControl.endRefreshing()
    }
    func bindViewModel() {
        viewModel.rowsCells.bindAndFire() { [weak self] _ in
            if((self?.viewModel.rowsCells.value.count)! > 0){
                self?.hideLoadingView()
            }
            self?.collectionView.reloadData()
        }
    }
}
extension NowPlayingViewController {
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item, count: 2)
        group.interItemSpacing = .fixed(CGFloat(2))
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView.reloadData()
    }
    func createLayoutDiffSection() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let columns = 1
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 2, bottom: 1, trailing: 2)
            let groupHeight =
                NSCollectionLayoutDimension.absolute(160)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 2, bottom: 1, trailing: 2)
            return section
        }
        return layout
    }
}
// MARK: - UICollectionViewDataSource method
extension NowPlayingViewController : UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (isSearching == true) {
            return searchMovies.count
        }
        else{
            return viewModel.rowsCells.value.count
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieCell
        var movie : MovieCellViewModel
        if (isSearching == true) {
            cell.isSearching = true
            movie = searchMovies[indexPath.row]
        }else{
            cell.isSearching = false
            movie = viewModel.rowsCells.value[indexPath.row]
        }
        cell.viewModel = movie
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteAction(sender:)), for: .touchUpInside)
        return cell
    }
    @objc func deleteAction(sender: UIButton) {
        collectionView?.performBatchUpdates({
            if(isSearching == false){
                if(sender.tag < viewModel.rowsCells.value.count){
                    self.collectionView?.deleteItems(at: [(NSIndexPath(row: sender.tag, section: 0) as IndexPath)])
                    viewModel.rowsCells.value.remove(at: sender.tag)
                    if viewModel.rowsCells.value.count > 0 {
                        self.collectionView?.reloadItems(at: [(NSIndexPath(row: sender.tag + 1, section: 0) as IndexPath) ])
                    }
                }
            }
            else{
                if(sender.tag < searchMovies.count){
                    self.collectionView?.deleteItems(at: [(NSIndexPath(row: sender.tag, section: 0) as IndexPath)])
                    searchMovies.remove(at: sender.tag)
                    if searchMovies.count > 0 {
                        self.collectionView?.reloadItems(at: [(NSIndexPath(row: sender.tag + 1, section: 0) as IndexPath) ])
                    }
                }
            }
        }, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailView = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        if (isSearching == true) {
            detailView.movie = searchMovies[indexPath.row]
            isSearching = false
        }else{
            detailView.movie = viewModel.rowsCells.value[indexPath.row]
        }
        self.navigationController?.pushViewController(detailView, animated: true)
    }
}
// MARK: - UISearchResults method
extension NowPlayingViewController : UISearchResultsUpdating,UISearchBarDelegate{
    func filterContent(for searchText: String) {
        searchMovies = viewModel.rowsCells.value.filter({ (movie : MovieCellViewModel) -> Bool in
            let match = movie.titles.range(of: searchText, options: .caseInsensitive)
            return match != nil
        })
    }
    // MARK: - UISearchResultsUpdating method
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    // MARK: - UISearchBarDelegate method
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchController.searchBar.text {
            if(searchText == ""){
                isSearching = false
            }else{
                isSearching = true
            }
            filterContent(for: searchText)
            self.collectionView.reloadData()
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        collectionView.reloadData()
    }
}
