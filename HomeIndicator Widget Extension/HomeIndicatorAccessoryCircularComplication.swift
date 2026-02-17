import WidgetKit
import SwiftUI

struct HomeIndicatorEntry: TimelineEntry {
    let date: Date
    let angle: Double
    let distance: Double
}

struct HomeIndicatorTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> HomeIndicatorEntry {
        HomeIndicatorEntry(date: Date(), angle: 45, distance: 120)
    }

    func getSnapshot(in context: Context, completion: @escaping (HomeIndicatorEntry) -> Void) {
        completion(placeholder(in: context))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<HomeIndicatorEntry>) -> Void) {
        let now = Date()
        let entries = [
            HomeIndicatorEntry(date: now, angle: 30, distance: 150),
            HomeIndicatorEntry(date: now.addingTimeInterval(15 * 60), angle: 35, distance: 140)
        ]
        completion(Timeline(entries: entries, policy: .after(now.addingTimeInterval(15 * 60))))
    }
}

struct HomeIndicatorAccessoryCircularComplicationView: View {
    let entry: HomeIndicatorEntry

    var body: some View {
        ZStack {
            Circle()
                .stroke(.secondary, lineWidth: 1)
            Capsule()
                .fill(.primary)
                .frame(width: 3, height: 10)
                .offset(y: -6)
                .rotationEffect(.degrees(entry.angle))
            Text("\(Int(entry.distance))")
                .font(.system(size: 8, weight: .semibold, design: .rounded))
                .offset(y: 7)
        }
        .padding(2)
    }
}

struct HomeIndicatorAccessoryCircularComplication: Widget {
    private let kind = "HomeIndicatorAccessoryCircularComplication"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HomeIndicatorTimelineProvider()) { entry in
            HomeIndicatorAccessoryCircularComplicationView(entry: entry)
        }
        .configurationDisplayName("HomeIndicator")
        .description("Shows direction and distance in accessory circular style.")
        .supportedFamilies([.accessoryCircular])
    }
}
