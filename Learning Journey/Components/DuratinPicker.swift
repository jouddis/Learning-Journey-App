//
//  Untitled.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 21/10/2025.
//
//import SwiftUI
//
//struct DurationPicker: View {
//    @Binding var selectedDuration: String
//    let durations = ["Week", "Month", "Year"]
//    
//    var body: some View {
//        HStack(spacing: 15) {
//            ForEach(durations, id: \.self) { duration in
//                Button(action: {
//                    selectedDuration = duration
//                }) {
//                    Text(duration)
//                        .frame(width: 97, height: 48)
//                        .font(.custom("SFPro-Medium", size: 17))
//                        .fontWeight(.medium)
//                        .foregroundStyle(Color.primaryText)
//                        .background(backgroundColor(isSelected: selectedDuration == duration))
//                        .glassEffect(.regular.interactive())
//                        
//                        
//                }
//            }
//        }
//    }
//    
//    @ViewBuilder
//    private func backgroundColor(isSelected: Bool) -> some View {
//        if isSelected {
//            RoundedRectangle(cornerRadius: 1000)
//                .fill(Color.primaryOrange)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 1000)
//                        .stroke(LinearGradient(colors: [.yellow, .black, .black, .yellow], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1))
//        } else {
//            RoundedRectangle(cornerRadius: 1000)
//                .fill(Color.black.opacity(0.2))
//                .overlay(
//                    RoundedRectangle(cornerRadius: 1000)
//                        .stroke(LinearGradient(colors: [.white, .black, .black, .white], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 0.5)
//                )
//                .overlay(
//                RoundedRectangle(cornerRadius: 1000)
//                    .fill(Color.white.opacity(9/100))
//                    
//            )
//        }
//    }
//}


import SwiftUI

struct DurationPicker: View {
    @Binding var selectedDuration: String
    let durations = ["Week", "Month", "Year"]
    
    var body: some View {
        HStack(spacing: 15) {
            ForEach(durations, id: \.self) { duration in
                Button(action: {
                    selectedDuration = duration
                }) {
                    Text(duration)
                        .frame(width: 97, height: 48)
                        .font(.custom("SFPro-Medium", size: 17))
                        .fontWeight(.medium)
                        .foregroundStyle(Color("PrimaryText"))
                        .background(backgroundColor(isSelected: selectedDuration == duration))
                        .glassEffect(.regular.interactive())
                }
            }
        }
    }
    
    @ViewBuilder
    private func backgroundColor(isSelected: Bool) -> some View {
        if isSelected {
            // Selected Style
            RoundedRectangle(cornerRadius: 1000)
                .fill(Color("PrimaryOrange"))
                .overlay(
                    RoundedRectangle(cornerRadius: 1000)
                        .stroke(LinearGradient(colors: [.yellow, .black, .black, .yellow], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1))
        } else {
            // Unselected Style
            RoundedRectangle(cornerRadius: 1000)
                .fill(Color.black.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 1000)
                        .stroke(LinearGradient(colors: [.white, .black, .black, .white], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 0.5)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 1000)
                        .fill(Color.white.opacity(9/100))
                )
        }
    }
}
