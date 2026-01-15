import Charts
import ComposableArchitecture
import Core
import SwiftUI

public struct BalanceGraphView: View {
    public let store: StoreOf<BalanceGraphReducer>
    public init(store: StoreOf<BalanceGraphReducer>) {
        self.store = store
    }
    public var body: some View {
        VStack {
            Chart {
                ForEach(store.graphData) { data in
                    BarMark(
                        x: .value("月", data.yearMonth),
                        y: .value("貯金額", data.amount)
                    )
                }
            }
            .chartYAxis {
                AxisMarks(position: .trailing) {
                    AxisGridLine()
                    AxisValueLabel($0.as(Double.self).map {
                        "\((String(format: "%.1f", $0 / 10000)))万円"
                    } ?? "")
                }
            }
            .chartYScale(domain: store.range)
            .chartScrollableAxes(.horizontal)
            .chartXVisibleDomain(length: 7)
            .chartScrollPosition(initialX: store.graphData.last?.yearMonth ?? "")
            .padding()
        }
        .background(.ultraThickMaterial)
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .shadow(radius: 10)
        .frame(height: 200)
    }
}
