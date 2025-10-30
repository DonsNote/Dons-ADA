//
//  ColorExtension.swift
//  Atinarae
//
//  Created by A_Mcflurry on 2023/05/04.
//

//  ----------------------------------------------------------------------
//              Color Extension입니다.
//              밑에 있는 익스텐션에다가 hex값으로 된 컬러를 지정해주면
//              .red처러 사용 가능 합니다. ex) .orbitLineColor
//  ----------------------------------------------------------------------

import Foundation
import SwiftUI

extension Color {
  init(hex: String) {
    let scanner = Scanner(string: hex)
    _ = scanner.scanString("#")
    
    var rgb: UInt64 = 0
    scanner.scanHexInt64(&rgb)
    
    let r = Double((rgb >> 16) & 0xFF) / 255.0
    let g = Double((rgb >>  8) & 0xFF) / 255.0
    let b = Double((rgb >>  0) & 0xFF) / 255.0
    self.init(red: r, green: g, blue: b)
  }
}
extension Color {
    static let orbitLineColor = Color(hex: "F5F5F5").opacity(0.8)   // 궤도
    static let orbitLineColor2 = Color(hex: "F5F5F5").opacity(0.3)
    
    static let orbitStarColor = Color(hex: "F2F2F7")    // 별
    
    static let backGroundColor = Color(hex: "0E0E0E")   // 배경
    
    static let buttonColor = Color(hex: "918AF5")       // 버튼
    static let buttonColor1 = Color(hex: "CAEBFF")
    
}

