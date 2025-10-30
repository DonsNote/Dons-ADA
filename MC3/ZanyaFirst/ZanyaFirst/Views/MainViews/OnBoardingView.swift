//
//  SplashViewSecond.swift
//  ZanyaFirst
//
//  Created by Kimjaekyeong on 2023/07/19.
//

import SwiftUI

struct OnBoardingView: View {
    //MARK: -1. PROPERTY
    
    init() {
        UINavigationBar.setAnimationsEnabled(false)
    }
    
    @StateObject private var viewModel = SplashViewModel()
    @State private var isBlinking = false
    
    //MARK: - 2. BODY
    var body: some View {
        NavigationView {
            
            ZStack(alignment: .top){
                Image(LaunchPageSheet)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                NavigationLink {
                    getDestination()
                } label: {
                    Image(LaunchStartButton)
                        .padding(.top, 703)
                        .opacity(isBlinking ? 0 : 1)
                }
            }
            .onAppear {
                viewModel.fetchUID()
                blinkAnimation()
    
            }
            .onOpenURL { url in
                let roomRecord = viewModel.parseURL(url: url)
                print("roomURL: \(roomRecord)")
                viewModel.addRoom(roomRecord: roomRecord)
            }
        }// NavigationView
    }// bodyㅐ
    
    private func blinkAnimation() {
        withAnimation(Animation.easeInOut(duration: 0.6).repeatForever()) {
            isBlinking.toggle()
            
        }
    }
    
    // 프로필 유무에 따른 분기를 위해 만든 함수.
    @ViewBuilder
    func getDestination() -> some View {
        switch viewModel.goToMainView {
        case true:
            MainView(viewModel: MainViewModel(profile: viewModel.profile))
        case false:
            SetProfileView()
        }
    }

    
    //MARK: -3. PREVIEW
    struct SplashView_Previews: PreviewProvider {
        static var previews: some View {
            OnBoardingView()
        }
    }
}

//MARK: -4. EXTENSION
extension String {
    func remove(target string: String) -> String {
        return components(separatedBy: string).joined()
    }
}
