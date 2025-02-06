import XCTest
import SnapshotTesting
import SwiftUI

@testable import CatApp

class MockCatBreedListService: CatBreedListServiceProtocol {
    func fetchCatBreedListPage(pageSize: Int,marker: Int) async throws -> [Model.CatBreedListEntry] {
        return []
    }
}

final class CatBreedListTests: XCTestCase {
    override func setUp() {
        super.setUp()
        isRecording = false
    }

    func testStatesSnapshot() {
        let viewModel = Screen.CatBreedList.ViewModel(service: MockCatBreedListService())
        let controller = UIHostingController(rootView: Screen.CatBreedList(viewModel: viewModel))

        viewModel.list = .loading
        assertSnapshot(of: controller, as: .image(on: .iPhone12), testName: "loading-page1")

        viewModel.list = .error("test error")
        assertSnapshot(of: controller, as: .image(on: .iPhone12), testName: "error-page1")

        viewModel.pageIdx = 1
        assertSnapshot(of: controller, as: .image(on: .iPhone12), testName: "error-page2")

        viewModel.list = .success([
            .init(data: .init(id: "1", name: "Akita", origin: "Japan", reference_image_id: "test")),
            .init(data: .init(id: "2", name: "Poodle", origin: "United States of America", reference_image_id: "test"))
        ])
        assertSnapshot(of: controller, as: .image(on: .iPhone12), testName: "success-page2")
    }
}
