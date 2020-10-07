import SwiftUI

struct JournalEntriesSectionView: View {
    
    static let sectionDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    var entries: [JournalEntry]?
    var sectionDate: Date
    
    var body: some View {
        Section(header: HStack {
            Text("\(sectionDate,formatter: Self.sectionDateFormat)")
            Spacer()
        }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)).background(Color.init(red: 100/255, green: 200/255, blue: 255/255, opacity: 0.5))) {
            if let entries = entries {
                ForEach(entries) { entry in
                    JournalEntryView(journalEntry: entry)
                }
            }
        }
    }
}
