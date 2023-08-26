//
//  SearchView.swift
//  Business Search
//
//  Created by Bo Tang on 11/18/22.
//

import SwiftUI
import PopoverSwiftUI
import Alamofire


//struct AutoCompletionPopOver: View {
//    @EnvironmentObject var businessSearchViewModel: BusinessSearchViewModel
//    @Binding var keyword: String
//
//    var body: some View {
//        var isloading = (businessSearchViewModel.autoCompletions.count == 0)
//        VStack {
//            if isloading {
//                ProgressView(label: {Text("loading...")})
//                    .frame( width: 500, height:  40)
//            } else {
//
//                ForEach(businessSearchViewModel.autoCompletions, id: \.self) { autoCompletion in
//                    Text(autoCompletion)
//                        .onTapGesture {
//                            keyword = autoCompletion
//                        }
//                        .foregroundColor(.gray)
//
//                }
//
//            }
//        }.padding()
//
//    }
//}


struct SearchView: View {
    
    @EnvironmentObject var businessSearchViewModel: BusinessSearchViewModel
    
    init () {
        
    }
    
    
    enum Category: String, CaseIterable, Identifiable {
        case defaults = "Defaults"
        case arts = "Arts and Entertainment"
        case health = "Health and Medical"
        case hotels = "Hotels and Travel"
        case food = "Food"
        case professionalService = "Professional Services"
        
        var id: String { self.rawValue }
    }
    
    @FocusState private var focused: Bool
    
    
    //    @State private var showPopover = false
    
    @State private var submitted = false
    
    @State private var keyword: String = ""
    //    @State private var keyword: String = "sushi"
    
    //    @State private var keyword: String = ""
    @State private var distance: String = "10"
    @State private var category: String = "Default"
    @State private var location: String = ""
    //    @State private var location: String = "Los Angeles"
    
    //    @State private var location: String = ""
    @State private var autoDetect: Bool = false
    
    func isFormValid() -> Bool {
        if (!keyword.isEmpty && !distance.isEmpty && (!location.isEmpty || autoDetect)) {
            return true
        } else {
            return false
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    func submit() {
        businessSearchViewModel.getBusinesses(term: keyword, categories: category, location: location, radius: String(Int(distance)!*1609), autoDetect: autoDetect)
        submitted = true
        hideKeyboard()
    }
    
    func clear() {
        keyword = ""
        distance = "10"
        category = ""
        location = ""
        autoDetect = false
        businessSearchViewModel.reset()
        hideKeyboard()
    }
    
    
    
    
    var body: some View {
        NavigationView {
            form
                .navigationBarTitle("Business Search")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: {
                            ReservationListView()
                                .navigationTitle("Your Reservations")
                        }) {
                            Image(systemName: "calendar.badge.clock")
                                .foregroundColor(.blue)
                            
                        }
                    }
                }
            
        }
    }
    
    
    
    
    @State var showsPopover = false
    @State var showsAlwaysPopover = false
    
    var form: some View {
        Form {
            Section {
                
                HStack {
                    Text("Keyword:").foregroundColor(.gray)
                    TextField("Required", text: $keyword)
//                        .onChange(of: keyword, perform: { newValue in
//
//                            if newValue.count > 0 {
//                                businessSearchViewModel.autoCompletions = [String]()
//                                if showsAlwaysPopover == false {
//                                    showsAlwaysPopover = true
//                                }
//                                businessSearchViewModel.getAutoCompletions(text: newValue)
//                            }
//                        })
                        .onSubmit {
                            if keyword.count > 0 {
                                showsAlwaysPopover = true

//                                if showsAlwaysPopover == false {
//                                    showsAlwaysPopover = true
//                                }
                                businessSearchViewModel.getAutoCompletions(text: keyword)
                            } else {
                                showsAlwaysPopover = false
                                businessSearchViewModel.autoCompletions = [String]()
                            }
                        }
                        .popoverView(isPresented: $showsAlwaysPopover,
                                     arrows: UIPopoverArrowDirection.up, // default arrow direction: .any
                                     background: .white) {           // default background color: nil
                            
                                var isloading = (businessSearchViewModel.autoCompletions.count == 0)
                                VStack {
                                    if isloading {
                                        ProgressView(label: {Text("loading...")})
                                            .frame( width: 500, height:  40)
                                    } else {
                                        
                                        ForEach(businessSearchViewModel.autoCompletions, id: \.self) { autoCompletion in
                                            Text(autoCompletion)
                                                .onTapGesture {
                                                    showsAlwaysPopover = false
                                                    keyword = autoCompletion
                                                }
                                                .foregroundColor(.gray)
                                                
                                        }
                                        
                                    }
                                }.padding()
                        }
                    //                        .alwaysPopover(isPresented: $showsAlwaysPopover) {
                    //                            AutoCompletionPopOver(keyword: $keyword)
                    //                                .environmentObject(businessSearchViewModel)
                    //                        }
                    //                        .onChange(of: keyword, perform: { newValue in
                    //
                    //                            if newValue.count > 0 {
                    //                                businessSearchViewModel.autoCompletions = [String]()
                    //                                if showsAlwaysPopover == false {
                    //                                    showsAlwaysPopover = true
                    //                                }
                    //                                businessSearchViewModel.getAutoCompletions(text: newValue)
                    //                            }
                    //                        })
                    
                }
                
                HStack {
                    Text("Distance:").foregroundColor(.gray)
                    TextField("Required", text: $distance)
                }
                
                HStack {
                    Text("Category:").foregroundColor(.gray)
                    Picker("Category:", selection: $category) {
                        ForEach(Category.allCases) { category in
                            Text(category.rawValue.capitalized).tag(category)
                        }
                    }
                    .foregroundColor(.gray)
                    .pickerStyle(.menu)
                }
                
                
                
                if !autoDetect {
                    HStack {
                        Text("Location:").foregroundColor(.gray)
                        TextField("Required", text: $location)
                    }
                    .animation(.default)
                }
                
                
                Toggle(isOn: $autoDetect.animation(), label: {
                    HStack {
                        Text("Auto-detect my location")
                            .foregroundColor(.gray)
                    }
                })
                
                HStack {
                    Spacer()
                    Button(action: {
                        submit()
                    }) {
                        HStack {
                            Spacer()
                            Text("Submit")
                            Spacer()
                        }
                    }
                    .disabled(!isFormValid())
                    .frame(width: 120 , height: 50, alignment: .center)
                    .foregroundColor(.white)
                    .background(isFormValid() ? .red : .gray)
                    .cornerRadius(8)
                    
                    
                    
                    Spacer()
                    
                    Button(action: {
                        
                        clear()
                        //                        print(keyword)
                        //                        businessSearchViewModel.getAutoCompletions(text: keyword)
                    }) {
                        HStack {
                            Spacer()
                            Text("Clear")
                            Spacer()
                        }
                    }
                    .frame(width: 120 , height: 50, alignment: .center)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(8)
                    
                    
                    Spacer()
                    
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(10)
                
            }.onTapGesture {
                hideKeyboard()
            }
            .onAppear {
                //                businessSearchViewModel.getBusinesses(term: keyword, categories: category, location: location, radius: String(Int(distance)!*1609), autoDetect: autoDetect)
                //                hideKeyboard()
            } // TODO: Delete this after developing
            
            results
        }
        
        
    } // end of "form"
    
    
    
    
    
    
    
    
    var results: some View {
        List {
            Text("Results").font(.title).fontWeight(.bold)
            
            if (businessSearchViewModel.isLoading) {
                HStack(alignment: .center) {
                    List {
                        ProgressView(label: {Text("Please wait...")})
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                }
            } else {
                if businessSearchViewModel.isLoaded && businessSearchViewModel.businesses.count == 0 {
                    List {
                        Text("No result available")
                            .foregroundColor(.red)
                    }
                } else {
                    List {
                        ForEach(0..<10) { i in
                            if businessSearchViewModel.businesses.indices.contains(i) {
                                let businessItem = businessSearchViewModel.businesses[i]
                                NavigationLink(
                                    destination: DetailsTabView(id: businessSearchViewModel.businesses[i].id)
                                        .hiddenNavigationBarStyle()
                                ) {
                                    Item(index: "\(i + 1)",
                                         name: businessItem.name!,
                                         rating: businessItem.rating!,
                                         //                                 distance: businessItem.distance!,
                                         distance: businessItem.distance!,
                                         id: businessItem.id,
                                         imageUrl: businessItem.imageURL!
                                    )
                                }
                            }
                        }
                    }
                }
                
            }
        }
    } // end of "results"
    
    
    
    
    
    
    
    
    struct Item: View {
        
        let index: String
        let name: String
        var rating: String
        let distance: String
        let id: String
        let imageUrl: String
        
        var body: some View {
            HStack {
                Text(index)
                //                Spacer()
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
                .cornerRadius(5)
                
                //                Spacer()
                Text(name).foregroundColor(.gray)
                    .padding(.horizontal)
                Spacer()
                
                
                
                Text(rating).fontWeight(.bold)
                    .padding(.horizontal)
                //                Spacer()
                Text(distance).fontWeight(.bold)
            }
        }
    } // end of "Item"
    
    
    
    
    
    
    
    
    
}
































struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(BusinessSearchViewModel())
            .previewDevice("iPhone 13 Pro")
        
    }
}
