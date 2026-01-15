import ComposableArchitecture
import Core
import SwiftUI

public struct SettingView: View {
    @Bindable public var store: StoreOf<SettingReducer>
    public init (store: StoreOf<SettingReducer>) {
        self.store = store
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                BackgroundView()
                    .ignoresSafeArea()

                ScrollView {
                    VStack {
                        HStack {
                            Text("設定画面")
                                .font(.title)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(20)
                        }
                        .background(.thickMaterial)
                        .cornerRadius(20)
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                        .shadow(radius: 10)

                        AccountSettingView(store: .init(
                            initialState: AccountSettingReducer.State()
                        ) {
                            AccountSettingReducer()
                        })

                        SourceSettingView(store: .init(
                            initialState: SourceSettingReducer.State(),
                        ) {
                            SourceSettingReducer()
                        })

                        Spacer()
                    }
                    .padding(.bottom, geometry.size.width / 5)
                }
                .mask(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .black, location: 0.0),
                            .init(color: .black, location: 0.97),
                            .init(color: .clear, location: 1.0)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
        }
        .onAppear {
            store.send(.view(.onAppear))
        }
    }
}

#Preview {
    SettingView(store: .init(
        initialState: SettingReducer.State()
    ) {
        SettingReducer()
    })
}
