//
//  EventsModel.swift
//  Sport_Baze
//
//  Created by Андрій Кузьмич on 23.08.2023.
//

import Foundation
struct Events : Decodable {
    let get : String?
    let parameters : EventsParameters?
    let errors : [String]?
    let results : Int?
    let paging : Paging?
    let response : [EventsResponse]?

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
        parameters = try values.decodeIfPresent(EventsParameters.self, forKey: .parameters)
        errors = try values.decodeIfPresent([String].self, forKey: .errors)
        results = try values.decodeIfPresent(Int.self, forKey: .results)
        paging = try values.decodeIfPresent(Paging.self, forKey: .paging)
        response = try values.decodeIfPresent([EventsResponse].self, forKey: .response)
    }

}
struct Paging : Codable {
    let current : Int?
    let total : Int?

    enum CodingKeys: String, CodingKey {

        case current = "current"
        case total = "total"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        current = try values.decodeIfPresent(Int.self, forKey: .current)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
    }

}
struct EventsParameters : Codable {
    let fixture : String?

    enum CodingKeys: String, CodingKey {

        case fixture = "fixture"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fixture = try values.decodeIfPresent(String.self, forKey: .fixture)
    }

}
struct EventsResponse : Decodable, Identifiable{
    let time : Time?
    let team : Team?
    let player : Player?
    let assist : Assist?
    let type : String?
    let detail : String?
    let comments : String?

    enum CodingKeys: String, CodingKey {

        case time = "time"
        case team = "team"
        case player = "player"
        case assist = "assist"
        case type = "type"
        case detail = "detail"
        case comments = "comments"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        time = try values.decodeIfPresent(Time.self, forKey: .time)
        team = try values.decodeIfPresent(Team.self, forKey: .team)
        player = try values.decodeIfPresent(Player.self, forKey: .player)
        assist = try values.decodeIfPresent(Assist.self, forKey: .assist)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        detail = try values.decodeIfPresent(String.self, forKey: .detail)
        comments = try values.decodeIfPresent(String.self, forKey: .comments)
    }

}
extension EventsResponse{
    var id: UUID{
        return UUID()
    }
}
struct Time : Codable {
    let elapsed : Int?
    let extra : Int?

    enum CodingKeys: String, CodingKey {

        case elapsed = "elapsed"
        case extra = "extra"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        elapsed = try values.decodeIfPresent(Int.self, forKey: .elapsed)
        extra = try values.decodeIfPresent(Int.self, forKey: .extra)
    }

}
struct Assist : Codable {
    let id : Int?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

extension Array {
    mutating func remove(where condition: (Element) -> Bool) -> Element? {
        guard let index = firstIndex(where: condition) else {
            return nil
        }

        return remove(at: index)
    }
}
struct Team: Decodable {
    let id : Int?
    let name : String?
    let logo : String?
}
struct Player : Codable {
    let id : Int?
    let name : String?
    let number : Int?
    var pos : Position?
    let grid : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case name = "name"
        case number = "number"
        case pos = "pos"
        case grid = "grid"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        number = try values.decodeIfPresent(Int.self, forKey: .number)
        pos = try values.decodeIfPresent(Position.self, forKey: .pos)
        grid = try values.decodeIfPresent(String.self, forKey: .grid)
    }
    
}
enum Position: String, Codable{
    case G
    case D
    case M
    case F
    case A
    
    var title: String{
        switch self{
        case .D: return "DF"
        case .G: return "GK"
        case .M: return "MF"
        case .F: return "FW"
        case .A: return "AT"
        }
    }
}
