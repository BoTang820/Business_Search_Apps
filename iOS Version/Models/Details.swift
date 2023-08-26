//
//  DetailsData.swift
//  Business Search
//
//  Created by Bo Tang on 11/23/22.
//

import Foundation

struct Details: Codable, Identifiable {
    var name: String = ""
    var address: String?
    var category: String?
    var phone: String?
    var priceRange: String?
    var status: String?
    var url: String = ""
    var imageUrls: [String]?
    var latitude = ""
    var longitude = ""
    var loaded = false
    
    var id = ""
}
