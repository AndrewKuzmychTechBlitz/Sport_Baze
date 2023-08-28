//
//  TeamInfoModel.swift
//  Sport_Baze
//
//  Created by Андрій Кузьмич on 28.08.2023.
//

import Foundation
struct TeamInformation : Codable {
    let get : String?
    let parameters : TeamParameters?
    let errors : [String]?
    let results : Int?
    let paging : Paging?
    let response : [TeamInformationResponse]?

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
        parameters = try values.decodeIfPresent(TeamParameters.self, forKey: .parameters)
        errors = try values.decodeIfPresent([String].self, forKey: .errors)
        results = try values.decodeIfPresent(Int.self, forKey: .results)
        paging = try values.decodeIfPresent(Paging.self, forKey: .paging)
        response = try values.decodeIfPresent([TeamInformationResponse].self, forKey: .response)
    }

}
struct TeamInformationResponse : Codable {
    let team : TeamInformationTeam?
    let venue : TeamInformationVenue?

    enum CodingKeys: String, CodingKey {

        case team = "team"
        case venue = "venue"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        team = try values.decodeIfPresent(TeamInformationTeam.self, forKey: .team)
        venue = try values.decodeIfPresent(TeamInformationVenue.self, forKey: .venue)
    }

}
struct TeamParameters : Codable {
    let id : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
    }

}
struct TeamInformationTeam : Codable {
    let id : Int?
    let name : String?
    let code : String?
    let country : String?
    let founded : Int?
    let national : Bool?
    let logo : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case code = "code"
        case country = "country"
        case founded = "founded"
        case national = "national"
        case logo = "logo"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        founded = try values.decodeIfPresent(Int.self, forKey: .founded)
        national = try values.decodeIfPresent(Bool.self, forKey: .national)
        logo = try values.decodeIfPresent(String.self, forKey: .logo)
    }

}
struct TeamInformationVenue : Codable {
    let id : Int?
    let name : String?
    let address : String?
    let city : String?
    let capacity : Int?
    let surface : String?
    let image : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case address = "address"
        case city = "city"
        case capacity = "capacity"
        case surface = "surface"
        case image = "image"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        capacity = try values.decodeIfPresent(Int.self, forKey: .capacity)
        surface = try values.decodeIfPresent(String.self, forKey: .surface)
        image = try values.decodeIfPresent(String.self, forKey: .image)
    }

}
