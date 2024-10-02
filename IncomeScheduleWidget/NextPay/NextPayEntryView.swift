import Foundation
import SwiftUI
import WidgetKit

internal struct NextPayEntryView: View {
    internal let entry: NextPayTimelineEntry
    @Environment(\.widgetFamily) private var widgetFamily

    internal var body: some View {
        switch widgetFamily {
        case .systemSmall:
            NextPayEntrySystemSmallView(entry: entry)
        case .systemMedium:
            Color.red
        case .systemLarge:
            Color.red
        case .systemExtraLarge:
            Color.red
        case .accessoryCircular:
            Color.red
        case .accessoryCorner:
            Color.red
        case .accessoryRectangular:
            Color.red
        case .accessoryInline:
            Color.red
        @unknown default:
            Color.red
        }
    }

    internal init(entry: NextPayTimelineEntry) {
        self.entry = entry
    }
}
