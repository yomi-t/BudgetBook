import AddFeature
import ComposableArchitecture
import HomeFeature
import SwiftUI

public struct AppView: View {
    public let store: StoreOf<AppReducer>
    public init (store: StoreOf<AppReducer>) {
        self.store = store
    }
    public var body: some View {
        ZStack {
            BackgroundView()
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    VStack {
                        switch store.selectedTab {
                        case .home:
                            HomeView(store: .init(
                                initialState: HomeReducer.State()
                            ) {
                                HomeReducer()
                            })

                        case .balance:
                            Text("Left Money View")
                                .font(.largeTitle)
                                .foregroundColor(.white)

                        case .add:
                            AddView(store: store.scope(state: \.addState, action: \.addAction))

                        case .balanceList:
                            Text("Left Money List View")
                                .font(.largeTitle)
                                .foregroundColor(.white)

                        case .settings:
                            Text("Settings View")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    CustomTabView(store: store.scope(state: \.customTabState, action: \.customTabAction))
                        .frame(height: geometry.size.width / 5)
                }
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    AppView(store: .init(
        initialState: AppReducer.State()
    ) {
        AppReducer()
    })
}
