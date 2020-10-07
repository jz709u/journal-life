
import SwiftUI

struct JournalEntryView: View {
    
    static let rowDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm"
        return formatter
    }()
    
    init(journalEntry: JournalEntry, twelveHour: Bool = true) {
        self.journalEntry = journalEntry
        if twelveHour {
            Self.rowDateFormat.dateFormat = "h:mm a"
        } else {
            Self.rowDateFormat.dateFormat = "H:mm"
        }
    }
    
    let journalEntry: JournalEntry
    var body: some View {
        HStack {
            Text("\(journalEntry.date, formatter: Self.rowDateFormat) \(journalEntry.header)")
        }
    }
}

