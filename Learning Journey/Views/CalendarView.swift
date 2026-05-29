//
//  CalendarView.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 22/10/2025.
//

import SwiftUI

struct CalendarView: View {
    // We pass the global VM to grab initial metrics
    @ObservedObject var activityViewModel: ActivityViewModel
    
    // Local ViewModel manages all date logic
    @ObservedObject private var viewModel: CalendarViewModel
    
    @State private var showMonthPicker = false
    
    init(activityViewModel: ActivityViewModel) {
        self.activityViewModel = activityViewModel
        
        // Initialize the CalendarViewModel with the correct signature
        _viewModel = ObservedObject(wrappedValue: CalendarViewModel(
            activityViewModel: activityViewModel
        ))
    }

    var body: some View {
        VStack(spacing: 18) {
            header
            weekDays
            Divider().frame(width:340,height:0.5).background(.white.opacity(0.3))
            metricsSection
        }
        
        .frame(width: 365, height: 254 )
        .padding(10)
        .background(Color.gray.opacity(14/100))
        .overlay(RoundedRectangle(cornerRadius: 13).stroke(
            AngularGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.4), Color.white, Color.white.opacity(0.5),
                    Color.white, Color.white, Color.white
                ]),
                center: .center
            ),
            lineWidth: 0.4
        ))
        .clipShape(RoundedRectangle(cornerRadius: 13))
        .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 5)
        
        // Note: CalendarMonthYearPicker struct must be defined elsewhere
        .sheet(isPresented: $showMonthPicker) {
                    CalendarMonthYearPicker(
                        selectedMonth: $viewModel.displayedMonth,
                        selectedYear: $viewModel.displayedYear
                    ) { month, year in
                        viewModel.updateMonthYear(month: month, year: year)
                    }
                }
    }

    private var header: some View {
        HStack  {
            Button { showMonthPicker.toggle() } label: {
                HStack(spacing: 4) {
                    Text("\(viewModel.monthName) \(viewModel.displayedYear.formatted(.number.grouping(.never)))")
                        .font(.headline)
                    Image(systemName: "chevron.right").font(.headline).foregroundColor(.orange)
                }
                .foregroundColor(.white)
            }
            Spacer()
            Button(action: viewModel.previousWeek) { Image(systemName: "chevron.left").foregroundColor(.orange) }
            .padding(.trailing, 20 )

            Button(action: viewModel.nextWeek) { Image(systemName: "chevron.right").foregroundColor(.orange) }
        }.padding(.top,10)

    }

    private var weekDays: some View {
        HStack(spacing: 10) {
            ForEach(viewModel.weekDates, id: \.self) { date in
                let day = Calendar.current.component(.day, from: date)
                let isToday = Calendar.current.isDateInToday(date)
                
                // 🚀 FINAL FIX: Get status directly from the ViewModel's history lookup (File 1)
                let dayStatus = activityViewModel.getStatus(for: date)
                
                let FillColor: Color = {
                    if dayStatus == .logged {
                        return activityViewModel.activityHistory.loggedColor
                    } else if dayStatus == .freezed {
                        return activityViewModel.activityHistory.freezedColor
                    } else if isToday {
                        return Color.orange
                    } else {
                        return .white.opacity(-1/100)
                    }
                }()
                
                VStack {
                    Text(date.formatted(.dateTime.weekday(.abbreviated)).uppercased())
                        .font(.custom("SFPro-Semibold", size: 13))
                        .foregroundColor(.gray)
                    Text("\(day)")
                        .font(.custom("SFPro-Regular", size: 20))
                        .frame(width: 44, height: 44)
                        .background(
                            ZStack {
                                Circle()
                                    .fill(FillColor)
                            }
                        )
                        .foregroundColor(dayStatus == .logged ? .orange :
                                         dayStatus == .freezed ? Color(.primaryBlue) : .white)
                }
            }
        }
    }
    
    private var metricsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Learning \(activityViewModel.currentGoalTopic)")
                .font(.headline)
                .foregroundColor(.white)
            HStack(spacing: 15) {
                // Accesses the now-correctly-computed metrics from the main VM
                metricBox(icon: "flame.fill", value: "\(activityViewModel.daysLearned)", label: "Days Learned", iconColor: .orange,
                          backgroundColor: .orange)
                metricBox(icon: "cube.fill", value: "\(activityViewModel.daysFreezed)", label: "Day Freezed", iconColor: Color(.primaryBlue),
                          backgroundColor: Color(.primaryBlue))
            }
        }.padding(.bottom,5)
    }
    
    private func metricBox(icon: String, value: String, label: String, iconColor: Color,
                          backgroundColor: Color) -> some View {
        HStack {
            Image(systemName: icon)
                .resizable().aspectRatio(contentMode: .fit).frame(width: 25, height: 25).foregroundColor(iconColor)
            VStack (alignment: .leading,spacing:-3){
                Text(value).font(.title2.bold())
                Text(label).font(.footnote)
            }
        }
        .padding()
        .frame(width:160 , height:69)
        .background(backgroundColor.opacity(0.28))
        .clipShape(RoundedRectangle(cornerRadius: 34))
        .foregroundColor(.white)
    }
}
