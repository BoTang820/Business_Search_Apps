//
//  BusinessSearchViewModel.swift
//  Business Search
//
//  Created by Bo Tang on 12/3/22.
//

import SwiftUI

class BusinessSearchViewModel: ObservableObject {
    @Published var businesses = [BusinessItem]()
    @Published var isLoading = false
    @Published var isLoaded = false
    @Published var details = Details()
    @Published var reviews = [ReviewItem]()
    @Published var autoCompletions = [String]()

    @AppStorage("reservations") var reservations = [ReservationItem]()
    
    
    
    let apiRequest = APIRequest()
    
    func getAutoCompletions(text: String) {
        apiRequest.getAutoComplete(text: text) {res in
            print(res)
            self.autoCompletions = res
            print(self.autoCompletions)
        }
    }
    
    func getBusinesses(term: String, categories: String, location: String?, radius: String, autoDetect: Bool) {
        if !autoDetect {
            self.isLoaded = false
            self.isLoading = true
            apiRequest.getGeoCode(location: location!) {res in
                let latitude = res[0]
                let longitude = res[1]
                print(latitude, longitude)
                self.apiRequest
                    .getBusinesses(term: term, categories: categories, latitude: latitude, longitude: longitude, radius: radius) {searchResults in
                        self.businesses = searchResults
                        print(self.businesses)
                    }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isLoading = false
                }
            }
        } else {
            self.isLoading = true
            apiRequest.getIpinfo() {res in
                let latitude = res[0]
                let longitude = res[1]
                print(latitude, longitude)
                self.apiRequest
                    .getBusinesses(term: term, categories: categories, latitude: latitude, longitude: longitude, radius: radius) {searchResults in
                        self.businesses = searchResults
                        print(self.businesses)
                    }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isLoading = false
                }
            }
        }
        self.isLoaded = true

        //        print(coord)

    }
    
    func getDetails(id: String) {
        apiRequest.getDetails(id: id) { details in
            self.details = details
            print(self.details)
        }
    }
    
    func getReviews(id: String) {
        apiRequest.getReviews(id: id) { reviews in
            self.reviews = reviews
            print(self.reviews)
        }
    }
    
    func reset() {
        self.businesses = [BusinessItem]()
        self.details = Details()
        self.reviews = [ReviewItem]()
        self.isLoaded = false
        self.isLoading = false
    }
    
    func setIsLoadedToFalse() {
        self.details.loaded = false
        print("loaded is set to false!")
    }
    
    func makeReservation(date: String, time: String, email: String) {

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let reservation = ReservationItem(name: self.details.name, date: date, time: time, email: email, id: self.details.id)
            self.reservations.append(reservation)
        }

        
        print("")
        print("Reservation List:")
        print(reservations)
        print(reservations.count)
    }
    
    func cancelReservation() {
        reservations = reservations.filter { $0.id != self.details.id }
        
        print("")
        print("Reservation List:")
        print(reservations)
        print(reservations.count)
    }
    
    
    
    
}
