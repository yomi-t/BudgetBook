import ComposableArchitecture
import SwiftUI

public struct HomeView: View {
    public let store: StoreOf<HomeReducer>
    public init (store: StoreOf<HomeReducer>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            Text("HomeView")
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
