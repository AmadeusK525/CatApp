import XCTest
import SnapshotTesting
import SwiftUI

@testable import CatApp

class MockCatBreedDetailsService: CatBreedDetailsServiceProtocol {
    func fetchDetails(id: String) async throws -> CatApp.Model.CatBreed {
        return .init(
            id: "",
            name: "",
            description: "",
            origin: "",
            reference_image_id: "",
            life_span: "",
            wikipedia_url: ""
        )
    }

    func fetchImage(id: String) async throws -> CatApp.Model.RemoteImage {
        return .init(id: "", url: "", width: 0, height: 0)
    }
}

final class CatBreedDetailsTests: XCTestCase {
    override func setUp() {
        super.setUp()
        isRecording = false
    }

    func testStatesSnapshot() {
        let viewModel = Screen.CatBreedDetails.ViewModel(id: "", service: MockCatBreedDetailsService())
        let controller = UIHostingController(rootView: Screen.CatBreedDetails(viewModel: viewModel))

        viewModel.details = .loading
        assertSnapshot(of: controller, as: .image(on: .iPhone12), testName: "loading")

        viewModel.details = .error("test error")
        assertSnapshot(of: controller, as: .image(on: .iPhone12), testName: "error")

        viewModel.details = .success(.init(
            id: "",
            name: "Akita",
            description: "Test description",
            origin: "Japan",
            reference_image_id: "test",
            life_span: "14",
            wikipedia_url: "https://wikipedia.org"
        ))
        assertSnapshot(of: controller, as: .image(on: .iPhone12), testName: "success")

        viewModel.imageURL = .error("test error")
        assertSnapshot(of: controller, as: .image(on: .iPhone12), testName: "details_success-image_error")
    }
}
