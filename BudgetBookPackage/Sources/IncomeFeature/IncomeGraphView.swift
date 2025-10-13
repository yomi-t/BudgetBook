import Charts
import ComposableArchitecture
import SwiftUI

public struct IncomeGraphView: View {
    public let store: StoreOf<IncomeGraphReducer>
    public init(store: StoreOf<IncomeGraphReducer>) {
        self.store = store
    }
    public var body: some View {
        VStack {
            Chart {
                ForEach(store.graphData) { data in
                    LineMark(
                        x: .value("月", data.yearMonth),
                        y: .value("収入", data.amount)
                    )
                    .lineStyle(StrokeStyle(lineWidth: 2))
                    .foregroundStyle(.blue)
                    
                    PointMark(
                        x: .value("月", data.yearMonth),
                        y: .value("収入", data.amount)
                    )
                    .foregroundStyle(.blue)
                }
            }
        }
        .background(.ultraThickMaterial)
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .shadow(radius: 10)
    }
}
