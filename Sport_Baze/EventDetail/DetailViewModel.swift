//
//  DetailViewModel.swift
//  Sport_Baze
//
//  Created by Андрій Кузьмич on 23.08.2023.
//

import Foundation
import Alamofire
final class DetailViewModel: ObservableObject{
    @Published var standingsArray:[Standing] = []
    @Published var eventsArray:[EventsResponse] = []
    @Published var statisticArray: [StatisticResponse] = []
    @Published var lineUpArray:[LineUPResponse] = []
    @Published var savedEvent:[SavedEvent] = []
    @Published var isSaved = false


    func loadStandings(league: Int) {
        let url = URL(string: "https://v3.football.api-sports.io/standings?league=\(league)&season=2022")
        let headers: HTTPHeaders = ["x-rapidapi-key":"9a49740c5034d7ee252d1e1419a10faa"]
        AF.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: Standings.self) { (response) in
                guard let standings = response.value else {return print(response.error)}
                if (!standings.response!.isEmpty){
                    self.standingsArray = standings.response![0].league?.standings![0] ?? []
                }
            }
    }
    func loadEvents(fixture: Int){
        let url = URL(string: "https://v3.football.api-sports.io/fixtures/events?fixture=\(fixture)")
        let headers: HTTPHeaders = ["x-rapidapi-key":"9a49740c5034d7ee252d1e1419a10faa"]
        AF.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: Events.self) { [weak self] (response) in
                guard let mainData = response.value else { return print(response.error) }
                self?.eventsArray = mainData.response!
            }
    }
    
    func loadStatistics(fixture: Int){
        let url = URL(string: "https://v3.football.api-sports.io/fixtures/statistics?fixture=\(fixture)")
        let headers: HTTPHeaders = ["x-rapidapi-key":"9a49740c5034d7ee252d1e1419a10faa"]
        AF.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: StatisticData.self) {[weak self] (response) in
                guard let mainData = response.value else { return print(response.error) }
                self?.statisticArray = mainData.response!
            }
    }
    func loadLineUp(fixture: Int){
        let url = URL(string: "https://v3.football.api-sports.io/fixtures/lineups?fixture=\(fixture)")
        let headers: HTTPHeaders = ["x-rapidapi-key":"9a49740c5034d7ee252d1e1419a10faa"]
        AF.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: LineUPModel.self) {  [weak self] (response) in
                guard let mainData = response.value else { return print(response.error?.errorDescription) }
                self?.lineUpArray = mainData.response!
            }
    }
    func addEvent(item: SavedEvent){
        self.savedEvent.append(item)
        isEventSaved(item: item)
    }

    func removeEvent(item: SavedEvent){
        if let itemToRemove = savedEvent.remove(where: {$0.fixture.id! == item.fixture.id!}){
        }
        isEventSaved(item: item)
    }
    
    func isEventSaved(item: SavedEvent){
        if savedEvent.contains(where: {$0.fixture.id == item.fixture.id}) == true{
            objectWillChange.send()
            self.isSaved = true
        }else{
            self.isSaved = false
        }
    }
}
