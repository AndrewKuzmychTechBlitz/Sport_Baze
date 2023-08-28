//
//  LineupModel.swift
//  Sport_Baze
//
//  Created by Андрій Кузьмич on 23.08.2023.
//

import Foundation
struct LineUPModel : Decodable {
    let get : String?
    let parameters : Parameters?
    let errors : [String]?
    let results : Int?
    let paging : Paging?
    let response : [LineUPResponse]?
    
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
        parameters = try values.decodeIfPresent(Parameters.self, forKey: .parameters)
        errors = try values.decodeIfPresent([String].self, forKey: .errors)
        results = try values.decodeIfPresent(Int.self, forKey: .results)
        paging = try values.decodeIfPresent(Paging.self, forKey: .paging)
        response = try values.decodeIfPresent([LineUPResponse].self, forKey: .response)
    }
    
}

struct LineUPResponse : Decodable {
    let team : Team?
    let formation : String?
    let startXI : [StartXI]?
    let substitutes : [Substitutes]?
    let coach : Coach?
    
    enum CodingKeys: String, CodingKey {
        
        case team = "team"
        case formation = "formation"
        case startXI = "startXI"
        case substitutes = "substitutes"
        case coach = "coach"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        team = try values.decodeIfPresent(Team.self, forKey: .team)
        formation = try values.decodeIfPresent(String.self, forKey: .formation)
        startXI = try values.decodeIfPresent([StartXI].self, forKey: .startXI)
        substitutes = try values.decodeIfPresent([Substitutes].self, forKey: .substitutes)
        coach = try values.decodeIfPresent(Coach.self, forKey: .coach)
    }
    
}
struct StartXI : Codable, Identifiable {
    let player : Player?
    
    enum CodingKeys: String, CodingKey {
        
        case player = "player"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        player = try values.decodeIfPresent(Player.self, forKey: .player)
    }
    
}
extension StartXI{
    var id: UUID{
        return UUID()
    }
}
//struct Player : Codable {
//    let id : Int?
//    let name : String?
//    let number : Int?
//    let pos : String?
//    let grid : String?
//
//    enum CodingKeys: String, CodingKey {
//
//        case id = "id"
//        case name = "name"
//        case number = "number"
//        case pos = "pos"
//        case grid = "grid"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decodeIfPresent(Int.self, forKey: .id)
//        name = try values.decodeIfPresent(String.self, forKey: .name)
//        number = try values.decodeIfPresent(Int.self, forKey: .number)
//        pos = try values.decodeIfPresent(String.self, forKey: .pos)
//        grid = try values.decodeIfPresent(String.self, forKey: .grid)
//    }
//
//}
struct Substitutes : Codable, Identifiable {
    let player : Player?
    
    enum CodingKeys: String, CodingKey {
        
        case player = "player"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        player = try values.decodeIfPresent(Player.self, forKey: .player)
    }
    
}
extension Substitutes{
    var id: UUID{
        return UUID()
    }
}
struct Coach : Codable {
    let id : Int?
    let name : String?
    let photo : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case name = "name"
        case photo = "photo"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        photo = try values.decodeIfPresent(String.self, forKey: .photo)
    }
    
}

