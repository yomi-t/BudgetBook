import AppFeature
import SwiftUI

struct ContentView: View {
    var body: some View {
        AppView(store: .init(
            initialState: AppReducer.State(),
            reducer: {
                AppReducer()
            }
        ))
    }
}

#Preview {
    ContentView()
}
