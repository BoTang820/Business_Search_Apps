//
//  APIRequest.swift
//  Business Search
//
//  Created by Bo Tang on 11/23/22.
//

import SwiftUI
import Foundation
import Alamofire
import SwiftyJSON

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}


extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}

extension View {

    func toast(isShowing: Binding<Bool>, text: Text, alignment: Alignment) -> some View {
        Toast(isShowing: isShowing,
              presenting: { self },
              text: text, alignment: alignment)
    }

}

extension View {
    func hiddenNavigationBarStyle() -> some View {
        modifier( HiddenNavigationBar() )
    }
}


struct Toast<Presenting>: View where Presenting: View {
    
    /// The binding that decides the appropriate drawing in the body.
    @Binding var isShowing: Bool
    /// The view that will be "presenting" this toast
    let presenting: () -> Presenting
    /// The text to show
    let text: Text
    
    let alignment: Alignment
    
    var body: some View {
        
        if self.isShowing {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    self.isShowing = false
                }
            }
        }
        
        return GeometryReader { geometry in
            
            ZStack(alignment: alignment) {
                
                self.presenting()
                
                HStack(alignment: .bottom) {
                    self.text
                }
                .frame(width: geometry.size.width * 0.7,
                       height: geometry.size.height / 8)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .transition(.slide)
                .opacity(self.isShowing ? 1 : 0)
                
            }
            
        }
        
    }
}



struct HiddenNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
}




class APIRequest {
    
    enum URL: String {
        case ipinfo = "https://ipinfo.io/json?token=3317efadd4e11f"
        case geoCode = "https://hw8-botang.uc.r.appspot.com/api/geoCode"
        case search = "https://hw8-botang.uc.r.appspot.com/api/businessSearch"
        case details = "https://hw8-botang.uc.r.appspot.com/api/businessDetails"
        case reviews = "https://hw8-botang.uc.r.appspot.com/api/businessReviews"
        case autoComplete = "https://hw8-botang.uc.r.appspot.com/api/autocomplete"
        
        case test = "https://hw8-botang.uc.r.appspot.com/api/businessSearch?term=sushi&categories=all&latitude=40.7127753&longitude=-74.0059728&radius=16090"
        
    }
    
    func getIpinfo(completion: @escaping ([String]) -> Void) {
        let request = AF.request((URL.ipinfo.rawValue).replacingOccurrences(of: " ", with: "+"))
        var res: [String] = []
        request.responseJSON { (response) in
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                //                print("JSON: " + "\(json["loc"])")
                let loc = "\(json["loc"])"
                //                json["loc"]
                res = loc.components(separatedBy: ",")
                //                print(res)
                completion(res)
                
            case .failure(let error): print(error)
            }
        }
    }
    
    func getGeoCode(location: String, completion: @escaping ([String]) -> Void) {
        var res: [String] = []
        let request = AF.request((URL.geoCode.rawValue + "?location=" + location).replacingOccurrences(of: " ", with: "+"))
        request.responseJSON { (response) in
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                //                print("JSON: " + "\(json["results"][0]["geometry"]["location"])")
                res.append("\(json["results"][0]["geometry"]["location"]["lat"])")
                res.append("\(json["results"][0]["geometry"]["location"]["lng"])")
                //                print(res)
                completion(res)
                
            case .failure(let error): print(error)
            }
        }
        
    }
    
    
    
    
    
    
    func getBusinesses(term: String, categories: String, latitude: String, longitude: String, radius: String, completion: @escaping ([BusinessItem]) -> Void) {
        var businesses = [BusinessItem]()
        
        let request = AF.request((URL.search.rawValue + "?term=" + term + "&categories=" + categories + "&latitude=" + latitude + "&longitude=" + longitude + "&radius=" + radius).replacingOccurrences(of: " ", with: "+"))
        request.responseJSON { (response) in
            switch response.result {
                
            case .success(let value):
                
                let json = JSON(value)["businesses"]
                print(json)
                for (key, item) in json {
                    if (Int(key)! < 10) {
                        var rating = item["rating"].stringValue
                        
                        if (!rating.contains(".")) {
                            rating = rating + ".0"
                        }
                        
                        let businessItem =
                        BusinessItem(
                            imageURL: item["image_url"].stringValue,
                            name: item["name"].stringValue,
                            rating: rating,
//                            distance: String((Int(item["distance"].stringValue)!) / 1609),
                            distance: String((item["distance"].stringValue as NSString).integerValue / 1609),
                            id: item["id"].stringValue
                        )
                        
                        businesses.append(businessItem)
                        
                        //                        print("")
                        //                        print(key)
                        //                        print(businessItem.distance as Any)
                        //                        print(businessItem.name as Any)
                        //                        print(businessItem.imageURL as Any)
                        //                        print(businessItem.rating as Any)
                        //                        print(businessItem.id as Any)
                        
                    }
                    
                }
                //                print(businesses.count)
                
                
                completion(businesses)
                
            case .failure(let error): print(error)
            }
        }
    }
    
    
    
    
    
    
    
    //    struct Details: Codable, Identifiable {
    //        var address: String?
    //        var category: String?
    //        var phone: String?
    //        var priceRange: String?
    //        var status: String?
    //        var url: String?
    //        var imageUrls: [String]?
    //        var latitude = ""
    //        var longitude = ""
    //
    //        var id = ""
    //    }
    
    
    
    func getDetails(id: String, completion: @escaping (Details) -> Void) {
        var details = Details()
        let request = AF.request(URL.details.rawValue + "?id=" + id)
        request.responseJSON { (response) in
            switch response.result {
                
            case .success(let value):
                
                let json  = JSON(value)
                
                let name = json["name"].stringValue
                
                let address = json["location"]["display_address"][0].stringValue + ", " + json["location"]["display_address"][1].stringValue
                
                var category = ""
                for (_, value) in json["categories"] {
                    category += (value["title"].stringValue + " | ")
                }
                if (category != "") {
                    let endIndex = category.index(category.endIndex, offsetBy: -3)
                    category = category.substring(to: endIndex)
                }
                //                print(category)
                
                let phone = json["display_phone"].stringValue
                let priceRange = json["price"].stringValue
                let status = json["hours"][0]["is_open_now"].stringValue
                let url = json["url"].stringValue
                
                var imageUrls = [String]()
                for (key, value) in json["photos"] {
                    imageUrls.append(value.stringValue)
                }
                //                print(imageUrls)
                
                let latitude = json["coordinates"]["latitude"].stringValue
                let longitude = json["coordinates"]["longitude"].stringValue
                let id = json["id"].stringValue
                
                details = Details(name: name,
                                  address: address,
                                  category: category,
                                  phone: phone,
                                  priceRange: priceRange,
                                  status: status,
                                  url: url,
                                  imageUrls: imageUrls,
                                  latitude: latitude,
                                  longitude: longitude,
                                  loaded: true,
                                  id: id
                )
                
                completion(details)
                
            case .failure(let error): print(error)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    func getReviews(id: String, completion: @escaping ([ReviewItem]) -> Void) {
        var reviews = [ReviewItem]()
        let request = AF.request(URL.reviews.rawValue + "?id=" + id)
        request.responseJSON { (response) in
            switch response.result {
                
            case .success(let value):
                
                let json = JSON(value)["reviews"]
                //                print(json)
                for (_, value) in json {
                    var user = value["user"]["name"].stringValue
                    var rating = value["rating"].stringValue
                    var text = value["text"].stringValue
                    var date = String(value["time_created"].stringValue.prefix(11))
                    //                    print(user)
                    //                    print(rating)
                    //                    print(text)
                    //                    print(date)
                    //                    print("")
                    reviews.append(ReviewItem(user: user,
                                              rating: rating,
                                              text: text,
                                              date: date))
                }
                
                
                completion(reviews)
                
            case .failure(let error): print(error)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    func getAutoComplete(text: String, completion: @escaping ([String]) -> Void) {
        var autoCompletions = [String]()
        let request = AF.request((URL.autoComplete.rawValue + "?text=" + text).replacingOccurrences(of: " ", with: "+"))
        request.responseJSON { (response) in
            print("ACs:")
            print(response)
            switch response.result {

            case .success(let value):

                let json = JSON(value)
                print(json[0])
                
                for (_,value) in json {
                    autoCompletions.append(value["text"].stringValue)
                }
                
//                for (_, value) in json {
//                    var user = value["user"]["name"].stringValue
//                    var rating = value["rating"].stringValue
//                    var text = value["text"].stringValue
//                    var date = String(value["time_created"].stringValue.prefix(11))
//                    //                    print(user)
//                    //                    print(rating)
//                    //                    print(text)
//                    //                    print(date)
//                    //                    print("")
//                    reviews.append(ReviewItem(user: user,
//                                              rating: rating,
//                                              text: text,
//                                              date: date))
//                }
//
//
                completion(autoCompletions)

            case .failure(let error): print(error)
            }

        }
    }
    
}
