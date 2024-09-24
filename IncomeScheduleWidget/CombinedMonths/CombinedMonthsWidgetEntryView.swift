import Foundation
import SwiftUI
import WidgetKit

internal struct CombinedMonthsWidgetEntryView: View {
    internal let entry: CombinedMonthsTimelineEntry
    @Environment(\.widgetFamily) private var widgetFamily

    internal var body: some View {
        switch widgetFamily {
        case .systemSmall:
            CombinedMonthsSystemSmallView(entry: entry)
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
    
    internal init(entry: CombinedMonthsTimelineProvider.Entry) {
        self.entry = entry
    }
}
