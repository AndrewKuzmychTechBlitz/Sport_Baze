//
//  Settings.swift
//  Sport_Baze
//
//  Created by Андрій Кузьмич on 17.08.2023.
//

import SwiftUI

struct SettingsScreen: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("Vibration") var vibrationIsON = false
    @State private var sendEmail = false
    @State private var showMailAlert = false
    @State private var showShare = false
    @State var shareText: ShareText?

    var body: some View {
        ZStack{
            Color.bg.ignoresSafeArea()
            VStack{
                header
                settingsList
                Spacer()
            }
            .foregroundColor(.white)
            .sheet(item: $shareText) { shareText in
                ActivityView(text: shareText.text)
            }
            .navigationBarBackButtonHidden()
        }
    }
    private var header: some View{
        HStack() {
            Text("Settings")
                .font(.system(size: 32, weight: .bold))
            Spacer()
        }
        .padding()
    }
    private var settingsList: some View{
        ScrollView(.vertical, showsIndicators: false) {
            VStack{
                Button {
                    NotificationClass.instance.showNotificationsSettings()
                    Vibration.instance.simpleSuccess()
                } label: {
                    settingsCell(title: "Notification", subtitle: "Customize how the app sends you alerts and choose which types of notifications you want to receive.")
                }
                vibrationCell
                NavigationLink {
                    SavedEventView()
                } label: {
                    settingsCell(title: "Saved Event", subtitle: "Review and agree to the app's terms and conditions before using it.")
                }
                .simultaneousGesture(TapGesture().onEnded({
                    Vibration.instance.simpleSuccess()
                }))
                NavigationLink {
                   PolicyScreen()
                } label: {
                    settingsCell(title: "Policy", subtitle: "Review and agree to the app's terms and conditions before using it.")
                }
                .simultaneousGesture(TapGesture().onEnded({
                    Vibration.instance.simpleSuccess()
                }))
                NavigationLink {
                    TermsScreen()
                } label: {
                    settingsCell(title: "Terms of Service", subtitle: "Review and agree to the app's terms and conditions before using it.")
                }
                .simultaneousGesture(TapGesture().onEnded({
                    Vibration.instance.simpleSuccess()
                }))
                Button {
                    shareText = ShareText(text: " https://apps.apple.com/app/id6448792803")
                    Vibration.instance.simpleSuccess()
                } label: {
                    settingsCell(title: "Share App", subtitle: "Review and agree to the app's terms and conditions before using it.")
                }
                Button {
                    ReviewHandler.requestReview()
                    Vibration.instance.simpleSuccess()
                } label: {
                    settingsCell(title: "Rate US", subtitle: "Review and agree to the app's terms and conditions before using it.")
                }
            }
            //.foregroundColor(.black)
        }
        .padding()
    }
    private var vibrationCell: some View{
        VStack(alignment: .leading){
            HStack{
                Toggle(isOn: $vibrationIsON) {
                    Text("Vibration")
                        .font(.system(size: 17))
                }
            }
            .padding(.horizontal)
            .frame(height: 44)
            .background {
                Color.appGray.cornerRadius(8)
            }
            Text("Customize how the app sends you alerts and choose which types of notifications you want to receive.")
                .font(.system(size: 10, weight: .regular, design: .default))
                .opacity(0.5)
                .multilineTextAlignment(.leading)
        }
    }
    private func settingsCell(title: String, subtitle: String)-> some View{
                   VStack(alignment: .leading){
                        HStack{
                        Text(title)
                            .font(.system(size: 17))
                        Spacer()
                        Image(systemName: "chevron.right")
                                .opacity(0.5)
                }
                .padding(.horizontal)
                .frame(height: 44)
                .background {
                    Color.appGray.cornerRadius(8)
                }
                Text(subtitle)
                    .font(.system(size: 10, weight: .regular, design: .default))
                    .opacity(0.5)
                    .multilineTextAlignment(.leading)
            }
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
struct ActivityView: UIViewControllerRepresentable {
    let text: String
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: [text], applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView>) {}
}
struct ShareText: Identifiable {
    let id = UUID()
    let text: String
}

