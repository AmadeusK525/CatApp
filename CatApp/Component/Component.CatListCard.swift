import SwiftUI

extension Component {
    struct CatBreedListCard: View {
        @ObservedObject var viewModel: ViewModel

        var body: some View {
            HStack(alignment: .center, spacing: .s8) {
                renderAvatarImage()

                renderMainContent(
                    title: viewModel.data.name,
                    subtitle: viewModel.data.origin
                )

                Spacer()

                Image(systemName: .chevronRight)
                    .foregroundStyle(.gray)
            }
            .onFirstAppear {
                Task {
                    await viewModel.fetchImage()
                }
            }
        }

        @ViewBuilder private func renderAvatarImage() -> some View {
            DataView(
                viewModel.image,
                loading: { ProgressView() },
                error: { _ in
                    Image(systemName: .exclamationTriangle)
                }
            ) { image in
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            }
            .frame(width: Constants.imageWidth, height: Constants.imageHeight)
            .clipShape(Circle())
        }

        @ViewBuilder private func renderMainContent(title: String, subtitle: String) -> some View {
            VStack(alignment: .leading, spacing: .s4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.black)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }

        }
    }
}

extension Component.CatBreedListCard {
    class ViewModel: ObservableObject {
        let data: Model.CatBreedListEntry
        let service: CatBreedListCardServiceProtocol

        @Published var image: Model.DataState<UIImage> = .loading

        init(data: Model.CatBreedListEntry, service: CatBreedListCardServiceProtocol = CatBreedListCardService()) {
            self.data = data
            self.service = service
        }

        @MainActor func fetchImage() async {
            // Since this component is inside of a List, we must make sure to
            // avoid re-fetches when this is scrolled back into view
            guard !self.image.isLoaded else { return }

            self.image = .loading
            do {
                let image = try await service.fetchImage(id: self.data.reference_image_id)

                self.image = .success(image)
            } catch {
                self.image = .error(error.localizedDescription)
            }
        }
    }
}

extension Component.CatBreedListCard {
    enum Constants {
        static let imageWidth: CGFloat = 64
        static let imageHeight: CGFloat = 64
    }
}

extension Component.CatBreedListCard {
    enum CardError: Error {
        case invalidImageURL
    }
}

#Preview {
    Component.CatBreedListCard(viewModel: .init(data: .init(
        id: "",
        name: "Akita",
        origin: "Japan",
        reference_image_id: ""
    )))
}
