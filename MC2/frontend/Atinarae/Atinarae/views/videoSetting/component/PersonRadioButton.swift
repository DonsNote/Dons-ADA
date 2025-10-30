//
//  PersonRadioButton.swift
//  Atinarae
//
//  Created by HyunwooPark on 2023/05/05.
//

import SwiftUI

struct PersonRadioButton: View {
//    @EnvironmentObject var appData: AppData
    @Binding var selectedFriend: Friend
    @Binding var friend:Friend
    
    var body: some View {
        
        VStack(alignment: .center) {
            if selectedFriend == friend {
                ZStack{
                    Image(friend.planetImage)
                        .resizable()
                        .foregroundColor(Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1)))
                        .frame(width: 52, height: 52)
                    Circle()
                        .stroke(Color.white, lineWidth: 3)
                        .frame(width: 63, height:63)
                        .background(Image(systemName: "checkmark").fontWeight(.bold))
                        
                        
                }
                Text(friend.nickname)
            } else {
                Image(friend.planetImage)
                    .resizable()
                    .foregroundColor(Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1)))
                    .frame(width: 63, height: 63)
                Text(friend.nickname)
            }
        }
        .padding(.top, 2)
        .padding(.leading,2)
    }
}

//struct PersonRadioButton_Previews: PreviewProvider {
//    static var previews: some View {
//        @EnvironmentObject var appData: AppData
//        PersonRadioButton()
//    }
//}
