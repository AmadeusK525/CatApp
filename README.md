## CatApp

Sample iOS application code to showcase the MVVM pattern in SwiftUI. This uses the public
[Cat API](https://thecatapi.com) for getting relevant data.

There are two pages: a `List` page and a `Details` page. Pagination, loading and error states are
easily handled with helper functions.

### Minimum deployment target

iOS 18.2

## Setup

### Prerequisites

- [Xcode](https://developer.apple.com/xcode/)
- [Ruby](https://www.ruby-lang.org/pt/)
  - Consider using [rbenv](https://github.com/rbenv/rbenv) for versioning

### First run

- Open the Xcode project and wait for SPM (Swift Package Manager) to sync
- Choose a deployment target and a simulator
- Tap run
- Enjoy!

### Fastlane

- Run `gem install bundler`
- Run `bundler install`
- Run `fastlane test`

## Architecture

- `Namespaces` are used for organizing the code
- Each `View` has its own `ViewModel`
- Each `ViewModel` can own a `Service` (for network communication)
  - These are protocols, for Dependency Injection
- Async data is stored in a `DataState` enum and rendered via a `DataView`
  - This takes care of loading and error states automatically
- `Coordinators` are available and use the old UINavigationController to push new Views onto the stack
  - I am not a big fan of `NavigationStack` and the native `SwiftUI` way oh handling navigation,
    so whenever possible I take this approach, as the API is
    [stable](https://developer.apple.com/documentation/swiftui/migrating-to-new-navigation-types)
    and reliable
