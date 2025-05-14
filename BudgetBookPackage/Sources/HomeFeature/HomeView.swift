import CommonFeature
import ComposableArchitecture
import SwiftUI

public struct HomeView: View {
    public let store: StoreOf<HomeReducer>
    public init (store: StoreOf<HomeReducer>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                LastMoneyView(store: .init(
                    initialState: LastMoneyReducer.State(),
                    reducer: {
                        LastMoneyReducer()
                    }
                ))
                LeftMoneyListView(store: .init(
                    initialState: LeftMoneyListReducer.State(),
                    reducer: {
                        LeftMoneyListReducer()
                    }
                ))
            }
        }
    }
}

#Preview {
    HomeView(store: .init(
        initialState: HomeReducer.State(),
        reducer: {
            HomeReducer()
        }
    ))
}
