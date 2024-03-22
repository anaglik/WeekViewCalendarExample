import Foundation

extension Date {
    var currentWeek: [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: self)
        let dayOfWeek = calendar.component(.weekday, from: today) - (calendar.firstWeekday - 1)
        let range = calendar.range(of: .weekday, in: .weekOfYear, for: today)
        let dates = range?.compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }
        return dates ?? []
    }
    
    var nextWeek: [Date] {
        guard let lastDay = currentWeek.last else { return [] }
        let calendar = Calendar.current
        let nextWeekDay = calendar.date(byAdding: .day, value: 1, to: lastDay)
        return nextWeekDay?.currentWeek ?? []
    }
    
    var previousWeek: [Date] {
        guard let lastDay = currentWeek.first else { return [] }
        let calendar = Calendar.current
        let nextWeekDay = calendar.date(byAdding: .day, value: -calendar.firstWeekday, to: lastDay)
        return nextWeekDay?.currentWeek ?? []
    }
    
    var dayOfWeek: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: self)
        let dayOfWeek = calendar.component(.weekday, from: today) - (calendar.firstWeekday - 1)
        return dayOfWeek
    }
}

extension Date: Identifiable {
    public var id: Double {
        self.timeIntervalSince1970
    }
}

