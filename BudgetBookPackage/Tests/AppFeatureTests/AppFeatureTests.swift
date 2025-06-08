@testable import AppFeature
import ComposableArchitecture
import Testing

@MainActor
struct AppFeatureTests {
    @Test
    func testSelectTab() async throws {
        let store = TestStore(initialState: AppReducer.State()) {
            AppReducer()
        }
        let customTabStore = TestStore(initialState: CustomTabReducer.State(selectedTab: .home)) {
            CustomTabReducer()
        }
    }
}
