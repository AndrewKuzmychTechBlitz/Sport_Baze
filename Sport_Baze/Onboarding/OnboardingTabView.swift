//
//  OnboardingTabView.swift
//  Sport_Baze
//
//  Created by Андрій Кузьмич on 17.08.2023.
//

import SwiftUI

struct OnboardingTabView: View {
    @State var index = 1

    var body: some View {
        NavigationView{
            ZStack{
                Color(.black)
                    .ignoresSafeArea()
                TabView(selection: $index){
                    OnboardingScreen(index: $index, title: "Stay up to date with the hottest football events!", bgImage: "Onboarding1")
                        .tag(1)
                    
                    OnboardingScreen(index: $index, title: "Track the best football events on the map!",  bgImage: "Onboarding2")
                        .tag(2)
                    OnboardingScreen(index: $index, title: "Get detailed statistics for each match!",  bgImage: "Onboarding3")
                        .tag(3)
                }
                .edgesIgnoringSafeArea(.vertical)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
        }
        .navigationBarHidden(true)
        .navigationViewStyle(.stack)
        
    }
}

struct OnboardingTabView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingTabView()
    }
}
