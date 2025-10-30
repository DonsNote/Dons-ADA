//
//  BlurView.swift
//  ZanyaFirst
//
//  Created by Kimjaekyeong on 2023/07/27.
//
import SwiftUI

struct BlurView: View {
    var body: some View {
        
        ZStack{
//            Text("fdsaf")
//            Rectangle()
            Rectangle()
                .foregroundColor(.white)
                .blur(radius: 10)
                .opacity(0.1)
                .frame(width: screenWidth * 2, height: screenHeight * 2)
        }
    }
}

struct BlurView_Previews: PreviewProvider {
    static var previews: some View {
        BlurView()
    }
}
