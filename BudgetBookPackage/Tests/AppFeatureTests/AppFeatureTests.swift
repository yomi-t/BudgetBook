@testable import AppFeature
import ComposableArchitecture
import Testing

@MainActor
struct AppFeatureTests {
    @Test
    func testSelectTab() async {
        let selectedTab: Tab = .add
        let store = TestStore(initialState: AppReducer.State()) {
            AppReducer()
        }

        await store.send(.customTabAction(.select(selectedTab))) {
            $0.customTabState.selectedTab = selectedTab
            $0.selectedTab = selectedTab
        }
    }
}
