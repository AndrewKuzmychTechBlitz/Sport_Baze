//
//  StartTabView.swift
//  Sport_Baze
//
//  Created by Андрій Кузьмич on 28.08.2023.
//

import SwiftUI

struct StartTabView: View {
    var body: some View {
        TabView {
            Group{
                MainScreen()
                    .tabItem {
                        VStack{
                            Image(systemName: "house")
                            Text("Main")
                        }
                    }
                MapScreen()
                    .tabItem {
                        VStack{
                            Image(systemName: "mappin.and.ellipse")
                            Text("Map")
                        }
                    }
                SettingsScreen()
                    .tabItem {
                        VStack{
                            Image(systemName: "gearshape.fill")
                            Text("Settings")
                        }
                    }
            }
            .tint(.accentPink)
        }
        .tint(.accentPink)
        .navigationBarBackButtonHidden()
    }
}

struct StartTabView_Previews: PreviewProvider {
    static var previews: some View {
        StartTabView()
    }
}
