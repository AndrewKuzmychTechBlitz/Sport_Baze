//
//  TeamStatModel.swift
//  Sport_Baze
//
//  Created by Андрій Кузьмич on 28.08.2023.
//

import Foundation
struct TeamStatistic : Decodable {
    let get : String?
    let parameters : TeamStatParameters?
    let errors : [String]?
    let results : Int?
    let paging : TeamStatPaging?
    let response : TeamStatResponse?

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
        parameters = try values.decodeIfPresent(TeamStatParameters.self, forKey: .parameters)
        errors = try values.decodeIfPresent([String].self, forKey: .errors)
        results = try values.decodeIfPresent(Int.self, forKey: .results)
        paging = try values.decodeIfPresent(TeamStatPaging.self, forKey: .paging)
        response = try values.decodeIfPresent(TeamStatResponse.self, forKey: .response)
    }

}

struct TeamStatParameters : Codable {
    let league : String?
    let team : String?
    let season : String?

    enum CodingKeys: String, CodingKey {

        case league = "league"
        case team = "team"
        case season = "season"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        league = try values.decodeIfPresent(String.self, forKey: .league)
        team = try values.decodeIfPresent(String.self, forKey: .team)
        season = try values.decodeIfPresent(String.self, forKey: .season)
    }

}
struct TeamStatPaging : Codable {
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
struct TeamStatResponse : Decodable, Identifiable {
    let league : League?
    let team : Team?
    let form : String?
    let fixtures : TeanStatFixtures?
    let goals : TeamStatGoals?
    let biggest : Biggest?
    let clean_sheet : Clean_sheet?
    let failed_to_score : Failed_to_score?
    let penalty : TeamStatPenalty?
    let lineups : [Lineups]?
    let cards : Cards?

    enum CodingKeys: String, CodingKey {

        case league = "league"
        case team = "team"
        case form = "form"
        case fixtures = "fixtures"
        case goals = "goals"
        case biggest = "biggest"
        case clean_sheet = "clean_sheet"
        case failed_to_score = "failed_to_score"
        case penalty = "penalty"
        case lineups = "lineups"
        case cards = "cards"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        league = try values.decodeIfPresent(League.self, forKey: .league)
        team = try values.decodeIfPresent(Team.self, forKey: .team)
        form = try values.decodeIfPresent(String.self, forKey: .form)
        fixtures = try values.decodeIfPresent(TeanStatFixtures.self, forKey: .fixtures)
        goals = try values.decodeIfPresent(TeamStatGoals.self, forKey: .goals)
        biggest = try values.decodeIfPresent(Biggest.self, forKey: .biggest)
        clean_sheet = try values.decodeIfPresent(Clean_sheet.self, forKey: .clean_sheet)
        failed_to_score = try values.decodeIfPresent(Failed_to_score.self, forKey: .failed_to_score)
        penalty = try values.decodeIfPresent(TeamStatPenalty.self, forKey: .penalty)
        lineups = try values.decodeIfPresent([Lineups].self, forKey: .lineups)
        cards = try values.decodeIfPresent(Cards.self, forKey: .cards)
    }

}
extension TeamStatResponse{
    var id: UUID{
        return UUID()
    }
}

struct TeanStatFixtures : Codable {
    let played : Played?
    let wins : Wins?
    let draws : Draws?
    let loses : Loses?

    enum CodingKeys: String, CodingKey {

        case played = "played"
        case wins = "wins"
        case draws = "draws"
        case loses = "loses"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        played = try values.decodeIfPresent(Played.self, forKey: .played)
        wins = try values.decodeIfPresent(Wins.self, forKey: .wins)
        draws = try values.decodeIfPresent(Draws.self, forKey: .draws)
        loses = try values.decodeIfPresent(Loses.self, forKey: .loses)
    }

}
struct TeamStatGoals : Decodable {
    let _for : For?
    let against : Against?

    enum CodingKeys: String, CodingKey {

        case _for = "for"
        case against = "against"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _for = try values.decodeIfPresent(For.self, forKey: ._for)
        against = try values.decodeIfPresent(Against.self, forKey: .against)
    }

}
//struct Goals: Codable{
//    let home, away: Int?
//}

struct Biggest : Decodable {
    let streak : Streak?
    let wins : StringWins?
    let loses : StringLoses?
    let goals : Goals?

    enum CodingKeys: String, CodingKey {

        case streak = "streak"
        case wins = "wins"
        case loses = "loses"
        case goals = "goals"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        streak = try values.decodeIfPresent(Streak.self, forKey: .streak)
        wins = try values.decodeIfPresent(StringWins.self, forKey: .wins)
        loses = try values.decodeIfPresent(StringLoses.self, forKey: .loses)
        goals = try values.decodeIfPresent(Goals.self, forKey: .goals)
    }

}
struct Clean_sheet : Codable {
    let home : Int?
    let away : Int?
    let total : Int?

    enum CodingKeys: String, CodingKey {

        case home = "home"
        case away = "away"
        case total = "total"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        home = try values.decodeIfPresent(Int.self, forKey: .home)
        away = try values.decodeIfPresent(Int.self, forKey: .away)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
    }

}
struct Failed_to_score : Codable {
    let home : Int?
    let away : Int?
    let total : Int?

    enum CodingKeys: String, CodingKey {

        case home = "home"
        case away = "away"
        case total = "total"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        home = try values.decodeIfPresent(Int.self, forKey: .home)
        away = try values.decodeIfPresent(Int.self, forKey: .away)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
    }

}
struct TeamStatPenalty : Codable {
    let scored : Scored?
    let missed : Missed?
    let total : Int?

    enum CodingKeys: String, CodingKey {

        case scored = "scored"
        case missed = "missed"
        case total = "total"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        scored = try values.decodeIfPresent(Scored.self, forKey: .scored)
        missed = try values.decodeIfPresent(Missed.self, forKey: .missed)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
    }

}
struct Lineups : Codable {
    let formation : String?
    let played : Int?

    enum CodingKeys: String, CodingKey {

        case formation = "formation"
        case played = "played"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        formation = try values.decodeIfPresent(String.self, forKey: .formation)
        played = try values.decodeIfPresent(Int.self, forKey: .played)
    }

}
struct Cards : Codable {
    let yellow: CardStat?
    let red: CardStat?


    enum CodingKeys: String, CodingKey {

        case yellow = "yellow"
        case red = "red"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        yellow = try values.decodeIfPresent(CardStat.self, forKey: .yellow)
        red = try values.decodeIfPresent(CardStat.self, forKey: .red)
    }

}
struct Played : Codable {
    let home : Int?
    let away : Int?
    let total : Int?

    enum CodingKeys: String, CodingKey {

        case home = "home"
        case away = "away"
        case total = "total"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        home = try values.decodeIfPresent(Int.self, forKey: .home)
        away = try values.decodeIfPresent(Int.self, forKey: .away)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
    }

}
struct Wins : Codable {
    let home : Int?
    let away : Int?
    let total: Int?

    enum CodingKeys: String, CodingKey {

        case home = "home"
        case away = "away"
        case total = "total"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        home = try values.decodeIfPresent(Int.self, forKey: .home)
        away = try values.decodeIfPresent(Int.self, forKey: .away)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
    }

}
struct Draws : Codable {
    let home : Int?
    let away : Int?
    let total : Int?

    enum CodingKeys: String, CodingKey {

        case home = "home"
        case away = "away"
        case total = "total"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        home = try values.decodeIfPresent(Int.self, forKey: .home)
        away = try values.decodeIfPresent(Int.self, forKey: .away)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
    }

}
struct Loses : Codable {
    let home : Int?
    let away : Int?
    let total: Int?

    enum CodingKeys: String, CodingKey {

        case home = "home"
        case away = "away"
        case total = "total"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        home = try values.decodeIfPresent(Int.self, forKey: .home)
        away = try values.decodeIfPresent(Int.self, forKey: .away)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
    }

}
struct For : Decodable {
    let home : Int?
    let away : Int?
    //let total: Int?

    enum CodingKeys: String, CodingKey {

        case home = "home"
        case away = "away"
        //case total = "total"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        home = try values.decodeIfPresent(Int.self, forKey: .home)
        away = try values.decodeIfPresent(Int.self, forKey: .away)
        //total = try values.decodeIfPresent(Int.self, forKey: .total)
    }

}
struct Against : Codable {
    let home : Int?
    let away : Int?
    //let total: Int?
    enum CodingKeys: String, CodingKey {

        case home = "home"
        case away = "away"
        //case total = "total"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        home = try values.decodeIfPresent(Int.self, forKey: .home)
        away = try values.decodeIfPresent(Int.self, forKey: .away)
       // total = try values.decodeIfPresent(Int.self, forKey: .total)
    }

}
struct Streak : Codable {
    let wins : Int?
    let draws : Int?
    let loses : Int?

    enum CodingKeys: String, CodingKey {

        case wins = "wins"
        case draws = "draws"
        case loses = "loses"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        wins = try values.decodeIfPresent(Int.self, forKey: .wins)
        draws = try values.decodeIfPresent(Int.self, forKey: .draws)
        loses = try values.decodeIfPresent(Int.self, forKey: .loses)
    }

}
struct Scored : Codable {
    let total : Int?
    let percentage : String?

    enum CodingKeys: String, CodingKey {

        case total = "total"
        case percentage = "percentage"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
        percentage = try values.decodeIfPresent(String.self, forKey: .percentage)
    }

}
struct Missed : Codable {
    let total : Int?
    let percentage : String?

    enum CodingKeys: String, CodingKey {

        case total = "total"
        case percentage = "percentage"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
        percentage = try values.decodeIfPresent(String.self, forKey: .percentage)
    }

}
struct CardStat : Codable {
    let first : TimeCards?
    let second : TimeCards?
    let third : TimeCards?
    let fourth : TimeCards?
    let fifth : TimeCards?
    let sixth : TimeCards?
    let seventh : TimeCards?
    let eighth : TimeCards?
    
    enum CodingKeys: String, CodingKey {
        
        case first = "0-15"
        case second = "16-30"
        case third = "31-45"
        case fourth = "46-60"
        case fifth = "61-75"
        case sixth = "76-90"
        case seventh = "91-105"
        case eighth = "106-120"
    }
    
    var totalCards: Int {
        let firstPart = (first?.total ?? 0) + (second?.total ?? 0)
        let secondPart = (third?.total ?? 0) + (fourth?.total ?? 0)
        let thirdPart = (fifth?.total ?? 0) + (sixth?.total ?? 0)
        let fourthPart = (seventh?.total ?? 0) + (eighth?.total ?? 0)
        return firstPart + secondPart + thirdPart + fourthPart
    }
}

struct TimeCards : Codable {
    let total : Int?
}
struct StringWins : Codable {
    let home : String?
    let away : String?

    enum CodingKeys: String, CodingKey {

        case home = "home"
        case away = "away"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        home = try values.decodeIfPresent(String.self, forKey: .home)
        away = try values.decodeIfPresent(String.self, forKey: .away)
    }

}
struct StringLoses : Codable {
    let home : String?
    let away : String?

    enum CodingKeys: String, CodingKey {

        case home = "home"
        case away = "away"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        home = try values.decodeIfPresent(String.self, forKey: .home)
        away = try values.decodeIfPresent(String.self, forKey: .away)
    }

}
