//
//  UserArtistPageView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI
import PhotosUI

struct UserArtistPageView: View {
    
    //MARK: -1.PROPERTY
    @EnvironmentObject var awsService: AwsService
    @StateObject var viewModel = UserArtistPageViewModel()
    
    //MARK: -2.BODY
    var body: some View {
        ZStack {
            VStack(spacing: UIScreen.getWidth(5)) {
                if viewModel.croppedImage != nil { pickedImage }
                else { artistPageImage }
                artistPageTitle
                Spacer()
            }
            .blur(radius: viewModel.isEditSocial || viewModel.isEditName || viewModel.isEditInfo ? 15 : 0)
            if viewModel.isEditSocial || viewModel.isEditName || viewModel.isEditInfo {
                Color.black.opacity(0.1)
                    .onTapGesture {
                        viewModel.isEditSocial = false
                        viewModel.isEditName = false
                        viewModel.isEditInfo = false
                    }
            }
            if viewModel.isEditSocial {
                editSocialSheet
            }
            if viewModel.isEditName {
                editNameSheet
            }
            if viewModel.isEditInfo {
                editInfoSheet
            }
            if viewModel.socialSaveOKModal {
                PopOverText(text: "저장되었습니다")
            }
            if viewModel.nameSaveOKModal {
                PopOverText(text: "저장되었습니다")
            }
            if viewModel.infoSaveOKModal {
                PopOverText(text: "저장되었습니다")
            }
        }
        .background(backgroundView())
        .ignoresSafeArea()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) { firstToolbarItem.opacity(viewModel.isEditSocial || viewModel.isEditName || viewModel.isEditInfo ? 0 : 1) }
            ToolbarItem(placement: .topBarTrailing) { secondToolbarItem.opacity(viewModel.isEditSocial || viewModel.isEditName || viewModel.isEditInfo ? 0 : 1) }
        }
        .cropImagePicker(show: $viewModel.popImagePicker, croppedImage: $viewModel.croppedImage, isLoding: $viewModel.isLoading)
        .onChange(of: viewModel.selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    viewModel.selectedPhotoData = data
                }
            }
        }
        .onChange(of: viewModel.selectedPhotoData) { newValue in
            if let data = newValue, let uiImage = UIImage(data: data) {
                viewModel.copppedImageData = data
                viewModel.croppedImage = uiImage
                viewModel.popImagePicker = false
            }
        }
        .onAppear {
            if let urlString = awsService.user.artist?.artistImage, let url = URL(string: urlString) {
                loadImage(from: url) }
            viewModel.youtubeURL = awsService.user.artist?.youtubeURL ?? ""
            viewModel.instagramURL = awsService.user.artist?.instagramURL ?? ""
            viewModel.soundcloudURL = awsService.user.artist?.soundcloudURL ?? ""
            viewModel.editUsername = awsService.user.artist?.stageName ?? ""
            viewModel.editUserInfo = awsService.user.artist?.artistInfo ?? ""
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationTitle("")
    }
}




//MARK: -4.EXTENSION
extension UserArtistPageView {
    var artistPageImage: some View {
        AsyncImage(url: URL(string: awsService.user.artist?.artistImage ?? "")) { image in
            image.resizable().aspectRatio(contentMode: .fit)
        } placeholder: {
            ProgressView()
        }
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenWidth)
        .mask(LinearGradient(gradient: Gradient(colors: [Color.black,Color.black,Color.black, Color.clear]), startPoint: .top, endPoint: .bottom))
        .overlay (
            HStack(spacing: UIScreen.getWidth(10)){
                if awsService.user.artist?.youtubeURL != "" {
                    Button {
                        UIApplication.shared.open(URL(string: (awsService.user.artist?.youtubeURL)!)!)
                    } label: { linkButton(name: YouTubeLogo).shadow(color: .black.opacity(0.4),radius: UIScreen.getWidth(5)) }
                }
                if awsService.user.artist?.instagramURL != "" {
                    Button {
                        UIApplication.shared.open(URL(string: (awsService.user.artist?.instagramURL)!)!)
                    } label: { linkButton(name: InstagramLogo).shadow(color: .black.opacity(0.4),radius: UIScreen.getWidth(5)) }
                }
                
                if awsService.user.artist?.soundcloudURL != "" {
                    Button {
                        UIApplication.shared.open(URL(string: (awsService.user.artist?.soundcloudURL)!)!)
                    } label: { linkButton(name: SoundCloudLogo).shadow(color: .black.opacity(0.4),radius: UIScreen.getWidth(5)) }
                }
                
                if viewModel.isEditMode == true {
                    Button { viewModel.isEditSocial = true } label: {
                        Image(systemName: "pencil.circle.fill")
                            .font(.custom20semibold())
                            .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                    }
                }
            }
                .frame(height: UIScreen.getHeight(25))
                .padding(.init(top: 0, leading: 0, bottom: UIScreen.getWidth(20), trailing: UIScreen.getWidth(15))), alignment: .bottomTrailing )
        .overlay(alignment: .bottom) {
            if viewModel.isEditMode {
                Button{
                    viewModel.popImagePicker = true
                } label: {
                    Image(systemName: "camera.circle.fill")
                        .font(.custom40bold())
                        .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                }
            }
        }
    }
    
    var pickedImage: some View {
        Image(uiImage: viewModel.croppedImage!)
            .resizable()
            .scaledToFit()
            .mask(LinearGradient(gradient: Gradient(colors: [Color.black,Color.black,Color.black, Color.clear]), startPoint: .top, endPoint: .bottom))
            .overlay (
                HStack(spacing: UIScreen.getWidth(10)){
                    if awsService.user.artist?.youtubeURL != "" {
                        Button {
                            UIApplication.shared.open(URL(string: (awsService.user.artist?.youtubeURL)!)!)
                        } label: { linkButton(name: YouTubeLogo).shadow(color: .black.opacity(0.4),radius: UIScreen.getWidth(5)) }
                    }
                    if awsService.user.artist?.instagramURL != "" {
                        Button {
                            UIApplication.shared.open(URL(string: (awsService.user.artist?.instagramURL)!)!)
                        } label: { linkButton(name: InstagramLogo).shadow(color: .black.opacity(0.4),radius: UIScreen.getWidth(5)) }
                    }
                    
                    if awsService.user.artist?.soundcloudURL != "" {
                        Button {
                            UIApplication.shared.open(URL(string: (awsService.user.artist?.soundcloudURL)!)!)
                        } label: { linkButton(name: SoundCloudLogo).shadow(color: .black.opacity(0.4),radius: UIScreen.getWidth(5)) }
                    }
                    
                    if viewModel.isEditMode == true {
                        Button { viewModel.isEditSocial = true } label: {
                            Image(systemName: "pencil.circle.fill")
                                .font(.custom20semibold())
                                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                        }
                    }
                }
                    .frame(height: UIScreen.getHeight(25))
                    .padding(.init(top: 0, leading: 0, bottom: UIScreen.getWidth(20), trailing: UIScreen.getWidth(15))), alignment: .bottomTrailing )
            .overlay(alignment: .bottom) {
                if viewModel.isEditMode {
                    PhotosPicker(
                        //TODO: 사진첩 접근해서 사진 받는 거 구현
                        selection: $viewModel.selectedItem,
                        matching: .images,
                        photoLibrary: .shared()) {
                            Image(systemName: "camera.circle.fill")
                                .font(.custom40bold())
                                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                        }
                }
            }
    }
    
    var artistPageTitle: some View {
        return VStack{
            ZStack {
                Text(awsService.user.artist?.stageName ?? "Artist Name")
                    .font(.custom40black())
                if viewModel.isEditMode == true {
                    HStack {
                        Spacer()
                        Button {
                            viewModel.isEditName = true
                        } label: {
                            Image(systemName: "pencil.circle.fill")
                                .font(.custom20semibold())
                                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                                .padding(.horizontal)
                        }
                    }
                }
            }
            ZStack {
                Text(awsService.user.artist?.artistInfo ?? "Insert artist infomation")
                    .font(.custom13heavy())
                if viewModel.isEditMode == true {
                    HStack {
                        Spacer()
                        Button { viewModel.isEditInfo = true } label: {
                            Image(systemName: "pencil.circle.fill")
                                .font(.custom20semibold())
                                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
                                .padding(.horizontal)
                        }
                    }
                }
            }
        }.padding(.bottom, UIScreen.getHeight(20))
        
    }
    
    var artistPageFollowButton: some View {
        Button { } label: {
            Text("Follow")
                .font(.custom21black())
                .padding(.init(top: UIScreen.getHeight(7), leading: UIScreen.getHeight(30), bottom: UIScreen.getHeight(7), trailing: UIScreen.getHeight(30)))
                .background{ Capsule().stroke(Color.white, lineWidth: UIScreen.getWidth(2)) }
                .shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(5))
        }
    }
    
    //Cancle Button
    var firstToolbarItem: some View {
        if viewModel.isEditMode {
            return AnyView(Button {
                viewModel.isEditMode = false
                viewModel.croppedImage = nil
                viewModel.isEditSocial = false
                viewModel.isEditName = false
                viewModel.isEditInfo = false
            } label: {
                toolbarButtonLabel(buttonLabel: "Cancle").shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(8))
            })
        } else {
            return AnyView(EmptyView())
        }
    }
    
    
    //Save Button
    var secondToolbarItem: some View {
        if viewModel.isEditMode {
            return AnyView(Button{
                viewModel.isEditMode = false
                viewModel.isEditSocial = false
                viewModel.isEditName = false
                viewModel.isEditInfo = false
                awsService.artistPatchcroppedImage = viewModel.croppedImage
                awsService.patchUserArtistProfile { }
            } label: {
                toolbarButtonLabel(buttonLabel: "Save").shadow(color: .black.opacity(0.7),radius: UIScreen.getWidth(8))
            })
        } else {
            return AnyView(Button{
                viewModel.isEditMode = true
            } label: {
                toolbarButtonLabel(buttonLabel: "Edit").shadow(color: .black.opacity(0.5),radius: UIScreen.getWidth(8))
            })
        }
    }
    
    var editSocialSheet: some View {
        VStack(alignment: .leading, spacing: UIScreen.getWidth(10)) {
            HStack {
                Image(YouTubeLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.getWidth(20))
                Text("Youtube")
                    .font(.custom14semibold())
            }
            TextField(awsService.user.artist?.youtubeURL ?? "Insert Youtube URL", text: $viewModel.youtubeURL)
                .font(.custom10semibold())
                .padding(UIScreen.getWidth(12))
                .background(.ultraThinMaterial)
                .cornerRadius(6)
            HStack {
                Image(InstagramLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.getWidth(20))
                Text("Instagram")
                    .font(.custom14semibold())
            }
            TextField(awsService.user.artist?.instagramURL ?? "Insert Instagram URL", text: $viewModel.instagramURL)
                .font(.custom10semibold())
                .padding(UIScreen.getWidth(12))
                .background(.ultraThinMaterial)
                .cornerRadius(6)
            HStack {
                Image(SoundCloudLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.getWidth(20))
                Text("SoundCloud")
                    .font(.custom14semibold())
            }
            TextField(awsService.user.artist?.soundcloudURL ?? "Insert Soundcloud URL", text: $viewModel.soundcloudURL)
                .font(.custom10semibold())
                .padding(UIScreen.getWidth(12))
                .background(.ultraThinMaterial)
                .cornerRadius(6)
            Button {
                awsService.user.artist?.youtubeURL = viewModel.youtubeURL
                awsService.user.artist?.instagramURL = viewModel.instagramURL
                awsService.user.artist?.soundcloudURL = viewModel.soundcloudURL
                viewModel.isEditSocial = false
            } label: {
                HStack {
                    Spacer()
                    Text("Save")
                    Spacer()
                }
                .font(.custom14semibold())
                .padding(UIScreen.getWidth(14))
                .background(LinearGradient(colors: [.appSky ,.appIndigo1, .appIndigo2], startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(6)
            }.padding(.top, UIScreen.getWidth(26))
        }.padding(.init(top: UIScreen.getWidth(10), leading: UIScreen.getWidth(10), bottom: UIScreen.getWidth(10), trailing: UIScreen.getWidth(10)))
    }
    
    var editNameSheet: some View {
        VStack(alignment: .leading, spacing: UIScreen.getWidth(10)) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.getWidth(20))
                    .padding(.leading, UIScreen.getWidth(3))
                Text("Artist name").font(.custom14semibold())
            }
            TextField(awsService.user.artist?.stageName ?? "Insert artist name", text: $viewModel.editUsername)
                .font(.custom10semibold())
                .padding(UIScreen.getWidth(12))
                .background(.ultraThinMaterial)
                .cornerRadius(6)
            Button {
                awsService.user.artist?.stageName = viewModel.editUsername
                
                withAnimation(.smooth(duration: 0.5)) {
                    viewModel.nameSaveOKModal = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        viewModel.nameSaveOKModal = false
                        viewModel.isEditName = false
                    }
                }
            } label: {
                HStack {
                    Spacer()
                    Text("Save")
                    Spacer()
                }
                .font(.custom14semibold())
                .padding(UIScreen.getWidth(14))
                .background(LinearGradient(colors: [.appSky ,.appIndigo1, .appIndigo2], startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(6)
            }
        }
        .padding(.horizontal, UIScreen.getWidth(10))
        .presentationDetents([.height(UIScreen.getHeight(150))])
        .presentationDragIndicator(.visible)
    }
    
    var editInfoSheet: some View {
        VStack(alignment: .leading, spacing: UIScreen.getWidth(10)) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.getWidth(20))
                    .padding(.leading, UIScreen.getWidth(3))
                Text("Artist Info").font(.custom14semibold())
            }
            TextField(awsService.user.artist?.artistInfo ?? "Insert artist Info", text: $viewModel.editUserInfo)
                .font(.custom10semibold())
                .padding(UIScreen.getWidth(12))
                .background(.ultraThinMaterial)
                .cornerRadius(6)
            //editInfoSheet Button
            Button {
                awsService.user.artist?.artistInfo = viewModel.editUserInfo
                withAnimation(.smooth(duration: 0.5)) {
                    viewModel.infoSaveOKModal = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        viewModel.infoSaveOKModal = false
                        viewModel.isEditInfo = false
                    }
                }
            } label: {
                HStack {
                    Spacer()
                    Text("Save")
                    Spacer()
                }
                .font(.custom14semibold())
                .padding(UIScreen.getWidth(14))
                .background(LinearGradient(colors: [.appSky ,.appIndigo1, .appIndigo2], startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(6)
            }
        }
        .padding(.horizontal, UIScreen.getWidth(10))
        .presentationDetents([.height(UIScreen.getHeight(150))])
        .presentationDragIndicator(.visible)
    }
    
    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    viewModel.croppedImage = image
                }
            }
        }.resume()
    }
}
