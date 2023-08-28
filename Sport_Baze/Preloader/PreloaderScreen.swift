//
//  PreloaderScreen.swift
//  Sport_Baze
//
//  Created by Андрій Кузьмич on 17.08.2023.
//

import SwiftUI

struct PreloaderScreen: View {
    var body: some View {
        ZStack(alignment: .bottom){
            Color.bg.ignoresSafeArea()
            logoLabel
            progressView
        }
        .foregroundColor(.white)
    }
    private var progressView: some View{
        VStack{
            CustomProgressView()
            Text("Loading...")
                .font(.system(size: 14))
        }
        .padding()
    }
    private var logoLabel: some View{
        VStack{
            Spacer()
            Image("Logo")
                Text("Sport Baze")
                    .font(.custom(.pilat_bold, size: 34))
                
                    .mask {
                        Rectangle()
                            .fill(LinearGradient(colors: [.white, .white.opacity(0.4)], startPoint: .leading, endPoint: .trailing))
                    }
            Spacer()
            
        }
    }
}

struct PreloaderScreen_Previews: PreviewProvider {
    static var previews: some View {
        PreloaderScreen()
    }
}
struct CustomProgressView: View{
    
    let defaultProgress = 0.9
    @State var fillRotationAngle = 0.0
    let defaultSize: CGFloat = 40
    let lineWidth: CGFloat = 10

    var body: some View {
        GeometryReader { geometry in
            let diameter = geometry.size.width
            let radius = diameter / 2
            
            ZStack {
                ForEach(0..<8) { i in
                    let angle = (0.25 * Double(i)) * .pi
                    Circle()
                        .frame(width: 6, height: 6)
                        .position(
                            x: radius * (1 - cos(angle)),
                            y: geometry.size.height / 2 - radius * sin(angle)
                        )
                }

                
            }
            .mask{
                Circle()
                    .trim(from: 0, to: defaultProgress)
                    .stroke(LinearGradient(colors: [Color.white, Color.white.opacity(0)], startPoint: .leading, endPoint: .trailing), lineWidth: lineWidth)
                    .frame(width: defaultSize - lineWidth, height: defaultSize - lineWidth)
                    .rotationEffect(.degrees(fillRotationAngle)) // UPDATE
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: false)) {
                            self.fillRotationAngle = 360.0                 }
                    }
            }
        }
        .frame(width: 32, height: 32)
    }
}

