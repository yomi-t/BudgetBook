import Charts
import ComposableArchitecture
import Core
import SwiftUI

public struct ExpenseGraphView: View {
    public let store: StoreOf<ExpenseGraphReducer>

    public init(store: StoreOf<ExpenseGraphReducer>) {
        self.store = store
    }

    public var body: some View {
        VStack {
            Chart {
                ForEach(store.graphData) { data in
                    BarMark(
                        x: .value(L10n.Common.month, data.yearMonth),
                        y: .value(L10n.Tab.expense, data.amount)
                    )
                    .foregroundStyle(.red.gradient)
                }
            }
            .chartYAxis {
                AxisMarks(position: .trailing) {
                    AxisGridLine()
                    AxisValueLabel($0.as(Double.self).map {
                        "\(String(format: "%.1f", $0 / 10000))\(L10n.Common.tensOfThousandsYen)"
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
