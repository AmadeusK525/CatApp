import SwiftUI

extension Style {
    enum Spacing: CGFloat {
        case s2 = 2
        case s4 = 4
        case s8 = 8
        case s16 = 16
        case s32 = 32
        case s64 = 64
    }
}

extension View {
    func padding(_ spacing: Style.Spacing) -> some View {
        padding(spacing.rawValue)
    }
}

extension VStack {
    init(alignment: HorizontalAlignment, spacing: Style.Spacing, @ViewBuilder content: () -> Content) {
        self.init(alignment: alignment, spacing: spacing.rawValue, content: content)
    }
}

extension HStack {
    init(alignment: VerticalAlignment, spacing: Style.Spacing, @ViewBuilder content: () -> Content) {
        self.init(alignment: alignment, spacing: spacing.rawValue, content: content)
    }
}
