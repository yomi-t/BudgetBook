import AddFeature
import BalanceFeature
import ComposableArchitecture
import Core
import ExpenseFeature
import HomeFeature
import IncomeFeature
import SwiftData
import SwiftUI

public struct AppView: View {
    public let store: StoreOf<AppReducer>

    public init(store: StoreOf<AppReducer>) {
        self.store = store
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    switch store.page {
                    case .home:
                        HomeView(store: .init(
                            initialState: HomeReducer.State()
                        ) {
                            HomeReducer()
                        })

                    case .balance:
                        BalanceView(store: .init(
                            initialState: BalanceReducer.State()
                        ) {
                            BalanceReducer()
                        })

                    case .add:
                        AddView(store: store.scope(state: \.addState, action: \.addAction))

                    case .income:
                        IncomeView(store: store.scope(state: \.incomeState, action: \.incomeAction))

                    case .expense:
                        ExpenseView(store: store.scope(state: \.expenseState, action: \.expenseAction))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                VStack {
                    Spacer()
                    CustomTabView(store: store.scope(state: \.customTabState, action: \.customTabAction))
                        .frame(height: geometry.size.width / 5)
                }
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}
