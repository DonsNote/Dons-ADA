//
//  File.swift
//  ZanyaFirst
//
//  Created by Kimjaekyeong on 2023/07/18.
//

import SwiftUI

struct RoomView: View {
    
    //MARK: - 1. PROPERTY
    @StateObject var viewModel: RoomViewModel
    @ObservedObject var keyboardMonitor : KeyboardMonitor = KeyboardMonitor()
    
    @State var ArrayNum : Int = 0
    @State var PunchMessageToggle: Bool = true
    @State var tapIndexNum : Int = 0

    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("isFirst") var isFirst: Bool = UserDefaults.standard.bool(forKey: "isFirst")
    
    //    var profile: Profile
    let profileImageArray = ProfileImageArray
    
    //For DonAnimation
    @State private var changingDerees: Double = -10
    @State private var isItemEffect = false
    @State private var catHandIndex = 0
    @State private var touchCount = 0
    @State private var showShare: Bool = false
    
    @GestureState private var isDetectingContinuousPress = false
    
    //MARK: - 2. BODY
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Group {
                    backgroundPage
                    VStack(spacing: 0){
                        toolBar
                        Spacer()
                        bottomTab
                    }
                    HiddenTapButton
                    memberSheet
                        .padding(.bottom, 140)
                    if isDetectingContinuousPress {
                      Image("tutorial")
                          .resizable()
                          .scaledToFit()
                    } else {

                    }
                }
                .blur(radius: viewModel.timeRemaining == 0 ? 7.5 : 0, opaque: false)
              
                timeOver
            }

        }
        .navigationBarBackButtonHidden()
        .ignoresSafeArea()
        .toolbar(.hidden)
        .hideKeyboardWhenTappedAround()
        .animation(.easeOut(duration: 0.1), value: keyboardMonitor.isKeyboardUP)
        .onAppear {
            if !isFirst {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isFirst.toggle()
                }
            }
          
            viewModel.requestNotificationPermission()
            viewModel.subscribeToNotifications_Dog()
            viewModel.subscribeToNotifications_Cat()
            viewModel.subscribeToNotifications_Pig()
        }
        .sheet(
            isPresented: $showShare,
            onDismiss: {
                showShare = false
                print("\(showShare) onDismiss") },
            content: {
                ActivityView(text: viewModel.preFix + (viewModel.roomInfo.record?.recordID.recordName ?? ""))
                    .presentationDetents([.medium, .large])
            }
        )// Sheet
    }
}


//MARK: -3. PREVIEW
struct RoomView_Preview: PreviewProvider {
    static var previews: some View {
        RoomView(viewModel: RoomViewModel(allUsers: dummyProfiles, users: dummyProfiles, roomInfo: dummyRoom))
//        , timeRemaining: Int(Date().timeIntervalSince(dummyRoom.time))
    }
}


//MARK: - 4. EXTENSION
extension RoomView {
    
    private var backgroundPage: some View {
        ZStack(alignment: .topLeading){
            //배경화면
            Image(BackgroundSheet)

            //배경 서있는 고양이 이미지
            Image("\(viewModel.users[0].imageKey ?? "")_Standing") // 이미지 사이즈 확인을 위한 테스트용 이미지
                .resizable()
                .scaledToFit()
                .frame(width: 210)
                .padding(.init(top: 148, leading: 156.84, bottom: 0, trailing: 0))
            
            //펀치페이지 말풍선
            //            if !isFirst {
            //                //앱 설치 후 최초 방 진입 시 1번만 노출
            //                ZStack{
            //                    Image(MessageDialogSheet)
            //                        .shadow(color: .black.opacity(0.2), radius: 3.18533, x: 0, y: 4.24711)
            //                }
            //                .padding(.init(top: 112, leading: 13, bottom: 0, trailing: 0))
            //            } else
            
            ZStack(alignment: .center) {
                Image(PunchDialogSheet)
                    .shadow(color: .black.opacity(0.2), radius: 3.18533, x: 0, y: 4.24711)
                VStack(spacing: 0){
                    Text(viewModel.convertSecondsToTime(timeInSeconds: viewModel.timeRemaining))
                        .font(Font.custom("LINE Seed Sans KR Bold", size: 30))
                        .foregroundColor(viewModel.timeRemaining < 60 ? .AppRed : .AppGreen)
                        .onReceive(viewModel.timer) { _ in
                            if viewModel.timeRemaining > 0 {
                                viewModel.timeRemaining -= 1
                            } else {
                                print("time's up")
                                viewModel.timer.upstream.connect().cancel()
                            }
                            print(viewModel.timeRemaining)
                        }
                    Image(itsempty)
                }
                .padding(.bottom, 16)
            }
            .padding(.init(top: 104.96, leading: 13, bottom: 0, trailing: 0))
            
//            if PunchMessageToggle == true {
//
//            } else {
//                //메세지 페이지 말풍선
//                ZStack{
//                    Image(MessageDialogTutorial_2)
//                        .shadow(color: .black.opacity(0.2), radius: 3.18533, x: 0, y: 4.24711)
//                }
//                .padding(.init(top: 112, leading: 13, bottom: 0, trailing: 0))
//            }
        }
    }
    
    private var toolBar: some View {
        HStack(spacing: 0){
            //BackButton
            Button {
                print("clicked back button")
                dismiss()
            } label: {
                Image(NavigationBackButton)
                    .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 4)
            }
            
            //RoomTitle
            ZStack{
                Image(RoomTitleSheet)
                    .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 4)
                StrokedTextCellCenter(text: viewModel.roomInfo.name, size: 18, color: .white, strokeColor: AppNavy)
                    .padding(.bottom, 4)
            }
            .padding(.init(top: 0, leading: 13, bottom: 0, trailing: 13))
            
            //QuestionButton
            Button {
                print("clicked question mark button")
            } label: {
                Image(QuestionButton)
                    .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 4)
            }.simultaneousGesture(continuousPress)
        }
        .padding(.init(top: 53, leading: 15, bottom: 0, trailing: 15))
        .frame(maxWidth: screenWidth)
    }
    
    private var memberSheet: some View {
        ZStack(alignment: .bottomLeading) {
            Image(MemberSheet)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
            
            if viewModel.users.count != 6 {
                HStack(alignment: .center,spacing: 0) {
                    ForEach(0..<viewModel.users.count, id: \.self) { i in
                        ZStack(alignment: .center){
                            Image(ProfilePlateOff)
                            VStack {
                                //Spacer()
                                Image("\(viewModel.users[i].imageKey ?? "")_RoomSheet") // TODO: 룸데이터에서 유저 정보 받아와야함
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 48)
                                // Spacer()
                                ClearRectangle(width: 0,height: 6)
                            }
                            VStack{
                                Spacer()
                                Image(nameSheet)
                            }
                            VStack{
                                Spacer()
                                TextCell(text: viewModel.users[i].name, size: 11, color: Color("AppBrown"))
                                    .padding(.bottom, 4)
                            }
                        }
                        .frame(width: 48, height: 60)
                        .padding(.init(top: 0, leading: 11, bottom: -16.75, trailing: 0))
                    }
                    Button {
                        showShare.toggle()
                    } label: {
                        Image(InviteFriend)
                    }
                    .padding(.init(top: 0, leading: 8, bottom: -16.75, trailing: 0))
                    
                    
                    Spacer()
                }
                .frame(width: 360, height: 111.5)
                
            } else {
                HStack(alignment: .center,spacing: 0) {
                    ForEach(0..<viewModel.users.count, id: \.self) { i in
                        ZStack(alignment: .center){
                            Image(ProfilePlateOff)
                            VStack {
                                //Spacer()
                                Image("\(viewModel.users[i].imageKey ?? "")_RoomSheet") // TODO: 룸데이터에서 유저 정보 받아와야함
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 48)
                                // Spacer()
                                ClearRectangle(width: 0,height: 6)
                            }
                            VStack{
                                Spacer()
                                Image(i == 0 ? nameSheetMe : nameSheet)
                            }
                            VStack{
                                Spacer()
                                TextCell(text: viewModel.users[i].name, size: 11, color: Color("AppBrown"))
                                    .padding(.bottom, 4)
                            }
                        }
                        .frame(width: 48, height: 60)
                        .padding(.init(top: 0, leading: 11, bottom: -16.75, trailing: 0))
                    }
                    Spacer()
                }
                .frame(width: 360, height: 111.5)
            }
        }
    }
    
    private var bottomTab: some View {
        ZStack {
            punchPage
                .zIndex(PunchMessageToggle ? 1 : 0)
            messagePage
                .zIndex(PunchMessageToggle ? 0 : 1)
        }
    }
    
    var punchPage: some View {
        let SoundList = [Sounds.catcat, Sounds.pigpig, Sounds.dogdog]
        let punchElementPage = [TambourinePage, BBoongPage, DJPage]
        let punchElementPage2 = [TambourinePage2, BBoongPage2, DJPage2]
        let Punchelement = [Tambourine, BBoong, DJ]
        
        return ZStack(alignment: .bottom) {
            Image(PunchPage)
                .padding(.init(top: 0, leading: 0, bottom: -101, trailing: 0))
            
            ZStack(alignment: .center) {
                TabView{
                    ZStack(alignment: .center){
                        Image(punchElementPage2[tapIndexNum])
                            .zIndex(isItemEffect ? 2 : 0)
                        Image(punchElementPage[tapIndexNum])
                            .zIndex(1)
                        HStack{
                            Spacer()
                            Image(Punchelement[tapIndexNum])
                                .scaleEffect(isItemEffect ? 1.1 : 1.0)
                                .rotationEffect(isItemEffect ? .degrees(changingDerees) : .zero)
                                .onTapGesture {
                                    print("Tap ZStack")
                                    print("\(tapIndexNum)")
                                    //       EffectSound.shared.playEffectSound()    // 효과음 내는 곳
                                    playSound(sound: SoundList[tapIndexNum].rawValue)
                                    withAnimation {
                                        isItemEffect.toggle()   // 배경 물방울이랑 템버린 반응용 bool
                                    }
                                    touchCount += 1 // 고양이 왼손 오른손을 교차하기 위한 로직
                                    switch touchCount % 2 {
                                    case 0:
                                        catHandIndex = 2
                                    case 1:
                                        catHandIndex = 1
                                    default:
                                        break
                                    }
                                    if isItemEffect {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            catHandIndex = 0
                                            withAnimation {
                                                isItemEffect = false
                                                changingDerees *= -1
                                            }
                                        }
                                    }
                                    switch tapIndexNum {
                                    case 0 :
                                        viewModel.touchNyang()
                                    case 1:
                                        viewModel.touchPig()
                                    case 2:
                                        viewModel.touchDog()
                                    default:
                                        viewModel.touchNyang()
                                    }
                                }
                            Spacer()
                        }
                        .zIndex(3)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                HStack(spacing: 0){
                    Button {
                        if tapIndexNum == 0 {
                            tapIndexNum = 2}
                        else {
                            tapIndexNum -= 1
                        }
                        
                        print("\(tapIndexNum)")
                    } label: {
                        Image(InstrumentLeft)
                            .padding(.init(top: 0, leading: 3, bottom: 0, trailing: 0))
                    }
                    
                    Spacer()
                    
                    Button {
                        if tapIndexNum == 2 {
                            tapIndexNum = 0}
                        else {
                            tapIndexNum += 1
                        }
                        print("\(tapIndexNum)")
                    } label: {
                        Image(InstrumentRight)
                            .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 3))
                    }
                }
                .padding(.bottom, 37)
            }
            .frame(width: 360, height: 360)
            ///이 스택에 blur를 줘야 View가 안 밀림. blur 모디파이어 사용시, 새 뷰를 그리기 때문에 View가 밀릴 경우 역으로 blur를 줘가며 찾으면 됨.
            .blur(radius: 0)
            //고양이손
            if catHandIndex == 0 {
                Image("\(viewModel.users[0].imageKey ?? "")_Hand")
                    .resizable()
                    .scaledToFit()
            } else if catHandIndex == 1 {
                Image("\(viewModel.users[0].imageKey ?? "")_HandLeft")
                    .resizable()
                    .scaledToFit()
            } else if catHandIndex == 2 {
                Image("\(viewModel.users[0].imageKey ?? "")_HandRight")
                    .resizable()
                    .scaledToFit()
            }
        }
//        .blur(radius: 7.5)
    }
    
    private var messagePage: some View {
        let columns = Array(
            repeating: GridItem(.flexible(), spacing: -12),
            count: 3
        )
        return ZStack(alignment: .bottom){
            Image(MessagePage)
                .padding(.init(top: 0, leading: 0, bottom: -101, trailing: 0))
            Image(Rectangle77)
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 15) {
                    if viewModel.nyangSounds.count != 0  {
                        ForEach(0..<viewModel.nyangSounds.count, id: \.self) {i in //TODO: - 메세지 데이터에서 메세지 숫자 받기
                            Button {
                                print("message play")
                                switch viewModel.nyangSounds[i].soundType{
                                case "TTS1":
                                    speechMsg_TTS1(msg: viewModel.nyangSounds[i].messsage)
                                case "TTS2":
                                    speechMsg_TTS2(msg: viewModel.nyangSounds[i].messsage)
                                case "TTS3":
                                    speechMsg_TTS3(msg: viewModel.nyangSounds[i].messsage)
                                case "TTS4":
                                    speechMsg_TTS4(msg: viewModel.nyangSounds[i].messsage)
                                default:
                                    speechMsg_TTS1(msg: viewModel.nyangSounds[i].messsage)
                                }
                            } label: {
                                ZStack(alignment: .bottomLeading){
                                    Image(messageCell)
                                        .resizable()
                                        .frame(width: 105, height: 85)
                                    HStack {
                                        VStack(alignment: .leading){
                                            //                                            TextCell(text: "비누", size: 11, color: .white) // TODO: - 메세지 데이터에서 닉네임 받기
                                            TextCell(text: "\(viewModel.nyangSounds[i].whoSend)", size: 11, color: .white) // TODO: - 메세지 데이터에서 닉네임 받기
                                                .padding(.init(top: 0, leading: 10, bottom: -7, trailing: 0))
                                            TextCell(text: "20초", size: 10, color: .white) // TODO: - 메세지 데이터에서 시간 값 받기
                                                .padding(.init(top: 0, leading: 10, bottom: 10, trailing: 0))
                                        }
                                        Spacer()
                                        //Image("messageBox_WhiteCat") // TODO: - 메세지 데이터에서 프로필 이미지키 받기
                                        Image(viewModel.nyangSounds[i].imageKey)
                                            .resizable()
                                            .frame(width: 38.36, height: 31.54)
                                            .padding(.init(top: 0, leading: 0, bottom: 8.46, trailing: 9.64))
                                    }
                                }
                                .frame(width: 101, height: 81)
                            }
                        }
                    } else {
                        
                    }
                }
                .padding(.top, 12)
            }
            .frame(width: 362, height: 226)
            .padding(.init(top: 0, leading: 0, bottom: 136, trailing: 0))
            
            Rectangle().fill(LinearGradient(colors: [Color(AppIvory), .clear], startPoint: .top, endPoint: .bottom))
                .frame(width: 362, height: 30)
                .cornerRadius(6)
                .padding(.bottom, 334)
            
            Rectangle().fill(LinearGradient(colors: [Color(AppIvory), .clear], startPoint: .bottom, endPoint: .top))
                .frame(width: 362, height: 40)
                .cornerRadius(6)
                .padding(.bottom, 134)
            
            ZStack {
                Image(Rectangle33)
                
                VStack(spacing: 0){
                    //냥소리 TTS BUTTON
                    HStack(spacing: 0){
                        
                        Button {
                            print("clickedTTS1")
                            viewModel.soundType = "TTS1"
                        } label: {
                            Image(viewModel.soundType == "TTS1" ? TTS1ButtonImage : TTS1ButtonImage_disable)
                        }
                        .padding(.trailing, 4)
                        
                        Button {
                            print("clickedTTS2")
                            viewModel.soundType = "TTS2"
                        } label: {
                            Image(viewModel.soundType == "TTS2" ? TTS2ButtonImage : TTS2ButtonImage_disable)
                        }
                        .padding(.trailing, 4)
                        
                        Button {
                            print("clickedTTS3")
                            viewModel.soundType = "TTS3"
                        } label: {
                            Image(viewModel.soundType == "TTS3" ? TTS3ButtonImage : TTS3ButtonImage_disable)
                        }
                        .padding(.trailing, 4)
                        
                        Button {
                            print("clickedTTS4")
                            viewModel.soundType = "TTS4"
                        } label: {
                            Image(viewModel.soundType == "TTS4" ? TTS4ButtonImage : TTS4ButtonImage_disable)
                        }
                        .padding(.trailing, 4)
                        
                        Spacer()
                    }
                    .padding(.init(top: -10, leading: 15, bottom: 14, trailing: 15))
                    
                    HStack(spacing: 15){
                        ZStack{
                            Image(Rectangle11)
                            //냥소리 텍스트필드
                            HStack {
                                TextField("냥소리를 입력해보세요 :3", text: $viewModel.sendMessage)
                                Button {
                                    switch viewModel.soundType {
                                    case "TTS1":
                                        speechMsg_TTS1(msg: viewModel.sendMessage)
                                    case "TTS2":
                                        speechMsg_TTS2(msg: viewModel.sendMessage)
                                    case "TTS3":
                                        speechMsg_TTS3(msg: viewModel.sendMessage)
                                    case "TTS4":
                                        speechMsg_TTS4(msg: viewModel.sendMessage)
                                    default:
                                        speechMsg_TTS1(msg: viewModel.sendMessage)
                                    }
                                } label: {
                                    if viewModel.sendMessage != "" {
                                        Image(SoundEnableButtonImage)}
                                    else {
                                        Image(SoundDisableButtonImage)
                                    }
                                }
                            }
                            .frame(width:280)
                            .padding(.bottom, 2)
                            .padding(.leading, 6)
                        }
                        Button {
                            print("음성메세지 전송버튼") //TODO: 음성메세지 전송할 수 있게 하기
                            viewModel.sendNyangSound()
                        } label: {
                            if viewModel.sendMessage != "" {
                                Image(SendButtonActivate)}
                            else {
                                Image(SendButtonDisabled)
                            }
                        }
                    }
                    .padding(.bottom, 0)
                }
            }
            .offset(y: keyboardMonitor.keyboardHeight * -0.99)
        }
    }
    
    private var HiddenTapButton: some View {
        HStack{
            Button {
                PunchMessageToggle = true
            } label: {
                Rectangle()
                    .frame(height: 50)
            }
            Button {
                PunchMessageToggle = false
            } label: {
                Rectangle()
                    .frame(height: 50)
            }
        }
        .offset(y: 20)
        .foregroundColor(.clear)
        .padding(0)
    }
    
    private var timeOver: some View {
        ZStack {
            Rectangle().fill(.white.opacity(0.5))
            Image(TimeOverLogo)
                .resizable()
                .aspectRatio(contentMode: .fit)
            Button {
                print("강조되고 반복되는 소리는 비누를 불안하게 해요.")
                dismiss()
            } label: {
                Image(TimeOverButton)
            }
            .padding(.top, 703)

        }
        .opacity(viewModel.timeRemaining == 0 ? 1 : 0)
    }
    
    func tapElement() {
        if ArrayNum == 2 {
            ArrayNum = 0
        } else {
            ArrayNum += 1 }
    }
    
    var continuousPress: some Gesture {
        LongPressGesture(minimumDuration: 0.1)
            .sequenced(before: DragGesture(minimumDistance: 0, coordinateSpace: .local))
            .updating($isDetectingContinuousPress) { value, gestureState, _ in
                switch value {
                case .second(true, nil):
                    gestureState = true
                    print("updating: Second")
                default:
                    break
                }
            }.onEnded { value in
                switch value {
                case .second(_, _):
                    print("onended: Second")
                default:
                    break
                }
            }
    }
}

