//
//  PlayersModel.swift
//  Sport_Baze
//
//  Created by Андрій Кузьмич on 28.08.2023.
//

import Foundation
struct PlayersModel : Decodable {
    let get : String?
    let parameters : PlayersParameters?
    let errors : [String]?
    let results : Int?
    let paging : PlayersPaging?
    let response : [PlayersResponse]?

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
        parameters = try values.decodeIfPresent(PlayersParameters.self, forKey: .parameters)
        errors = try values.decodeIfPresent([String].self, forKey: .errors)
        results = try values.decodeIfPresent(Int.self, forKey: .results)
        paging = try values.decodeIfPresent(PlayersPaging.self, forKey: .paging)
        response = try values.decodeIfPresent([PlayersResponse].self, forKey: .response)
    }

}
struct PlayersParameters : Codable {
    let team : String?

        enum CodingKeys: String, CodingKey {

            case team = "team"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            team = try values.decodeIfPresent(String.self, forKey: .team)
        }
}
struct PlayersPaging : Codable {
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
struct PlayersResponse : Decodable, Identifiable {
    let team : PlayersTeam?
    let players : [Players]?
    
    enum CodingKeys: String, CodingKey {
        
        case team = "team"
        case players = "players"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        team = try values.decodeIfPresent(PlayersTeam.self, forKey: .team)
        players = try values.decodeIfPresent([Players].self, forKey: .players)
    }
}
extension PlayersResponse{
    var id: UUID{
        return UUID()
    }
}
struct Players : Codable, Identifiable {
    let id : Int?
    let name : String?
    let age : Int?
    let number : Int?
    let position : String?
    let photo : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case age = "age"
        case number = "number"
        case position = "position"
        case photo = "photo"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        age = try values.decodeIfPresent(Int.self, forKey: .age)
        number = try values.decodeIfPresent(Int.self, forKey: .number)
        position = try values.decodeIfPresent(String.self, forKey: .position)
        photo = try values.decodeIfPresent(String.self, forKey: .photo)
    }

}
extension Players{
    var _id: UUID{
        return UUID()
    }
}
struct PlayersTeam : Codable {
    let id : Int?
    let name : String?
    let logo : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case logo = "logo"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        logo = try values.decodeIfPresent(String.self, forKey: .logo)
    }

}
