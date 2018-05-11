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
        
        collectionView.register(UINib(nibName: "MovieThumbnail", bundle: nil), forCellWithReuseIdentifier: "movieThumbnail")
        
        viewModel.movieThumbnails.asObservable().subscribe(onNext: { [weak self] _ in
            self?.collectionView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.viewDidLoad()
    }
    
    // MARK: - Implementation
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    fileprivate let viewModel = MoviesGridViewModel()
    private let disposeBag = DisposeBag()
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
}
