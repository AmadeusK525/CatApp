import SwiftUI

extension Screen {
    struct CatBreedList: View {
        @ObservedObject var viewModel: ViewModel

        var body: some View {
            VStack {
                DataView(
                    viewModel.list,
                    onErrorRetry: {
                        Task {
                            await viewModel.loadPage()
                        }
                    },
                    success: renderListSuccess
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                renderPageChanger()
                    .padding(.s16)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .disabled(viewModel.list.isLoading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Cat Breed Gallery")
            .onFirstAppear {
                Task {
                    await viewModel.loadPage()
                }
            }
        }

        @ViewBuilder private func renderListSuccess(list: [Component.CatBreedListCard.ViewModel]) -> some View {
                ScrollView {
                    LazyVStack {
                        ForEach(list, id: \.data.id) { rowViewModel in
                            Button(action: { viewModel.onTapRow?(rowViewModel.data.id) }) {
                                Component.CatBreedListCard(viewModel: rowViewModel)
                            }
                            Divider()
                        }
                    }
                    .padding(.s16)
                }
        }

        @ViewBuilder private func renderPageChanger() -> some View {
            VStack(alignment: .trailing, spacing: .s4) {
                Text("Page \(viewModel.pageIdx + 1)")
                    .bold()

                HStack(alignment: .center, spacing: .s16) {
                    Button(action: {
                        Task {
                            await viewModel.prevPage()
                        }
                    }) {
                        Image(systemName: .chevronLeft)
                    }
                    .disabled(viewModel.pageIdx <= 0)

                    Button(action: {
                        Task {
                            await viewModel.nextPage()
                        }
                    }) {
                        Image(systemName: .chevronRight)
                    }
                }
            }
        }
    }
}

extension Screen.CatBreedList {
    class ViewModel: ObservableObject {
        @Published var list: Model.DataState<[Component.CatBreedListCard.ViewModel]> = .loading
        @Published var pageIdx = 0

        var onTapRow: ((String) -> Void)?

        private let service: CatBreedListServiceProtocol

        init(service: CatBreedListServiceProtocol = CatBreedListService()) {
            self.service = service
        }

        @MainActor func loadPage() async {
            self.list = .loading
            do {
                let list = try await self.service.fetchCatBreedListPage(
                    pageSize: Constants.pageSize,
                    marker: self.pageIdx
                )
                self.list = .success(list.map { row in .init(data: row) })
            } catch {
                self.list = .error(error.localizedDescription)
            }
        }

        @MainActor func nextPage() async {
            self.pageIdx += 1
            await self.loadPage()
        }

        @MainActor func prevPage() async {
            if pageIdx <= 0 {
                return
            }

            self.pageIdx -= 1
            await self.loadPage()
        }
    }
}

extension Screen.CatBreedList {
    enum Constants {
        static let pageSize = 20
    }
}

#Preview {
    let viewModel = Screen.CatBreedList.ViewModel()
    viewModel.list = .success([
        .init(data: .init(id: "0", name: "Akita", origin: "Japan", reference_image_id: ""))
    ])
    return Screen.CatBreedList(viewModel: viewModel)
}
