//
//  ConfirmationSheetView.swift
//  Business Search
//
//  Created by Bo Tang on 12/5/22.
//

import SwiftUI

struct ConfirmationSheetView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var isShowing: Bool
    @EnvironmentObject var businessSearchViewModel: BusinessSearchViewModel


    var body: some View {
        
        if self.isShowing {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if self.isShowing {
                    withAnimation {
                        UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true)
                        self.isShowing = false
                    }

                }
            }
        }
        
        return ZStack {
            Rectangle().foregroundColor(.green)
            
            VStack {
                Spacer()
                Text("Congratulations!")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                
                Text("You have successfully made an reservation at \(businessSearchViewModel.details.name)")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                Spacer()
                doneButton
            }
        }.ignoresSafeArea(.all)
    }
    
    var doneButton: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .frame(width: 140, height: 40.0)
                .cornerRadius(20)
            Button(action: {
                UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true)
                self.isShowing = false
            }) {
                Text("Done")
                .foregroundColor(.green)
            }
            .padding(30)
            

        }
        
    }
}

//struct ConfirmationSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConfirmationSheetView()
//    }
//}
