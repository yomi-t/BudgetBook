@testable import AppFeature
import ComposableArchitecture
import Core
import Testing

@MainActor
private struct AppFeatureTests {
    struct SelectTabTestCase: Sendable {
        let tab: Tab
        let expectedPage: Page
    }

    @Test(arguments: [
        SelectTabTestCase(tab: .home, expectedPage: .home),
        SelectTabTestCase(tab: .balance, expectedPage: .balance),
        SelectTabTestCase(tab: .add, expectedPage: .add),
        SelectTabTestCase(tab: .income, expectedPage: .income),
        SelectTabTestCase(tab: .settings, expectedPage: .settings)
    ])
    func testSelectTab(_ testCase: SelectTabTestCase) async {
        let store = TestStore(initialState: AppReducer.State()) {
            AppReducer()
        }

        // テストストアの詳細検証を無効にする
        store.exhaustivity = .off

        await store.send(.customTabAction(.view(.select(testCase.tab)))) {
            $0.customTabState.selectedTab = testCase.tab
            $0.page = testCase.expectedPage
        }
    }

    struct InitialStateTestCase: Sendable {
        let initialTab: Tab
        let expectedPage: Page
    }

    @Test(arguments: [
        InitialStateTestCase(initialTab: .home, expectedPage: .home),
        InitialStateTestCase(initialTab: .balance, expectedPage: .home),
        InitialStateTestCase(initialTab: .income, expectedPage: .home),
        InitialStateTestCase(initialTab: .settings, expectedPage: .home)
    ])
    func testInitialState(_ testCase: InitialStateTestCase) {
        let state = AppReducer.State(selectedTab: testCase.initialTab)

        // 初期状態でselectedTabが正しく設定されていることを確認
        if state.customTabState.selectedTab != testCase.initialTab {
            Issue.record("Expected selectedTab to be \(testCase.initialTab) but got \(state.customTabState.selectedTab)")
        }
        // pageは常にhomeで初期化される
        if state.page != testCase.expectedPage {
            Issue.record("Expected page to be \(testCase.expectedPage) but got \(state.page)")
        }
    }

    struct TabSequenceTestCase: Sendable {
        let tabs: [Tab]
    }

    @Test(arguments: [
        TabSequenceTestCase(tabs: [.home, .balance, .income]),
        TabSequenceTestCase(tabs: [.settings, .home, .add]),
        TabSequenceTestCase(tabs: [.income, .income, .income]),
        TabSequenceTestCase(tabs: [.home, .balance, .add, .income, .settings])
    ])
    func testTabSequenceSelection(_ testCase: TabSequenceTestCase) async {
        let store = TestStore(initialState: AppReducer.State()) {
            AppReducer()
        }

        store.exhaustivity = .off
        
        for tab in testCase.tabs {
            await store.send(.customTabAction(.view(.select(tab)))) {
                $0.customTabState.selectedTab = tab
                // Tabに対応するPageを設定
                switch tab {
                case .home:
                    $0.page = .home

                case .balance:
                    $0.page = .balance

                case .add:
                    $0.page = .add

                case .income:
                    $0.page = .income

                case .settings:
                    $0.page = .settings
                }
            }
        }
    }

    @Test
    func testTabIconNames() {
        let expectedIcons: [Tab: String] = [
            .home: "house",
            .balance: "list.bullet",
            .add: "plus",
            .income: "dollarsign.circle",
            .settings: "gear"
        ]

        for tab in Tab.allCases {
            let iconName = tab.iconName()
            if iconName != expectedIcons[tab] {
                Issue.record("Expected icon name for \(tab) to be \(expectedIcons[tab] ?? "") but got \(iconName)")
            }
        }
    }

    @Test
    func testTabNames() {
        let expectedNames: [Tab: String] = [
            .home: "Home",
            .balance: "Balance",
            .add: "Add",
            .income: "Income",
            .settings: "Settings"
        ]

        for tab in Tab.allCases {
            let tabName = tab.tabName()
            if tabName != expectedNames[tab] {
                Issue.record("Expected tab name for \(tab) to be \(expectedNames[tab] ?? "") but got \(tabName)")
            }
        }
    }
}
