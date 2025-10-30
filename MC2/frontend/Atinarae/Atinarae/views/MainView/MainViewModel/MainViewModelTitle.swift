//
//  MainViewModel.swift
//  Atinarae
//
//  Created by A_Mcflurry on 2023/05/04.
//

//  ----------------------------------------------------------------------
//                  메인뷰의 최상단에 위치하는 뷰모델.
//                  배경이 흰색이라 안보이는데 다 있긴 합니다
//                  배경화면 주석 지우면 나옵니다
//  ----------------------------------------------------------------------

import SwiftUI

struct MainViewModelTitle: View {
    var body: some View {
        ZStack{
            // Color.backGroundColor
            HStack{
                Image("Title")
                    .resizable()
                    .frame(width : 150, height: 25)
                
                Spacer()
                Image(systemName: "bell")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 25, height: 25)
                    .padding(.trailing)
                    
                Image(systemName: "person.circle")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 25, height: 25)
                    
            }
            .padding()
        }
    }
}





struct MainViewModel_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            MainViewModelTitle()
        }
    }
}
