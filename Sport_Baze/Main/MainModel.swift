//
//  MainModel.swift
//  Sport_Baze
//
//  Created by Андрій Кузьмич on 18.08.2023.
//

import Alamofire
import Foundation
struct MainData: Decodable, Identifiable {
    let get: String?
    let parameters: MainParameters?
    let errors: [String]?
    let results: Int?
    let paging: MainPaging?
    let response: [MainResponse]?
    enum CodingKeys: String, CodingKey {
        case get = "get"
        case parameters = "parameters"
        case errors = "errors"
        case results = "results"
        case paging = "paging"
        case response = "response"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        get = try values.decodeIfPresent(String.self, forKey: .get)
        parameters = try values.decodeIfPresent(MainParameters.self, forKey: .parameters)
        errors = try values.decodeIfPresent([String].self, forKey: .errors)
        results = try values.decodeIfPresent(Int.self, forKey: .results)
        paging = try values.decodeIfPresent(MainPaging.self, forKey: .paging)
        response = try values.decodeIfPresent([MainResponse].self, forKey: .response)
    }

}
extension MainData{
    var id: UUID{
        return UUID()
    }
}

// MARK: - Paging
struct MainPaging: Decodable {
    let current, total: Int?
}

// MARK: - Parameters
struct MainParameters: Decodable {
    let next: String?
}

// MARK: - Response
struct MainResponse: Decodable, Identifiable {
    let fixture: Fixture?
    let league: League?
    let teams: Teams?
    let goals: Goals?
    let score: Score?

    enum CodingKeys: String, CodingKey {

        case fixture = "fixture"
        case league = "league"
        case teams = "teams"
        case goals = "goals"
        case score = "score"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fixture = try values.decodeIfPresent(Fixture.self, forKey: .fixture)
        league = try values.decodeIfPresent(League.self, forKey: .league)
        teams = try values.decodeIfPresent(Teams.self, forKey: .teams)
        goals = try values.decodeIfPresent(Goals.self, forKey: .goals)
        score = try values.decodeIfPresent(Score.self, forKey: .score)
    }


}
extension MainResponse{
    var id: UUID{
        return UUID()
    }
}


// MARK: - League
struct League2 {
    let id: Int
    let name: String
    let type: TypeEnum
    let logo: String
}
struct Season : Codable, Equatable {
    static func == (lhs: Season, rhs: Season) -> Bool {
        return lhs.coverage == rhs.coverage
    }
    
    let year : Int?
    let start : String?
    let end : String?
    let current : Bool?
    let coverage : Coverage?

    enum CodingKeys: String, CodingKey {

        case year = "year"
        case start = "start"
        case end = "end"
        case current = "current"
        case coverage = "coverage"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        year = try values.decodeIfPresent(Int.self, forKey: .year)
        start = try values.decodeIfPresent(String.self, forKey: .start)
        end = try values.decodeIfPresent(String.self, forKey: .end)
        current = try values.decodeIfPresent(Bool.self, forKey: .current)
        coverage = try values.decodeIfPresent(Coverage.self, forKey: .coverage)
    }

}
enum TypeEnum {
    case cup
    case league
}
struct Coverage : Codable, Equatable {
    static func == (lhs: Coverage, rhs: Coverage) -> Bool {
        return lhs.fixtures == rhs.fixtures
    }
    
    let fixtures : Fixtures?
    let standings : Bool?
    let players : Bool?
    let top_scorers : Bool?
    let top_assists : Bool?
    let top_cards : Bool?
    let injuries : Bool?
    let predictions : Bool?
    let odds : Bool?

    enum CodingKeys: String, CodingKey {

        case fixtures = "fixtures"
        case standings = "standings"
        case players = "players"
        case top_scorers = "top_scorers"
        case top_assists = "top_assists"
        case top_cards = "top_cards"
        case injuries = "injuries"
        case predictions = "predictions"
        case odds = "odds"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fixtures = try values.decodeIfPresent(Fixtures.self, forKey: .fixtures)
        standings = try values.decodeIfPresent(Bool.self, forKey: .standings)
        players = try values.decodeIfPresent(Bool.self, forKey: .players)
        top_scorers = try values.decodeIfPresent(Bool.self, forKey: .top_scorers)
        top_assists = try values.decodeIfPresent(Bool.self, forKey: .top_assists)
        top_cards = try values.decodeIfPresent(Bool.self, forKey: .top_cards)
        injuries = try values.decodeIfPresent(Bool.self, forKey: .injuries)
        predictions = try values.decodeIfPresent(Bool.self, forKey: .predictions)
        odds = try values.decodeIfPresent(Bool.self, forKey: .odds)
    }

}
struct Fixtures : Codable, Equatable {
    let events : Bool?
    let lineups : Bool?
    let statistics_fixtures : Bool?
    let statistics_players : Bool?

    enum CodingKeys: String, CodingKey {

        case events = "events"
        case lineups = "lineups"
        case statistics_fixtures = "statistics_fixtures"
        case statistics_players = "statistics_players"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        events = try values.decodeIfPresent(Bool.self, forKey: .events)
        lineups = try values.decodeIfPresent(Bool.self, forKey: .lineups)
        statistics_fixtures = try values.decodeIfPresent(Bool.self, forKey: .statistics_fixtures)
        statistics_players = try values.decodeIfPresent(Bool.self, forKey: .statistics_players)
    }

}

// MARK: - Fixture
struct Fixture: Codable {
    let id: Int?
    let referee: String?
    let timezone: String?
    let date: String?
    let timestamp: Int?
    let periods: Periods?
    let venue: Venue?
    let status: MainStatus?

    enum CodingKeys: String, CodingKey {

            case id = "id"
            case referee = "referee"
            case timezone = "timezone"
            case date = "date"
            case timestamp = "timestamp"
            case periods = "periods"
            case venue = "venue"
            case status = "status"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = try values.decodeIfPresent(Int.self, forKey: .id)
            referee = try values.decodeIfPresent(String.self, forKey: .referee)
            timezone = try values.decodeIfPresent(String.self, forKey: .timezone)
            date = try values.decodeIfPresent(String.self, forKey: .date)
            timestamp = try values.decodeIfPresent(Int.self, forKey: .timestamp)
            periods = try values.decodeIfPresent(Periods.self, forKey: .periods)
            venue = try values.decodeIfPresent(Venue.self, forKey: .venue)
            status = try values.decodeIfPresent(MainStatus.self, forKey: .status)
        }

}

// MARK: - Periods
struct Periods: Codable {
    let first, second: Int?
}

// MARK: - Status
struct MainStatus: Codable {
    let long: String?
    let short: String?
    let elapsed: Int?
}

// MARK: - Venue
struct Venue: Codable {
    let id: Int?
    let name, city: String?
}

// MARK: - Goals
struct Goals: Codable{
    let home, away: Int?
}
struct Teams: Decodable {
    let home, away: MainAway?
}

// MARK: - Away
struct MainAway: Codable {
    let id: Int?
    let name: String?
    let logo: String?
    let winner: Bool?
}

// MARK: - League
struct League: Codable,Equatable {
    let id: Int?
    let name, country: String?
    let logo: String?
    let flag: String?
    //let season: AnyCodableValue?
    let round: String?
}
//func ==(lhs: League, rhs: LeagueResp) -> Bool {
//    return lhs == rhs.league  && lhs.country == rhs.country && lhs.seasons == rhs.seasons // ignoring the position
//}

// MARK: - Score
struct Score: Decodable {
    let halftime, fulltime, extratime, penalty: Goals?
}


struct NetworkError: Error {
  let initialError: AFError
  let backendError: BackendError?
}
struct BackendError: Decodable, Error {
    var status: String
    var message: String
}
struct DateBar: Identifiable{
    let id: Int
    let month: String
    let day: String
    let date: Date
    let isTapped: Bool
}
