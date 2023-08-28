//
//  Sport_BazeApp.swift
//  Sport_Baze
//
//  Created by Андрій Кузьмич on 17.08.2023.
//

import SwiftUI
import SDWebImageSVGCoder
import OneSignal
import FirebaseCore
import AppTrackingTransparency
import AdSupport
import AppsFlyerLib

@main
struct Sport_BazeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var dataReceived = false

    init() {
        setUpDependencies() // Initialize SVGCoder
    }

    var body: some Scene {
        WindowGroup {
            ZStack{
                if dataReceived{
                    NavigationView{
                        StartView()
                    }
                    .onAppear{
                        setupColorScheme(true)
                    }
                }else{
                    Color.black.ignoresSafeArea()
                }
            }.onReceive(NotificationCenter.default.publisher(for:  .onDataImported), perform: { _ in
                self.dataReceived = true
            })
        }
    }
    private func setupColorScheme(_ isDarkMode: Bool) {
        UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
    }
}
private extension Sport_BazeApp {
    
    func setUpDependencies() {
        SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
    }
}
class AppDelegate: NSObject, UIApplicationDelegate, AppsFlyerLibDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // MARK: Firebase
        //FirebaseApp.configure()
        // Remove this method to stop OneSignal Debugging
        // MARK: OneSignal
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
        
        OneSignal.initWithLaunchOptions(launchOptions)
        OneSignal.setAppId("cc0aea99-35a9-49fa-a3c1-b0aed3dec30c")
        
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notification: \(accepted)")
        })
        // MARK: AppsFlyerLib
        
        AppsFlyerLib.shared().appsFlyerDevKey = "8JG9WryQxMPAC476gd3QuH"
        AppsFlyerLib.shared().appleAppID = "6450987687"
        AppsFlyerLib.shared().isDebug = true
        AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)
        AppsFlyerLib.shared().delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(sendLaunch),name: UIApplication.didBecomeActiveNotification, object: nil)
        
        
        
        return true
    }
    @objc func sendLaunch(app:Any) {
        
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { (status) in
                switch status {
                case .denied:
                    print("AuthorizationSatus is denied")
                case .notDetermined:
                    print("AuthorizationSatus is notDetermined")
                case .restricted:
                    print("AuthorizationSatus is restricted")
                case .authorized:
                    print("AuthorizationSatus is authorized")
                    
                @unknown default:
                    fatalError("Invalid authorization status")
                }
            }
            AppsFlyerLib.shared().start()
        }
    }
}
extension AppDelegate {
    
    // Handle Organic/Non-organic installation
    func onConversionDataSuccess(_ data: [AnyHashable: Any]) {
        let appsFlyerUID = AppsFlyerLib.shared().getAppsFlyerUID()
        print("onConversionDataSuccess data:")
        for (key, value) in data {
            print(key, ":", value)
        }
        
        if let status = data["af_status"] as? String {
            if (status == "Non-organic") {
                if let sourceID = data["media_source"],
                   let campaign = data["campaign"] {
                    print("This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)")
                    let newService = AnalyticsService.service + "&bundle=com.365spo.app&user_status=\(data["af_status"])&sub2=Empty&adgroup=Empty&appsflyer_id=\(appsFlyerUID)&af_channel=Empty&traffic_source=\(data["media_source"])&appID=id6450987687&sub2=\(data[""])&idfa=\(data["idfa"])&flyer_auth_key=8JG9WryQxMPAC476gd3QuH"
                    
                    AnalyticsService.service = newService
                }
            } else {
                print("This is an organic install.")
                let newService = AnalyticsService.service + "&bundle=com.365spo.app&user_status=\(data["af_status"])&sub2=Empty&adgroup=Empty&appsflyer_id=\(appsFlyerUID)&af_channel=Empty&traffic_source=\(data["media_source"])&appID=id6450987687&sub2=\(data[""])&idfa=\(data["idfa"])&flyer_auth_key=8JG9WryQxMPAC476gd3QuH"
                AnalyticsService.service = newService
            }
        }
        NotificationCenter.default.post(name: .onDataImported , object: nil)
    }
    
    func onConversionDataFail(_ error: Error) {
        print("\(error)")
        NotificationCenter.default.post(name: .onDataImported , object: nil)
    }
    
}
extension NSNotification.Name {
    static let onDataImported = NSNotification.Name("completeLoading")
}
