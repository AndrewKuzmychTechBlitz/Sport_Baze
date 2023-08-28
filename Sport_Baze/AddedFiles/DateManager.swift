//
//  DateManager.swift
//  Sport_Baze
//
//  Created by Андрій Кузьмич on 18.08.2023.
//

import Foundation
class DateManager{
    static let instance = DateManager()
    
    func dateToString(date: Date,format: String)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_us")
        return formatter.string(from: date)
    }
    func convertFromStringToString(date: String, format: String)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: date)!
        return dateToString(date: date, format: format)
    }
    func convertToDate(date: String)-> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: date)!
        return date
    }
    func calculateDifference(matchDate: Date) -> Int{
        let diffComponents = Calendar.current.dateComponents([.second], from: Date() , to: matchDate)
        let seconds = diffComponents.second
        return seconds!
    }
    
}
