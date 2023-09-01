//
//  SavedEvent.swift
//  Sport_Baze
//
//  Created by Андрій Кузьмич on 17.08.2023.
//

import SwiftUI

struct SavedEventView: View {
    @State var savedEvent:[SavedEvent] = []
    
    @Environment(\.dismiss) var dismiss
        var body: some View {
            NavigationView{
                ZStack(alignment: .top){
                    Color.bg.ignoresSafeArea()
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        VStack{
                            header
                            savedEventList
                        }
                        .foregroundColor(.white)
                        
                        .navigationBarBackButtonHidden(true)
                        .onAppear{
                            self.savedEvent = UserDefaultsBuffer.savedEvent!
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden()
            .navigationViewStyle(.stack)
        }
        //MARK: - Header
    private var header: some View{
        ZStack(alignment: .leading) {
            Button {
                dismiss()
                Vibration.instance.simpleSuccess()
            } label: {
                Image(systemName: "arrow.backward")
                    .font(.system(size: 24))
            }
            Text("Saved Event")
                .font(.system(size: 22, weight: .semibold))
                .frame(maxWidth: .infinity)
        }
        .padding()
    }
    private var savedEventList: some View{
        ScrollView(.vertical, showsIndicators: false) {
            VStack{
                if !savedEvent.isEmpty{
                    ForEach(savedEvent) { event in
                        NavigationLink {
                            EventDetailScreen(home: event.home,
                                         away: event.away,
                                         goal: event.goal,
                                         fixture: event.fixture,
                                         league: event.league)
                        } label: {
                            EventMainCell(league: event.league,
                                      fixture: event.fixture,
                                      home: event.home,
                                      away: event.away,
                                      goals: event.goal)
                        }
                    }
                }else{
                    EmptyState()
                }
            }
        }
        .padding(.horizontal)
    }

}

//struct SavedEvent_Previews: PreviewProvider {
//    static var previews: some View {
//        SavedEventView()
//    }
//}
