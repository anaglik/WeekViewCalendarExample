import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            CalendarView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    HomeView()
}
