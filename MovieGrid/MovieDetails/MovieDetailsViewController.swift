//
//  MovieDetailsViewController.swift
//  MovieGrid
//
//  Created by Ihor Vovk on 5/12/18.
//  Copyright © 2018 Ihor Vovk. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    func setup(movieID: Int) {
        viewModel.setup(movieID: movieID)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = viewModel.title
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20), NSAttributedStringKey.foregroundColor: UIColor.lightGray]
        navigationController?.navigationBar.tintColor = UIColor.lightGray
        
        if let posterURL = viewModel.posterURL {
            posterActivityIndicator.startAnimating()
            
            backgroundImageView.af_setImage(withURL: posterURL)
            posterImageView.af_setImage(withURL: posterURL) { [weak self] _ in
                self?.posterActivityIndicator.stopAnimating()
            }
        }
        
        scoreLabel.text = viewModel.score
        ratingLabel.text = viewModel.rating
        releaseDateLabel.text = viewModel.releaseDate
        titleLabel.text = viewModel.title
        overviewLabel.text = viewModel.overview
    }
    
    // MARK: - Implementation
    
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var posterActivityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!
    
    var viewModel = MovieDetailsViewModel()
}
