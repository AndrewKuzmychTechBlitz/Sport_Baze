//
//  EventsView.swift
//  Sport_Baze
//
//  Created by Андрій Кузьмич on 23.08.2023.
//

import SwiftUI
struct EventView: View{
    var array:[EventsResponse]
    var home: MainAway
    var away: MainAway
    var body: some View{
        ZStack(alignment: .top){
            Color.bg.ignoresSafeArea()
            VStack(alignment: .leading){
                Text("Events")
                    .font(.system(size: 34, weight: .bold))
                if !array.isEmpty{
                    eventScroll
                }else{
                    EmptyState()
                }
            }
            .foregroundColor(.white)
            .padding(.horizontal)
        }
    }
    private var eventScroll: some View{
        ScrollView(.vertical, showsIndicators: false) {
            VStack{
                ForEach(array) { event in
                    if home.name ?? "" == event.team?.name ?? ""{
                        if event.type ?? "" == "subst"{
                            EventHomeSubst(time: event.time?.elapsed ?? 0,
                                           playerName: event.player?.name ?? "",
                                           asistName: event.assist?.name ?? "")
                        }else{
                            EventHome(time: event.time?.elapsed ?? 0,
                                      playerName: event.player?.name ?? "",
                                      eventImage: event.detail ?? "")
                        }
                    }else{
                        if event.type ?? "" == "subst"{
                            EventAwaySubst(time: event.time?.elapsed ?? 0,
                                           playerName: event.player?.name ?? "",
                                           asistName: event.assist?.name ?? "")
                        }else{
                            EventAway(time: event.time?.elapsed ?? 0,
                                      playerName: event.player?.name ?? "",
                                      eventImage: event.detail ?? "")
                        }
                    }
                }
            }
            .padding()
            .background {
                Color.detailBG.cornerRadius(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    }
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}
struct EventHomeSubst: View{
    var time: Int
    var playerName: String
    var asistName: String
    var body: some View{
        VStack(spacing: 5) {
            HStack{
                Text("\(time)'")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(width: 26)
                Image("subst")
                Text("IN")
                    .foregroundColor(.green)
                Text(playerName)
                Text("OUT")
                    .foregroundColor(.red)
                Text(asistName)
                Spacer()
            }
            .font(.system(size: 15))
            Divider()
                .frame(height: 1)
                .background {
                    Color.white.opacity(0.2)
                }
        }
        .padding(.bottom)
    }
}
struct EventAwaySubst:  View{
    var time: Int
    var playerName: String
    var asistName: String
    var body: some View{
        VStack(spacing: 5){
            HStack{
                Spacer()
                Text(asistName)
                Text("OUT")
                    .foregroundColor(.red)
                Text(playerName)
                Text("IN")
                    .foregroundColor(.green)
                Image("subst")
                Text("\(time)'")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(width: 26)
            }
                .font(.system(size: 15))
            Divider()
                .frame(height: 1)
                .background {
                    Color.white.opacity(0.2)
                }
        }
        .padding(.bottom)

    }
}
struct EventAway:  View{
    var time: Int
    var playerName: String
    var eventImage: String
    var body: some View{
        VStack(spacing: 5){
            HStack{
                Spacer()
                Text(playerName)
                Image(eventImage)
                Text("\(time)'")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(width: 26)
            }
            .font(.system(size: 15))
            Divider()
                .frame(height: 1)
                .background {
                    Color.white.opacity(0.2)
                }
        }
        .padding(.bottom)

    }
}
struct EventHome:  View{
    var time: Int
    var playerName: String
    var eventImage: String
    var body: some View{
        VStack(spacing: 5) {
            
            HStack{
                Text("\(time)'")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(width: 26)
                Image(eventImage)
                Text(playerName)
                Spacer()
            }
            .font(.system(size: 15))
            Divider()
                .frame(height: 1)
                .background {
                    Color.white.opacity(0.2)
                }
        }
        .padding(.bottom)

    }
}
