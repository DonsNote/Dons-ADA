//
//  DetailViewModel.swift
//  Atinarae
//
//  Created by A_Mcflurry on 2023/05/04.
//

import SwiftUI

struct DetailViewModel: View {
    @State private var selected = "SwiftUI"
    @State private var buttonPush = false
    var body: some View {
        VStack(alignment: .leading){
            Text("딸의 독립을 축하하며")
                .font(.title2)
            HStack{
                Text("수능")
                Text("2020.01.23")
            }
           Divider()
           
        }
        
        
        
    }
        
}

struct DetailViewModel_Previews: PreviewProvider {
    static var previews: some View {
        DetailViewModel()
    }
}
