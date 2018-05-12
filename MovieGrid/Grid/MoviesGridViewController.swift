//
//  MoviesGridViewController.swift
//  MovieGrid
//
//  Created by Ihor Vovk on 5/11/18.
//  Copyright © 2018 Ihor Vovk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MoviesGridViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Latest Movies", comment: "")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20), NSAttributedStringKey.foregroundColor: UIColor.lightGray]
        navigationController?.navigationBar.tintColor = UIColor.lightGray
        navigationItem.backBarButtonItem = UIBarButtonItem(title: NSLocalizedString("back", comment: ""), style: .plain, target: nil, action: nil)
        
        collectionView.register(UINib(nibName: "MovieThumbnail", bundle: nil), forCellWithReuseIdentifier: "movieThumbnail")
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        viewModel.movieThumbnails.asObservable().subscribe(onNext: { [weak self] _ in
            self?.collectionView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.openMovieDetails.subscribe(onNext: { [weak self] movieID in
            self?.openMovieDetails(movieID: movieID)
        }).disposed(by: disposeBag)
        
        viewModel.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        if let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemWidth = (collectionView.bounds.size.width - collectionViewLayout.sectionInset.left - collectionViewLayout.sectionInset.right - collectionViewLayout.minimumInteritemSpacing) / 2
            let itemHeight = itemWidth * 1.5
            collectionViewLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Implementation
    
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    
    fileprivate let viewModel = MoviesGridViewModel()
    private let disposeBag = DisposeBag()
    
    func openMovieDetails(movieID: Int) {
        let movieDetailsViewController = MovieDetailsViewController(nibName: "MovieDetails", bundle: nil)
        movieDetailsViewController.setup(movieID: movieID)
        navigationController?.pushViewController(movieDetailsViewController, animated: true)
    }
    
    @objc private func refresh(_ sender: Any) {
        viewModel.refresh()
        collectionView.refreshControl?.endRefreshing()
    }
}

extension MoviesGridViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movieThumbnails.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movieThumbnail = viewModel.movieThumbnails.value[indexPath.item]
        
        let result = collectionView.dequeueReusableCell(withReuseIdentifier: "movieThumbnail", for: indexPath) as! MovieThumbnailCell
        result.fill(thumbnail: movieThumbnail)
        
        return result
    }
}

extension MoviesGridViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectMovie(index: indexPath.item)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let lastVisibleIndexPath = collectionView.indexPathsForVisibleItems.last {
            viewModel.didScroll(lastVisibleIndex: lastVisibleIndexPath.item)
        }
    }
}
