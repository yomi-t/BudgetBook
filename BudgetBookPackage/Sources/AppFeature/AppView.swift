import AddFeature
import ComposableArchitecture
import HomeFeature
import IncomeFeature
import Repository
import SharedModel
import SwiftData
import SwiftUI

public struct AppView: View {
    public let store: StoreOf<AppReducer>
    private let balanceRepository: BalanceRepository
    private let incomeRepository: IncomeRepository

    public init(store: StoreOf<AppReducer>, balanceRepository: BalanceRepository, incomeRepository: IncomeRepository) {
        self.store = store
        self.balanceRepository = balanceRepository
        self.incomeRepository = incomeRepository
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
                                HomeReducer(balanceRepository: balanceRepository)
                            })

                        case .income:
                            IncomeView(store: .init(
                                initialState: IncomeReducer.State()
                            ) {
                                IncomeReducer(incomeRepository: incomeRepository)
                            })

                        case .add:
                            AddView(store: store.scope(state: \.addState, action: \.addAction))

                        case .balanceList:
                            Text("Left Money List View")
                                .font(.largeTitle)
                                .foregroundColor(.white)

                        case .settings:
                            Text("Settings View")
                                .font(.largeTitle)
                                .foregroundColor(.white)
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
