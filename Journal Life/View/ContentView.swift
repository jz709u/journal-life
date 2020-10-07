
import SwiftUI

struct ContentView: View {
    
    @State var book = JournalBook()

    var body: some View {
        NavigationView {
            JournalBookSortByComponentView(book: book)
                .navigationTitle("Journal Life")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("New") {}
                    }
                    ToolbarItem(placement: .bottomBar) {
                        Button("Filter") {}
                    }
                }
        }.environmentObject(JZStyleGuide())
    }
}

struct JournalBookSortByComponentView: JournalBookView {
    
    // MARK: - Model
    
    let calendar: Calendar
    let book: JournalBook
    
    // MARK: - View Model
    
    var sectionDates = [Date]()
    var sectionToJournalEntries = [Date: [JournalEntry]]()
    
    init(book: JournalBook,
         sortBy component: Calendar.Component = .day,
         calendar: Calendar = .autoupdatingCurrent) {
        self.book = book
        self.calendar = calendar
    
        let result = calendar.group(dateRepresentables: book.entries,
                                    component: component)
        sectionDates = result.keys.sorted().reversed()
        sectionToJournalEntries = result
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(sectionDates) { date in
                    JournalEntriesSectionView(entries: sectionToJournalEntries[date],
                                          sectionDate: date)
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Date: Identifiable {
    public var id: Date { self }
}

protocol JournalBookView: View {
    var book: JournalBook { get }
}
