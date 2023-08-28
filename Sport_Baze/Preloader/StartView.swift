//
//  StartView.swift
//  Sport_Baze
//
//  Created by Андрій Кузьмич on 17.08.2023.
//

import SwiftUI
struct StartView: View {
    @StateObject var vm = PreloaderViewModel()
    var body: some View {
        ZStack {
            if vm.showMain == false{
                PreloaderScreen()
                VStack {
                    MyWebViewRepresentable(url: URL(string: AnalyticsService.service)!)
                        .onLoadStatusChanged(perform: { url, loading, error in
                            vm.presentMain(url: url, loading: loading, error: error)
                        })
                        .isHidden(vm.hiddenWV, remove: vm.deleteWeb)
                }
            }else{
                OnboardingTabView()
            }
        }
    }
}
//struct StartView_Previews: PreviewProvider {
//    static var previews: some View {
//        StartView()
//    }
//}
extension View {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}
