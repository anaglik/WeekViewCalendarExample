import Foundation

struct Week: Identifiable, Hashable {
    let id = UUID()
    let dates: [Date]
}
