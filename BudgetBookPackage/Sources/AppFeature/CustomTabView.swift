import ComposableArchitecture
import SwiftUI

public struct CustomTabView: View {
    let store: StoreOf<CustomTabReducer>
    @Namespace private var namespace
    init (store: StoreOf<CustomTabReducer>) {
        self.store = store
    }
    private let tabSpacing: CGFloat = 5

    public var body: some View {
        VStack {
            GeometryReader { geometry in
                let itemWidth = (geometry.size.width / CGFloat(Tab.allCases.count)) - tabSpacing
                ZStack(alignment: .leading) {
                    if let selectedIndex = Tab.allCases.firstIndex(of: store.selectedTab) {
                        SelectBackgroundView()
                            .frame(width: itemWidth, height: itemWidth)
                            .offset(x: CGFloat(selectedIndex) * itemWidth + (CGFloat(selectedIndex) * tabSpacing))
                            .animation(.easeOut(duration: 0.2), value: store.selectedTab)
                    }
                    HStack(spacing: tabSpacing) {
                        ForEach(Tab.allCases, id: \.self) { tab in
                            Button(
                                action: {
                                    store.send(.select(tab))
                                }, label: {
                                    if tab == .add {
                                        CenterItemLabel(
                                            tab: tab,
                                            itemWidth: itemWidth,
                                            isSelected: store.selectedTab == tab
                                        )
                                    } else {
                                        ItemLabel(tab: tab)
                                            .frame(width: itemWidth, height: itemWidth)
                                            .foregroundColor(store.selectedTab == tab ? .white : .gray)
                                    }
                                }
                            )
                        }
                    }
                }
                .frame(height: itemWidth, alignment: .bottom)
                .padding(tabSpacing)
                .background(.thickMaterial)
                .cornerRadius(.infinity)
                .shadow(radius: 10)
            }
            .padding(.horizontal, 20)
        }
    }
}

private struct ItemLabel: View {
    let tab: Tab
    var body: some View {
        VStack {
            Image(systemName: tab.iconName())
                .resizable()
                .frame(width: 22, height: 22)
            Text(tab.tabName())
                .font(.caption2)
        }
    }
}

private struct CenterItemLabel: View {
    let tab: Tab
    var itemWidth: CGFloat
    var isSelected: Bool
    var body: some View {
        VStack {
            Image(systemName: tab.iconName())
                .resizable()
                .frame(width: 30, height: 30)
                .padding(10)
        }
        .frame(width: itemWidth, height: itemWidth)
        .background(isSelected ? .clear : .white)
        .foregroundColor(isSelected ? .white : .blue)
        .cornerRadius(.infinity)
        .shadow(radius: 5)
    }
}

private struct SelectBackgroundView: View {
    private let gradient: RadialGradient = .init(
        colors: [
            .init(red: 0.0, green: 0.4, blue: 0.9),
            .init(red: 0.3, green: 0.8, blue: 1.0)
        ],
        center: .center,
        startRadius: 0,
        endRadius: 70
    )
    var body: some View {
        Circle()
            .fill(gradient)
    }
}

#Preview {
    ZStack {
        BackgroundView()
            .ignoresSafeArea()
        GeometryReader { geometry in
            VStack {
                Spacer()
                CustomTabView(store: .init(
                    initialState: CustomTabReducer.State(selectedTab: .home)
                ) {
                    CustomTabReducer()
                })
                .frame(height: geometry.size.width / 5)
            }
        }
    }
}
