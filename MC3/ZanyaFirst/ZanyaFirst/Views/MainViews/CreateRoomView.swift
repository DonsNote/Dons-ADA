//
//  File.swift
//  ZanyaFirst
//
//  Created by Kimjaekyeong on 2023/07/18.
//

import SwiftUI


struct CreateRoomView: View {
    
    //MARK: -1. PROPERTY
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel = CreateRoomViewModel()
    @ObservedObject var keyboardMonitor : KeyboardMonitor = KeyboardMonitor()
    
    
    @State var isClickedComBut: Bool = false
    @Binding var task: Int
   
    
    //MARK: -2. BODY
    var body: some View {
        ZStack{
            CreatePageSheetBG
            Xmark
            
            GeometryReader { geo in
                VStack(spacing: 0) {
                    CreateRoomTextField
                    CreateTimePicker
                    Spacer()
                    CreateSaveButton
                }
//                .padding(.top, UIApplication.shared.windows[0].safeAreaInsets.top)
                .padding(.init(top: 0, leading: 24, bottom: 0, trailing: 24))
            }.onAppear{
                print(viewModel.time)
            }
           
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
        .hideKeyboardWhenTappedAround()
        .animation(.easeOut(duration: 0.1), value: keyboardMonitor.isKeyboardUP)
        .confirmationDialog(
            "방이 생성되었습니다",
            isPresented: $isClickedComBut,
            titleVisibility: .visible
        ) {
            Button("OK", role: .cancel) {
                viewModel.clickedCompleteButton()
                task += 1
                dismiss()
            }
        } message: {
            Text("")
        }
    }
}


//MARK: -3. PREVIEW
//struct CreateRoomView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateRoomView()
//    }
//}

//MARK: -4. EXTENSION
extension CreateRoomView {
    
    private var CreatePageSheetBG: some View {
        ZStack {
            Image(CreatePageSheet)
                .resizable()
                .aspectRatio(contentMode: .fit)
            VStack{
                Image(CreateRoomTitle)
                    .padding(.top, 51)
                Spacer()
            }
        }
    }
    
    private var Xmark: some View {
        VStack{
            HStack{
                Button {
                    dismiss()
                } label: {
                    Image(CreatePageXmark)
                }
                Spacer()
            }
            .padding(.init(top: 65, leading: 25, bottom: 0, trailing: 0))
            Spacer()
        }
    }
    
    private var CreateRoomTextField: some View {
        ZStack(alignment: .center){
            Image(CreateTitleSheet)
            TextField("방 이름을 정해주세요",
                      text: $viewModel.roomName,
                      prompt: Text("방 제목을 정해주세요 :3").font(Font.custom("LINE Seed Sans KR Regular", size: 18)).foregroundColor(.AppTextFieldGray))
                .padding()
                .padding(.top, 22)
        }
        .frame(width: 297)
        .padding(.init(top: keyboardMonitor.isKeyboardUP ? 120 : 179, leading: 0, bottom: 24, trailing: 0))
    }
    
    //MARK: 이거 색깔 어케바꾸지;;;
    private var CreateTimePicker: some View {
        ZStack{
            Image(CreatePickerSheet)
            //TODO: -피커 가운데 바 노랗게 하는건 모르겠음
            VStack {
                DatePicker(selection: $viewModel.time, displayedComponents: .hourAndMinute){}
                    .datePickerStyle(WheelDatePickerStyle())
                    .colorInvert()
                    .colorMultiply(Color(AppWine))
            }
            .frame(width: 198.5)
            .padding(.trailing, 8)
            .padding(.top, 15)
            .foregroundColor(.FontRed)
        }
    }
    
    private var CreateSaveButton: some View {
            Button {
                Text("New Room Created")
                guard !viewModel.roomName.isEmpty else { return }
                isClickedComBut = true
                //                viewModel.clickedCompleteButton()
            } label: {
                Image(viewModel.roomName == "" ? CreateRoomSaveButton_disabled : CreateRoomSaveButton)
            }
        .padding(.init(top: 0, leading: 0, bottom: 53, trailing: 0))
        .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 4)
        .offset(y: keyboardMonitor.keyboardHeight * -0.9)
        .disabled(viewModel.roomName == "" ? true : false)
    }
}

