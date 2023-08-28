//
//  OnboardingScreen.swift
//  Sport_Baze
//
//  Created by Андрій Кузьмич on 17.08.2023.
//

import SwiftUI

struct OnboardingScreen: View {
    @Binding var index: Int
    var title: String
    var bgImage: String
    var body: some View {
        ZStack(alignment: .top){
            Color.bg.ignoresSafeArea()
            Image(bgImage)
                .resizable()
                .scaledToFit()
                .ignoresSafeArea()
                .offset(y:bgImage == "Onboarding1" ? 0 : 30)
            infoLabel
        }
        .foregroundColor(.white)
    }
    private var infoLabel: some View{
        VStack(alignment: .leading){
            Spacer()
            title_link
            buttons
        }
        .padding(25)
    }
    private var logoLabel: some View{
        HStack{
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 45, height: 45)
            Text("Sport Baze")
                .font(.custom(.pilat_bold, size: 20))
            
                .mask {
                    Rectangle()
                        .fill(LinearGradient(colors: [.white, .white.opacity(0.4)], startPoint: .leading, endPoint: .trailing))
                }
        }
    }
    private var title_link: some View{
        HStack(alignment: .bottom){
            VStack(alignment: .leading){
                logoLabel
                Text(title)
                    .font(.system(size: 34, weight: .medium))
                    .multilineTextAlignment(.leading)
            }
            Spacer()
            GeometryReader { geo in
                ZStack(alignment: .leading){
                    Rectangle()
                        .foregroundColor(.clear)
                        .background(
                            LinearGradient(colors: [.blueGR1, .blueGR2], startPoint: .trailing, endPoint: .leading)
                        )
                        .cornerRadius(40)
                        .rotationEffect(Angle(degrees: -45))
                    
                    Button {
                        if index < 3{
                            self.index += 1
                        }
                        Vibration.instance.simpleSuccess()
                    } label: {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14))
                            .frame(width: 24, height: 24)
                            .overlay {
                                Circle()
                                    .stroke(lineWidth: 1)
                            }
                    }
                    .frame(width: 45, height: 45)
                }
            }
            .frame(width: 197, height: 197)
            .padding(.trailing, -150)
        }
    }
    private var buttons: some View{
        HStack{
            if index < 3{
                Button {
                    self.index += 1
                    Vibration.instance.simpleSuccess()
                } label: {
                    Text("Next!")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(width: 162, height: 45)
                        .background {
                            Color.accentPink.cornerRadius(32)
                        }
                }
            }else{
                NavigationLink {
                    StartTabView()
                } label: {
                    Text("Start!")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(width: 162, height: 45)
                        .background {
                            Color.accentPink.cornerRadius(32)
                        }
                }
            }
            Spacer()
            if index < 3{
                NavigationLink {
                    StartTabView()
                } label: {
                    HStack(spacing: 0){
                        Text("Skip")
                            .font(.system(size: 14, weight: .bold))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14))
                    }
                    .opacity(0.5)
                    .frame(width: 45,height: 45)
                }
                .simultaneousGesture(TapGesture().onEnded({
                    Vibration.instance.simpleSuccess()
                }))
            }
        }
    }
}

struct OnboardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScreen(index: .constant(3), title: "Stay up to date with the hottest football events!", bgImage: "Onboarding3")
    }
}
