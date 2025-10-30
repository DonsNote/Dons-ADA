//
//  StrokeTextLabelCenter.swift
//  ZanyaFirst
//
//  Created by Kimjaekyeong on 2023/07/24.
//

import SwiftUI
import UIKit

struct StrokedTextCellCenter: View {
    var text: String
    var size: CGFloat
    var color: Color = .white
    var strokeColor: String = AppGreen

    var body: some View {
            ZStack {
                StrokeTextLabelCenter(text: text, size: size, strokeColor: strokeColor)
                    Text(text)
                        .font(Font.custom("LINE Seed Sans KR Bold", fixedSize: size))
                    .foregroundColor(color)
            }.frame(height: size)
        
        
    }
}
struct StrokeTextLabelCenter: UIViewRepresentable {
    var text: String
    var size: CGFloat
    var strokeColor: String
    
    var color: UIColor? { return UIColor(named: strokeColor) }
    
    func makeUIView(context: Context) -> UILabel {
        let attributedStringParagraphStyle = NSMutableParagraphStyle()
        attributedStringParagraphStyle.alignment = NSTextAlignment.center
        let attributedString = NSAttributedString(
            string: text,
            attributes:[
                NSAttributedString.Key.paragraphStyle: attributedStringParagraphStyle,
                NSAttributedString.Key.strokeWidth: 25.0,
                NSAttributedString.Key.foregroundColor: color,
                NSAttributedString.Key.strokeColor: color,
                NSAttributedString.Key.font: UIFont(name: "LINE Seed Sans KR Bold", size: size)
            ]
        )

        let strokeLabel = UILabel(frame: CGRect.zero)
        strokeLabel.attributedText = attributedString
        strokeLabel.backgroundColor = UIColor.clear
        strokeLabel.sizeToFit()
        strokeLabel.center = CGPoint.init(x: 0.0, y: 0.0)
        return strokeLabel
    }

    func updateUIView(_ uiView: UILabel, context: Context) {}
}




struct StrokedTextCellCenter_Previews: PreviewProvider {
    static var previews: some View {
        StrokedTextCellCenter(text: "일어나라냥 나랑살래냥", size: 20, color: Color(.white))
    }
}
