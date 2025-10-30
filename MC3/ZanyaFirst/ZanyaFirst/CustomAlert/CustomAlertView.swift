//
//  CustomAlertView.swift
//  ZanyaFirst
//
//  Created by BAE on 2023/07/28.
//

import SwiftUI

struct CustomAlertView: View {
    
    @EnvironmentObject var alertObject: CustomAlertObject
    
    @State var roomName: String?
    
    @Binding var task: Int
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.black.opacity(0.3))
//                .opacity(0.3)
            
//            Rectangle().fill(.white.opacity(0.5))
            sheet
            
            if let roomName = roomName {
                VStack(alignment: .center) {
                    Text("\(roomName)")
                        .font(Font.custom("LINE Seed Sans KR Bold", size: 17))
                        .foregroundColor(.AppGreen)
                    Text("방에서 나가시겠어요?")
                        .font(Font.custom("LINE Seed Sans KR Bold", size: 17))
                        .foregroundColor(.AppWineAlertText)
                }
                .padding(.bottom, 42)

            } else {
                TextCell(text: "아직 초대한 친구가 없어요. \n친구를 초대하시겠어요?", size: 17, color: .AppWineAlertText)
                    .padding(.bottom, 33.6)
                    .multilineTextAlignment(.center)
            }
            
            HStack(alignment: .center, spacing: 6) {
                dismissButton
                okButton
            }
            .padding(.top, 100)
        }
        .ignoresSafeArea()
        .onChange(of: alertObject.roomName) { newValue in
            self.roomName = newValue
        }
    }
    
    var sheet: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 28)
                .fill(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.49, green: 0.44, blue: 0.85), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.93, green: 0.93, blue: 1), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.01, y: 0.01),
                        endPoint: UnitPoint(x: 0.99, y: 0.99)
                    )
                )
                .frame(width: 304, height: 164)
            
            RoundedRectangle(cornerRadius: 26)
                .fill(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.88, green: 0.88, blue: 1), location: 0.00),
                            Gradient.Stop(color: Color(red: 1, green: 1, blue: 1), location: 0.15),
                            Gradient.Stop(color: Color(red: 1, green: 1, blue: 1), location: 0.54),
                            Gradient.Stop(color: Color(red: 0.75, green: 0.75, blue: 0.91), location: 0.84),
                            Gradient.Stop(color: Color(red: 0.65, green: 0.65, blue: 0.87), location: 0.95),
                            Gradient.Stop(color: .white, location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.5, y: 0),
                        endPoint: UnitPoint(x: 0.5, y: 1.02)
                    )
                )
                .frame(width: 300, height: 160)
        }
    }
    
    var dismissButton: some View {
        Button {
            print("dismiss")
            alertObject.isClicked = false
        } label: {
            if roomName != nil {
                Image(outMessageCancleButton)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Image(inviteMessageCancelButton)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .frame(width: 139)
    }
    
    var okButton: some View {
        Button {
            print("okay \(alertObject.isClicked)")
            print("UID \(alertObject.UID)")
            alertObject.userRoomOut()
            task += 1
        } label: {
            if roomName != nil {
                Image(outMessageOutButton)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Image(inviteMessageOkayButton)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .frame(width: 139)
    }
}

//struct CustomAlertView_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomAlertView(roomName: "일어날래, 나랑 살래?", task: $1)
//            .environmentObject(CustomAlertObject())
//    }
//}

