
import Foundation

struct JournalBook {
    var entries = [JournalEntry(date: Date(), header: "Hello World"),
                   JournalEntry(date: Date().addingTimeInterval(-10), header: "Hello World 2"),
                   JournalEntry(date: Date().addingTimeInterval(-20), header: "Hello World 3"),
                   JournalEntry(date: Date().addingTimeInterval(-24 * 60 * 60), header: "entry 2 "),
                   JournalEntry(date: Date().addingTimeInterval(2 * -24 * 60 * 60), header: "entry 2 ")]
}

struct JournalEntry: Hashable,
                     Identifiable,
                     Comparable,
                     DateRepresentable {
    static func < (lhs: JournalEntry, rhs: JournalEntry) -> Bool {
        lhs.date < rhs.date
    }
    
    var id = UUID()
    var date: Date
    var header: String
    var content: String = ""
}
