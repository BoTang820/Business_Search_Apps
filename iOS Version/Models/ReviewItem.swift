//
//  ReviewsData.swift
//  Business Search
//
//  Created by Bo Tang on 11/23/22.
//

import Foundation
struct ReviewItem: Codable, Identifiable {
    
    var user: String
    var rating: String
    var text: String
    var date: String
    
    var id = UUID()
}


