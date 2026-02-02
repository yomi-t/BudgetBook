import ComposableArchitecture
import SwiftUI

public struct IncomeDetailView: View {
    public let store: StoreOf<IncomeDetailReducer>
    public init(store: StoreOf<IncomeDetailReducer>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            SourceRateGraphView(data: store.incomes)
            IncomeSourceListView(store: store.scope(
                state: \.incomeSourceListState,
                action: \.incomeSourceListAction
            ))
        }
    }
}
