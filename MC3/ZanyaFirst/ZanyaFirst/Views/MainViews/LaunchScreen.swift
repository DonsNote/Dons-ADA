//
//  LaunchScreen.swift
//  ZanyaFirst
//
//  Created by Kimjaekyeong on 2023/07/26.
//

import SwiftUI

struct LaunchScreen: View {
    
    //MARK: -1. PROPERTY
   
    
    //MARK: - 2. BODY
    var body: some View {
        ZStack(alignment: .top){
            Image(LaunchPageSheet)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            Button {
                print("start")// TODO: -시작하기 구현하기
            } label: {
                Image(LaunchStartButton)
                    
                    .padding(.top, 703)
                    
            }
        }
    }
}


    //MARK: -3. PREVIEW
struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
