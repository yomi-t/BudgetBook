import AppFeature
import SwiftUI

public struct ContentView: View {
    public var body: some View {
        AppView(store: .init(
            initialState: AppReducer.State()
        ) {
            AppReducer()
        })
    }
}

#Preview {
    ContentView()
}
