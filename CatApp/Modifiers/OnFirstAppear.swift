import SwiftUI

struct OnFirstAppear: ViewModifier {
    @State private var hasAppeared = false

    let perform: () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear {
                if !hasAppeared {
                    hasAppeared = true
                    perform()
                }
            }
    }
}

extension View {
    func onFirstAppear(perform: @escaping () -> Void) -> some View {
        self.modifier(OnFirstAppear(perform: perform))
    }
}
