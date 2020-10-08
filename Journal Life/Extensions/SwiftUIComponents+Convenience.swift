import SwiftUI
import Combine

class JZStyleGuide: ObservableObject {
    @Published var mainColor: Color = Color.green
}

protocol JZBaseView: View { }

struct JZLazyStackScrollView<T: JZSectionData>: JZBaseView {
    
    @EnvironmentObject var styleGuide: JZStyleGuide
    
    var sectionData: [T]
    var vertical = true
    var body: some View {
        if vertical { ScrollView { LazyVStack(content: { stackBody }) } }
        else { ScrollView { LazyHStack { stackBody } } }
    }
    
    var stackBody: some View {
        // for each section
        ForEach(sectionData, id: \.headerText) { data in
            JZLazySectionView(data: data)
        }
    }
}

protocol JZLazyScrollViewItem {
    associatedtype View
    var view: View { get}
}

struct JZLazySectionView: View {
    
    @EnvironmentObject var styleGuide: JZStyleGuide
    
    let data: JZSectionData
    
    var header: some View {
        HStack {
            Text(data.headerText)
            Spacer()
        }
        .padding()
        .background(styleGuide.mainColor)
    }
    var footer: some View {
        HStack { }
    }
    
    var body: some View {
        Section(header: header, footer: footer) {
            ForEach(data.rows, id: \.id) { (row) in
                JZLazyRowView(data: row)
            }
        }
    }
}

struct JZLazyRowView: View {
    
    let data: JZRowData
    
    var body: some View {
        HStack {
            Text(data.text)
        }
    }
}

protocol JZSectionData {
    var headerText: String { get }
    var rows: [JZRowData] { get }
}

protocol JZRowData {
    var id: String { get }
    var text: String { get }
}


// MARK: - App

struct SectionData: JZSectionData {
    var headerText: String
    var rows: [JZRowData]
}

struct RowData: JZRowData {
    var id: String
    var text: String
}

struct GithubJobsContentView: View {
    
    struct AlertMessage: Identifiable {
        let id = UUID()
        let message: String
    }
    
    @ObservedObject var manager = GithubJobsPostingManager()
    @State var alertMessage: AlertMessage?
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(onChange: { (value) in
                    manager.searchText = value
                },
                text: manager.searchText)
                JZLazyStackScrollView(sectionData: manager.sectionData)
                    .navigationViewStyle(DoubleColumnNavigationViewStyle())
                    .navigationTitle("Github Jobs")
                    .toolbar {
                        ToolbarItem(placement: .bottomBar) {
                            Button("search jobs") {
                                alertMessage = AlertMessage(message: "hello")
                            }
                        }
                    }.alert(item: $alertMessage) { m in
                        Alert (title: Text("Search"), message: Text(m.message),  dismissButton: nil)
                    }
            }
        }.environmentObject(JZStyleGuide())
    }
}

class GithubJobsPostingManager: ObservableObject {
    
    let session = URLSession.shared
    @Published var sectionData = [SectionData]()
    var cancelable: AnyCancellable?
    
    var searchText = ""
    
    init() {

        cancelable = session.dataTaskPublisher(for: URL(string:"https://jobs.github.com/positions.json?description=swift&page=1")!)
            .tryMap({ $0.data })
            .decode(type: [GithubJob].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { print("\($0)") },
                  receiveValue: {
                    self.sectionData = [SectionData(headerText: "test",
                                                    rows: $0.map { RowData(id: $0.id,
                                                                           text:$0.description)
                                                    })]
                  })
        
    }
    
    func requestJobs() {
        
    }
}


struct GithubJob: Decodable, Identifiable, CustomStringConvertible {
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case url
        case createdAt = "created_at"
        case company
        case companyURL = "company_url"
        case location
        case title
        case jobDescription = "description"
        case companyLogo = "company_logo"
        case howToApply = "how_to_apply"
    }
    var id: String
    var type: String
    var url: URL
    var createdAt: String
    var company: String
    var companyURL: URL
    var location: String
    var title: String
    var jobDescription: String
    var companyLogo: String?
    var howToApply: String
    
    var description: String {
        "\(title)\n\(company)\n\(location)\n\(jobDescription)"
    }
}



struct JZContentView_Previews: PreviewProvider {
    static var previews: some View {
        GithubJobsContentView()
    }
}
