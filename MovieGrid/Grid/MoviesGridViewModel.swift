//
//  MoviesGridViewModel.swift
//  MovieGrid
//
//  Created by Ihor Vovk on 5/11/18.
//  Copyright © 2018 Ihor Vovk. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

class MoviesGridViewModel: NSObject {
    
    var movieThumbnails = Variable<[MovieThumbnail]>([])
    
    init(managerProvider: ManagerProvider = ManagerProvider.sharedInstance) {
        moviesManager = managerProvider.moviesManager
        dataManager = managerProvider.dataManager
    }
    
    func viewDidLoad() {
        fetchResultsController = NSFetchedResultsController(fetchRequest: Movie.fetchRequest(), managedObjectContext: dataManager.dataStack.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultsController.delegate = self
        
        try? fetchResultsController.performFetch()
        updateMovies()
        
        moviesManager.loadMovies()
    }
    
    // MARK: - Implementation
    
    private let moviesManager: MoviesManager
    private let dataManager: DataManager
    
    private var fetchResultsController: NSFetchedResultsController<Movie>!
    
    private func updateMovies() {
        guard let movies = fetchResultsController.fetchedObjects else { return }
        
        var movieThumbnails: [MovieThumbnail] = []
        for movie in movies {
            if let posterURL = movie.generatePosterURL(width: 32) {
                let movieThumbnail = MovieThumbnail(movieID: Int(movie.id), posterURL: posterURL)
                movieThumbnails.append(movieThumbnail)
            }
        }
        
        self.movieThumbnails.value = movieThumbnails
    }
}

extension MoviesGridViewModel: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateMovies()
    }
}
