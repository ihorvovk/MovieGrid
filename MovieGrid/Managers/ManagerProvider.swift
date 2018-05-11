//
//  ManagerProvider.swift
//  MovieGrid
//
//  Created by Ihor Vovk on 5/11/18.
//  Copyright © 2018 Ihor Vovk. All rights reserved.
//

import Foundation

class ManagerProvider {
    
    static let sharedInstance = ManagerProvider()
    
    init() {
        dataManager = DataManager()
        moviesManager = MoviesManager(dataManager: dataManager)
    }
    
    let dataManager: DataManager
    let moviesManager: MoviesManager
}
