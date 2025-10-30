//
//  LunchPage.swift
//  Atinarae
//
//  Created by A_Mcflurry on 2023/05/05.
//

//  ----------------------------------------------------------------------
//          최초 타이틀 페이지
//          실행될때 넘어가는데
//          여기서 최초 실행 여부를 판단해서 온보딩 페이지와 메인페이지로 나뉠 예정입니다.
//  ----------------------------------------------------------------------

import SwiftUI

struct LunchPage: View {
    @State var tag:Int? = nil
    var body: some View {
        NavigationView{
            
            ZStack{
                Color.backGroundColor.ignoresSafeArea()
                Image("Title")
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // 1초 지연
                            self.tag = 1    // 밑에 NavigationLink를 대려옵니다.
                    }
                        
                }
                NavigationLink(destination: MainView(), tag : 1, selection: self.$tag){}
            }
        }.navigationBarHidden(true)
       
    }
    
}

struct LunchPage_Previews: PreviewProvider {
    static var previews: some View {
        LunchPage()
    }
}
