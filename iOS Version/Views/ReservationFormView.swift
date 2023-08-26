//
//  ReservationFormView.swift
//  Business Search
//
//  Created by Bo Tang on 11/22/22.
//

import SwiftUI

struct ReservationFormView: View {
    
    @EnvironmentObject var businessSearchViewModel: BusinessSearchViewModel
//    @Environment(\.dismiss) var dismiss
    @Binding var justReserved: Bool
    
    
    
    
    let hourChoices = ["10", "11", "12", "13", "14", "15", "16", "17"]
    let minutesChoices = ["00", "15", "30", "45"]
    
    @State private var showToast = false
    @State private var showConfirmationSheet = false
    
    @State private var email: String = ""
    @State private var date = Date()
    @State private var hour: String = "10"
    @State private var minutes: String = "00"
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
//    func makeReservation() {
//        let date = String(self.date.description.split(separator: " ")[0])
//        businessSearchViewModel.makeReservation(date: date, time: "\(self.hour):\(self.minutes)", email: self.email)
//    }
    
    func submit() {


        
        if isValidEmailAddress(emailAddressString: email) {
            let date = String(date.description.split(separator: " ")[0])
            businessSearchViewModel.makeReservation(date: date, time: "\(hour):\(minutes)", email: email)
            print("Reservation made!")




        } else {
            withAnimation {
//                businessSearchViewModel.reservations = [ReservationItem]()
                showToast = true

            }
        }
        showConfirmationSheet = true

    }
    
    
    var body: some View {
        Form {
            Section {
                Text("Reservation Form")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            Section {
                Text(businessSearchViewModel.details.name)
                    .font(.title)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
            Section {
                HStack {
                    Text("Email:").foregroundColor(.gray)
                    TextField("Required", text: $email)
                    
                }
                .padding(.vertical)
                HStack {
                    DatePicker(selection: $date, in: Date()..., displayedComponents: .date) {
                        Text("Date/Time:")
                            .foregroundColor(.gray)
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 80.0, height: 34.0)
                            .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.945))
                        HStack {
                            Picker("", selection: $hour) {
                                ForEach(hourChoices, id: \.self) { hourChoice in
                                    Text(hourChoice)
                                }
                            }
                            .accentColor(.black)
                            .pickerStyle(.menu)
                            Text(":")
                                .foregroundColor(.gray)
                            Picker("", selection: $minutes) {
                                ForEach(minutesChoices, id: \.self) { minutesChoice in
                                    Text(minutesChoice)
                                }
                            }
                            .pickerStyle(.menu)
                            .accentColor(.black)
                            
                        }
                    }
                }
                .padding(.vertical)
                HStack(alignment: .center) {
                    Spacer()
                    Button(action: {
                        if isValidEmailAddress(emailAddressString: email) {
                            let date = String(date.description.split(separator: " ")[0])
                            businessSearchViewModel.makeReservation(date: date, time: "\(hour):\(minutes)", email: email)
                            print("Reservation made!")
                            showConfirmationSheet = true
                            justReserved = true



                        } else {
                            withAnimation {
                //                businessSearchViewModel.reservations = [ReservationItem]()
                                showToast = true

                            }
                        }
                        print(showConfirmationSheet)
//                        showConfirmationSheet = true
                        print(showConfirmationSheet)
                        
                    }) {
                            HStack {
                                Spacer()
                                Text("Submit")
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
                .padding(.vertical)
                
                
                
            }
        }
        .sheet(isPresented: $showConfirmationSheet) {
            ConfirmationSheetView(isShowing: $showConfirmationSheet)
//            ZStack {
//                Rectangle().foregroundColor(.green)
//
//                VStack {
//                    Spacer()
//                    Text("Congratulations!")
//                        .fontWeight(.bold)
//                        .foregroundColor(.white)
//                        .padding()
//
//                    Text("You have successfully made an reservation at this place")
//                        .foregroundColor(.white)
//                    Spacer()
////                    doneButton
//                }
//            }.ignoresSafeArea(.all)
        }
        .toast(isShowing: $showToast, text: Text("Please enter a valid email."), alignment: Alignment.bottom)
    }
    
}

//struct ReservationFormView_Previews: PreviewProvider {
//    static var previews: some View {
////        ReservationFormView()
//            .environmentObject(BusinessSearchViewModel())
//    }
//}
