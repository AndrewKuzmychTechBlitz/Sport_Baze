//
//  StatisticModel.swift
//  Sport_Baze
//
//  Created by Андрій Кузьмич on 23.08.2023.
//

import Foundation
struct StatisticData : Decodable {
    let get : String?
    let parameters : StatisticParameters?
    let errors : [String]?
    let results : Int?
    let paging : StatisticPaging?
    let response : [StatisticResponse]?
    
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
        parameters = try values.decodeIfPresent(StatisticParameters.self, forKey: .parameters)
        errors = try values.decodeIfPresent([String].self, forKey: .errors)
        results = try values.decodeIfPresent(Int.self, forKey: .results)
        paging = try values.decodeIfPresent(StatisticPaging.self, forKey: .paging)
        response = try values.decodeIfPresent([StatisticResponse].self, forKey: .response)
    }
    
}
struct StatisticPaging : Codable {
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
struct StatisticParameters : Codable {
    let fixture : String?
    
    enum CodingKeys: String, CodingKey {
        
        case fixture = "fixture"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fixture = try values.decodeIfPresent(String.self, forKey: .fixture)
    }
    
}
struct StatisticResponse : Decodable, Identifiable {
    let team : StatisticsTeam?
    let statistics : [Statistics]?
    
    enum CodingKeys: String, CodingKey {
        
        case team = "team"
        case statistics = "statistics"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        team = try values.decodeIfPresent(StatisticsTeam.self, forKey: .team)
        statistics = try values.decodeIfPresent([Statistics].self, forKey: .statistics)
    }
    
}
extension StatisticResponse{
    var id: UUID{
        return UUID()
    }
}
struct Statistics : Decodable, Identifiable {
    let type : String?
    var value : AnyCodableValue?
    
    enum CodingKeys: String, CodingKey {
        
        case type = "type"
        case value = "value"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        value = try values.decodeIfPresent(AnyCodableValue.self, forKey: .value)
    }
    
}
extension Statistics{
    var id: UUID{
        return UUID()
    }
}
enum Value: Decodable {
    case integer(Int)
    case string(String)
    case null
}

struct StatisticsTeam : Codable {
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
enum AnyCodableValue: Codable {
    case integer(Int)
    case string(String)
    case float(Float)
    case double(Double)
    case boolean(Bool)
    case null
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        
        if let x = try? container.decode(Float.self) {
            self = .float(x)
            return
        }
        
        if let x = try? container.decode(Double.self) {
            self = .double(x)
            return
        }
        
        if let x = try? container.decode(Bool.self) {
            self = .boolean(x)
            return
        }
        
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        
        if container.decodeNil() {
            self = .string("")
            return
        }
        
        throw DecodingError.typeMismatch(AnyCodableValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        case .float(let x):
            try container.encode(x)
        case .double(let x):
            try container.encode(x)
        case .boolean(let x):
            try container.encode(x)
        case .null:
            try container.encode(self)
            break
        }
    }
    
    //Get safe Values
    var stringValue: String {
        switch self {
        case .string(let s):
            return s
        case .integer(let s):
            return "\(s)"
        case .double(let s):
            return "\(s)"
        case .float(let s):
            return "\(s)"
        default:
            return ""
        }
    }
    
    var intValue: Int {
        switch self {
        case .integer(let s):
            return s
        case .string(let s):
            return (Int(s) ?? 0)
        case .float(let s):
            return Int(s)
        case .null:
            return 0
        default:
            return 0
        }
    }
    
    var floatValue: Float {
        switch self {
        case .float(let s):
            return s
        case .integer(let s):
            return Float(s)
        case .string(let s):
            return (Float(s) ?? 0)
        default:
            return 0
        }
    }
    
    var doubleValue: Double {
        switch self {
        case .double(let s):
            return s
        case .string(let s):
            return (Double(s) ?? 0.0)
        case .integer(let s):
            return (Double(s))
        case .float(let s):
            return (Double(s))
        default:
            return 0.0
        }
    }
    
    var booleanValue: Bool {
        switch self {
        case .boolean(let s):
            return s
        case .integer(let s):
            return s == 1
        case .string(let s):
            let bool = (Int(s) ?? 0) == 1
            return bool
        default:
            return false
        }
    }
}
