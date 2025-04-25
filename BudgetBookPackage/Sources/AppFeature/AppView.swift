import ComposableArchitecture
import SwiftUI

public struct AppView: View {
    public let store: StoreOf<AppReducer>
    public init (store: StoreOf<AppReducer>) {
        self.store = store
    }
    
    public var body: some View {
        TabView {
            
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
