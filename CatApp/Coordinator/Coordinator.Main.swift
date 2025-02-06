import SwiftUI

extension Coordinator {
    class Main {
        let controller: UINavigationController = .init()

        func start() {
            let viewModel: Screen.CatBreedList.ViewModel = .init()
            viewModel.onTapRow = { [weak self] id in
                self?.navigateToCatImageDetailsScreen(id: id)
            }
            let controller = UIHostingController(rootView: Screen.CatBreedList(viewModel: viewModel))
            self.controller.setViewControllers([controller], animated: false)
        }

        func navigateToCatImageDetailsScreen(id: String, animated: Bool = true) {
            let viewModel: Screen.CatBreedDetails.ViewModel = .init(id: id)
            let controller = UIHostingController(rootView: Screen.CatBreedDetails(viewModel: viewModel))
            self.controller.pushViewController(controller, animated: animated)
        }
    }
}
