//
//  MainViewModelGeometry.swift
//  Atinarae
//
//  Created by A_Mcflurry on 2023/05/04.
//

//  ----------------------------------------------------------------------
//              삽질을 정말... 많이 했읍니다...
//              여기서도 지오메트리리더를 사용, 메인뷰와 여기서 이중으로 사용해서
//              문제가 많았는데, 어찌 해결을 했습니다?
//              이 파일은 여기보단 밑에 적어놓은 주석을 보는게 코드 이해가 더 빠를수도 있습니다.
//  ----------------------------------------------------------------------


import SwiftUI

struct MainViewModelGeometry: View {
    @State private var animationFlag = false        // 별들이 도는 애니메이션 bool
    @State var tag:Int? = nil                       // 네비게이션뷰 이동을 위한 tag
    private var animation = Animation.linear.repeatForever(autoreverses: false)
    let planetSize: CGFloat = 100   // 행성의 크기 조절
    let starSize: CGFloat = 40      // 별의 크기 조절
    
    
    
    var body: some View {
        
        
        GeometryReader{ geo in
            let diameter = geo.size.height/2.5  // 1번째 원
            let diameter2 = geo.size.height/1.5 // 2번째 원
            let diameter3 = geo.size.height/1.1 // 3번째 원
            
            ZStack{
                
                // 배경화면
                Color.backGroundColor

                // 원 생성
                self.makeCircle(dim: diameter - 50)
                self.makeCircle(dim: diameter2  - 50)
                self.makeCircle(dim: diameter3 - 50)
                
                
                // 행성 생성
                Button{
                    // self.tag = 1
                } label: {
                    Image("planet_by")
                        .resizable()
                        .frame(width: planetSize, height: planetSize)
                }
                .modifier(self.makePlanetEffect(diameter: diameter2, point: 6.7))
                
                Button{
                    
                } label: {
                    Image("planet_by")
                        .resizable()
                        .frame(width: planetSize, height: planetSize)
                }
                .modifier(self.makePlanetEffect(diameter: diameter2, point: 3.5))
                
                Button{
                    
                } label: {
                    Image("planet_py")
                        .resizable()
                        .frame(width: planetSize, height: planetSize)
                }
                .modifier(self.makePlanetEffect(diameter: diameter3, point: 4.4))
                
                Button{
                    
                } label: {
                    Image("planet_yb")
                        .resizable()
                        .frame(width: planetSize, height: planetSize)
                }
                .modifier(self.makePlanetEffect(diameter: diameter3, point: 1.5))
                
                Button{
                    
                } label: {
                    Image("planet_yb")
                        .resizable()
                        .frame(width: planetSize, height: planetSize)
                    
                }
                .modifier(self.makePlanetEffect(diameter: diameter3, point: 5.6))
                
                
                // 가운대에 있는 MY생성, Eclipse가 버튼이 되지 않게 따로 빼놓음
                ZStack{
                    Image("MY Eclipse")
                    Button{
                        self.tag = 1
                    } label: {
                        Image("MY")
                            .resizable()
                            .frame(width: 100, height: 100, alignment: .center)
                    }
                }
            }
            .onAppear{
                self.animationFlag.toggle() // 실행시 애니메이션 실행
            }
            
            // tag로 뷰 이동을 위한 링크 설정
            NavigationLink(destination: DetailView(), tag : 1, selection: self.$tag){}
        }
    }
    
    // 이곳에서 움직이는 별과 궤도를 만듭니다.
    func makeCircle(dim: CGFloat) -> some View {
        let diameter = dim + 50
        return ZStack {
            Circle()    // 궤도
                .strokeBorder(  // 그라데이션 디자인 감각이 안좋아서 대충 넣어봤습니다..
                    AngularGradient(gradient: Gradient(colors: [.orbitLineColor, .orbitLineColor2, .orbitLineColor, .orbitLineColor2, .orbitLineColor]), center: .center)
                       )
                .frame(width: diameter, height: diameter)
            
            Image("star")   // 별
                .resizable()
                .frame(width: starSize, height: starSize, alignment: .center)
                .offset(y:14)
                .modifier(self.makeOrbitEffect(diameter: diameter))
                .animation(Animation.linear(duration: 250)
                    .repeatForever(autoreverses: false))
            
            
        }
    }
    
    func makePlanetEffect(diameter: CGFloat, point: Double) -> some GeometryEffect {
        return PlanetEffect(point: point, percent: 0, radius: diameter / 2)
    }
   
    func makeOrbitEffect(diameter: CGFloat) -> some GeometryEffect {
        return OrbitEffect(percent: self.animationFlag ? 1.0 : 0.0, radius: diameter / 2)
    }

}



struct OrbitEffect: GeometryEffect {
    let initialAngle = CGFloat.random(in: 0..<2 * .pi)
    
    var percent: CGFloat = 0
    let radius: CGFloat
    
    var animatableData: CGFloat {
        get { return percent }
        set { percent = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let angle = 2 * .pi * percent + initialAngle
        let point = CGPoint(x: cos(angle) * radius, y: sin(angle) * radius)
        return ProjectionTransform(CGAffineTransform(translationX: point.x, y: point.y))
    }
}

struct PlanetEffect: GeometryEffect {
    let point: Double
    let percent: CGFloat
    let radius: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let angle = 2 * 3.14 + CGFloat(point)
        
        return ProjectionTransform(CGAffineTransform(translationX: cos(angle) * radius, y: sin(angle) * radius))
    }
}

struct MainViewModelGeometry_Previews: PreviewProvider {
    static var previews: some View {
            GeometryReader{ geo in
                NavigationView{
                MainViewModelGeometry()
                    .frame(width: geo.size.width, height: geo.size.height/2)
            }
        }
    }
}
