//
//  EventDetalScreen.swift
//  Sport_Baze
//
//  Created by Андрій Кузьмич on 21.08.2023.
//

import SwiftUI
import Kingfisher

struct EventDetailScreen: View {
    let home: MainAway
    let away: MainAway
    let goal: Goals
    let fixture: Fixture
    let league: League
    @State var tabIndex: Int = 0
    @State var showStatistic: Bool = false
    @State var showEvents: Bool = false
    @State var showTable: Bool = false
    @State var showLineUp: Bool = false
    @State var alertText: String = "added"
    @State var showSavedEventAlert: Bool = false
    @State var shareText: ShareText?
    @Environment(\.dismiss) var dismiss
    @StateObject var vm = DetailViewModel()
    
    var body: some View {
        ZStack(alignment: .top){
            Color.detailBG.ignoresSafeArea()
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 20){
                    header
                    teamsLabel
                    dopTeamInfo
                    selectedBar
                    previewScroll
                }
                .foregroundColor(.white)
                .padding(.horizontal)
                .onAppear{
                    vm.loadEvents(fixture: fixture.id ?? 0)
                    vm.loadStatistics(fixture: fixture.id ?? 0)
                    vm.loadStandings(league: league.id ?? 0)
                    vm.loadLineUp(fixture: fixture.id ?? 0)
                    vm.savedEvent = UserDefaultsBuffer.savedEvent!
                    vm.isEventSaved(item: SavedEvent(home: home, away: away, league: league, goal: goal, fixture: fixture))
                }
            }
        }
        .navigationBarBackButtonHidden()
        .sheet(item: $shareText) { shareText in
            ActivityView(text: shareText.text)
        }
        .sheet(isPresented: $showStatistic) {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                StatisticView(array: vm.statisticArray)
                
            }
        }
        .sheet(isPresented: $showEvents) {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                EventView(array: vm.eventsArray, home: home, away: away)
                
            }
        }
        .sheet(isPresented: $showTable) {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                StandingsView(array: vm.standingsArray)
                
            }
        }
        .sheet(isPresented: $showLineUp) {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                LineUpView(array: vm.lineUpArray)
            }
        }
        .alert(isPresented: $showSavedEventAlert) {
            Alert(title: Text("Success! A event has been \(alertText)"))
        }

    }
    private var header: some View{
        ZStack{
            Text("Detail Event")
                .font(.system(size: 21, weight: .medium))
            HStack{
                Button {
                    DispatchQueue.global().async {
                        UserDefaultsBuffer.savedEvent = vm.savedEvent
                    }
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 21))
                }
                Spacer()
                Menu {
                    Button {
                        if vm.isSaved{
                            vm.removeEvent(item: SavedEvent(home: home, away: away, league: league,  goal: goal, fixture: fixture))
                            alertText = "deleted"
                            showSavedEventAlert.toggle()
                        }else{
                            vm.addEvent(item: SavedEvent(home: home, away: away, league: league, goal: goal, fixture: fixture))
                            alertText = "added"
                            showSavedEventAlert.toggle()
                        }
                        Vibration.instance.simpleSuccess()
                    } label: {
                        Text( vm.isSaved ? "Delete Event" : "Save Event")
                    }
                    Button {
                        shareText = ShareText(text: " https://apps.apple.com/app/id6448792803")
                        Vibration.instance.simpleSuccess()
                    } label: {
                       Text("Share")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 13))
                        .overlay {
                            Circle()
                                .stroke(lineWidth: 2)
                                .frame(width: 24, height: 24)
                        }
                        .frame(width: 45, height: 45)
                }
            }
        }        
    }
    private var teamsLabel: some View{
        HStack(alignment: .top){
            NavigationLink {
                TeamDetailScreen(leagueInfo: league, teamID: home.id ?? 0)
            } label: {
                teamLabel(image: home.logo ?? "", name: home.name ?? "")

            }

            goalLabel
            NavigationLink {
                TeamDetailScreen(leagueInfo: league, teamID: away.id ?? 0)
            } label: {
                teamLabel(image: away.logo ?? "", name: away.name ?? "")
            }
        }
        .padding(.vertical, 12)
        .background {
            Color.detailCellBG.cornerRadius(64)
        }
    }
    private var dopTeamInfo: some View{
        VStack(spacing: 8){
            
            dopTeamInfoLabel(label: "League", value: league.name ?? "")
            HStack{
                Text("Date:")
                    .font(.system(size: 12))
                Spacer()
                Text(DateManager.instance.convertFromStringToString(date: fixture.date ?? "", format: "dd MMMM, "))
                    .font(.system(size: 12, weight: .semibold))
                    .opacity(0.5)
                Text(DateManager.instance.convertFromStringToString(date: fixture.date ?? "", format: "HH:mm"))
                    .font(.system(size: 12, weight: .semibold))
            }
            dopTeamInfoLabel(label: "Location", value: fixture.venue?.name ?? "")
        }
    }
    private func teamLabel(image: String, name: String) -> some View{
        HStack{
            Spacer()
            VStack{
                KFImage(URL(string: image))
                    .placeholder({
                        Circle()
                            .fill(Color.accentPink)
                    })
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32)
                    .clipShape(Circle())
                Text(name)
                    .font(.system(size: 15, weight: .medium))
                    .multilineTextAlignment(.center)
                
            }
            Spacer()
            
        }
    }
    private func dopTeamInfoLabel(label: String, value: String) -> some View{
        HStack{
            Text("\(label):")
                .font(.system(size: 12))
            Spacer()
            Text(value)
                .font(.system(size: 12, weight: .semibold))
        }
    }
    private var goalLabel: some View{
        VStack{
            if (fixture.status?.short ?? "") == "FT"{
                HStack(spacing: 0){
                    Text("\(goal.home ?? 0)")
                        .opacity(0.5)
                    Text(" : \(goal.away ?? 0)")
                }
                .font(.custom(.pilat_bold, size: 20))
            }else{
                Text("- : -")
                    .font(.custom(.pilat_bold, size: 20))
            }
            Text("\(fixture.status?.elapsed ?? 0)'")
                .font(.system(size: 14, weight: .medium))
                .opacity(0.5)
        }
    }
    private var selectedBar: some View{
        HStack{
            Button {
                if !vm.statisticArray.isEmpty{
                    showStatistic.toggle()
                }
            } label: {
                barButton(image: "chart.bar.fill", name: "Statistic")
            }
            
            
            Button {
                if !vm.eventsArray.isEmpty{
                    showEvents.toggle()
                }
            } label: {
                barButton(image: "clock.fill", name: "Events")
            }
            
            Button {
                if !vm.eventsArray.isEmpty{
                    showTable.toggle()
                }
            } label: {
                barButton(image: "square.fill.text.grid.1x2", name: "Table")
            }
           
            Button {
                if !vm.lineUpArray.isEmpty{
                    showLineUp.toggle()
                }
            } label: {
                barButton(image: "sportscourt", name: "Lineup")
            }
        }
    }
    private var previewScroll: some View{
        ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20){
                    if !vm.statisticArray.isEmpty && !vm.standingsArray.isEmpty && !vm.eventsArray.isEmpty{
                        Button {
                            showStatistic.toggle()
                        } label: {
                            matchStatisticItem
                        }
                    
                   // if {
                        Button {
                            showEvents.toggle()
                        } label: {
                            matchEventItem
                        }
                   // }
//                    if {
                        Button {
                            showTable.toggle()
                        } label: {
                            tableItem
                        }
                    }else{
                        EmptyState()
                    }
                    Spacer()
            }
        }
        .background {
            Color.bg
                .border(.white.opacity(0.2), width: 1)
                .padding(-20)
            
        }
        
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
    private var matchStatisticItem: some View{
        VStack{
            HStack(spacing: 5){
                Text("MATCH STATISTIC")
                    .font(.system(size: 18, weight: .medium))
                Spacer()
                Text("See All")
                    .font(.system(size: 14))
                    .foregroundColor(.blueGR2)
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.blueGR2)
            }
            .padding(.bottom, 12)
            HStack(spacing: 12){
                ZStack{
                    CustomCircleProgressView(percent: calcBallPosession(value1: vm.statisticArray[0].statistics?[9].value?.stringValue ?? ""), tintColor: .accentPink, size: 48)
                    Text(vm.statisticArray[0].statistics?[9].value?.stringValue ?? "")
                        .font(.system(size: 15, weight: .semibold))
                }
                VStack(spacing: 12){
                    ForEach(0..<3) { i in
                        HStack{
                            Text(String(vm.statisticArray[0].statistics?[i].value?.intValue ?? 0))
                                .font(.system(size: 16, weight: .semibold))
                            Spacer()
                            Text(vm.statisticArray[0].statistics?[i].type ?? "")
                                .font(.system(size: 14))
                                .opacity(0.5)
                            Spacer()
                            Text(String(vm.statisticArray[1].statistics?[i].value?.intValue ?? 0))
                                .font(.system(size: 16, weight: .semibold))
                        }
                    }
                }
                ZStack{
                    CustomCircleProgressView(percent: calcBallPosession(value1: vm.statisticArray[1].statistics?[9].value?.stringValue ?? ""), tintColor: .blueGR2, size: 48)
                        .rotationEffect(.degrees(180))
                    Text(vm.statisticArray[1].statistics?[9].value?.stringValue ?? "")
                        .font(.system(size: 15, weight: .semibold))
                }
            }
        }
        .padding()
        .background{
            Color.detailBG.cornerRadius(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                }
        }
    }
    private var matchEventItem: some View{
        VStack{
            HStack(spacing: 5){
                Text("MATCH EVENT")
                    .font(.system(size: 18, weight: .medium))
                Spacer()
                Text("See All")
                    .font(.system(size: 14))
                    .foregroundColor(.blueGR2)
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.blueGR2)
            }
            .padding(.bottom, 12)
            ForEach(0..<4) { i in
                if home.name ?? "" == vm.eventsArray[i].team?.name ?? ""{
                    if vm.eventsArray[i].type ?? "" == "subst"{
                        EventHomeSubst(time: vm.eventsArray[i].time?.elapsed ?? 0,
                                       playerName: vm.eventsArray[i].player?.name ?? "",
                                       asistName: vm.eventsArray[i].assist?.name ?? "")
                    }else{
                        EventHome(time: vm.eventsArray[i].time?.elapsed ?? 0,
                                  playerName: vm.eventsArray[i].player?.name ?? "",
                                  eventImage: vm.eventsArray[i].detail ?? "")
                    }
                }else{
                    if vm.eventsArray[i].type ?? "" == "subst"{
                        EventAwaySubst(time: vm.eventsArray[i].time?.elapsed ?? 0,
                                       playerName: vm.eventsArray[i].player?.name ?? "",
                                       asistName: vm.eventsArray[i].assist?.name ?? "")
                    }else{
                        EventAway(time: vm.eventsArray[i].time?.elapsed ?? 0,
                                  playerName: vm.eventsArray[i].player?.name ?? "",
                                  eventImage: vm.eventsArray[i].detail ?? "")
                    }
                }
            }
            
        }
        .padding()
        .background{
            Color.detailBG.cornerRadius(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                }
        }
    }
    private var tableItem: some View{
        VStack{
            HStack(spacing: 5){
                Text("Table")
                    .font(.system(size: 18, weight: .medium))
                Spacer()
                Text("See All")
                    .font(.system(size: 14))
                    .foregroundColor(.blueGR2)
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.blueGR2)
            }
            .padding(.bottom, 12)
            if vm.standingsArray.count < 4{
                ForEach(vm.standingsArray) { match in
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
            }else{
                ForEach(0..<4) { i in
                    StandingsCell(num: vm.standingsArray[i].rank ?? 0,
                                  image: vm.standingsArray[i].team?.logo ?? "",
                                  name: vm.standingsArray[i].team?.name ?? "",
                                  m: vm.standingsArray[i].all?.played ?? 0,
                                  p: vm.standingsArray[i].all?.win ?? 0,
                                  d: vm.standingsArray[i].all?.draw ?? 0,
                                  l: vm.standingsArray[i].all?.lose ?? 0,
                                  gd: vm.standingsArray[i].goalsDiff ?? 0,
                                  pts: vm.standingsArray[i].points ?? 0)

                }
            }
                
        }
        .padding()
        .background{
            Color.detailBG.cornerRadius(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                }
        }
    }
    //    private func onButtonTapped(index: Int) {
    //        withAnimation(.linear) { tabIndex = index }
    //    }
    private func calcBallPosession(value1: String)-> Double{
        var Value1  = value1
        Value1.removeLast()
        return (Double(Value1) ?? 0.0) / Double(100)
    }
    
}


struct BarButton: View {
    var name: String
    var image: String
    @Binding var isSelected: Bool
    var body: some View {
        VStack{
            HStack{
                Spacer()
                VStack{
                    Image(systemName: image)
                    Text(name)
                        .font(.system(size: 16, weight: .medium, design: .default))
                }
                
                Spacer()
            }
            
        }
        .padding(.vertical, 5)
        .opacity(isSelected ? 1 : 0.5)
    }
    
}
struct CustomCircleProgressView: View {
    var percent: Double
    var tintColor: Color
    var size: CGFloat
    var body: some View {
        ZStack(alignment: .leading) {
            Circle()
                .stroke(Color.white.opacity(0.2), lineWidth: 4)
            Circle()
                .trim(from: 0, to: percent)
                .stroke(tintColor, lineWidth: 4)
        }
        .frame(width: size)
    }
    func calPercent()-> CGFloat{
        let width = (UIScreen.main.bounds.width - 70) / 2
        return width * self.percent
    }
}





extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

//struct EventDetailScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        //EventDetalScreen()
//        // StandingsView()
//        //StatisticView()
//        //EventAway(time: 89, playerName: "Jay Matete", eventImage: "Red Card")
//        //LineUpView()
//    }
//}
extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}
struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        edges.map { edge -> Path in
            switch edge {
            case .top: return Path(.init(x: rect.minX, y: rect.minY, width: rect.width, height: width))
            case .bottom: return Path(.init(x: rect.minX, y: rect.maxY - width, width: rect.width, height: width))
            case .leading: return Path(.init(x: rect.minX, y: rect.minY, width: width, height: rect.height))
            case .trailing: return Path(.init(x: rect.maxX - width, y: rect.minY, width: width, height: rect.height))
            }
        }.reduce(into: Path()) { $0.addPath($1) }
    }
}
