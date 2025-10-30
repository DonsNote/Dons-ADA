//
//  ArtistProfileSettingView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI

struct ArtistProfileSettingView: View {
    
    //MARK: -1.PROPERTY
    @EnvironmentObject var awsService : AwsService
    @StateObject var viewModel = UserArtistProfileSettingViewModel()
    @Environment(\.dismiss) var dismiss
    @Binding var onDismiss: Bool
    
    //MARK: -2.BODY
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                profileSection
                
                customDivider()
                
                firstSection
                
                customDivider()
                
                thirdSection
                
                Spacer()
            }
            .background(backgroundView().ignoresSafeArea())
            .overlay(alignment: .topLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.down")
                        .font(.custom20semibold())
                        .padding(.init(top: UIScreen.getWidth(20), leading: UIScreen.getWidth(20), bottom: UIScreen.getWidth(0), trailing: UIScreen.getWidth(0)))
                }
            }
            .navigationTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $viewModel.popAddBusking, content: {
                AddBuskingPageView(viewModel: AddBuskingPageViewModel())
            })
        }
    }
}

//MARK: -4.EXTENSION

extension ArtistProfileSettingView {
    var profileSection: some View {
        HStack(spacing: UIScreen.getWidth(20)) {
            CircleBlur(image: awsService.user.artist?.artistImage ?? "", width: 120)
            
            VStack(alignment: .leading) {
                HStack{
                    Image(systemName: "person.circle.fill").font(.custom18semibold())
                    Text(awsService.user.artist?.stageName ?? "").font(.custom21black())
                }
                
                .padding(.bottom, UIScreen.getWidth(15))
            }.padding(.top, UIScreen.getWidth(15)).shadow(color: .black.opacity(0.4),radius: UIScreen.getWidth(5))
            Spacer()
        }
        .padding(.init(top: UIScreen.getWidth(40), leading: UIScreen.getWidth(20), bottom: UIScreen.getWidth(10), trailing: UIScreen.getWidth(20)))
    }
    
    var firstSection: some View {
        VStack(alignment: .leading) {
            NavigationLink {
                UserArtistPageView()
            } label: {
                Text("아티스트 페이지 관리")
                    .font(.custom13bold())
                    .padding(UIScreen.getWidth(20))
                    .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
            }
            NavigationLink {
                AddBuskingPageView(viewModel: AddBuskingPageViewModel())
            } label: {
                Text("공연 등록")
                    .font(.custom13bold())
                    .padding(UIScreen.getWidth(20))
                    .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
            }
            NavigationLink {
                MyBuskingSettingView()
            } label: {
                Text("공연 관리")
                    .font(.custom13bold())
                    .padding(UIScreen.getWidth(20))
                    .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
            }
        }
    }
    
    
    var secondSection: some View {
        VStack(alignment: .leading) {
            Toggle(isOn: $viewModel.switchNotiToggle, label: {
                Text("알림 설정")
                    .font(.custom13bold())
                    .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                
            }) .tint(.cyan.opacity(0.2))
        }.padding(.init(top: UIScreen.getWidth(15), leading: UIScreen.getWidth(20), bottom: UIScreen.getWidth(15), trailing: UIScreen.getWidth(20)))
    }
    
    
    var thirdSection: some View {
        VStack(alignment: .leading) {
            Button{
                dismiss()
            } label: {
                Text("개인 계정 전환")
                    .font(.custom13bold())
                    .padding(UIScreen.getWidth(20))
                    .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
            }
            
            NavigationLink {
                EditArtistAcountView(onDismiss: $onDismiss)
            } label: {
                Text("아티스트 계정 관리")
                    .font(.custom13bold())
                    .padding(UIScreen.getWidth(20))
                    .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
            }
        }
    }
}

