//
//  ReviewsView.swift
//  Business Search
//
//  Created by Bo Tang on 12/4/22.
//

import SwiftUI

struct ReviewsView: View {
    
    @EnvironmentObject var businessSearchViewModel: BusinessSearchViewModel
    
    
    var body: some View {
        //        List {
        //
        //
        //            Review(user: "Nasty Bitch", rating: "1", text: "I wanna be fucked! Please put your dick into my little pussy and asshole!", date: "2022-12-04")
        //        }
        VStack {
            List {
                ForEach(0..<3) { i in
                    if businessSearchViewModel.reviews.indices.contains(i) {
                        let reviewItem = businessSearchViewModel.reviews[i]
                        Review(user: reviewItem.user,
                               rating: reviewItem.rating,
                               text: reviewItem.text,
                               date: reviewItem.date)
                    }
                }
            }

            Spacer()
        }
        
        
        
    }
    
    struct Review: View {
        
        let user: String
        let rating: String
        let text: String
        let date: String
        
        var body: some View {
            
            VStack(alignment: .center, spacing: 10.0) {
                HStack {
                    Text(user).fontWeight(.bold)
                    
                    Spacer()
                    
                    Text(rating + "/5").fontWeight(.bold)
                    
                }
                Text(text)
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.leading)
                
                Text(date)
                
            }
            .padding(.all)
            
            
        }
    }
    
    
}





















struct ReviewsView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewsView()
            .environmentObject(BusinessSearchViewModel())
    }
}
