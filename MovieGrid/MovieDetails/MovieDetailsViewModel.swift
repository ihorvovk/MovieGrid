//
//  MovieDetailsViewModel.swift
//  MovieGrid
//
//  Created by Ihor Vovk on 5/12/18.
//  Copyright © 2018 Ihor Vovk. All rights reserved.
//

import Foundation
import CoreData

class MovieDetailsViewModel {
    
    var posterURL: URL?
    var score: String?
    var rating: String?
    var releaseDate: String?
    var title: String?
    var overview: String?
    
    init(managerProvider: ManagerProvider = ManagerProvider.sharedInstance) {
        dataManager = managerProvider.dataManager
    }
    
    func setup(movieID: Int) {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = \(movieID)")
        guard let fetchedMovie = try? dataManager.dataStack.mainContext.fetch(fetchRequest).first, let movie = fetchedMovie else {
            return
        }
        
        posterURL = movie.generatePosterURL(width: posterWidth)
        score = String(format: "%.1f", movie.score)
        rating = "R"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        releaseDate = dateFormatter.string(from: movie.releaseDate)
        
        title = movie.title
        overview = movie.overview
    }
    
    // MARK: - Implementation
    
    private let dataManager: DataManager
    
    private let posterWidth = 342
}
