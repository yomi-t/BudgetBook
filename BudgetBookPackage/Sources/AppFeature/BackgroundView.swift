import SwiftUI

public struct BackgroundView: View {
    public init() {}
    public var body: some View {
        MeshGradient(
            width: 2,
            height: 2,
            points: [
                [0, 0], [1, 0],
                [0, 1], [1, 1]
            ], colors: [
                Color(red: 0.8, green: 0.95, blue: 1.0), Color(red: 0.6, green: 0.9, blue: 1.0),
                Color(red: 0.3, green: 0.7, blue: 1.0), Color(red: 0.1, green: 0.5, blue: 0.9)
            ]
        )
        .ignoresSafeArea()
    }
}

#Preview {
    BackgroundView()
}
