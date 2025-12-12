import Charts
import ComposableArchitecture
import Core
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
                    BarMark(
                        x: .value("月", data.yearMonth),
                        y: .value("収入", data.amount)
                    )
                }
            }
            .chartYAxis {
                AxisMarks(position: .trailing) {
                    AxisGridLine()
                    AxisValueLabel($0.as(Int.self).map { "\($0 / 10000)万円" } ?? "")
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
        .padding(.top, 20)
        .shadow(radius: 10)
        .frame(height: 200)
    }
}

#Preview {
    IncomeGraphView(store: .init(
        initialState: IncomeGraphReducer.State(incomeData: IncomeMock.sampleData)
    ) {
        IncomeGraphReducer()
    })
}
