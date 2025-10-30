//
//  MainView.swift
//  ZanyaFirst
//
//  Created by Kimjaekyeong on 2023/07/18.
//

import SwiftUI


struct MainView: View {
    
    //MARK: -1. PROPERTY
    //권한설정 요구하는 거임
    @EnvironmentObject var lnManager: LocalNotificationManager
    @StateObject var viewModel: MainViewModel
    @StateObject var alertObject = CustomAlertObject()
    
    @Environment(\.scenePhase) var scenePhase
    
    @State private var isCreateButtonClicked : Bool = false
    @State private var path = NavigationPath()
    @State private var profileNumber: Int = 0
    
    let profileArray = ProfileImageArray
    
    //MARK: 프리뷰하려고 더미룸 데이터 넣고 뿌림
    //var rooms : [RoomViewModel] = dummyRoomViewModels//TODO: 프리뷰 용임 //올리기 전에 지워야함
    
    //MARK: - 2. BODY
    var body: some View {
        NavigationView {
            ZStack{
                Group {
                    MainPageBackground
                        .zIndex(1)
                    MainPageProfileButton
                        .zIndex(2)
                    MainPageRoomList
                        .zIndex(3)
                    MainPageCreateRoomBtn
                        .zIndex(4)
                }
                .blur(radius: alertObject.isClicked ? 7.5 : 0, opaque: false)
                
                CustomAlertView(task: $viewModel.task)
                    .environmentObject(alertObject)
                    .zIndex(alertObject.isClicked ? 5 : 0)
                    .onChange(of: alertObject.isClicked) { newValue in
                        print("ROOM NAME \(newValue)")
//                        viewModel.fetchItem()
                    }
            }
            .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)
        .task {
            try? await lnManager
                .requestAuthorization()
            
        }// task
        .task(id: viewModel.task) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                viewModel.fetchItem()
            }
        }
        .onChange(of: scenePhase) { newValue in
            if newValue == .active {
                Task {
                    await lnManager
                        .getCurrentSetting()
                    await lnManager
                        .getCurrentSetting()
                }
            }
        }// onChange
    }// body
}// MainView


//MARK: -3. PREVIEW
struct MainView_Preview: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel(profile: dummyProfile4))
            .environmentObject(LocalNotificationManager())
    }
}

//MARK: -4. EXTENSION
extension MainView {
    private var MainPageBackground: some View {
        ZStack {
            Image(MainPageSheetImage)
                .resizable()
                .ignoresSafeArea()
            VStack {
                Image(RoomListImage)
                    .padding(.top, 51)
                Spacer()
            }
        }
    }
    
    private var MainPageProfileButton: some View {
        VStack{
            HStack{
                Spacer()
                //TODO: - 프로필 설정 페이지로 이동
                NavigationLink {
                    UpdateProfileView(viewModel: UpdateProfileViewModel(profile: viewModel.profile, delegate: viewModel))
                } label: {
                    ZStack {
                        Image(MainPageProfileBag)
                            .shadow(color: .black.opacity(0.25), radius: 3, x: 0, y: 4)
                        Image("\(viewModel.profile.imageKey ?? "")_MainProfile")
                        //                        Image("setProfileGentle_MainProfile") // 테스트이미지
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28.22)
                            .padding(.top, 11.69)
                    }
                }
                .padding(EdgeInsets(top: 43, leading: 0, bottom: 0, trailing: 18))
            }
            Spacer()
        }
    }
    
    private var MainPageCreateRoomBtn: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                
                NavigationLink {
                    CreateRoomView(task: $viewModel.task)
                } label: {
                    ClearRectangle(width: 121, height: 34, ClearOn: true)
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 36.8, trailing: 10))
            }
        }
    }
    
    private var MainPageRoomList: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                ForEach(viewModel.rooms, id: \.self) { room in
                    NavigationLink{
                        if viewModel.timeComponets.hour! == Calendar.current.dateComponents([.hour,.minute], from: room.time).hour! && viewModel.timeComponets.minute! == Calendar.current.dateComponents([.hour,.minute], from: room.time).minute!{
                            RoomView(viewModel: RoomViewModel(allUsers: viewModel.allUsers, users: [viewModel.profile], roomInfo: room))
//                            , timeRemaining: Int(180-Date().timeIntervalSince(room.time))
                        } else {
                            RoomDisableView(viewModel: RoomDisableViewModel(room: room))
                        }
                        
                        
                    } label: {
                        //TODO: isOnTime 로직 구현해야함
                        if viewModel.nowIsOnTime(room: room) {
                            RoomCell(viewModel: RoomCellViewModel(isOnTime: true, room: room) ,UID: viewModel.profile.UID)
                                .environmentObject(alertObject)
                        }else {
                            RoomCell(viewModel: RoomCellViewModel(isOnTime: false, room: room) ,UID: viewModel.profile.UID)
                                .environmentObject(alertObject)
                        }
                    }// label
                }// ForEach
            }// ScrollView
            .refreshable {
                viewModel.fetchItem()
            }
            .scrollIndicators(.hidden)
            .padding(.init(top: 183, leading: 0, bottom: 100, trailing: 0))
        }
    }
    
    private var outMessage: some View {
        ZStack{
            Image(BlurRectangle)
            Image(outMessageSheet)
                .resizable()
                .frame(width: 300, height: 160)
                .shadow(color: .black.opacity(0.25), radius: 3, x: 0, y: 4)
            
            VStack{
                Spacer()
                HStack(spacing: 0){
                    Button {
                        print("cancle")
                    } label: {
                        Image(outMessageCancleButton)
                            .resizable()
                            .frame(width: 138, height: 46.01)
                    }.padding(.leading, 8)
                    Spacer()
                    Button {
                        print("out")
                    } label: {
                        Image(outMessageOutButton)
                            .resizable()
                            .frame(width: 138, height: 46.01)
                    }
                    .padding(.trailing, 8)
                }
                .padding(.bottom,10.37)
            }
            .frame(width: 300, height: 166)
        }
        .frame(width: screenWidth, height: screenHeight)
        .background(.ultraThinMaterial)
    }
    
    private var inviteMessage: some View {
        ZStack{
            Image(BlurRectangle)
            Image(inviteMessageSheet)
                .resizable()
                .frame(width: 300, height: 160)
                .shadow(color: .black.opacity(0.25), radius: 3, x: 0, y: 4)
            
            VStack{
                Spacer()
                HStack(spacing: 0){
                    Button {
                        print("cancle")
                    } label: {
                        Image(inviteMessageCancelButton)
                            .resizable()
                            .frame(width: 138, height: 46.01)
                    }
                    .padding(.leading, 8)
                    Spacer()
                    Button {
                        print("invite")
                    } label: {
                        Image(inviteMessageInviteButton)
                            .resizable()
                            .frame(width: 138, height: 46.01)
                    }
                    .padding(.trailing, 8)
                    
                }
                .padding(.bottom,10.37)
            }
            .frame(width: 300, height: 166)
        }
        .frame(width: screenWidth, height: screenHeight)
            .background(.ultraThinMaterial)
    }
}

extension Date {
    var displayFormat: String {
        self.formatted(
            .dateTime
                .hour(.twoDigits(amPM: .omitted))
                .minute(.twoDigits)
        )
    }
}
extension View {
    func hideKeyboardWhenTappedAround() -> some View {
        return self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
