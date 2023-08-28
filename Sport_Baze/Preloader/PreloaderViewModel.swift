//
//  PreloaderViewModel.swift
//  Sport_Baze
//
//  Created by Андрій Кузьмич on 17.08.2023.
//

import Foundation
class PreloaderViewModel: ObservableObject {
    @Published var didFinishLoading: Bool = false
    @Published var showMain = false
    @Published var hiddenWV = true
    @Published var deleteWeb = false
    
    
    func presentMain(url: String?, loading: Bool, error: Error?) {
        if loading {
            if url == "https://www.google.com/" {
                print("This is GOOGLE")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.showMain = true
                    self.deleteWeb = true
                }
            } else {
                print("This is The URL")
                if hiddenWV {
                    hiddenWV = false
                }
            }
        } else {
            if let error = error {
                print("Main view error: \(error.localizedDescription)")
                let firstError = "The Internet connection appears to be offline."
                if error.localizedDescription ==  firstError {
                    print("NO INTERNET CONNECTION")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.hiddenWV = true
                        self.deleteWeb = true
                        self.showMain = true
                    })
                }
            }
        }
    }
}
