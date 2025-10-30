//
//  SetNameView.swift
//  ZanyaFirst
//
//  Created by Kimjaekyeong on 2023/07/18.
//

import SwiftUI

struct SetProfileView: View {
    
    //TODO: 입력된 프로필을 Cloud에 올리는 로직 작업 필요. 버튼 클릭시 로그는 찍힘.
    
    //MARK: -1. PROPERTY
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = SetProfileViewModel()
    @ObservedObject var keyboardMonitor : KeyboardMonitor = KeyboardMonitor()
    
    let profileArray = ProfileImageArray
    let setProfileImageArray = SetPrifileCatArray
    
    
    //MARK: -2. BODY
    var body: some View {
        NavigationView {
            ZStack{
                SetProfileBackground
                dismissButton
                
                // 키보드가 올라올 때 뷰를 미는 걸 방지하기 위해 Geometry 사용함.
                GeometryReader { geo in
                    VStack(spacing: 0) {
                        catArray
                        textField
                        Spacer()
                        completeButton
                            .background(
                                NavigationLink(destination: MainView(viewModel: MainViewModel(profile: viewModel.profile)),isActive: $viewModel.goToMainView){
                                })
                    }// VStack
                    .padding(.top, UIApplication.shared.windows[0].safeAreaInsets.top)
                }
            }// ZStack
            .ignoresSafeArea()
        }// NavigationView
        .navigationBarBackButtonHidden()
        .hideKeyboardWhenTappedAround()
        .onAppear{
            print("user name: \(viewModel.name)")
        }
        .animation(.easeOut(duration: 0.1), value: keyboardMonitor.isKeyboardUP)
        .confirmationDialog(
            "프로필이 생성되었습니다",
            isPresented: $viewModel.isCompleted,
            titleVisibility: .visible
        ) {
            Button("OK", role: .cancel) {
                viewModel.goToMainView = true
            }
        } message: {
            Text("")
        }
        
    }// body
}// SetProfileView

//MARK: -3. PREVIEW
struct SetProfileView_Previews: PreviewProvider {
    static var previews: some View {
        SetProfileView()
    }
}

//MARK: -4. EXTENSION
extension SetProfileView {
    
    
    private var SetProfileBackground: some View {
        ZStack {
            Image(SetProfileBackgroundSheet)
                .resizable()
                .aspectRatio(contentMode: .fit)
            VStack{
                Image(SetProfileTitle)
                    .padding(.top, 51)
                Spacer()
            }
        }
    }// SetProfileBackground
    
    private var catArray: some View{
        VStack(alignment: .center, spacing: 0) {
            ForEach(setProfileImageArray, id: \.self) { catsRow in
                HStack(alignment: .center, spacing: 0){
                    ForEach(catsRow, id: \.self) { cat in
                        ZStack{
                            Image(viewModel.catName == cat ? ProfileCircleOn : ProfileCircleOff)
                                .frame(width: 82, height: 82)
                            Image(cat)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 56)
                        }
                        .onTapGesture {
                            viewModel.clickedCatBtn(cat)
                            print("\(cat) is selected")
                        }
                        .padding(7)
                    }// cat ForEach
                }
                // HStack
                
            }// catsRow ForEach
        }// VStack
        .padding(.horizontal, 46)
        .padding(.init(top: 97, leading: 0, bottom: 0, trailing: 0))
    }// catArray
    
    private var textField: some View{
        ZStack{
            Image(SetProfileTextField)
                .resizable()
                .aspectRatio(contentMode: .fit)
            //TODO: - 입력 카운트 및, 전체 삭제 버튼(optional한 작업. 공수 남으면 진행)
            TextField("닉네임", text: $viewModel.name)
                .padding(.horizontal)
        }.frame(width: 297)
            .padding(EdgeInsets(top: 7, leading: 46, bottom: 0, trailing: 46))
    }
    
    private var completeButton: some View{
        Button {
            print("name: \(viewModel.name), cat: \(viewModel.catName)")
            viewModel.completeButtonPressed()
        } label: {
            Image(viewModel.name == "" ? SetProfileCompleteButton_disabled : SetProfileCompleteButton)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(EdgeInsets(top: 0, leading: 22, bottom: 51, trailing: 22))
                .shadow(color: .black.opacity(0.15), radius: 5.5, x: 0, y: 4)
        }
        .offset(y: keyboardMonitor.keyboardHeight * -0.9)
        .disabled(viewModel.name == "" ? true : false)
    }
    
    private var dismissButton: some View {
        VStack{
            HStack{
                Button {
                    print("dismiss")
                    dismiss()
                } label: {
                    Image(SetPageXmark)
                }// label
                Spacer()
            }// HStack
            .padding(.init(top: 65, leading: 25, bottom: 0, trailing: 0))
            Spacer()
        }// VStack
    }// dismissButton
    
}


