//
//  ReservationListView.swift
//  Business Search
//
//  Created by Bo Tang on 11/22/22.
//

import SwiftUI

struct ReservationListView: View {
    @EnvironmentObject var businessSearchViewModel: BusinessSearchViewModel

    func removeRows(at offsets: IndexSet) {
        businessSearchViewModel.reservations.remove(atOffsets: offsets)
        print(businessSearchViewModel.reservations.count)
        print(businessSearchViewModel.reservations)
    }
    
    var body: some View {
        
        if businessSearchViewModel.reservations.count == 0 {
            ZStack {

                    Rectangle().foregroundColor(.white)
                    Text("No bookings found")
                        .foregroundColor(.red)


            }
        } else {
            List {
                ForEach(businessSearchViewModel.reservations) {r in
                    Reservation(name: r.name, date: r.date, time: r.time, email: r.email)
                }
                .onDelete(perform: removeRows)

            }
        }        
        
        
    }
    
    
    struct Reservation: View {
        let name: String
        let date: String
        let time: String
        let email: String
        
        var body: some View {
            HStack {
                Text(name)
                    .multilineTextAlignment(.leading)
                    .frame(width: 80.0)

                Text(date)
                    .multilineTextAlignment(.leading)
                    .frame(width: 75.0)
                Text(time)
                    .multilineTextAlignment(.leading)
                    .frame(width: 35.0)
                Text(email)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 105.0)
            }.font(.footnote)

        }
    }
    
}

struct ReservationListView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationListView()
            .environmentObject(BusinessSearchViewModel())
    }
}
 


