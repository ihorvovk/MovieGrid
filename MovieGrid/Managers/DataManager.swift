//
//  DataManager.swift
//  MovieGrid
//
//  Created by Ihor Vovk on 5/11/18.
//  Copyright © 2018 Ihor Vovk. All rights reserved.
//

import Foundation
import Sync

class DataManager {
    
    private(set) var dataStack: DataStack
    
    init(modelName: String = "MovieGrid", storeType: DataStackStoreType = .sqLite) {
        dataStack = DataStack(modelName:modelName, storeType: storeType)
    }
}
