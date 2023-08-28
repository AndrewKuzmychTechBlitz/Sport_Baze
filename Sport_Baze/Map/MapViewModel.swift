//
//  MapViewModel.swift
//  Sport_Baze
//
//  Created by Андрій Кузьмич on 18.08.2023.
//

import Foundation
import Alamofire
import CoreLocation
final class MapViewModel: ObservableObject{
    
    @Published var allEvent: [MapModel] = []
    let popularLeague = [475, 602, 606, 630, 611, 66, 61, 62, 63, 145, 147, 144, 93, 90, 88, 89, 143, 140, 141, 134, 810, 128, 96, 95, 94,
                         39, 40, 41, 42, 48, 136, 135, 430, 119, 120, 239, 81, 78, 79, 200, 208, 269, 268, 106, 108, 107]
    
    func loadLiveEvents(date: String){
        let url = URL(string: "https://v3.football.api-sports.io/fixtures?date=\(date)&timezone=Europe/Kiev" )
        let headers: HTTPHeaders = ["x-rapidapi-key":"9a49740c5034d7ee252d1e1419a10faa"]
        AF.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: MainData.self) { [weak self] (response) in
                guard let mainData = response.value else { return print(response.error?.errorDescription) }
                self?.sortEvent(array: mainData.response!)
            }
    }
    func sortEvent(array: [MainResponse]){
        var allEvent: [MapModel] = []
        let geocoder = CLGeocoder()
        for i in array{
            if self.popularLeague.contains((i.league?.id)!) {
                getCoordinateFrom(address: i.fixture?.venue?.city ?? "") { coordinate, error in
                    guard let coordinate = coordinate, error == nil else { return }
                    DispatchQueue.main.async {
                        self.allEvent.append(MapModel(value: i, coordinates: coordinate))
                    }
                }
            }
        }
        DispatchQueue.main.async {
            self.allEvent = allEvent
        }
    }
    func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1) }
    }

}
struct MapModel: Identifiable{
    var id = UUID().uuidString
    var value: MainResponse
    var coordinates: CLLocationCoordinate2D
}
