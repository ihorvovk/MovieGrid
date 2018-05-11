//
//  Movie+CoreDataProperties.swift
//  MovieGrid
//
//  Created by Ihor Vovk on 5/11/18.
//  Copyright © 2018 Ihor Vovk. All rights reserved.
//
//

import Foundation
import CoreData

extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var posterPath: String
    @NSManaged public var releaseDate: TimeInterval
    @NSManaged public var title: String
    @NSManaged public var overview: String
    @NSManaged public var score: Double
    @NSManaged public var id: Int64
}
