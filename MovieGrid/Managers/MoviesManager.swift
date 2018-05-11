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

    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func loadMovies(success: (() -> Void)? = nil, failure: (() -> Void)? = nil) {
        Alamofire.request("http://api.themoviedb.org/3/movie/now_playing?api_key=ebea8cfca72fdff8d2624ad7bbf78e4c").validate().responseJSON { [weak self] response in
            guard let `self` = self else { return }
            
            switch response.result {
            case .success(let result):
                let json = JSON(result)
                if let movies = json["results"].arrayObject as? [[String: Any]] {
                    Sync.changes(movies, inEntityNamed: "Movie", dataStack: self.dataManager.dataStack, operations: [.insert, .update]) { error in
                        if error == nil {
                            DDLogInfo("Successfully loaded and mapped movies")
                            success?()
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
                failure?()
            }
        }
    }
    
    // MARK: - Implementation
    
    let dataManager: DataManager
}
