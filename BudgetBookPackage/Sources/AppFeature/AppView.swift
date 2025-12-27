import AddFeature
import BalanceFeature
import ComposableArchitecture
import Core
import HomeFeature
import IncomeFeature
import SettingFeature
import SwiftData
import SwiftUI

public struct AppView: View {
    public let store: StoreOf<AppReducer>

    public init(store: StoreOf<AppReducer>) {
        self.store = store
    }

    public var body: some View {
        ZStack {
            BackgroundView()
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    VStack {
                        switch store.selectedTab {
                        case .home:
                            HomeView(store: .init(
                                initialState: HomeReducer.State()
                            ) {
                                HomeReducer()
                            })
                            
                        case .balanceList:
                            BalanceView(store: .init(
                                initialState: BalanceReducer.State()
                            ) {
                                BalanceReducer()
                            })

                        case .add:
                            AddView(store: store.scope(state: \.addState, action: \.addAction))

                        case .income:
                            IncomeView(store: .init(
                                initialState: IncomeReducer.State()
                            ) {
                                IncomeReducer()
                            })

                        case .settings:
                            SettingView(store: .init(
                                initialState: SettingReducer.State()
                            ) {
                                SettingReducer()
                            })
                        }
                    }
                    .frame(maxWidth: .infinity)
                    CustomTabView(store: store.scope(state: \.customTabState, action: \.customTabAction))
                        .frame(height: geometry.size.width / 5)
                }
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}
