//
//  ReservationsData.swift
//  Business Search
//
//  Created by Bo Tang on 11/23/22.
//

import Foundation
struct ReservationItem: Codable, Identifiable, Equatable {
    var name: String
    var date: String
    var time: String
    var email: String
    
    var id: String
}


