import SwiftUI

extension Screen {
    struct CatBreedDetails: View {
        @ObservedObject var viewModel: ViewModel

        var body: some View {
            ScrollView {
                VStack(alignment: .center, spacing: .s16) {
                    DataView(viewModel.imageURL, success: renderImageSuccess)
                    DataView(viewModel.details, success: renderDetailsSuccess)
                }
                .padding(.s32)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .navigationTitle("Cat Breed")
            .task {
                await viewModel.fetchDetails()
            }
        }

        @ViewBuilder private func renderImageSuccess(url: URL) -> some View {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure:
                    Component.ErrorView(errorMsg: "Failed to load image") {
                        Task {
                            if let details = viewModel.details.data {
                                await viewModel.fetchImage(id: details.reference_image_id)
                            }
                        }
                    }
                @unknown default:
                    EmptyView()
                }
            }
        }

        @ViewBuilder private func renderDetailsSuccess(details: Model.CatBreed) -> some View {
            VStack(alignment: .leading, spacing: .s8) {
                Text(details.name)
                    .font(.title)
                    .bold()

                Text("Country of origin: \(details.origin)")
                    .font(.headline)
                Text("Average lifespan: \(details.life_span)")
                    .font(.headline)

                Text(details.description)
                    .font(.body)

                if let wikipedia = URL(string: details.wikipedia_url) {
                    Link("More info on Wikipedia", destination: wikipedia)
                }
            }
            .onFirstAppear {
                Task {
                    if !viewModel.imageURL.isLoaded {
                        await viewModel.fetchImage(id: details.reference_image_id)
                    }
                }
            }
        }
    }
}

extension Screen.CatBreedDetails {
    class ViewModel: ObservableObject {
        let id: String
        
        @Published var details: Model.DataState<Model.CatBreed> = .loading
        @Published var imageURL: Model.DataState<URL> = .loading

        private let service: CatBreedDetailsServiceProtocol

        init(
            id: String,
            service: CatBreedDetailsServiceProtocol = CatBreedDetailsService()
        ) {
            self.id = id
            self.service = service
        }

        @MainActor func fetchDetails() async {
            self.details = .loading

            do {
                let details = try await service.fetchDetails(id: self.id)
                self.details = .success(details)
            } catch {
                print(error)
                self.details = .error(error.localizedDescription)
            }
        }

        @MainActor func fetchImage(id: String) async {
            self.imageURL = .loading

            do {
                let image = try await service.fetchImage(id: id)
                let url = URL(string: image.url)

                guard let url else {
                    throw CatBreedDetailsError.invalidImageURL
                }

                self.imageURL = .success(url)
            } catch {
                self.imageURL = .error(error.localizedDescription)
            }
        }
    }
}

extension Screen.CatBreedDetails {
    enum CatBreedDetailsError: Error {
        case invalidImageURL
    }
}
