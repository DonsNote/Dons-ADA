//
//  MainView.swift
//  Atinarae
//
//  Created by A_Mcflurry on 2023/05/04.
//

//  -------------------------------------------------------------------------------------
//          메인 뷰
//          MainViewModel폴더에 있는 여러 ViewModel들을 가져와 만들었습니다
//          지오메트리리더를 사용해서 화면 크기가 달라져도 일정 비율을 유지할 수 있게 만들었고요.
//          행성을 눌러 디테일뷰로 들어갈때 여기서 DetailView로 넘겨주는 값으로 사람을 판별하면 될듯합니다.
//  ------------------------------------------------------------------------------------


import SwiftUI

struct MainView: View {
    @State var tag: Int? = nil   // 화면 이동을 위한 tag.
    
    var body: some View {
            ZStack{
            Color.backGroundColor.ignoresSafeArea()
            GeometryReader{ geometry in
                
                VStack{
                    MainViewModelTitle()
                        .frame(width: geometry.size.width, height: geometry.size.height/6)
                    
                    MainViewModelGeometry()
                        .frame(width: geometry.size.width, height: geometry.size.height/2)
                    
                    
                        Button{
                            self.tag = 1
                        } label: {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(
                                    AngularGradient(gradient: Gradient(colors: [.buttonColor, .buttonColor1]), center: .top)
                                        )
                                .frame(width: geometry.size.width/3, height: 50)
                                .overlay{
                                    HStack{
                                        Image(systemName: "paperplane")
                                            .foregroundColor(.black)
                                        Text("메세지보내기")
                                            .foregroundColor(.black)
                                            .font(.subheadline).bold()
                                    }
                                }

                    }
                        .frame(width: geometry.size.width, height: geometry.size.height/3)
                }
                NavigationLink(destination: CameraDummyView(), tag : 1, selection: self.$tag){}
            }
                
        }
        // navigatinBar를 지우겠다는 신념
        .navigationBarTitle("")
        .navigationBarHidden(true)
        
        
        }
       
        
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            MainView()
        }
    }
}

