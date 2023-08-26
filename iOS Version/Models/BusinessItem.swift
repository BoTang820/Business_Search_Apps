//
//  SearchData.swift
//  Business Search
//
//  Created by Bo Tang on 11/23/22.
//

import Foundation
import UIKit

struct BusinessItem: Codable, Identifiable {
    
    var imageURL: String?
    var name: String?
    var rating: String?
    var distance: String?
    
    var id: String
}


