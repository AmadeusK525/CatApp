import SwiftUI

extension Model {
    enum SystemImage: String {
        case exclamationTriangle = "exclamationmark.triangle"
        case arrowCounterClockwise = "arrow.counterclockwise"
        case chevronLeft = "chevron.left"
        case chevronRight = "chevron.right"
    }
}

extension Image {
    init(systemName: Model.SystemImage) {
        self.init(systemName: systemName.rawValue)
    }
}
