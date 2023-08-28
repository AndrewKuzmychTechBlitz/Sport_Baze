//
//  MainViewModel.swift
//  Sport_Baze
//
//  Created by Андрій Кузьмич on 18.08.2023.
//

import SwiftUI
import Foundation
import Alamofire
final class MainViewModel: ObservableObject{
    @Published var eventsArray:[MainResponse] = []
    @Published var mostExpectedEvent:[PublishMain] = []
    //@Published var liveEvent: [MainResponse] = []
    //@Published var dateArray: [DateBar] = []
    @Published var date = Date()
    @Published var selectedDate: Date = Date()
    @Published var savedEvent:[SavedEvent] = []
    var color = [LinearGradient(colors: [Color(red: 0.95, green: 0.17, blue: 0.3),Color(red: 1, green: 0.89, blue: 0.5)], startPoint: .leading, endPoint: .trailing), LinearGradient(colors: [.blueGR1, .blueGR2], startPoint: .trailing, endPoint: .leading),LinearGradient(colors: [Color(red: 0.74, green: 0.19, blue: 1),Color(red: 0.01, green: 0.09, blue: 0.5)], startPoint: .leading, endPoint: .trailing) ]
    let popularLeague = [475, 602, 606, 630, 611, 66, 61, 62, 63, 145, 147, 144, 93, 90, 88, 89, 143, 140, 141, 134, 810, 128, 96, 95, 94,
                         39, 40, 41, 42, 48, 136, 135, 430, 119, 120, 239, 81, 78, 79, 200, 208, 269, 268, 106, 108, 107]
    
    func loadAllEvent(){
        var date = DateManager.instance.dateToString(date: self.date, format: "yyyy-MM-dd")
        let url = URL(string: "https://v3.football.api-sports.io/fixtures?date=\(date)&timezone=Europe/Kiev" )
        let headers: HTTPHeaders = ["x-rapidapi-key":"9a49740c5034d7ee252d1e1419a10faa"]
        AF.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: MainData.self) { [weak self] (response) in
                guard let mainData = response.value else { return print(response.error?.errorDescription) }
                self?.findMostExpectedEvents(array: mainData.response!)
                
            }
    }
    func findMostExpectedEvents(array: [MainResponse]){
        var sortedArray: [MainResponse] = []
        for i in array{
            if self.popularLeague.contains((i.league?.id)!) {
                sortedArray.append(i)
            }
        }
        self.eventsArray = sortedArray
        findHotEvent(array: sortedArray)
       // self.checkIsSaved(array: sortedArray)
    }
    func findHotEvent(array: [MainResponse]){
        var index = 0
        var leagueArray:[Int] = []
        var eventArray:[PublishMain] = []
        for i in array{
            
            if !leagueArray.contains(i.league?.id ?? 0){
                if index >= 2{
                  index = 0
                }else{
                    index += 1
                }
                leagueArray.append(i.league?.id ?? 0)
                eventArray.append(PublishMain(isSaved: color[index], value: i))
            }
        }
        self.mostExpectedEvent = eventArray
        print(leagueArray)
        print(eventArray)
    }
//    func checkIsSaved(array : [MainResponse]){
//        var sortedArray: [MainResponse] = []
//        for i in array{
//            if self.savedEvent.contains(where: {$0.fixture.id == i.fixture?.id}){
//                sortedArray.append(i)
//            }else{
//                sortedArray.append(PublishMain(isSaved: false, value: i))
//            }
//        }
//        DispatchQueue.main.async {
//            self.eventsArray = sortedArray
//        }
//    }
//    func findLiveEvents(array: [MainResponse]){
//        var sortedArray: [MainResponse] = []
//        var imagei = 0
//        for i in array{
//            if (i.fixture?.status?.short == "1H"||i.fixture?.status?.short == "2H"){
//                sortedArray.append(i)
//            }
//        }
//        self.liveEvent = sortedArray
//        
//    }
//    func getDate(){
//        var array: [DateBar] = []
//        let date = CalendarRange(calendar: Calendar(identifier: .gregorian), component: .day, epoch: Date(), values: -30 ... 30)
//        var j = 1
//        var currentDate = DateManager.instance.dateToString(date: Date(), format: "yyyy-MM-dd")
//        self.selectedDate = DateManager.instance.dateToString(date: Date(), format: "MMMM d, yyyy")
//        for i in date{
//            var idate = DateManager.instance.dateToString(date: i, format: "yyyy-MM-dd")
//            if idate == currentDate{
//                array.append( DateBar(id: j, month: DateManager.instance.dateToString(date: i, format: "MMM"),
//                                      day: DateManager.instance.dateToString(date: i, format: "dd"),
//                                      date: i, isTapped: true))
//            }else{
//                array.append( DateBar(id: j, month: DateManager.instance.dateToString(date: i, format: "MMM"),
//                                      day: DateManager.instance.dateToString(date: i, format: "dd"),
//                                      date: i, isTapped: false))
//            }
//            j += 1
//        }
//        self.dateArray = array
//    }
//    func dateTapped(item: DateBar){
//        var array: [DateBar] = []
//        self.date = item.date
//        for i in self.dateArray{
//            array.append(DateBar(id: i.id, month: i.month, day: i.day, date: i.date, isTapped: false))
//            if i.date == item.date{
//                let idx = array.firstIndex(where: {$0.date == item.date})
//                array[idx!] = DateBar(id: item.id, month: item.month, day: item.day, date: item.date, isTapped: true)
//                self.selectedDate = DateManager.instance.dateToString(date:  array[idx!].date, format: "MMMM d, yyyy")
//            }
//        }
//        self.dateArray = array
//        self.loadAllEvent()
//    }
}

struct PublishMain{
    var isSaved: LinearGradient
    var value: MainResponse
}
extension PublishMain{
    var id: UUID{
        return UUID()
    }
}
struct SavedEvent: Codable, Identifiable{
    
    var home: MainAway
    var away: MainAway
    var league: League
    var goal: Goals
    var fixture: Fixture
    //var isRemindered: Bool
}
extension SavedEvent{
    var id: UUID{
        return UUID()
    }
}
