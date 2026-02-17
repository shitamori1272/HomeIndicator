import Foundation
import WidgetKit

struct ComplicationPayload: Codable {
    let updatedAt: Date
    let angle: Double
    let distance: Double
}

enum ComplicationSharedConstants {
    static let appGroupSuiteName = "group.com.Shitamori.HomeIndicator"
    static let payloadKey = "complicationPayloadV1"
    static let widgetKind = "HomeIndicatorAccessoryCircularComplication"
}

struct ComplicationSharedStore {
    private let userDefaults: UserDefaults?

    init(userDefaults: UserDefaults? = UserDefaults(suiteName: ComplicationSharedConstants.appGroupSuiteName)) {
        self.userDefaults = userDefaults
    }

    func save(angle: Double, distance: Double) {
        let payload = ComplicationPayload(updatedAt: Date(), angle: angle, distance: distance)
        guard let data = try? JSONEncoder().encode(payload) else { return }
        userDefaults?.set(data, forKey: ComplicationSharedConstants.payloadKey)
    }

    func reloadWidgetTimeline() {
        WidgetCenter.shared.reloadTimelines(ofKind: ComplicationSharedConstants.widgetKind)
    }
}
