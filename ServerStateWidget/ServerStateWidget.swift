//
//  ServerStateWidget.swift
//  ServerStateWidget
//
//  Created by Wttch on 2023/5/28.
//

import WidgetKit
import SwiftUI
import Intents

struct ServerStateProvider: IntentTimelineProvider {
    // 默认的空白小组件的实体对象
    func placeholder(in context: Context) -> ServerStateEntry {
        ServerStateEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (ServerStateEntry) -> ()) {
        let entry = ServerStateEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        print("Start get timeline...")
        NetworkService.loadServerStates { serverStates in
            let serverState = serverStates.first
            let currentDate = Date()
            print("Exec load server state...\(currentDate.ISO8601Format())")
            
            
            var entries: [ServerStateEntry] = []
            
            let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 10, to: currentDate)!
            entries.append(ServerStateEntry(date: nextUpdateDate, configuration: configuration, serverState: serverState))
            
            let timeline = Timeline(entries: entries, policy: .after(nextUpdateDate))
            
            completion(timeline)
        }
    }
}

struct ServerStateEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let serverState: ServerState?
    
    init(date: Date, configuration: ConfigurationIntent, serverState: ServerState? = nil) {
        self.date = date
        self.configuration = configuration
        self.serverState = serverState
    }
}

struct ServerStateWidgetEntryView : View {
    var entry: ServerStateProvider.Entry

    var body: some View {
        if let serverState = entry.serverState {
            VStack(alignment: .leading, spacing: 10) {
                Spacer()
                HStack {
                    Text(serverState.serverName)
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                }
                Text(serverState.state)
                    .font(.caption)
                    .bold()
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .foregroundColor(.pink)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.white)
                    )
                Text("\(formatter.string(from: entry.date))")
                Text("IP:\(serverState.ipAddress)")
                Text("PORT:\(serverState.ipPort)")
                Spacer()
            }
            .padding(.horizontal, 10)
            .background(.pink)
        } else {
            Text("Defaults")
        }
    }
    var formatter: DateFormatter {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter
    }
}

struct ServerStateWidget: Widget {
    let kind: String = "ServerStateWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: ServerStateProvider()) { entry in
            ServerStateWidgetEntryView(entry: entry)
        }
        .onBackgroundURLSessionEvents(matching: "", { identifier, completion in
            
        })
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct ServerStateWidget_Previews: PreviewProvider {
    static var previews: some View {
        ServerStateWidgetEntryView(entry: ServerStateEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
