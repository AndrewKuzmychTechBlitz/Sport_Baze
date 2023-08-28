//
//  StatisticView.swift
//  Sport_Baze
//
//  Created by Андрій Кузьмич on 23.08.2023.
//

import SwiftUI
struct StatisticView: View{
    var array:[StatisticResponse]
    var body: some View{
        ZStack{
            Color.bg.ignoresSafeArea()
            VStack(alignment: .leading){
                Text("Statistic")
                    .font(.system(size: 34, weight: .bold))
                    .padding()
                 if !array.isEmpty{
                
                statisticList
                 }else{
                     EmptyState()
                 }
            }
            .foregroundColor(.white)
        }
        
    }
    private var ballProfessionalLabel: some View{
        HStack{
            Text(array[0].statistics?[9].value?.stringValue ?? "")
                .font(.system(size: 16, weight: .semibold))
            Spacer()
                
//            ballProfessional(progress: calcBallPosession(value1: array[0].statistics?[9].value?.stringValue ?? ""))
            ballProfessional(progress: calcBallPosession(value1: array[0].statistics?[9].value?.stringValue ?? ""))
            Spacer()
            Text(array[1].statistics?[9].value?.stringValue ?? "")
                .font(.system(size: 16, weight: .semibold))
        }
        .padding()
    }
    private func ballProfessional(progress: Double)-> some View{
        ZStack{
            Circle()
                .stroke(Color.blueGR2, lineWidth: 4)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.accentPink, lineWidth: 4)
            Text("Ball \nProfessional")
                .kerning(0.3)
                .multilineTextAlignment(.center)
                .font(.system(size: 14))
        }
        .frame(height: 110)
    }
    private var statisticList: some View{
        ScrollView(showsIndicators: false) {
        VStack{
            ballProfessionalLabel
                ForEach(0..<array[0].statistics!.count-2) { i in
                    statisticCell(statistic1: array[0].statistics![i], statistic2: array[1].statistics![i])
                }
            }
            .padding(.top)
            .background {
                Color.detailBG.cornerRadius(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    }
            }
            .padding(.horizontal)
        }
        .ignoresSafeArea(.all, edges: .bottom)
       
    }
    private func statisticCell(statistic1: Statistics, statistic2: Statistics) -> some View{
            HStack{
                Text("\(statistic1.value?.intValue ?? 0)")
                Spacer()
                Text(statistic1.type ?? "")
                    .font(.system(size: 14))
                    .opacity(0.5)
                Spacer()
                Text("\(statistic2.value?.intValue ?? 0)")
            }
            .font(.system(size: 16, weight: .semibold))
        .padding()
    }
    func generateProgress(home: Int, away: Int)-> Double{
        if home > away{
            return 1-(Double(away)/Double(home)/2)
            
        }else if away > home{
            return (Double(home)/Double(away)/2)
        }else{
            return 0.5
        }
    }
    private func calcBallPosession(value1: String)-> Double{
        var Value1  = value1
        Value1.removeLast()
        return (Double(Value1) ?? 0.0) / Double(100)
    }
    
}
