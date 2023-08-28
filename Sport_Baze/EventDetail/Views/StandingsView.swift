//
//  StandingsView.swift
//  Sport_Baze
//
//  Created by Андрій Кузьмич on 23.08.2023.
//

import SwiftUI
import Kingfisher
struct StandingsView: View{
    var array:[Standing]
    var body: some View{
        VStack(alignment: .leading){
            Text("Table")
                .font(.system(size: 34, weight: .bold))
                .padding()
            if !array.isEmpty{
                standingsScroll
            }else{
                EmptyState()
            }
        }
        .foregroundColor(.white)
        .background {
            Color.bg.ignoresSafeArea()
        }
    }
    private var standingsScroll: some View{
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0){
                standingsHeader
                VStack{
                    ForEach(array) { match in
                        StandingsCell(num: match.rank ?? 0,
                                      image: match.team?.logo ?? "",
                                      name: match.team?.name ?? "",
                                      m: match.all?.played ?? 0,
                                      p: match.all?.win ?? 0,
                                      d: match.all?.draw ?? 0,
                                      l: match.all?.lose ?? 0,
                                      gd: match.goalsDiff ?? 0,
                                      pts: match.points ?? 0)
                    }
                }
                
            }
            .background {
                Color.detailBG.cornerRadius(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    }
            }
        }
        .padding(.horizontal)
    }
    private var standingsHeader: some View{
        HStack{
            Text("#")
                .font(.system(size: 12))
                .frame(width: 25)
                .foregroundColor(.blueGR2)
                .frame(width: 40)
            Text("Team")
                .font(.system(size: 12))
                .foregroundColor(.blueGR2)
               
            Spacer()
            HStack{
                Text("M")
                    .font(.system(size: 12))
                    .frame(width: 20)
                Text("W")
                    .font(.system(size: 12))
                    .frame(width: 20)
                Text("D")
                    .font(.system(size: 12))
                    .frame(width: 20)
                Text("L")
                    .font(.system(size: 12))
                    .frame(width: 20)
                Text("G")
                    .font(.system(size: 12))
                    .frame(width: 20)
                Text("PTS")
                    .font(.system(size: 12))
                    .frame(width: 23)
            }
        }
        .padding()
        .background {
            Color.blueGR2.opacity(0.2).cornerRadius(10, corners: [.topLeft, .topRight])
        }
        //.foregroundColor(.redDark)
    }
    private func standingsCell(num: Int, image: String, name: String,m:Int, p: Int, d: Int, l: Int, gd: Int, pts: Int) -> some View{
        HStack{
            HStack{
                Circle()
                    .fill(Color.accentPink)
                    .frame(width: 6)
                
                Text("\(num)")
                    .font(.system(size: 12))
            }
            .frame(width: 25, height: 42, alignment: .leading)
            KFImage(URL(string: image))
                .placeholder {
                    Image("Ellipse 64")
                        .resizable()
                        .scaledToFit()
                }
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
            Text(name)
                .font(.system(size: 12))
            Spacer()
            Group {
                Text("\(m)")
                    .font(.system(size: 12))
                    .frame(width: 20)
                Text("\(p)")
                    .font(.system(size: 12))
                    .frame(width: 20)
                Text("\(d)")
                    .font(.system(size: 12))
                    .frame(width: 20)
                Text("\(l)")
                    .font(.system(size: 12))
                    .frame(width: 20)
                Text("\(gd)")
                    .font(.system(size: 12))
                    .frame(width: 20)
                Text("\(pts)")
                    .font(.system(size: 12))
                    .frame(width: 23)
            }

        }
        .padding(.horizontal)
    }
    
}
struct StandingsCell: View{
    var num: Int
    var image: String
    var name: String
    var m:Int
    var p: Int
    var d: Int
    var l: Int
    var gd: Int
    var pts: Int

    var body: some View{
        VStack(spacing: 5) {
            
            HStack{
                HStack{
                    Circle()
                        .fill(Color.accentPink)
                        .frame(width: 6)
                    
                    Text("\(num)")
                        .font(.system(size: 12))
                }
                .frame(width: 25, height: 42, alignment: .leading)
                KFImage(URL(string: image))
                    .placeholder {
                        Image("Standings")
                            .resizable()
                            .scaledToFit()
                    }
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text(name)
                    .font(.system(size: 12))
                Spacer()
                Group {
                    Text("\(m)")
                        .font(.system(size: 12))
                        .frame(width: 20)
                    Text("\(p)")
                        .font(.system(size: 12))
                        .frame(width: 20)
                    Text("\(d)")
                        .font(.system(size: 12))
                        .frame(width: 20)
                    Text("\(l)")
                        .font(.system(size: 12))
                        .frame(width: 20)
                    Text("\(gd)")
                        .font(.system(size: 12))
                        .frame(width: 20)
                    Text("\(pts)")
                        .font(.system(size: 12))
                        .frame(width: 23)
                }
                
            }
            .padding(.horizontal)
            Divider()
                .frame(height: 1)
                .background {
                    Color.white.opacity(0.2)
                }

        }
    }
}
