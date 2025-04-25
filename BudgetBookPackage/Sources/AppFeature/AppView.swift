import ComposableArchitecture
import HomeFeature
import SwiftUI

public struct AppView: View {
    public let store: StoreOf<AppReducer>
    public init (store: StoreOf<AppReducer>) {
        self.store = store
    }
    
    public var body: some View {
        TabView {
            HomeView(store: .init(
                initialState: HomeReducer.State(),
                reducer: {
                    HomeReducer()
                }
            ))
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
        }
    }
}

#Preview {
    AppView(store: .init(
        initialState: AppReducer.State(),
        reducer: {
            AppReducer()
        }
    ))
}
