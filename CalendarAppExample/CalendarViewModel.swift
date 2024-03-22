import Foundation

@Observable
final class CalendarViewModel {
    private let calendar = Calendar.current
    var selectedDate: Date
    var selectedWeekIndex = 1
    var currentWeeks: [Week]
    
    init() {
        let today = calendar.startOfDay(for: Date())
        selectedDate = today
        currentWeeks = [
            Week(dates: today.previousWeek),
            Week(dates: today.currentWeek),
            Week(dates: today.nextWeek)
        ]
    }
    
    func isDateSelected(_ date: Date) -> Bool {
        calendar.isDate(date, inSameDayAs: selectedDate)
    }
    
    func addNeededWeek() {
        if selectedWeekIndex == 0 {
            guard let someDate = currentWeeks.first?.dates.first else { return }
            let weekToAdd = someDate.previousWeek
            currentWeeks.insert(Week(dates: weekToAdd), at: 0)
            currentWeeks.removeLast()
            selectedWeekIndex = 1
        } else if selectedWeekIndex == 2 {
            guard let someDate = currentWeeks.last?.dates.first else { return }
            let weekToAdd = someDate.nextWeek
            currentWeeks.append(Week(dates: weekToAdd))
            currentWeeks.removeFirst()
            selectedWeekIndex = 1
        }
    }
    
    func updateSelectedDate() {
        if let index = currentWeeks.first?.dates.firstIndex(of: selectedDate) {
            selectedDate = currentWeeks[selectedWeekIndex].dates[index]
        } else if let index = currentWeeks.last?.dates.firstIndex(of: selectedDate) {
            selectedDate = currentWeeks[selectedWeekIndex].dates[index]
        }
    }
}
