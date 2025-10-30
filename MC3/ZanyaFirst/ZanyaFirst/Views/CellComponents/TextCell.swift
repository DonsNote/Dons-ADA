//
//  TextView.swift
//  ZanyaFirst
//
//  Created by Kimjaekyeong on 2023/07/19.
//

import SwiftUI

struct TextCell: View {
    
    var text: String = "gkgkk"
    var size: CGFloat
    var color: Color
    var weight: String = "Bold"
    
    var body: some View {
        VStack(spacing: 0) {
            Text(text)
                .font(Font.custom("LINE Seed Sans KR \(weight)", size: size))
                .foregroundColor(color)
        }
    }
}
struct TextCell_Previews: PreviewProvider {
    static var previews: some View {
        TextCell(text: "일어나라냥", size: 20, color: .cyan)
    }
}
