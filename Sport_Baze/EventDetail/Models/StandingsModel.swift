//
//  StandingsModel.swift
//  Sport_Baze
//
//  Created by Андрій Кузьмич on 23.08.2023.
//

import Foundation
struct Standings : Decodable, Identifiable {
        let get : String?
        let parameters : Parameters?
        let errors : [String]?
        let results : Int?
        let paging : Paging?
        let response : [StandingsResponse]?}

extension Standings{
    var id: UUID{
        return UUID()
    }
}

 //MARK: - Parameters
struct Parameters: Decodable {
    let league : String?
    let season : String?
}

// MARK: - Response
struct StandingsResponse: Decodable {
    let league: StandingsLeague?
}
extension StandingsResponse{
    var id: UUID{
        return UUID()
    }
}

// MARK: - League
struct StandingsLeague: Decodable {
    let id : Int?
    let name : String?
    let country : String?
    let logo : String?
    let flag : String?
    let season : Int?
    let standings : [[Standing]]?
}

// MARK: - Standing
struct Standing: Decodable, Identifiable {
    let rank : Int?
    let team : Team?
    let points : Int?
    let goalsDiff : Int?
    let group : String?
    let form : String?
    let status : String?
    let description : String?
    let all : All?
    let home : Home?
    let away : Away?
    let update : String?
}
extension Standing{
    var id: UUID{
        return UUID()
    }
}
//struct Team: Decodable {
//    let id : Int?
//    let name : String?
//    let logo : String?
//}

// MARK: - All
struct All: Decodable {
    let played : Int?
    let win : Int?
    let draw : Int?
    let lose : Int?
}

enum Status: String, Codable {
    case same = "same"
}

// MARK: - Team
//struct StandingTeam: Decodable {
//    let id : Int?
//    let name : String?
//    let logo : String?
//}

struct Home : Decodable {
    let played : Int?
    let win : Int?
    let draw : Int?
    let lose : Int?

}

struct Away : Decodable {
    let played : Int?
    let win : Int?
    let draw : Int?
    let lose : Int?
}
