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
    var loading = Variable<Bool>(false)
    var openMovieDetails: Observable<Int> { return openMovieDetailsSubject }
    
    init(managerProvider: ManagerProvider = ManagerProvider.sharedInstance) {
        moviesManager = managerProvider.moviesManager
        dataManager = managerProvider.dataManager
    }
    
    func viewDidLoad() {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
        
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataManager.dataStack.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultsController.delegate = self
        
        try? fetchResultsController.performFetch()
        updateMovies()
        
        refresh()
    }
    
    func refresh() {
        loading.value = true
        
        moviesManager.loadMovies(page: 1, deleteOld: true, success: { [weak self] isLast in
            self?.lastLoadedPage = 1
            self?.allPagesLoaded = isLast
            self?.loading.value = false
            }, failure: { [weak self] in
                self?.loading.value = false
        })
    }
    
    func didSelectMovie(index: Int) {
        let movieID = movieThumbnails.value[index].movieID
        openMovieDetailsSubject.onNext(movieID)
    }
    
    func didScroll(lastVisibleIndex: Int) {
        if !loading.value && !allPagesLoaded, let lastLoadedPage = lastLoadedPage, lastVisibleIndex > moviesManager.moviesPageSize * lastLoadedPage - 5 {
            let page = lastLoadedPage + 1
            loading.value = true
            
            try? fetchResultsController.performFetch()
            moviesManager.loadMovies(page: page, deleteOld: false, success: { [weak self] isLast in
                self?.lastLoadedPage = page
                self?.allPagesLoaded = isLast
                self?.loading.value = false
            }, failure: { [weak self] in
                self?.loading.value = false
            })
        }
    }
    
    // MARK: - Implementation
    
    private let moviesManager: MoviesManager
    private let dataManager: DataManager
    
    private var openMovieDetailsSubject = PublishSubject<Int>()
    private var fetchResultsController: NSFetchedResultsController<Movie>!
    private var lastLoadedPage: Int? = nil
    private var allPagesLoaded = false
    
    private let posterWidth = 342
    
    private func updateMovies() {
        guard let movies = fetchResultsController.fetchedObjects else { return }
        
        var movieThumbnails: [MovieThumbnail] = []
        for movie in movies {
            if let posterURL = movie.generatePosterURL(width: posterWidth) {
                let movieThumbnail = MovieThumbnail(movieID: Int(movie.id), posterURL: posterURL)
                movieThumbnails.append(movieThumbnail)
            }
        }
        
        self.movieThumbnails.value = movieThumbnails
    }
}

extension MoviesGridViewModel: NSFetchedResultsControllerDelegate {
    
    // TODO: Implement all the delegate methods with more fine-grained refresh of the grid
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateMovies()
    }
}
