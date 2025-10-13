import ComposableArchitecture
import SwiftUI

public struct IncomeView: View {
    public let store: StoreOf<IncomeReducer>
    public init (store: StoreOf<IncomeReducer>) {
        self.store = store
    }
    public var body: some View {
        VStack {
            IncomeGraphView(store: .init(
                initialState:
                    IncomeGraphReducer.State(graphData: store.graphData)
            ) {
                IncomeGraphReducer()
            })
            IncomeListView(store: .init(
                initialState:
                    IncomeListReducer.State(incomes: store.incomes)
            ) {
                IncomeListReducer()
            })
        }
        .onAppear {
            store.send(.view(.onAppear))
        }
    }
}

#Preview {
    
}
