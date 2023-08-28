//
//  MainScreen.swift
//  Sport_Baze
//
//  Created by Андрій Кузьмич on 17.08.2023.
//

import SwiftUI
import Kingfisher

struct MainScreen: View {
    var orangeGR = LinearGradient(colors: [Color(red: 0.95, green: 0.17, blue: 0.3),Color(red: 1, green: 0.89, blue: 0.5)], startPoint: .leading, endPoint: .trailing)
    var blueGR = LinearGradient(colors: [.blueGR1, .blueGR2], startPoint: .trailing, endPoint: .leading)
    var purpleGR = LinearGradient(colors: [Color(red: 0.74, green: 0.19, blue: 1),Color(red: 0.01, green: 0.09, blue: 0.5)], startPoint: .leading, endPoint: .trailing)
    let itemWidth: CGFloat = 155
    @StateObject var vm = MainViewModel()
    @State var array:[LinearGradient] = []
    @State var index: Int = 2
    @State private var activeLiveIndex: Int = 0
    @State private var navigateLive: Bool = true
    @State var navigateToRoot: Bool = false
    var body: some View {
        ZStack(alignment: .top){
            Color.bg.ignoresSafeArea()
            VStack{
                header
//                hotEventCell(bg: orangeGR)
//                hotEventCell(bg: blueGR)
//                hotEventCell(bg: purpleGR)
                if !vm.eventsArray.isEmpty && !vm.mostExpectedEvent.isEmpty{
                    hotEventScroll
                    allEventScroll
                }else{
                    EmptyState()
                }
            }
            .foregroundColor(.white)
            .onAppear{
                array = [purpleGR, blueGR, orangeGR]
                vm.loadAllEvent()
            }
        }
        .navigationBarBackButtonHidden()
       
    }
    private var header: some View{
        HStack{
            Text(DateManager.instance.dateToString(date: vm.selectedDate, format: "MMM, dd"))
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.blueGR2)
            Spacer()
            Image("calendar")
                .font(.title3)
                .overlay{
                    DatePicker(
                        "",
                        selection: $vm.date,
                        displayedComponents: [.date]
                    )
                    .blendMode(.destinationOver)
                    //a.accentColor(.appOrange)
                    .onChange(of: vm.date) { newValue in
                        vm.selectedDate = vm.date
                        vm.loadAllEvent()
                    }
                }

        }
        .padding()
    }
    private func hotEventCell(bg: LinearGradient, league: League, fixture: Fixture,  home: MainAway, away: MainAway, goals: Goals, isNavigate: Bool) -> some View{
        VStack{
            HStack(spacing: -20){
                KFImage(URL(string: home.logo ?? ""))
                    .placeholder({
                        Circle()
                            .fill(Color.accentPink)
                    })
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48)
                    .clipShape(Circle())
                    //.padding(16)
                    
                KFImage(URL(string: away.logo ?? ""))
                    .placeholder({
                        Circle()
                            .fill(Color.accentPink)
                    })
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48)
                    .clipShape(Circle())
                    //.padding(16)
            }
            Text(DateManager.instance.convertFromStringToString(date: fixture.date ?? "", format: "HH:mm"))
                .font(.custom(.pilat_bold, size: 20))
            Text(DateManager.instance.convertFromStringToString(date: fixture.date ?? "", format: "MMM, dd"))
                .font(.system(size: 14, weight: .medium))
                .opacity(0.5)
                    HStack{
                        Text("Detail")
                            .font(.system(size: 12, weight: .medium))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 7))
                            .frame(width: 14, height: 14)
                            .overlay {
                                Circle()
                                    .stroke(lineWidth: 1)
                            }

                 
            }
        }
        .padding()
        .frame(width: 155, height: 144, alignment: .center)
        .background {
            ZStack(alignment: .topTrailing){
                bg.cornerRadius(10)
                Image("Exclude")
                Image("fire.fill")
                    
                    .padding(6)
                    .background {
                        Circle()
                    }
                    .offset(x: 5, y: -10)
                
            }
        }
    }
    private var hotEventScroll: some View{
        VStack {
            Text("Hot Matches")
                .font(.system(size: 24, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)

            GeometryReader { geometry in
                AdaptivePagingScrollView(currentPageIndex: $activeLiveIndex, onNavigating: $navigateLive,
                                         itemsAmount: vm.mostExpectedEvent.count - 1,
                                         itemWidth: itemWidth,
                                         itemPadding:45,
                                         pageWidth: geometry.size.width) {
                    GeometryReader { screen in
                        HStack(alignment: .bottom,spacing: 45){
                            ForEach(vm.mostExpectedEvent.indices) { i in
                                NavigationLink {
                                    EventDetailScreen(home: (vm.mostExpectedEvent[i].value.teams?.home)!,
                                                      away: (vm.mostExpectedEvent[i].value.teams?.away)!,
                                                      goal: vm.mostExpectedEvent[i].value.goals!,
                                                      fixture: vm.mostExpectedEvent[i].value.fixture!,
                                                      league: vm.mostExpectedEvent[i].value.league!)
                                } label: {
                                    hotEventCell(bg: vm.mostExpectedEvent[i].isSaved,
                                                 league: vm.mostExpectedEvent[i].value.league! ,
                                                 fixture: vm.mostExpectedEvent[i].value.fixture!,
                                                 home: (vm.mostExpectedEvent[i].value.teams?.home)!,
                                                 away: (vm.mostExpectedEvent[i].value.teams?.away)!,
                                                 goals:vm.mostExpectedEvent[i].value.goals!,
                                                 isNavigate: i == activeLiveIndex)
                                        .scaleEffect(i == activeLiveIndex ? 1.5 : 1, anchor: .bottom)
                                }

                                
                            }
                        }
                        .frame(height: 216, alignment: .bottom)
                    }
                    .frame(width: self.itemWidth, height: 216, alignment: .bottom)
                }
            }
            .frame(width: self.itemWidth, height: 216, alignment: .bottom)
        }
    }
    private var allEventScroll: some View{
        VStack {
            Text("All Matches")
                .font(.system(size: 24, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)

            if !vm.eventsArray.isEmpty{
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(vm.eventsArray) { event in
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

                       
                    }
                }
            }else{
                EmptyState()
            }
        }
        .padding(.horizontal)

    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
struct EventMainCell: View{
    var league: League
    var fixture: Fixture
    var home: MainAway
    var away: MainAway
    var goals: Goals
    var body: some View{
        VStack{
            HStack{
                fire
                Spacer()
                date
            }
            HStack{
                VerticalTeamLabel(text: home.name ?? "", image: home.logo ?? "", imageSize: 32, textSize: 14)
                goal
                VerticalTeamLabel(text:  away.name ?? "", image:  away.logo ?? "", imageSize: 32, textSize: 14)
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
    private var fire: some View{
        HStack{
            Image("fire")
            Image("fire.fill")
            Image("fire.fill")
        }
        .padding(.horizontal)
    }
    private var date: some View{
        ZStack(alignment: .top){
            Image("date-bage")
                .resizable()
                .scaledToFit()
                .offset(y:-1)
            Text(DateManager.instance.convertFromStringToString(date: fixture.date ?? "", format: "MMM, dd"))
                .font(.system(size: 15, weight: .semibold))
                .multilineTextAlignment(.center)
                .padding(5)
        }
        .frame(width: 40, height: 55)
    }
    private var goal: some View{
        VStack{
            HStack(spacing: 0){
                Text("\(goals.home ?? 0) ")
                    .opacity(0.5)
                Text(": \(goals.away ?? 0) ")
            }
            .font(.custom(.pilat_bold, size: 20))
            Text("\(fixture.status?.elapsed ?? 0)'")
                .opacity(0.5)
                .font(.system(size: 14, weight: .medium))
        }
    }
}
struct VerticalTeamLabel: View {
    var text: String
    var image: String
    var imageSize: CGFloat
    var textSize: CGFloat
    var body: some View{
        HStack{
            Spacer()
            VStack(spacing: 12){
                
                KFImage(URL(string: image))
                    .placeholder({
                        Circle()
                            .fill(Color.accentPink)
                    })
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageSize)
                    .clipShape(Circle())
                    .padding(16)
                    .background {
                        Circle()
                            .fill(Color.white.opacity(0.03))
                    }
                Text(text)
                    .font(.system(size: textSize, weight: .medium))
                    .multilineTextAlignment(.center)
                
            }
            Spacer()
        }
    }
    
}
struct EmptyState: View{
    var body: some View{
        VStack{
            Text("Dear user, at the moment there is no relevant information in this block.")
                .font(.system(size: 15))
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.5))
            Spacer()
        }
        .padding(.horizontal)
    }
}
