import SwiftUI

extension Model {
    enum DataState<T> {
        case loading
        case success(T)
        case error(String)
        
        var isLoaded: Bool {
            guard case .success = self else { return false }

            return true
        }

        var isLoading: Bool {
            guard case .loading = self else { return false }

            return true
        }

        var data: T? {
            guard case .success(let data) = self else {
                return nil
            }

            return data
        }
    }
}

struct DataView<Data, SuccessView: View, LoadingView: View, ErrorView: View>: View {
    let dataState: Model.DataState<Data>
    let loading: () -> LoadingView
    let success: (Data) -> SuccessView
    let error: (String) -> ErrorView

    init(
        _ dataState: Model.DataState<Data>,
        @ViewBuilder loading: @escaping () -> LoadingView,
        @ViewBuilder error: @escaping (String) -> ErrorView,
        @ViewBuilder success: @escaping (Data) -> SuccessView
    ) {
        self.dataState = dataState
        self.success = success
        self.loading = loading
        self.error = error
    }

    public var body: some View {
        switch dataState {
        case .loading: loading()
        case .error(let errorMsg): error(errorMsg)
        case .success(let content): success(content)
        }
    }
}

extension DataView where LoadingView == ProgressView<EmptyView, EmptyView>, ErrorView == Component.ErrorView {
    init(
        _ dataState: Model.DataState<Data>,
        onErrorRetry: (() -> Void)? = nil,
        @ViewBuilder success: @escaping (Data) -> SuccessView
    ) {
        self.dataState = dataState
        self.success = success
        self.loading = { ProgressView() }
        self.error = { errorMsg in Component.ErrorView(errorMsg: errorMsg, retry: onErrorRetry) }
    }
}
