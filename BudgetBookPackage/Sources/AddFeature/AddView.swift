import ComposableArchitecture
import Core
import SwiftUI

public struct AddView: View {
    @Bindable public var store: StoreOf<AddReducer>
    public init (store: StoreOf<AddReducer>) {
        self.store = store
    }
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                BackgroundView()
                    .ignoresSafeArea()

                VStack {
                    Picker("選択", selection: $store.selectedTab) {
                        ForEach(AddReducer.AddTab.allCases, id: \.self) { tab in
                            Text(tab.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    switch store.selectedTab {
                    case .balance:
                        AddBalanceView(store: store.scope(state: \.balanceState, action: \.balance))

                    case .income:
                        AddIncomeView(store: store.scope(state: \.incomeState, action: \.income))
                    }
                }
                .padding(.bottom, geometry.size.width / 5)
            }
        }
    }
}
