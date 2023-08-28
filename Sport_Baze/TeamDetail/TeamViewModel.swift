//
//  TeamViewModel.swift
//  Sport_Baze
//
//  Created by Андрій Кузьмич on 28.08.2023.
//

import Foundation
import Alamofire
final class TeamDetailViewModel: ObservableObject{
    @Published var playersArray: [PlayersResponse] = []
    @Published var teamStatistic:TeamStatResponse?
    @Published var teamInformation: [TeamInformationResponse] = []
    @Published var last5Event: [MainResponse] = []
    @Published var allEvent: [MainResponse] = []
    @Published var nextEvent: [MainResponse] = []
    @Published var standingsArray:[Standing] = []
    
    func loadPlayers(id: Int){
        let url = URL(string: "https://v3.football.api-sports.io/players/squads?team=\(id)")
        let headers: HTTPHeaders = ["x-rapidapi-key":"9a49740c5034d7ee252d1e1419a10faa"]
        
        AF.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: PlayersModel.self) {[weak self] (response) in
                guard let mainData = response.value else { return print(response.error) }
                self?.playersArray = mainData.response!
            }
    }
    func loadTeamInformation(id: Int){
        let url = URL(string: "https://v3.football.api-sports.io/teams?id=\(id)")
        let headers: HTTPHeaders = ["x-rapidapi-key":"9a49740c5034d7ee252d1e1419a10faa"]
        
        AF.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: TeamInformation.self) {[weak self] (response) in
                guard let mainData = response.value else { return print(response.error!) }
                self?.teamInformation = mainData.response!
            }
    }
    func loadPreviousEvent(teamID: Int){
        let url = URL(string: "https://v3.football.api-sports.io/fixtures?team=\(teamID)&last=5&status=ft&timezone=Europe/Kiev")
        let headers: HTTPHeaders = ["x-rapidapi-key":"9a49740c5034d7ee252d1e1419a10faa"]
        AF.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: MainData.self) { [weak self] (response) in
                guard let mainData = response.value else { return print(response.error?.errorDescription) }
                self?.last5Event = mainData.response!
            }
    }
    func loadNextEvent(teamID: Int){
        let url = URL(string: "https://v3.football.api-sports.io/fixtures?team=\(teamID)&next=1&timezone=Europe/Kiev")
        let headers: HTTPHeaders = ["x-rapidapi-key":"9a49740c5034d7ee252d1e1419a10faa"]
        AF.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: MainData.self) { [weak self] (response) in
                guard let mainData = response.value else { return print(response.error?.errorDescription) }
                self?.nextEvent = mainData.response!
            }
    }
    func loadAllEvent(teamID: Int){
        let date = DateManager.instance.dateToString(date: Date() - ((365 * 24 * 60 * 60)/2), format: "yyyy-MM-dd")
        let datePlusYear = DateManager.instance.dateToString(date: Date() + ((365 * 24 * 60 * 60)/2), format: "yyyy-MM-dd")
        let year = DateManager.instance.dateToString(date: Date(), format: "yyyy")
        let url = URL(string: "https://v3.football.api-sports.io/fixtures?team=\(teamID)&season=\(year)&from=\(date)&to=\(datePlusYear)&timezone=Europe/Kiev")
        let headers: HTTPHeaders = ["x-rapidapi-key":"9a49740c5034d7ee252d1e1419a10faa"]
        AF.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: MainData.self) { [weak self] (response) in
                guard let mainData = response.value else { return print(response.error?.errorDescription) }
                self?.allEvent = mainData.response!
            }
    }
    func loadTeamStatic(leagueID: Int, teamID: Int){
        let url = URL(string: "https://v3.football.api-sports.io/teams/statistics?league=\(leagueID)&team=\(teamID)&season=2022")
        let headers: HTTPHeaders = ["x-rapidapi-key":"9a49740c5034d7ee252d1e1419a10faa"]
        
        AF.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: TeamStatistic.self) { [weak self] (response) in
                guard let mainData = response.value else { return print(response.error) }
                self?.teamStatistic = mainData.response!
                
            }
    }
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
    
    
}
