import SwiftUI

extension Component {
    struct ErrorView: View {
        let errorMsg: String
        let onErrorRetry: (() -> Void)?

        var body: some View {
            VStack(alignment: .center, spacing: .s2) {
                HStack(alignment: .center, spacing: .s2) {
                    Image(systemName: .exclamationTriangle)
                        .foregroundStyle(.red)
                    
                    Text("Something went wrong: \(errorMsg)")
                        .foregroundStyle(.red)
                }

                if let onErrorRetry {
                    Button {
                        onErrorRetry()
                    } label: {
                        HStack(alignment: .center, spacing: .s4) {
                            Image(systemName: .arrowCounterClockwise)
                            Text("Retry")
                        }
                    }
                    .foregroundStyle(.blue)
                }
            }
        }
    }
}
