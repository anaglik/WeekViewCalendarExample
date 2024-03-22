import SwiftUI

struct CalendarView: View {
    @Bindable var viewModel = CalendarViewModel()
    
    var body: some View {
        #if DEBUG
        let _ = Self._printChanges()
        #endif
        VStack(spacing: 8) {
            Text(viewModel.selectedDate.formatted(Date.FormatStyle().month(.wide)))
                .font(.title)
                .fontWeight(.bold)
                .padding([.leading, .trailing], 20.0)
                .frame(maxWidth: .infinity, alignment: .leading)
            TabView(selection: $viewModel.selectedWeekIndex) {
                ForEach(Array(viewModel.currentWeeks.enumerated()), id: \.element) { index, week in
                    WeekView(viewModel: viewModel, week: week)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 70)
            
            Text(viewModel.selectedDate.formatted(date: .abbreviated, time: .omitted))
                .font(.subheadline)
                .frame(maxWidth: .infinity)
        }
    }
}

private struct WeekView: View {
    @Bindable var viewModel: CalendarViewModel
    let week: Week
    var body: some View {
        HStack {
            ForEach(week.dates) { date in
                DayView(date: date, selectedDate: $viewModel.selectedDate)
            }
        }
        .padding([.leading, .trailing], 20.0)
        .background {
            GeometryReader { proxy in
                let minX = proxy.frame(in: .global).minX
                Color.clear
                    .preference(key: WeekViewOffsetKey.self, value: minX)
                    .onPreferenceChange(WeekViewOffsetKey.self, perform: { value in
                        // we need to detect index change + stop of scrolling
                        if value == 0.0 && (viewModel.selectedWeekIndex == 0 || viewModel.selectedWeekIndex == 2) {
                            viewModel.addNeededWeek()
                            viewModel.updateSelectedDate()
                        }
                    })
            }
        }
    }
}

private struct DayView: View {
    let date: Date
    @Binding var selectedDate: Date
    private var isSelected: Bool { date == selectedDate }
    var body: some View {
        VStack(spacing: 8) {
            Text(date.formatted(Date.FormatStyle().weekday(.abbreviated)))
                .font(.subheadline)
            Text(date.formatted(Date.FormatStyle().day()))
                .font(.callout)
                .foregroundStyle(isSelected ? .white : .black )
                .fontWeight(.bold)
                .frame(width: 36, height: 36)
                .background(isSelected ? Color.blue.shadow(.drop(radius: 1.0)) : Color.white.shadow(.drop(radius: 1.0)), in: .circle)
                .padding([.bottom], 1)
        }
        .onTapGesture {
            withAnimation(.easeIn(duration: 0.2)) {
                selectedDate = date
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    CalendarView()
//    var tomorrow = Date()
//    tomorrow.addTimeInterval(60*60*30)
//    return DayView(date: .now, selectedDate: .constant(tomorrow))
}

private struct WeekViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
