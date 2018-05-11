//
//  Movie+CoreDataClass.swift
//  MovieGrid
//
//  Created by Ihor Vovk on 5/11/18.
//  Copyright © 2018 Ihor Vovk. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Movie)
public class Movie: NSManagedObject {
    
    func generatePosterURL(width: Int) -> URL? {
        return URL(string: "http://image.tmdb.org/t/p/w\(width)" + posterPath)
    }
}
