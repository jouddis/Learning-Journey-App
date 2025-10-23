//
//  CalendarDatePicker.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 22/10/2025.
//

import SwiftUI

struct CalendarMonthYearPicker: View {
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    var onSelect: (Int, Int) -> Void

    private let months = Calendar.current.monthSymbols
    private let years = Array(2000...2050)

    // Formatter to ensure no thousands separator (e.g., 2025 not 2,025)
    private static let plainNumberFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.usesGroupingSeparator = false
        f.numberStyle = .none
        return f
    }()

    var body: some View {
        VStack {
            Text("Select Month & Year")
                .font(.headline)
                .padding(.top)

            HStack {
                Picker("Month", selection: $selectedMonth) {
                    ForEach(1...12, id: \.self) { index in
                        Text(months[index - 1]).tag(index)
                    }
                }
                .frame(maxWidth: .infinity)

                Picker("Year", selection: $selectedYear) {
                    ForEach(years, id: \.self) { year in
                        let yearString = CalendarMonthYearPicker.plainNumberFormatter.string(from: NSNumber(value: year)) ?? String(year)
                        Text(yearString).tag(year)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .pickerStyle(.wheel)
            .frame(height: 150)

            Button("Done") {
                onSelect(selectedMonth, selectedYear)
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
            .padding()
        }
        .presentationDetents([.height(300)])
        .background(.ultraThinMaterial)
    }
}
