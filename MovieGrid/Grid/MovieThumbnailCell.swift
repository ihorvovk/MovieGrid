//
//  MovieThumbnailCell.swift
//  MovieGrid
//
//  Created by Ihor Vovk on 5/12/18.
//  Copyright © 2018 Ihor Vovk. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieThumbnailCell: UICollectionViewCell {
    
    override func prepareForReuse() {
        activityIndicator.stopAnimating()
        posterImageView.af_cancelImageRequest()
    }
    
    func fill(thumbnail: MovieThumbnail) {
        activityIndicator.startAnimating()
        posterImageView.af_setImage(withURL: thumbnail.posterURL) { [weak self] _ in
            self?.activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Implementation
    
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
}
