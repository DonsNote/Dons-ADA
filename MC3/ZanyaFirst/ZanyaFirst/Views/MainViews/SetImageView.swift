////
////  File.swift
////  ZanyaFirst
////
////  Created by Kimjaekyeong on 2023/07/18.
////
//
//
////MARK: - 셋 이미지랑 셋 네임이랑 디자인단에서 합쳐지면서 얘는 셋 프로필에 병합되었음 // 고로 안쓰고 있지만 걍 냅둠
//import SwiftUI
//
//struct SetImageView: View {
//    
//    //MARK: -1. PROPERTY
// //   let cats : [[String]] = [["blueCat","scotCat","oddCat"],["blackCat","blueCat","shamCat"]]
//    let cats : [[String]] = [["LivProfile", "BinuProfile", "DonProfile"],["DdanProfile", "SeanProfile", "BaronProfile"]]
//    let profileArray = ProfileImageArray
//    @StateObject private var viewModel = SetImageViewModel()
//    
//    //MARK: -2. BODY
//    var body: some View {
//        VStack{
//            header
//                //     catsBtn
//            Spacer()
//            completeButton
//        }
//        .navigationBarBackButtonHidden(true)
//        .padding()
////        .background(
////            NavigationLink(destination: MainView(viewModel: MainViewModel(profile: viewModel.profile), room: <#Room#>),isActive: $viewModel.goToMainView){
////            
////        })
//    }
//}
////MARK: -3. PREVIEW
//struct SetImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        SetImageView()
//    }
//}
//
//extension SetImageView {
//    private var header: some View {
//        Text("고양이를 선택해주세요")
//            .font(.headline)
//            .underline()
//    }
//    
////    private var catsBtn: some View {
////        ForEach(self.cats, id: \.self){ catsRaw in
////            HStack{
////                ForEach(catsRaw, id: \.self){ cat in
////                    Button {
////                        viewModel.clickedCatBtn(cat)
////                    } label: {
////                        Image(profileArray[cat])
////                            .resizable()
////                            .scaledToFit()
////                            .padding()
////                    }
////                }
////            }
////        }
////    }
//    
//    private var completeButton: some View {
//        Button {
//            viewModel.completeButtonPressed()
//        } label: {
//            Text("완료")
//                .font(.headline)
//                .foregroundColor(.white)
//                .frame(height: 55)
//                .frame(maxWidth: .infinity)
//                .background(Color.blue)
//                .cornerRadius(10)
//                
//        }
//    }
//    
//}
