@testable import AppFeature
import ComposableArchitecture
import Testing

@MainActor
private struct AppFeatureTests {
    @Test(arguments: Tab.allCases)
    func testSelectTab(selectedTab: Tab) async {
        let store = TestStore(initialState: AppReducer.State()) {
            AppReducer()
        }

        // テストストアの詳細検証を無効にする
        store.exhaustivity = .off

        await store.send(.customTabAction(.select(selectedTab))) {
            $0.customTabState.selectedTab = selectedTab
            $0.selectedTab = selectedTab
        }
    }
}
