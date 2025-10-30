//
//  CategoryAddView.swift
//  Atinarae
//
//  Created by HyunwooPark on 2023/05/06.
//

import SwiftUI

struct CategoryAddView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var appData: AppData
    @State var newCategoryName:String
    @FocusState var isFocused: Bool

    var body: some View {
        
            VStack {
                Form {
                    TextField("제목", text: $newCategoryName)
                        .onAppear(){
                            self.isFocused = true
                        }
                        .onSubmit {
                            appData.user.categories.append(newCategoryName)
                            presentationMode.wrappedValue.dismiss()
                        }
                        .focused($isFocused)
                        
                }
            }
            .navigationBarTitle(Text("카테고리 추가"), displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading:
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("취소")
                    },
                trailing:
                    Button(action: {
                        appData.user.categories.append(newCategoryName)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("저장")
                    }
            )
        
    }
}

//struct CategoryAddView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        let categories = Binding<[String]>(get: { ["1","2"] }, set: { _ in })
//        
//        let view = CategoryAddView(categories: categories, newCategoryName: "")
//        return view
//    }
//}
