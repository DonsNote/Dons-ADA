//
//  ClearRectangle.swift
//  ZanyaFirst
//
//  Created by Kimjaekyeong on 2023/07/19.
//

import SwiftUI

struct ClearRectangle: View {
    
    var width: CGFloat = 100
    var height: CGFloat = 100
    var ClearOn: Bool = false
    
    var body: some View {
        Rectangle()
            .frame(width: width,height: height)
            .foregroundColor(ClearOn ? .clear : .black)
    }
}

struct ClearRectangle_Previews: PreviewProvider {
    static var previews: some View {
        ClearRectangle()
    }
}
