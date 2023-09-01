//
//  TeamDetailScreen.swift
//  Sport_Baze
//
//  Created by Андрій Кузьмич on 26.08.2023.
//

import SwiftUI
import Kingfisher
import SDWebImageSwiftUI


struct TeamDetailScreen: View {
    var leagueInfo: League
    var teamID: Int
    @State var showStatistic: Bool = false
    @State var showPlayers: Bool = false
    @State var showTable: Bool = false
    @State var showMatches: Bool = false
    @StateObject var vm = TeamDetailViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.detailBG.ignoresSafeArea()
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    if !vm.teamInformation.isEmpty{
                        header
                        teamInfoLabel
                        selectedBar
                        previewScroll
                    }
                }
                .padding(.horizontal)
                .foregroundColor(.white)
            }
        }
        .onAppear{
            vm.loadTeamInformation(id: teamID)
            vm.loadAllEvent(teamID: teamID)
            vm.loadNextEvent(teamID: teamID)
            vm.loadPreviousEvent(teamID: teamID)
            vm.loadStandings(league: leagueInfo.id ?? 0)
            vm.loadPlayers(id: teamID)
            vm.loadTeamStatic(leagueID: leagueInfo.id ?? 0, teamID: teamID)
        }
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $showStatistic) {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                TeamStatisticScreen(statistic: vm.teamStatistic)
                
            }
        }
        .sheet(isPresented: $showTable) {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                StandingsView(array: vm.standingsArray)
                
            }
        }
        .sheet(isPresented: $showPlayers) {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                TeamPlayersScreen(array: vm.playersArray)
            }
        }
        .sheet(isPresented: $showMatches) {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                TeamAllMatchesScreen(array: vm.allEvent)
            }
        }
        
    }
    private var header: some View{
        ZStack(alignment: .leading) {
            Text("Team Detail")
                .font(.system(size: 21, weight: .medium))
                .frame(maxWidth: .infinity)
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
            }
            
        }
    }
    private var teamInfoLabel: some View{
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 4){
                VerticalTeamLabel(text: vm.teamInformation[0].team?.name ?? "",
                                  image:  vm.teamInformation[0].team?.logo ?? "",
                                  imageSize: 68,
                                  textSize: 21)
                Text(leagueInfo.name ?? "")
                    .font(.system(size: 12, weight: .semibold))
                    .opacity(0.5)
            }
            HStack(spacing: -8){
                KFImage(URL(string: leagueInfo.logo ?? ""))
                    .placeholder({
                        Circle()
                            .fill(Color.accentPink)
                    })
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                    .clipShape(Circle())
                    .background {
                        Circle()
                            .fill(Color.white.opacity(0.03))
                    }
                WebImage(url: URL(string:  leagueInfo.flag ?? "")!, options: [], context: [.imageThumbnailPixelSize : CGSize.zero])
                    .placeholder {ProgressView()}
                    .resizable()
                    .frame(width: 24, height: 24)
                    .clipShape(Circle())
            }
        }
    }
    private var selectedBar: some View{
        HStack{
            Button {
                if vm.teamStatistic != nil{
                    showStatistic.toggle()
                }
            } label: {
                barButton(image: "chart.bar.fill", name: "Statistic")
            }
            Button {
                if !vm.standingsArray.isEmpty{
                    showTable.toggle()
                }
            } label: {
                barButton(image: "square.fill.text.grid.1x2", name: "Table")
            }
            
            Button {
                if !vm.playersArray.isEmpty{
                    showPlayers.toggle()
                }
            } label: {
                barButton(image: "person.3.fill", name: "Players")
            }
            Button {
                if !vm.allEvent.isEmpty{
                    showMatches.toggle()
                }
            } label: {
                barButton(image: "sportscourt.fill", name: "Matches")
            }
        }
        .padding(.vertical)
    }
    private func barButton(image: String, name: String) -> some View {
        HStack{
            Spacer()
            VStack(spacing: 4){
                Image(systemName: image)
                Text(name)
                    .font(.system(size: 13, weight: .medium, design: .default))
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 6)
        .background {
            Color.detailCellBG.cornerRadius(9)
        }
        .padding(.bottom, 25)
    }
    private var nextMatch: some View{
        VStack{
            if !vm.nextEvent.isEmpty{
                NavigationLink {
                    EventDetailScreen(home: (vm.nextEvent[0].teams?.home)!,
                                      away: (vm.nextEvent[0].teams?.away)!,
                                      goal: vm.nextEvent[0].goals!,
                                      fixture: vm.nextEvent[0].fixture!,
                                      league: vm.nextEvent[0].league!)
                } label: {
                    VStack{
                        HStack{
                            Text("Next Game")
                                .font(.system(size: 24, weight: .semibold))
                                .padding()
                            Spacer()
                            ZStack(alignment: .top){
                                Image("date-bage")
                                    .resizable()
                                    .scaledToFit()
                                    .offset(y:-1)
                                Text(DateManager.instance.convertFromStringToString(date: vm.nextEvent[0].fixture?.date ?? "", format: "MMM dd"))
                                    .font(.system(size: 15, weight: .semibold))
                                    .multilineTextAlignment(.center)
                                    .padding(5)
                            }
                            .frame(width: 40, height: 55)
                        }
                        HStack{
                            VerticalTeamLabel(text: vm.nextEvent[0].teams?.home?.name ?? "",
                                              image: vm.nextEvent[0].teams?.home?.logo ?? "",
                                              imageSize: 32,
                                              textSize: 14)
                            VStack{
                                Text(DateManager.instance.convertFromStringToString(date: vm.nextEvent[0].fixture?.date ?? "", format: "HH:mm"))
                                    .font(.custom(.pilat_bold, size: 20))
                                Text(DateManager.instance.convertFromStringToString(date: vm.nextEvent[0].fixture?.date ?? "", format: "MMMM, dd"))
                                    .font(.system(size: 14, weight: .medium))
                                    .opacity(0.5)
                                
                            }
                            VerticalTeamLabel(text: vm.nextEvent[0].teams?.away?.name ?? "",
                                              image: vm.nextEvent[0].teams?.away?.logo ?? "",
                                              imageSize: 32,
                                              textSize: 14)
                        }
                        .padding(.top,-30)
                        .padding()
                    }
                    .foregroundColor(.white)
                    .background {
                        LinearGradient(colors: [Color(red: 0.14, green: 0.18, blue: 0.22), Color(red: 0.09, green: 0.12, blue: 0.15)], startPoint: .leading, endPoint: .trailing)
                            .cornerRadius(10)
                    }
                }
            }else{
                EmptyState()
            }
        }
    }
    private var lastResultLabel: some View{
        VStack(alignment: .leading) {
            Text("Last Results")
                .font(.system(size: 24, weight: .semibold))
                .padding()
            if !vm.last5Event.isEmpty{
                HStack(alignment: .top){
                    
                    ForEach(vm.last5Event) { event in
                        lastResultCell(image1: event.teams?.home?.logo ?? "",
                                       image2: event.teams?.away?.logo ?? "",
                                       date: DateManager.instance.convertFromStringToString(date: event.fixture?.date ?? "", format: "dd, MMMM"),
                                       goalHome: event.goals?.home ?? 0,
                                       goalAway: event.goals?.away ?? 0,
                                       color:  (event.teams?.home?.winner ?? false) && (!(event.teams?.away?.winner ?? false)) ? .green : (!(event.teams?.home?.winner ?? false)) && ((event.teams?.away?.winner ?? false)) ? .red : .yellow)
                    }
                    
                }
            }else{
                EmptyState()
            }
        }
        .padding(.bottom)
        .background {
            LinearGradient(colors: [Color(red: 0.14, green: 0.18, blue: 0.22), Color(red: 0.09, green: 0.12, blue: 0.15)], startPoint: .leading, endPoint: .trailing)
                .cornerRadius(10)
        }
    }
    private func lastResultCell(image1: String, image2: String, date: String, goalHome: Int, goalAway: Int, color: Color) -> some View{
        VStack{
            HStack(spacing: -10){
                KFImage(URL(string: image1 ))
                    .placeholder({
                        Circle()
                            .fill(Color.accentPink)
                    })
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32)
                    .clipShape(Circle())
                KFImage(URL(string: image2 ))
                    .placeholder({
                        Circle()
                            .fill(Color.accentPink)
                    })
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32)
                    .clipShape(Circle())
            }
            HStack(spacing: 0){
                Text("\(goalHome)")
                    .opacity(0.5)
                Text(" : \(goalAway)")
            }
            .font(.custom(.pilat_bold, size: 14))
            Text(date)
                .font(.system(size: 10, weight: .semibold))
                .opacity(0.5)
            
            
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 5)
        .background {
            Color.detailCellBG
                .border(width: 3, edges: [.top], color: color)
        }
    }
    private func statisticCell(label: String, value: Int,progress: Double, color: Color) -> some View {
        HStack{
            Spacer()
            VStack{
                Text(label)
                    .font(.system(size: 15))
                ZStack{
                    CustomCircleProgressView(percent: progress, tintColor: color, size: 75)
                    Text(String(value))
                        .font(.system(size: 16, weight: .semibold))
                }
            }
            Spacer()
            
        }
    }
    private var statisticLabel: some View{
        VStack(alignment: .leading, spacing: 16){
            Text("Statistic")
                .font(.system(size: 24, weight: .semibold))
            if vm.teamStatistic != nil{
                HStack{
                    statisticCell(label: "Wins", value: vm.teamStatistic?.fixtures?.wins?.total ?? 0, progress: calc(var1: vm.teamStatistic?.fixtures?.wins?.total ?? 0, total: vm.teamStatistic?.fixtures?.played?.total ?? 0), color: .green)
                    statisticCell(label: "Draw", value: vm.teamStatistic?.fixtures?.draws?.total ?? 0, progress: calc(var1: vm.teamStatistic?.fixtures?.draws?.total ?? 0, total: vm.teamStatistic?.fixtures?.played?.total ?? 0), color: .yellow)
                    statisticCell(label: "Lose", value:  vm.teamStatistic?.fixtures?.loses?.total ?? 0, progress: calc(var1: vm.teamStatistic?.fixtures?.loses?.total ?? 0, total: vm.teamStatistic?.fixtures?.played?.total ?? 0), color: .red)
                }
            }else{
                EmptyState()
            }
        }
        .padding()
        .background {
            LinearGradient(colors: [Color(red: 0.14, green: 0.18, blue: 0.22), Color(red: 0.09, green: 0.12, blue: 0.15)], startPoint: .leading, endPoint: .trailing)
                .cornerRadius(10)
        }
    }
    private var previewScroll: some View{
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20){
                if !vm.nextEvent.isEmpty && !vm.last5Event.isEmpty && vm.teamStatistic != nil{
                    
                    nextMatch
                    lastResultLabel
                    statisticLabel
                }else{
                    EmptyState()
                }
            }
            .padding(.bottom)
        }
        .background {
            Color.bg
                .border(.white.opacity(0.2), width: 1)
                .padding(-20)
            
        }
    }
    private func calc(var1: Int, total: Int) -> Double{
        if total != 0{
            return Double(var1)/Double(total)
        }else{
            return 0
        }
    }
}

//struct TeamDetailScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        //TeamDetailScreen()
//        TeamPlayersScreen()
//    }
//}

struct TeamStatisticScreen: View{
    var statistic:TeamStatResponse?
    //var array:[StatisticResponse]
    var body: some View{
        ZStack{
            Color.bg.ignoresSafeArea()
            VStack(alignment: .leading){
                Text("Statistic")
                    .font(.system(size: 34, weight: .bold))
                    .padding()
                if statistic != nil{
                    statisticList
                }else{
                    EmptyState()
                }
                
            }
            .foregroundColor(.white)
        }
        
    }
    
    private var statisticList: some View{
        ScrollView(showsIndicators: false) {
            VStack{
                statisticCell(label: "Played", value: statistic?.fixtures?.played?.total ?? 0)
                statisticCell(label: "Wins", value: statistic?.fixtures?.wins?.total ?? 0)
                statisticCell(label: "Draws", value: statistic?.fixtures?.draws?.total ?? 0)
                statisticCell(label: "Loses", value: statistic?.fixtures?.loses?.total ?? 0)
                statisticCell(label: "Clean Sheet", value: statistic?.clean_sheet?.total ?? 0)
                statisticCell(label: "Failed To Score", value: statistic?.failed_to_score?.total ?? 0)
                statisticCell(label: "Goals For", value: (statistic?.goals?._for?.home ?? 0) + (statistic?.goals?._for?.away ?? 0))
                statisticCell(label: "Red Cards", value: statistic?.cards?.red?.totalCards ?? 0)
                statisticCell(label: "Yellow Cards", value: statistic?.cards?.yellow?.totalCards ?? 0)
            }
            
            .background {
                Color.detailBG.cornerRadius(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    }
            }
            .padding(.horizontal)
        }
        .ignoresSafeArea(.all, edges: .bottom)
        
    }
    private func statisticCell(label: String, value: Int) -> some View{
        HStack{
            Text(label)
                .font(.system(size: 14))
            Spacer()
            Text("\(value)")
                .font(.system(size: 16, weight: .semibold))
            
        }
        .padding()
        
    }
}
struct TeamAllMatchesScreen: View{
    var array:[MainResponse]
    var body: some View{
        NavigationView{
            ZStack{
                Color.bg.ignoresSafeArea()
                VStack(alignment: .leading){
                    Text("All Matches")
                        .font(.system(size: 34, weight: .bold))
                        .padding()
                    if !array.isEmpty{
                        eventList
                    }else{
                                    EmptyState()
                                }
                }
                .foregroundColor(.white)
            }
        }
    }
    private var eventList: some View{
        ScrollView(showsIndicators: false) {
            VStack{
                ForEach(array) { event in
                    NavigationLink {
                        EventDetailScreen(home: (event.teams?.home)!,
                                          away: (event.teams?.away)!,
                                          goal: event.goals!,
                                          fixture: event.fixture!,
                                          league: event.league!)
                    } label: {
                        
                        EventMainCell(league: event.league!,
                                      fixture: event.fixture!,
                                      home: (event.teams?.home)!,
                                      away: (event.teams?.away)!,
                                      goals: event.goals!)
                    }
                    .simultaneousGesture(TapGesture().onEnded({
                        Vibration.instance.simpleSuccess()
                    }))            }
                
                .background {
                    Color.detailBG.cornerRadius(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.white.opacity(0.2), lineWidth: 1)
                        }
                }
                .padding(.horizontal)
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
}
struct TeamPlayersScreen: View{
    var array:[PlayersResponse]
    var body: some View{
        ZStack{
            Color.bg.ignoresSafeArea()
            VStack(alignment: .leading){
                Text("Players")
                    .font(.system(size: 34, weight: .bold))
                    .padding()
                
                if !array.isEmpty{
                    playersList
                }else{
                    EmptyState()
                }
            }
            .foregroundColor(.white)
        }
        
    }
    private var playersList: some View{
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24){
                attackersList
                defendersList
                midfieldersList
                goalkeepersList
            }
        }
    }
    private var attackersList: some View{
        VStack(alignment: .leading){
            Text("Attackers")
                .font(.system(size: 24, weight: .semibold))
            ForEach(array[0].players!) { player in
                if player.position == "Attacker"{
                    playerCell(image: player.photo ?? "", name: player.name ?? "", number: player.number ?? 0, age: player.age ?? 0)
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
        .padding(.horizontal)
        
    }
    private var defendersList: some View{
        VStack(alignment: .leading){
            Text("Defenders")
                .font(.system(size: 24, weight: .semibold))
            ForEach(array[0].players!) { player in
                if player.position == "Defender"{
                    playerCell(image: player.photo ?? "", name: player.name ?? "", number: player.number ?? 0, age: player.age ?? 0)
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
        .padding(.horizontal)
        
    }
    private var midfieldersList: some View{
        VStack(alignment: .leading){
            Text("Midfielders")
                .font(.system(size: 24, weight: .semibold))
            ForEach(array[0].players!) { player in
                if player.position == "Midfielder"{
                    playerCell(image: player.photo ?? "", name: player.name ?? "", number: player.number ?? 0, age: player.age ?? 0)
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
        .padding(.horizontal)
        
    }
    private var goalkeepersList: some View{
        VStack(alignment: .leading){
            Text("Goalkeepers")
                .font(.system(size: 24, weight: .semibold))
            ForEach(array[0].players!) { player in
                if player.position == "Goalkeeper"{
                    playerCell(image: player.photo ?? "", name: player.name ?? "", number: player.number ?? 0, age: player.age ?? 0)
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
        .padding(.horizontal)
        
    }
    private func playerCell(image: String, name: String, number: Int, age: Int) -> some View{
        HStack{
            KFImage(URL(string: image))
                .placeholder({
                    Circle()
                        .fill(Color.accentPink)
                })
                .resizable()
                .scaledToFit()
                .frame(width: 32)
                .clipShape(Circle())
            VStack(alignment: .leading){
                Text(name)
                    .font(.system(size: 12, weight: .medium))
                Text(String(age))
                    .font(.system(size: 10))
                    .opacity(0.5)
            }
            Spacer()
            Text("#\(number)")
                .font(.system(size: 15, weight: .medium))
        }
        .padding()
        .background {
            Color.detailCellBG.cornerRadius(10)
        }
    }
}

