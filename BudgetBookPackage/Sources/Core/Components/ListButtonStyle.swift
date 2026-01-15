import SwiftUI

/// Listで押下時の背景色を変える場合に使うButtonStyle
private protocol ListButtonStyle: ButtonStyle {
    /// 通常の背景色
    var backgroundColor: Color { get }
    /// 押下時の背景色
    var pressedBackgroundColor: Color { get }

    /// 背景色を取得する
    /// - Parameter isPressed: 押下時かどうか
    /// - Returns: Color
    func backgroundColor(isPressed: Bool) -> Color
}

extension ListButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(backgroundColor(isPressed: configuration.isPressed))
    }

    func backgroundColor(isPressed: Bool) -> Color {
        isPressed ? pressedBackgroundColor : backgroundColor
    }
}

public struct ListItemButtonStyle: ListButtonStyle {
    var backgroundColor: Color = .clear
    var pressedBackgroundColor: Color = .gray.opacity(0.2)
    public init() {}
}
