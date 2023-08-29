//
//  LineupView.swift
//  Sport_Baze
//
//  Created by Андрій Кузьмич on 23.08.2023.
//

import SwiftUI
import Kingfisher
struct LineUpView: View{
    var array:[LineUPResponse]
    @State var index: Int = 1
    let columns = [
        GridItem(.fixed(109)),
        GridItem(.fixed(109)),
        GridItem(.fixed(109)),
    ]
    var body: some View{
        ZStack(alignment: .top){
            Color.bg.ignoresSafeArea()
            VStack(alignment: .leading){
                Text("Lineup")
                    .font(.system(size: 34, weight: .bold))
                    .padding(.vertical)
                if !array.isEmpty{
                    scroll
                }else{
                    EmptyState()
                }
            }
            .foregroundColor(.white)
            .padding(.horizontal)
        }

    }
    private var scroll: some View{
        ScrollView(.vertical, showsIndicators: false) {
            VStack{
                field
                buttons
                chooseGrid
               
//                switch self.index{
//                case 1: homeTeamGrid
//                case 2: awayTeamGrid
//                default:
//                    EmptyState()
//                }
            }
        }
    }
    @ViewBuilder var chooseGrid: some View{
        if index == 1{
            homeTeamGrid
        }else{
            awayTeamGrid
        }
    }
    private var homeTeamGrid: some View{
        VStack{
            LazyVGrid(columns: columns) {
                
                ForEach(array[0].startXI!.indices) { i in
                    playerCell(image: "", name: array[0].startXI![i].player?.name ?? "", number: array[0].startXI![i].player?.number ?? 0, position: array[0].startXI![i].player?.pos?.title ?? "")
                }
            }
        }
    }
    private var awayTeamGrid: some View{
        VStack{
            LazyVGrid(columns: columns) {
                ForEach(array[1].startXI!.indices) { i in
                    playerCell(image: "", name: array[1].startXI![i].player?.name ?? "", number: array[1].startXI![i].player?.number ?? 0, position: array[1].startXI![i].player?.pos?.title ?? "")
                }
            }
        }
    }
    private var field: some View{
        VStack{
            HStack{
                Text(array[0].team?.name ?? "")
                Spacer()
                Text(array[0].formation ?? "")
                    .foregroundColor(.accentPink)
            }
            .font(.system(size: 14, weight: .medium))
            ZStack{
                Image("Field")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width - 20)
                VStack{
                    Image("\(array[0].formation ?? "") R")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width - 80)
                    Image("\(array[1].formation ?? "") B")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width - 80)
                }
               
            }
            HStack{
                Text(array[1].team?.name ?? "")
                Spacer()
                Text(array[1].formation ?? "")
                    .foregroundColor(.blueGR2)
            }
            .font(.system(size: 14, weight: .medium))
        }
    }
    private var buttons: some View{
        HStack{
            Button {
                index = 1
            } label: {
                Text("Home")
                    .opacity(index == 1 ? 1: 0.5)
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .background {
                        if index == 1{
                            Color.accentPink.cornerRadius(27)
                        }else{
                            Color.detailBG.cornerRadius(27)
                        }
                    }
            }
            Button {
                index = 2
            } label: {
                Text("Away")
                    .opacity(index == 2 ? 1: 0.5)
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .background {
                        if index == 2{
                            Color.accentPink.cornerRadius(27)
                        }else{
                            Color.detailBG.cornerRadius(27)
                        }
                    }
            }

        }
        .padding(.vertical, 10)
    }
    private func playerCell(image: String, name: String, number: Int, position: String) -> some View{
        VStack{
//            KFImage(URL(string: image))
//                .placeholder({
//                    Circle()
//                        .fill(Color.accentPink)
//                })
            Image("Group 88")
                .resizable()
                .scaledToFit()
                .frame(width: 70)
                .clipShape(Circle())
            Text(name)
                .font(.system(size: 12, weight: .medium))
                .lineLimit(2)
            Text("# \(number) - \(position)")
                .font(.system(size: 10))
                .opacity(0.5)
            Spacer()
        }
        .frame(height: 120)
        .padding()
        .background {
            Color.detailCellBG.cornerRadius(10)
        }
    }
}
