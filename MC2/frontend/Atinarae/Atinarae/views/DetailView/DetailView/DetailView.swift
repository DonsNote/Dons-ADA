//
//  DetailView.swift
//  Atinarae
//
//  Created by A_Mcflurry on 2023/05/04.
//

import SwiftUI

struct DetailView: View {
    @State var date = Date()
    var body: some View {
        
            List{
                ScrollView{
                        VStack{
                            ForEach(1..<3) { _ in
                                DetailViewModel()
                                
                            }
                        }
                    
            
            }
        }
        
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
