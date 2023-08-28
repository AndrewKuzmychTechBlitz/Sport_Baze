//
//  UserDefaultsBuffer.swift
//  Sport_Baze
//
//  Created by Андрій Кузьмич on 28.08.2023.
//

import Foundation
struct UserDefaultsBuffer {
    static var defaultData: UserDefaults = UserDefaults.standard
    static let keyForSavedEvent = "SavedEvent"
    //static let keyForReminder = "SavedReminder"
   // static let keyForSavedTeam = "SavedTeam"

    static var savedEvent: [SavedEvent]? {
        get {
            if let data = UserDefaults.standard.data(forKey: keyForSavedEvent){
                if let decoded = try? JSONDecoder().decode([SavedEvent].self, from: data){
                    return decoded
                }else{
                    return []
                }
            }else{
                return []
            }
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue){
                UserDefaults.standard.set(encoded,forKey: keyForSavedEvent)
            }
        }
    }
//    static var savedTeam: [SavedTeam]? {
//        get {
//            if let data = UserDefaults.standard.data(forKey: keyForSavedTeam){
//                if let decoded = try? JSONDecoder().decode([SavedTeam].self, from: data){
//                    return decoded
//                }else{
//                    return []
//                }
//            }else{
//                return []
//            }
//        }
//        set {
//            if let encoded = try? JSONEncoder().encode(newValue){
//                UserDefaults.standard.set(encoded,forKey: keyForSavedTeam)
//            }
//        }
//    }
//    static var savedRemindered: [Int]? {
//        get {
//            return defaultData.array(forKey: keyForReminder) as? [Int] ?? []
//        }
//        set {
//            defaultData.set(newValue, forKey: keyForReminder)
//        }
//    }

}

