//
//  RoomDisableView.swift
//  ZanyaFirst
//
//  Created by Kimjaekyeong on 2023/08/01.
//

import SwiftUI

struct RoomDisableView: View {
    
    @StateObject var viewModel: RoomDisableViewModel
    
    @Environment(\.dismiss) private var dismiss
    var date: String = ""
    
    var body: some View {
        ZStack {
            Image(RoomDisableSheet)
                .resizable()
                .scaledToFill()
            
            VStack {
                ZStack{
                    Image(RoomDisableLogo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 346.13)
                       
                    
                    VStack {
                        HStack(spacing: 1){
                            if viewModel.afterNoon {
                                if String(viewModel.min).count == 1 {
                                    TextCell(text: "오후 \(viewModel.hour):0\(viewModel.min)", size: 26, color: Color(AppPink))
                                } else {
                                    TextCell(text: "오후 \(viewModel.hour):\(viewModel.min)", size: 26, color: Color(AppPink))
                                }
                            } else {
                                if String(viewModel.min).count == 1 {
                                    TextCell(text: "오전 \(viewModel.hour):0\(viewModel.min)", size: 26, color: Color(AppPink))
                                } else {
                                    TextCell(text: "오전 \(viewModel.hour):\(viewModel.min)", size: 26, color: Color(AppPink))
                                }
                            }
                            TextCell(text: "에", size: 17, color: Color(AppBlackForBurble))
                        }
                        TextCell(text: "방이 열려요:3", size: 17, color: Color(AppBlackForBurble))
                    }
                    .padding(.top, -56)
                } .padding(.top, 278)
                Spacer()
                
                Button {
                    print("dismiss")
                    dismiss()
                } label: {
                    Image(RoomDisableCompletButtonImage)
                        .padding(.bottom, 55)
                        .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 4)
                }
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
    }
}

//struct RoomDisableView_Previews: PreviewProvider {
//    static var previews: some View {
//        RoomDisableView()
//    }
//}
