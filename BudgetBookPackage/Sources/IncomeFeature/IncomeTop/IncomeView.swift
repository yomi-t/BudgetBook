import ComposableArchitecture
import Core
import SwiftUI

@ViewAction(for: IncomeReducer.self)
public struct IncomeView: View {
    public let store: StoreOf<IncomeReducer>
    public init (store: StoreOf<IncomeReducer>) {
        self.store = store
    }
    public var body: some View {
        GeometryReader { geometry in
            NavigationStackStore(
                store.scope(state: \.path, action: \.path)
            ) {
                ZStack {
                    BackgroundView()
                        .ignoresSafeArea()

                    VStack {
                        IncomeYearView(store: .init(
                            initialState:
                                IncomeYearReducer.State(incomeData: store.incomes)
                        ) {
                            IncomeYearReducer()
                        })
                        IncomeGraphView(store: .init(
                            initialState:
                                IncomeGraphReducer.State(incomeData: store.incomes)
                        ) {
                            IncomeGraphReducer()
                        })
                        IncomeListView(store: store.scope(
                            state: \.incomeListState,
                            action: \.incomeListAction
                        ))
                    }
                    .padding(.bottom, geometry.size.width / 5)
                }
                .onAppear {
                    send(.onAppear)
                }
            } destination: { store in
                switch store.case {
                case let .incomeDetail(store):
                    GeometryReader { geometry in
                        ZStack {
                            BackgroundView()
                                .ignoresSafeArea()

                            IncomeDetailView(store: store)
                                .padding(.bottom, geometry.size.width / 5)
                        }
                    }
                }
            }
        }
    }
}
