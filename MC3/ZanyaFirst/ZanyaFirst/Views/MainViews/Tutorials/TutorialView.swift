//
//  TutorialView.swift
//  ZanyaFirst
//
//  Created by BAE on 2023/08/02.
//

import SwiftUI

struct TutorialView: View {
    var body: some View {
        //        ZStack{
        //            Rectangle()
        //                .fill(.black)
        //                .opacity(0.5)
        //            TutorialView_Cheese()
        //        }
        //        .ignoresSafeArea()
        
//        ZStack {
//            Image("Tuto_test")
//            //                .resizable()
//            //                .aspectRatio(contentMode: .fit)
//            Text("Hi")
//        }
//        .ignoresSafeArea()
        InviteTutorial_Cheese()
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}

struct TutorialView_Cheese: View {
    var body: some View {
        VStack{
            Spacer()
            Image("TutorialView_Cheese")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}

struct InviteTutorial_Cheese: View {
    var body: some View {
        Image("Tuto_test")
            .resizable()
        //                .aspectRatio(contentMode: .fit)
            .ignoresSafeArea()
    }
}

//struct 
