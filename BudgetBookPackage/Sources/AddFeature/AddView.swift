import ComposableArchitecture
import Core
import SwiftUI

@ViewAction(for: AddReducer.self)
public struct AddView: View {
    @Bindable public var store: StoreOf<AddReducer>
    public init (store: StoreOf<AddReducer>) {
        self.store = store
    }
    public var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    BackgroundView()
                        .ignoresSafeArea()
                    
                    VStack {
                        Picker(L10n.Common.select, selection: $store.selectedTab) {
                            ForEach(AddReducer.AddTab.allCases, id: \.self) { tab in
                                Text(tab.localizedName)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        switch store.selectedTab {
                        case .balance:
                            AddBalanceView(store: store.scope(state: \.balanceState, action: \.balance))
                            
                        case .income:
                            AddIncomeView(store: store.scope(state: \.incomeState, action: \.income))
                        }
                    }
                    .padding(.bottom, geometry.size.width / 5)
                }
                .ignoresSafeArea(.keyboard)
            }
            .onAppear {
                send(.onAppear)
            }
        }
    }
}
