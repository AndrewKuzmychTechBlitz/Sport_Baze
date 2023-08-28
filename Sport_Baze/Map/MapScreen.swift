//
//  MapScreen.swift
//  Sport_Baze
//
//  Created by Андрій Кузьмич on 18.08.2023.
//

import SwiftUI
import MapKit

struct MapScreen: View {
    @StateObject var vm = MapViewModel()
    @State private var  mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.141), span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2))
    var body: some View {
        ZStack{
            if !vm.allEvent.isEmpty{
                Map(coordinateRegion: $mapRegion, annotationItems: vm.allEvent) { location in
                    MapAnnotation(coordinate: location.coordinates) {
                            AnnotationCell(item: location)
                    }
                }
                .ignoresSafeArea()
                .onAppear{
                    self.mapRegion = MKCoordinateRegion(center: vm.allEvent[0].coordinates, span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2))
                }
            }
        }
        .onAppear{
            vm.loadLiveEvents(date: "2023-08-09")
            if !vm.allEvent.isEmpty{
                self.mapRegion = MKCoordinateRegion(center: vm.allEvent[0].coordinates, span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
            }
        }
    }

}

struct MapScreen_Previews: PreviewProvider {
    static var previews: some View {
        MapScreen()
    }
}
struct AnnotationCell: View{
    var item: MapModel
    @State var showcell: Bool = false
    var body: some View{
        ZStack{
                Button {
                    showcell.toggle()
                } label: {
                   locationItem
                }
            if showcell{
                ZStack{
                    Color.white.opacity(0).ignoresSafeArea()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        .onTapGesture {
                            showcell = false
                        }
                    NavigationLink {
                        EventDetailScreen(home: (item.value.teams?.home)!,
                                     away: (item.value.teams?.away)!,
                                     goal: item.value.goals!,
                                     fixture: item.value.fixture!,
                                     league: item.value.league!)
                    } label: {
                        EventMainCell(league: item.value.league!,
                                  fixture: item.value.fixture!,
                                  home: (item.value.teams?.home)!,
                                  away: (item.value.teams?.away)!,
                                  goals: item.value.goals!)
                        .frame(width: UIScreen.main.bounds.width - 40)
                    }
                    .simultaneousGesture(TapGesture().onEnded({
                        Vibration.instance.simpleSuccess()
                    }))
                }
            }
        }
    }
    private var locationItem: some View{
        Image("fire.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 24, height: 24)
            .padding(6)
            .background {
                Circle()
                    .fill(Color.white)
                    .shadow(color: Color(red: 0.7, green: 0.14, blue: 0.23), radius: 5, x: 0, y: 2)
                    .overlay(
                        Circle()
                            .stroke(Color(red: 0.7, green: 0.14, blue: 0.23), lineWidth: 1)
                            .padding(3)
                    )
            }
    }
}
