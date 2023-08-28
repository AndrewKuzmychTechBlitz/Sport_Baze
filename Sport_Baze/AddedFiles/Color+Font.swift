//
//  Color+Font.swift
//  Sport_Baze
//
//  Created by Андрій Кузьмич on 17.08.2023.
//

import Foundation
import SwiftUI
extension Color {
//    static let appOrange = Color("Orange")
//    static let barButtonGray = Color("BarButtonGray")
    static let bg = Color("BG")
    static let accentPink = Color("AccentPink")
    static let blueGR1 = Color("BlueGR1")
    static let blueGR2 = Color("BlueGR2")
    static let appGray = Color("AppGray")
    static let detailBG = Color("DetailBG")
    static let detailCellBG = Color("DetailCellBG")
}
enum CustomFont: String{
    case pilat_bold = "PilatExtended-bold"
}
extension Font{
    static func custom(_ font: CustomFont, size: CGFloat) -> Font {
        Font.custom(font.rawValue, size: size)
    }
}
