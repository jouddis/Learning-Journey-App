//
//  DataModel.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 27/10/2025.
//
//import Foundation
//import SwiftUI
//
//// MARK: - 1. Activity Data Schemas (Structs & Enums)
//
//struct CalendarDay: Identifiable {
//    let id = UUID()
//    let day: Int
//    var isCurrent: Bool = false
//    var status: DayStatus = .default
//}
//
//enum DayStatus {
//    case `default`
//    case logged
//    case freezed
//}

// MARK: - 2. Historical Activity Tracker (Model Class)

// Removed duplicate ActivityHistory. The canonical implementation lives in ActivityHistory.swift.
import Foundation
import SwiftUI

// MARK: - 1. Activity Data Schemas (Structs & Enums)

struct CalendarDay: Identifiable {
    let id = UUID()
    let day: Int
    var isCurrent: Bool = false
    var status: DayStatus = .default
}

enum DayStatus: Hashable {
    case `default`
    case logged
    case freezed
}
