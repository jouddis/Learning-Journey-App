//
//  ActivitySummaryView.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 21/10/2025.
//

import SwiftUI

struct ActivitySummaryView: View {
    @ObservedObject var viewModel: ActivityViewModel
    
    var body: some View {
        HStack(spacing: 15) {
            // Days Learned Box
            SummaryBox(
                iconName: "flame.fill",
                title: "\(viewModel.daysLearned)",
                subtitle: "Days Learned",
                color: .primaryOrange
            )

            // Days Freezed Box
            SummaryBox(
                iconName: "snowflake",
                title: "\(viewModel.daysFreezed)",
                subtitle: "Days Freezed",
                color: .teal // Using teal for the freeze color
            )
        }
    }
}

// Inner reusable box component
struct SummaryBox: View {
    let iconName: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(color)
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        // Use a dark, slightly rounded background for the box
        .background(Color.white.opacity(0.08))
        .cornerRadius(12)
    }
}
#Preview {
    ActivitySummaryView(viewModel: ActivityViewModel())
}
