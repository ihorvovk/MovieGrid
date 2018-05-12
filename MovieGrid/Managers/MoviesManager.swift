//
//  MoviesManager.swift
//  MovieGrid
//
//  Created by Ihor Vovk on 5/11/18.
//  Copyright © 2018 Ihor Vovk. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Sync
import CocoaLumberjackSwift

class MoviesManager {

    let moviesPageSize = 20
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func loadMovies(page: Int, deleteOld: Bool, success: ((_ isLast: Bool) -> Void)? = nil, failure: (() -> Void)? = nil) {
        guard page > 0 else {
            failure?()
            return
        }
        
        Alamofire.request("http://api.themoviedb.org/3/movie/now_playing?api_key=ebea8cfca72fdff8d2624ad7bbf78e4c&page=\(page)").validate().responseJSON { [weak self] response in
            guard let `self` = self else { return }
            
            switch response.result {
            case .success(let result):
                let json = JSON(result)
                if let movies = json["results"].arrayObject as? [[String: Any]] {
                    var moviesWithIndexes = movies
                    for index in 0 ..< movies.count  {
                        moviesWithIndexes[index]["index"] = index + (page - 1) * self.moviesPageSize
                    }
                    
                    let isLast = (page >= json["total_pages"].intValue)
                    
                    let operations: Sync.OperationOptions = deleteOld ? [.all] : [.insert, .update]
                    Sync.changes(moviesWithIndexes, inEntityNamed: "Movie", dataStack: self.dataManager.dataStack, operations: operations) { error in
                        if error == nil {
                            DDLogInfo("Successfully loaded and mapped movies")
                            success?(isLast)
                        } else {
                            if let error = error {
                                DDLogError("Failed to map movies - \(error)")
                            }
                            
                            failure?()
                        }
                    }
                } else {
                    DDLogError("Failed to load movies")
                    failure?()
                }
            case .failure(let error):
                DDLogError("Failed to load movies - \(error.localizedDescription)")
                failure?()
            }
        }
    }
    
    // MARK: - Implementation
    
    let dataManager: DataManager
}
