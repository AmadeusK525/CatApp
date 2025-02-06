import XCTest

@testable import CatApp

class MockCatBreedListService: CatBreedListServiceProtocol {
    func fetchCatBreedListPage(pageSize: Int, marker: Int) async throws -> [CatApp.Model.CatBreedListEntry] {
        lastPageIdx = marker
        return []
    }
    
    var lastPageIdx: Int? = nil
}

final class CatBreedListViewModelTests: XCTestCase {
    var mockService = MockCatBreedListService()

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        self.mockService = MockCatBreedListService()
    }

    override func tearDownWithError() throws { }

    @MainActor
    func testPageIndexing() async throws {
        let viewModel = Screen.CatBreedList.ViewModel(service: self.mockService)
        XCTAssertNil(self.mockService.lastPageIdx)

        await viewModel.loadPage()
        XCTAssertEqual(self.mockService.lastPageIdx, 0)

        await viewModel.loadPage()
        XCTAssertEqual(self.mockService.lastPageIdx, 0)

        await viewModel.nextPage()
        XCTAssertEqual(self.mockService.lastPageIdx, 1)

        await viewModel.nextPage()
        XCTAssertEqual(self.mockService.lastPageIdx, 2)

        await viewModel.prevPage()
        XCTAssertEqual(self.mockService.lastPageIdx, 1)

        await viewModel.prevPage()
        XCTAssertEqual(self.mockService.lastPageIdx, 0)

        await viewModel.prevPage()
        // Should not go below 0
        XCTAssertEqual(self.mockService.lastPageIdx, 0)
    }
}
