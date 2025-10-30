//
//  ArtistListView.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/10/14.
//

import SwiftUI

struct ArtistListView: View {
    //MARK: -1.PROPERTY
    @EnvironmentObject var awsService: AwsService
    let columns = Array(
        repeating: GridItem(.flexible(), spacing: 0),
        count: 3
    )
    
    //MARK: -2.BODY
    var body: some View {
        ScrollView(showsIndicators: false) {
            HStack {
                roundedBoxText(text: "Artist List")
                    .shadow(color: .black.opacity(0.4),radius: UIScreen.getHeight(5))
                Spacer()
            }
                .padding(.init(top: UIScreen.getWidth(10), leading: UIScreen.getWidth(20), bottom: UIScreen.getWidth(0), trailing: UIScreen.getWidth(20)))
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(awsService.allAtrist) { i in
                    NavigationLink {
                        ArtistPageView(viewModel: ArtistPageViewModel(artist: i))
                    } label: {
                        ProfileRectangle(image: i.artistImage, name: i.stageName).scaleEffect(0.9)
                    }
                }
            }.padding(.init(top: UIScreen.getWidth(10), leading: UIScreen.getWidth(10), bottom: UIScreen.getWidth(10), trailing: UIScreen.getWidth(10)))
        }.background(backgroundView().ignoresSafeArea()).navigationTitle("")
           
    }
}

