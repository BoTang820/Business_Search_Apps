//
//  DetailsView.swift
//  Business Search
//
//  Created by Bo Tang on 11/22/22.
//

import SwiftUI

struct DetailsView: View {
    @EnvironmentObject var businessSearchViewModel: BusinessSearchViewModel
    @State private var showingSheet = false
    @State private var showToast = false
    
    @State private var justReserved = false
    
    
    //    @State var address: String = ""
    //    @State var category: String = ""
    //    @State var phone: String = ""
    //    @State var priceRange: String = ""
    //    @State var status: String = ""
    //    @State var url: String = ""
    
    func name() -> String {
        return businessSearchViewModel.details.name
    }
    
    func address() -> String {
        if let value = businessSearchViewModel.details.address {
            return value
        } else {
            return ""
        }
    }
    
    func category() -> String {
        if let value = businessSearchViewModel.details.category {
            return value
        } else {
            return ""
        }
    }
    
    func phone() -> String {
        if let value = businessSearchViewModel.details.phone {
            return value
        } else {
            return ""
        }
    }
    
    func priceRange() -> String {
        if let value = businessSearchViewModel.details.priceRange {
            return value
        } else {
            return ""
        }
    }
    
    func status() -> String {
        if let value = businessSearchViewModel.details.status {
            return (value == "true") ? "Open Now" : "Closed"
        } else {
            return ""
        }
    }
    
    func url() -> String {
        return businessSearchViewModel.details.url
    }
    
    func imageUrls() -> [String] {
        if let value = businessSearchViewModel.details.imageUrls {
            return value
        } else {
            return [""]
        }
    }
    
    func isLoaded() -> Bool {
        return businessSearchViewModel.details.loaded
    }
    
    func shareOnTwitter() {
        var string = ("https://twitter.com/intent/tweet?text=\(name().replacingOccurrences(of: " ", with: "%20"))%0A&url=\(url())").replacingOccurrences(of: " ", with: "%20")
        
        if let url = URL(string: string) {
            print("Successfully unwrapped url!")
            UIApplication.shared.open(url)
        }
    }
    
    
    
    var body: some View {
        
        VStack(alignment: .center) {
            if isLoaded() {
                titleSection
                infomationSection
                reserveButton
                    .sheet(isPresented: $showingSheet) {
                        ReservationFormView(justReserved: $justReserved)
                    }
                shareSection
                carousel
                
                Spacer()
            } else {
                VStack(alignment: .center) {
                    Spacer()
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    Spacer()
                }
            }
            
        }
        .toast(isShowing: $showToast, text: Text("Your reservation is cancelled."), alignment: Alignment.bottom)
        
    }
    
    
    
    
    
    
    var titleSection: some View  {
        Text(name())
            .font(.title)
            .fontWeight(.bold)
    }
    
    
    
    
    
    
    var infomationSection: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Address")
                        .fontWeight(.bold)
                    Text(address())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                    
                    
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Category")
                        .fontWeight(.bold)
                    Text(category())
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.trailing)
                }
                
            }
            .padding(.all)
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Phone")
                        .fontWeight(.bold)
                    Text(phone())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                    
                    
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Price Range")
                        .fontWeight(.bold)
                    Text(priceRange())
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.trailing)
                }
                
            }
            .padding([.leading, .bottom, .trailing])
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Status")
                        .fontWeight(.bold)
                    Text(status())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(status()=="Open Now" ? .green : .red)
                        .multilineTextAlignment(.leading)
                    
                    
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Visit Yelp For more")
                        .fontWeight(.bold)
                    
                    Text(.init("[Business Link](\(url()))"))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.trailing)
                }
                
            }
            .padding([.leading, .bottom, .trailing])
        }
    }
    
    
    
    
    
    
    var reserveButton: some View {
        
        if !businessSearchViewModel.reservations.contains(where: {$0.id == businessSearchViewModel.details.id}) && !justReserved {
            return Button(action: {
                showingSheet.toggle()
            }) {
                HStack {
                    Spacer()
                    Text("Reserve Now")
                        .fontWeight(.bold)
                    Spacer()
                }
            }
            .frame(width: 130 , height: 50, alignment: .center)
            .foregroundColor(.white)
            .background(.red)
            .cornerRadius(15)
            .padding(.bottom)
        } else {
            return Button(action: {
                businessSearchViewModel.cancelReservation()
                withAnimation {
                    showToast.toggle()
                }
            }) {
                HStack {
                    Spacer()
                    Text("Cancel Reservation")
                        .fontWeight(.bold)
                    Spacer()
                }
            }
            .frame(width: 130 , height: 50, alignment: .center)
            .foregroundColor(.white)
            .background(.blue)
            .cornerRadius(15)
            .padding(.bottom)
        }
        
        //        Button(action: {
        //            print("Reserved!")
        //        }) {
        //            HStack {
        //                Spacer()
        //                Text("Cancel Reservation")
        //                    .fontWeight(.bold)
        //                Spacer()
        //            }
        //        }
        //        .frame(width: 180 , height: 50, alignment: .center)
        //        .foregroundColor(.white)
        //        .background(.blue)
        //        .cornerRadius(15)
        //        .padding(.bottom)
        
    }
    
    
    
    
    
    
    var shareSection: some View {
        HStack {
            Text("Share on: ")
                .fontWeight(.bold)
            
            
            Link(destination:URL(
                string: "https://www.facebook.com/sharer/sharer.php?u=\(url())"
            )! , label: {
                Image("facebookIcon")
                    .resizable()
                    .frame(width: 50, height: 50)
            })
            

            
            

            Button(action: shareOnTwitter)
            {
                Image("twitterIcon")
                    .resizable()
                    .frame(width: 50, height: 50);
            }
            
            
        }
    }
    
    
    
    
    
    
    @State private var index = 0
    
    var carousel: some View {
        VStack{
            TabView(selection: $index) {
                ForEach(imageUrls(), id: \.self) { imageUrl in
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 280, height: 210)
                    
                    
                    //                    Image("\(index+1)")
                    //                        .resizable()
                    //                        .frame(width: 300, height: 300)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        }
        .frame(height: 300)
    }
}



























struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        
        //        @StateObject var businessSearchViewModel = BusinessSearchViewModel()
        
        DetailsView()
            .environmentObject(BusinessSearchViewModel())
            .previewDevice("iPhone 13 Pro")
        
    }
}
